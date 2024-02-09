package multiplayer;

import haxe.Constraints.Function;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.addons.ui.FlxUIInputText;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.colyseus.Client;
import io.colyseus.Room;
import io.colyseus.events.EventHandler;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import ibwwg.FlxScrollableArea;
import flixel.math.FlxRect;
import openfl.utils.Assets as OpenFlAssets;
import multiplayer.schemas.*;
import multiplayer.entities.*;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end


enum MenuEnum {
	CONNECTING;
    MAIN;
    ROOMLIST;
    CREATE;
	LOBBY;
}

class MultiplayerMainMenuState extends MusicBeatState
{
	// COISAS UI
	var hostearBt:FlxButton;
	var entrarBt:FlxButton;
	var comecarBt:FlxButton;
	var configBt:FlxButton;
	var bGround:FlxSprite;
	var ipBar:FlxUIInputText;
	var multiplayerTxt:FlxText;
	public var canClick:Bool = false;
	var textinhoDebug:FlxText;

	// SUBMENU OPÇÕES
	public var isOnOptions:Bool = false;

	// SUBMENU AVISOS
	var blackTransBG:FlxSprite;
	var avisoBg:FlxSprite;
	var avisoTexto:FlxText;
	var okBt:FlxButton;

	// SERVER - acessos
    var client:Client;
	var curRoom:Room<LobbyState>;

	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;
	var canInitMatch:Bool = false;
	//var selectedMusic:String = "soulless/soulless-hard";
	var isPlayingMatch:Bool = false;
	public var daNoteReceived:Array<Int> = [0];

	// PLAYERS
	public var players:Array<LobbyPlayerObject> = [new LobbyPlayerObject(174,190), new LobbyPlayerObject(681,190)];
	public static var instance:MultiplayerMainMenuState;

	// VARIAVEIS OPÇÕES
	public var modos:Array<Dynamic> = [
		["PONTOS", "Ganha quem tiver a maior pontuação."],
		["HITS", "Ganha quem tiver mais hits."],
		["ERROS", "Ganha quem tiver menos erros."]
	];
	public var ModoDeJogo:Int = 0;

	public var TrocarLados:Bool = false;

	public var musicas:Array<Dynamic> = [];
	public var MusicaAtual:Int = 0;

	public var roomList:RoomList;
	public var curMenu:MenuEnum = MAIN;

	function getAllSongs():Array<Dynamic> // TODO: Mudar isso daqui pra fazer ele pegar as charts direto da source
	{
		WeekData.reloadWeekFiles(true);
		var nomesEPaths:Array<Dynamic> = [];
		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			for (i in 0...leWeek.songs.length) {
				var path:String = Paths.formatToSongPath(leWeek.songs[i][0])+"/"+Paths.formatToSongPath(leWeek.songs[i][0])+"-hard";
				if(!OpenFlAssets.exists(Paths.json(path)))
				{
					path = Paths.formatToSongPath(leWeek.songs[i][0])+"/"+Paths.formatToSongPath(leWeek.songs[i][0]);
				}
				if(!OpenFlAssets.exists(Paths.json(path)))
				{
					path = Paths.formatToSongPath(leWeek.songs[i][0])+"/"+Paths.formatToSongPath(leWeek.songs[i][0])+"-easy";
				}
				nomesEPaths.push([leWeek.songs[i][3], path]);
			}
		}
		return nomesEPaths;
	}

	function deactivateAll()
	{
		entrarBt.visible = false;
		hostearBt.visible = false;
		ipBar.visible = false;
		multiplayerTxt.visible=false;
		
		comecarBt.visible = false;
		configBt.visible = false;

		if(roomList != null)
		{
			roomList.remover();
			roomList = null;
		}
	}

	function changeMenu(nextMenu:MenuEnum)
	{
		deactivateAll();
		switch(nextMenu)
		{
			case LOBBY:
				if(isHost)
				{
					comecarBt.visible = true;
					configBt.visible = true;
				}
			case ROOMLIST:
				if(roomList!=null)
				{
					roomList.adicionar();
					add(roomList);
				}
			case MAIN:
				entrarBt.visible = true;
				hostearBt.visible = true;
				ipBar.visible = true;
				multiplayerTxt.visible=true;
			default:
				trace("esse menu ainda não foi adicionado");
		}
		curMenu = nextMenu;
	}

	public function voltarMenu()
		{
			switch(curMenu)
			{
				case LOBBY:
					if(curRoom != null)
						{
							curRoom.leave();
						}
				case ROOMLIST:
					changeMenu(MAIN);
				case MAIN:
					MusicBeatState.switchState(new MainMenuStateMobile());
				default:
					trace("esse menu ainda não foi adicionado");
			}
		}

	override function create()
	{
		instance = this;
		client = new Client('ws://serveo.net:2567');
		musicas = getAllSongs();
		multiplayerTxt = new FlxText(0, 0, FlxG.width - 95, "MULTIPLAYER", 100);
		multiplayerTxt.setFormat(Paths.font("letravio.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		multiplayerTxt.y = -1500;
		multiplayerTxt.screenCenter(X);

		ipBar = new FlxUIInputText(0, 0, 575, GJClient.userName, 50, FlxColor.BLACK, FlxColor.WHITE, true); // TODO: Uma lista com todos as rooms disponíveis e rooms com senha
		ipBar.screenCenter(X);
		ipBar.y = 1500;
		ipBar.alignment = CENTER;

		bGround = new FlxSprite(0, 0).loadGraphic(Paths.image('ph')); // paulo henrique
		bGround.setGraphicSize(Std.int(bGround.width));
		bGround.antialiasing = ClientPrefs.globalAntialiasing;
		bGround.updateHitbox();
		bGround.alpha = 1;
		add(bGround);

		add(ipBar);


		textinhoDebug = new FlxText(0, 0, 0, "", 25, true);
		textinhoDebug.screenCenter(XY);

		hostearBt = createButton('multiplayer/hospedarBt', 0.6, 0, 1500, true, true, hostear);
		add(hostearBt);
		entrarBt = createButton('multiplayer/entrarBt', 0.6, 0, 1500, true, true, mostrarSalas);
		add(entrarBt);

		add(multiplayerTxt);
		super.create();

		FlxTween.tween(multiplayerTxt, {y: 51}, 0.75, {ease: FlxEase.expoInOut});
		FlxTween.tween(ipBar, {y: 253}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(entrarBt, {y: 488}, 1.45, {
			ease: FlxEase.expoInOut,
			onComplete: function(tween:FlxTween)
			{
				canClick = true;
			}
		});
		FlxTween.tween(hostearBt, {y: 348}, 1.25, {ease: FlxEase.expoInOut});

		var num:Int = 0;
		for (player in players)
		{
			player.nome = num == 0 ? GJClient.userName : "";
			add(player);
			num++;
		}

		comecarBt = createButton('multiplayer/iniciarBt', 0.6, 276, 563, false, false, function(){
			if(canInitMatch && !isPlayingMatch)
				{	
					var mensagem:String = Std.string(MusicaAtual)+"\n"+Std.string(TrocarLados)+"\n"+Std.string(ModoDeJogo);
					curRoom.send("init-game", mensagem);
					//server.send({message: Std.string(MusicaAtual) + "\n" +Std.string(TrocarLados)+ "\n"+ Std.string(ModoDeJogo), verb: "init-match"});
				}
		});
		add(comecarBt);

		configBt = createButton('multiplayer/configBt', 0.6, 857, 563, false, false, function(){
			if (isOnOptions || isPlayingMatch)
				return;
			isOnOptions = true;
			configBt.visible = false;
			comecarBt.visible = false;
			openSubState(new OptionsSubstate());
		} );
		add(configBt);
		changeMenu(MAIN);
	}

	public function onOverBtns()
	{
		if (!canClick)
			return;
		GlobalSoundManager.play("scrollMenu");
	}

	public function getIsOnServer():Bool
	{
		return isOnServer;
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK && !ipBar.hasFocus && !isOnOptions && canClick && !isPlayingMatch)
		{
			GlobalSoundManager.play("cancelMenu");
			voltarMenu();
		}

		ipBar.hasFocus = false; // to pensando oq colocar nele aqui, enquanto isso fica desativado

		configBt.visible = isOnServer && isHost && !isOnOptions;
		comecarBt.visible = isOnServer && isHost && !isOnOptions;
		if (isOnServer)
		{
			inputShit();
		}
		canInitMatch = isOnServer && !isPlayingMatch && isHost && players[1].nome != "";
		super.update(elapsed);
	}

	function eventHandlers()
	{
		curRoom.onMessage("lobbyPlayers", function(message) {
			var allMessage:Array<String> = Std.string(message).split("\n");
			switch(allMessage[0])
			{
				case "entrou":
					players[Std.parseInt(allMessage[4])].nome = Std.string(allMessage[1]);
					players[Std.parseInt(allMessage[4])].charID = Std.string(allMessage[2]);
					players[Std.parseInt(allMessage[4])].sessionId = Std.string(allMessage[3]);
				case "saiu":
					players[Std.parseInt(allMessage[4])].nome = "";
					players[Std.parseInt(allMessage[4])].charID = "bf";
					players[Std.parseInt(allMessage[4])].sessionId = "";
			}
		});
		

		curRoom.onMessage("init-game", function(message) {
			if(isPlayingMatch)
				return;
			var allMessage:Array<String> = Std.string(message).split("\n");
			MusicaAtual = Std.parseInt(allMessage[0]);
			TrocarLados = allMessage[1] != "false" ? true : false;
			ModoDeJogo = Std.parseInt(allMessage[2]);
			initMatch();
		});

		curRoom.onMessage("toPronto", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.podeComecar++;
		});

		curRoom.onMessage("input-game", function(message) {
			if(!isPlayingMatch)
				return;
			daNoteReceived.push(Std.parseInt(message));
		});

		curRoom.onMessage("enviarMisses", function(message) {
			if(!isPlayingMatch)
				return;
			var allMessage:Array<String> = message.split("\n");
			MultiplayerPlayState.instance.opponentHits = Std.parseInt(allMessage[1]);
			MultiplayerPlayState.instance.opponentMisses = Std.parseInt(allMessage[2]);
			MultiplayerPlayState.instance.opponentScore = Std.parseInt(allMessage[3]);
		});

		curRoom.onMessage("queroSair", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.podeTerminar++;
		});

		curRoom.onMessage("stop-match", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.podeTerminar+=2; // DESCULPA X02 E LORENA NÃO MIM MATEM
		});

		curRoom.onMessage("lobbyInput", function(message) {
			mudaAeMano(Std.string(getIndexBySession(message.clientID)), message.qual, message.tipo, message.isHost);
		});

		curRoom.onMessage("leave", function(message) {
			curRoom.leave();
			switch(message.cause)
				{
					case 9000:
						avisarAlgo("O host se desconectou.");
					default:
						avisarAlgo("Reason: "+Std.string(message.cause));
				}
		});

		curRoom.onLeave+=function() {
			isOnServer = false;
			isHost = false;

			changeMenu(MAIN);

			var num:Int = 0;
			for (player in players)
			{
				player.nome = num == 0 ? GJClient.userName : "";
				add(player);
				num++;
			}
		};
	}

	public function hostear()
	{
		if (!canClick || ipBar.hasFocus)
			return;

		ipBar.hasFocus = false;
		canClick = false;
		//GlobalSoundManager.play('confirmMenu');

		var roomOptions:Map<String, Dynamic> = new Map<String, Dynamic>();
		roomOptions.set("salaNome", GJClient.userName+"'s Room");
		roomOptions.set("mode", "Score");
		roomOptions.set("changeSides", false);
		roomOptions.set("myName", GJClient.userName);
		roomOptions.set("myChar", "bf");
		roomOptions.set("isHost", "0");

		client.create("gameRoom", roomOptions, LobbyState, function(err, room) {
			if (err != null) {
				trace("CREATE ERROR: " + err);
				avisarAlgo(Std.string(err));
				return;
			}
			curRoom = room;
			isHost = true;
			isOnServer = true;
			
			changeMenu(LOBBY);
			players[0].nome = GJClient.userName;
			players[0].charID = "bf";
			players[0].sessionId = curRoom.sessionId;

			eventHandlers();

			canClick = true;

		});
	}

	public function initMatch()
	{
		if(isPlayingMatch)
			return;
		isPlayingMatch = true;
		openSubState(new multiplayer.MultiplayerPlayState(0, musicas[MusicaAtual][1], isHost, TrocarLados, ModoDeJogo));
	}

	public function enviarInputGame(note:Int)
	{
		if(!isPlayingMatch)
			return;
		curRoom.send("input-game", Std.string(note));
		//trace("Enviei Input "+Std.string(note));
	}

	public function enviarToPronto()
	{
		if(!isPlayingMatch)
			return;
		curRoom.send("toPronto", 1);
	}

	public function enviarQueroTerminar()
	{
		if(!isPlayingMatch)
			return;
		curRoom.send("queroSair", 1);
	}

	public function enviarMissesEHits(hits:Int, misses:Int, score:Int)
	{
		if(!isPlayingMatch)
			return;
		curRoom.send("enviarMisses", Std.string(myID) + "\n" + Std.string(hits) + "\n" + Std.string(misses)+ "\n" + Std.string(score));
	}

	public function send_results(hits:Array<Int>, combo:Int, score:Int, playerName:String)
	{
		var hits_message:String = '';
		for (hit in hits){hits_message += Std.string(hit) + ", ";}
		hits_message = hits_message.substring(0, hits_message.length - 2); //Serve para remover o último ", "
		//usuario.send({myID: myID, message: Std.string(myID) + "\n" + hits_message + "\n" + Std.string(combo) + "\n" + Std.string(score) + "\n" + playerName, verb: 'results'});
	}

	//private function definirUsuario():Void {usuario = isHost ? server : client;}

	public function endMatch()
	{
		if(!isPlayingMatch)
			return;
		//openSubstate(new ResultsSubstate([sicks, goods, bads, shits], 1, combo, songScore, GJClient.username));
		isPlayingMatch = false;
		for(bf in players)
		{
			bf.keys = [false, false, false, false];
			bf.resetPos();
		}
		daNoteReceived = [];
		FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
	}

	public function mostrarSalas()
	{
		if(!canClick || ipBar.hasFocus)
			return;
		canClick = false;
		var roomArray:Array<RoomAvailable> = [];
		client.getAvailableRooms("gameRoom", function(err, rooms) {
			if (err != null) {
			  	trace(err);
				avisarAlgo(Std.string(err));
			  	return;
			}
			roomArray = rooms;
			changeMenu(ROOMLIST);
			canClick = true;
		  });
		roomList = new RoomList(0, 0, roomArray);
		openSubState(roomList);
	}

	public function entrar(room:RoomAvailable)
	{
		if (!canClick || ipBar.hasFocus)
			return;
		if(roomList != null)
		{
			roomList.remover();
		}
		canClick = false;
		//GlobalSoundManager.play('confirmMenu');

		var roomOptions:Map<String, Dynamic> = new Map<String, Dynamic>();
		roomOptions.set("myName", GJClient.userName);
		roomOptions.set("myChar", "bf");
		roomOptions.set("isHost", "1");

		client.getAvailableRooms("gameRoom", function(err, rooms) {
			if (err != null) {
			  	trace(err);
				avisarAlgo(Std.string(err));
			  	return;
			}
			var contem:Bool = false;
			for (roomAvailable in rooms)
			{
				if(roomAvailable.roomId == room.roomId)
				{
					client.joinById(room.roomId, roomOptions, LobbyState, function(err, room) {
						if (err != null) {
							trace("JOIN ERROR: " + err);
							avisarAlgo(Std.string(err));
							canClick = true;
							return;
						}
			
			
						curRoom = room;
						isHost = false;
						isOnServer = true;
			
						changeMenu(LOBBY);
						players[1].nome = GJClient.userName;
						players[1].charID = "bf";
						players[1].sessionId = curRoom.sessionId;
			
						eventHandlers();
			
						canClick = true;
					});
					contem = true;
					break;
				}
			}
			if(!contem)
			{
				canClick = true;
				avisarAlgo("Sala indisponível");
				changeMenu(MAIN);
			}
		});


	}

	function getIndexBySession(sessionId:String):Int
	{
		for (i in 0...players.length)
		{
			if(players[i].sessionId == sessionId)
			{
				return i;
			}
		}
		return -1;
	}

	function segureiObotao(qual:String)
	{
		curRoom.send("lobbyInput", {clientID: curRoom.sessionId, tipo: "Segurei", qual: qual, isHost: isHost});
	}

	function solteiObotao(qual:String)
	{
		curRoom.send("lobbyInput", {clientID: curRoom.sessionId, tipo: "Soltei", qual: qual, isHost: isHost});
	}

	function mudaAeMano(zero:String, one:String, two:String, ?isServer:Bool = false)
	{
		var zeroInt:Int = Std.parseInt(zero);
		if (two == "Segurei")
		{
			switch (one)
			{
				case "cima":
					players[zeroInt].keys[2] = true;
				case "baixo":
					players[zeroInt].keys[1] = true;
				case "direita":
					players[zeroInt].keys[3] = true;
				case "esquerda":
					players[zeroInt].keys[0] = true;
			}

			if (isServer)
			{
				//server.send({message: zero + " " + one + " Segurei", verb: 'input'});
			}

			players[zeroInt].bfAnims(one);
		}
		else
		{
			switch (one)
			{
				case "cima":
					players[zeroInt].keys[2] = false;
				case "baixo":
					players[zeroInt].keys[1] = false;
				case "direita":
					players[zeroInt].keys[3] = false;
				case "esquerda":
					players[zeroInt].keys[0] = false;
			}
			if (isServer)
			{
				//server.send({message: zero + " " + one + " Soltei", verb: 'input'});
			}
			if (players[zeroInt].keys[0] == false && players[zeroInt].keys[1] == false && players[zeroInt].keys[2] == false && players[zeroInt].keys[3] == false)
			{
				players[zeroInt].bfAnims(one, true);
			}
		}
	}

	var imRemoving:Bool = false;

	public function inputShit()
	{
		//trace("Player 1: "+players[0].keys.toString() + "\nPlayer 2: " + players[1].keys.toString());
		if(!isPlayingMatch)
		{
			if (controls.NOTE_UP_P)
				{
					segureiObotao("cima");
				}
				if (controls.NOTE_DOWN_P)
				{
					segureiObotao("baixo");
				}
				if (controls.NOTE_RIGHT_P)
				{
					segureiObotao("direita");
				}
				if (controls.NOTE_LEFT_P)
				{
					segureiObotao("esquerda");
				}
		
				if (controls.NOTE_UP_R)
				{
					solteiObotao("cima");
				}
				if (controls.NOTE_DOWN_R)
				{
					solteiObotao("baixo");
				}
				if (controls.NOTE_RIGHT_R)
				{
					solteiObotao("direita");
				}
				if (controls.NOTE_LEFT_R)
				{
					solteiObotao("esquerda");
				}
		}

		
		if(daNoteReceived.length>0 && !imRemoving)
		{
			imRemoving = true;
			new FlxTimer().start(2.5, function(tmr:FlxTimer) {
				if(daNoteReceived.length>0)
				{
					daNoteReceived.remove(daNoteReceived[0]);
				}
				imRemoving = false;
			});
		}

		/*if(isPlayingMatch)
		{
			trace(Std.string(daNoteReceived));
		}*/
	}

	function avisarAlgo(avisarIssoAqui:String)
	{
		GlobalSoundManager.play("negado");
		canClick = false;
		blackTransBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTransBG.alpha = 0.75;
		add(blackTransBG);

		avisoBg = new FlxSprite(281, 102).loadGraphic(Paths.image('multiplayer/submenus/avisoPanel', 'preload', false));
		avisoBg.antialiasing = ClientPrefs.globalAntialiasing;
		avisoBg.updateHitbox();
		avisoBg.x = 281;
		avisoBg.y = 102;
		add(avisoBg);

		avisoTexto = new FlxText(281, 300, 725, avisarIssoAqui, 40, false);
		avisoTexto.alignment = CENTER;
		add(avisoTexto);

		okBt = new FlxButton(0, 0, '');
		okBt.loadGraphic(Paths.image('mainmenu/btok', 'preload', false));
		okBt.updateHitbox();
		okBt.alpha = 0.75;
		okBt.x = 527;
		okBt.y = 532;
		add(okBt);
		okBt.onDown.callback = function()
		{
			remove(blackTransBG);
			remove(avisoBg);
			remove(okBt);
			remove(avisoTexto);
			canClick = true;
			GlobalSoundManager.play("confirmMenu");
		}
		okBt.onOver.callback = function()
		{
			okBt.alpha = 1;
			GlobalSoundManager.play("scrollMenu");
		}
		okBt.onOut.callback = function()
		{
			okBt.alpha = 0.75;
		}
	}

	override function beatHit()
	{
		super.beatHit();
		for (player in players)
		{
			if(player.keys == [false, false, false, false])
			{
				player.bf.playAnim('idle', true);
			}
		}
	}
							  //Não é mignon (malz...)
	function createButton(file:String, scale:Float, x:Float, y:Float, visible:Bool = true, centralize:Bool = true, ?callback:Function = null, ?arg:Dynamic= null):FlxButton {
        var button = new FlxButton(x, y, '');
        button.loadGraphic(Paths.image(file, 'preload'));
        button.setGraphicSize(Std.int(button.width * scale));
        button.updateHitbox();
		if (centralize)
        	button.screenCenter(X);
        button.visible = visible;
		button.alpha = 0.75;
		button.onOver.callback = function() {
			if(!button.visible || !canClick)
				return;
			GlobalSoundManager.play("scrollMenu");
			button.alpha=1;
		}
		button.onOut.callback = function() {
			if(!button.visible || !canClick)
				return;
			button.alpha=0.75;
		}
		button.onDown.callback = function() {
			if(!button.visible && callback != null && canClick)
				return;
			GlobalSoundManager.play("confirmMenu");
			if(arg != null)
			{
				callback(arg);
			}
			else
			{
				callback();
			}
		}
        return button;
    }

}

class LobbyPlayerObject extends FlxSpriteGroup
{
	public var sessionId:String = "";
	public var nome:String = "Player 1";
	public var charID:String = "bf";
	public var keys:Array<Bool> = [false, false, false, false];
	public var bf:Boyfriend;
	public var isConnected:Bool = false;
	var textinhoBF:FlxText;

	public function new(x:Float, y:Float)
	{
		super(x,y);

		// BOYFRIEND LES GOOO
		bf = new Boyfriend(0, 0);
		bf.playAnim('idle', false, false, 10);
		add(bf);

		// TEXTINHO TEXTOSO
		textinhoBF = new FlxText(90, 0, 0, "", 50, true);
		textinhoBF.alignment = CENTER;
		add(textinhoBF);
		textinhoBF.y = bf.y-60;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		isConnected = nome != "";
		textinhoBF.text = isConnected ? nome : "";
		bf.alpha = isConnected ? 1 : 0.5;
		bf.visible = MultiplayerMainMenuState.instance.getIsOnServer();
		textinhoBF.visible = MultiplayerMainMenuState.instance.getIsOnServer();
		textinhoBF.alignment = CENTER;
	}

	public function bfAnims(direction:String, ?soltou:Bool = false)
		{
			if (!soltou)
			{
				switch (direction)
				{
					case "esquerda":
						bf.playAnim('singLEFT', true);
					case "baixo":
						bf.playAnim('singDOWN', true);
					case "cima":
						bf.playAnim('singUP', true);
					case "direita":
						bf.playAnim('singRIGHT', true);
				}
			}
	
			if (soltou)
			{
				bf.playAnim('idle', false);
			}
		}

	public function resetPos()
	{
		bf.playAnim('idle', true);
	}
}

class RoomList extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var scrollBar:FlxScrollableArea;
	var roomList:FlxSpriteGroup;
	var viewPortRect:FlxRect;
	
	public function new(x:Int, y:Int, rooms:Array<RoomAvailable>)
	{
		super();
		refresh(rooms);
		MultiplayerMainMenuState.instance.curMenu = ROOMLIST;
	}

	public function refresh(rooms:Array<RoomAvailable>)
	{
		var num:Int = 0;
		roomList = cast add(new FlxSpriteGroup());

		for (room in rooms) {
			var roomObject:RoomObject = new RoomObject(((100*num)+num*5), room);
			roomList.add(roomObject);
			num++;
		}

		roomList.setPosition(-2560);
		viewPortRect = new FlxRect( 325, 100, 600, 500 );

		scrollBar = new FlxScrollableArea(viewPortRect, roomList.getHitbox(), ResizeMode.NONE, -1, FlxColor.LIME, this);
		adicionar();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
			{
				GlobalSoundManager.play("cancelMenu");
				MultiplayerMainMenuState.instance.voltarMenu();
			}
	}

	public function adicionar()
	{
		if(!FlxG.cameras.list.contains(scrollBar))
		{
			FlxG.cameras.add(scrollBar);
		}
	}

	public function remover()
	{
		if(FlxG.cameras.list.contains(scrollBar))
			{
				FlxG.cameras.remove(scrollBar, true);
			}
		close();
	}

	override function close()
	{
		super.close();
	}

}

class RoomObject extends FlxSpriteGroup
{
	var nameTxt:FlxText;
	var descTxt:FlxText;
	var fundo:FlxSprite;
	var room:RoomAvailable;
	var joinButton:FlxButton;

	public function new(y:Int, room:RoomAvailable)
	{
		super(0,y);
		this.room = room;
		this.alpha = 0.75;
		fundo = new FlxSprite(0,0).makeGraphic(600, 100, FlxColor.GRAY);
		add(fundo);
		createJoinButton();
		nameTxt = new FlxText(0, 30, 600, room.metadata.displayName, 30, true);
		nameTxt.autoSize=true;
		nameTxt.alignment=CENTER;
		add(nameTxt);
	}

	function createJoinButton()
	{
		joinButton = new FlxButton(0, 0, "", function(){MultiplayerMainMenuState.instance.entrar(room);GlobalSoundManager.play("confirmMenu");});
		joinButton.onOver.callback = function(){this.alpha = 1;GlobalSoundManager.play("scrollMenu");} ;
		joinButton.onOut.callback = function(){this.alpha = 1;};
        joinButton.setGraphicSize(Std.int(this.width), Std.int(this.height));
        joinButton.updateHitbox();
		joinButton.alpha = 0.75;
		add(joinButton);
	}
}

class OptionsSubstate extends MusicBeatSubstate
{
	var scrollBar:FlxScrollableArea;
	var optionsObjects:FlxSpriteGroup;
	//talvez eu refaça isso aqui tudo

	// 0 = Bool, 1 = Selection
	//name, type, desc
	var options:Array<Dynamic> = [
		["Modo de Jogo", 1, "Muda o modo de jogo atual", ["ModoDeJogo", "modos", true]],
		["Musica Atual", 1, "Muda a musica atual", ["MusicaAtual", "musicas", false]], 
		["Trocar Lados", 0, "Troca o lado dos jogadores", ["TrocarLados"]]

	];

	public function new()
	{
		super();
	}

	override function create()
	{
		var num:Int = 1;
		optionsObjects = cast add(new FlxSpriteGroup());
		var textoOptions:FlxText = new FlxText(0, 50, 0, "OPÇÕES", 30);
		textoOptions.screenCenter(X);
		optionsObjects.add(textoOptions);

		for (option in options) {
			var button:OptionObject = new OptionObject(((100*num)+num*5), option[0], option[1], option[2], option[3]);
			optionsObjects.add(button);
			num++;
		}

		optionsObjects.setPosition(-1280, 0);

		scrollBar = new FlxScrollableArea( new FlxRect( 0, 0, FlxG.width, FlxG.height ), optionsObjects.getHitbox(), ResizeMode.NONE, -1, FlxColor.LIME, this);
		FlxG.cameras.add(scrollBar);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
		{
			close();
		}
	}

	override function close()
	{
		FlxG.cameras.remove(scrollBar);
		MultiplayerMainMenuState.instance.isOnOptions = false;
		super.close();
	}
}

class OptionObject extends FlxSpriteGroup
{
	// principais
	var nameTxt:FlxText;
	var descTxt:FlxText;
	var fundo:FlxSprite;
	var type:Int;

	//bool
	var button:FlxButton;
	var ativado:Bool;
	var reference:String;

	//selection
	var selection:SelectionObject;

	public function new(y:Int, name:String, type:Int, desc:String, variable:Dynamic)
		{
			super(150, y);
			this.type = type;
			fundo = new FlxSprite(0,0).makeGraphic(1280-300, 100, FlxColor.GRAY);
			add(fundo);
			nameTxt = new FlxText(5, 20, 0, name, 30);
			add(nameTxt);
			descTxt = new FlxText(5, 50, 0, desc, 20);
			add(descTxt);
			switch(type)
			{
				case 0: // se for só um bool
					reference = variable[0];
					ativado = Reflect.getProperty(MultiplayerMainMenuState.instance, reference);
					button = new FlxButton(1165.5-300+20, 18.5, "", clickButton);
					button.loadGraphic(Paths.image(ativado?'multiplayer/submenus/checkbox_checked':'multiplayer/submenus/checkbox', 'preload'));
					button.updateHitbox();
					add(button);
				case 1: // se for selecionável
					selection = new SelectionObject(500, 18.5, variable);
					add(selection);
			}
		}
	
	function clickButton()
	{
		ativado = !ativado;
		button.loadGraphic(Paths.image(ativado?'multiplayer/submenus/checkbox_checked':'multiplayer/submenus/checkbox', 'preload'));
		save();
	}

	function save()
	{
		Reflect.setProperty(MultiplayerMainMenuState.instance, reference, ativado);
	}
}

class SelectionObject extends FlxSpriteGroup
{
	var atual:FlxText;
	var desc:FlxText;
	var setaDireita:FlxButton;
	var setaEsquerda:FlxButton;

	var value:Int;
	var list:Array<Dynamic>;
	var reference:String;

	public function new(x:Float, y:Float, variable:Dynamic)
	{
		super(x, y);
		reference = variable[0];
		value = Reflect.getProperty(MultiplayerMainMenuState.instance, reference);
		list = Reflect.getProperty(MultiplayerMainMenuState.instance, variable[1]);


		atual = new FlxText(97.5, 18, 300, list[value][0], 25);
		atual.autoSize = true;
		atual.alignment = CENTER;
		add(atual);

		//se tem desc
		if(variable[2] == true)
		{
			atual.y = 10;
			desc = new FlxText(97.5, 30, 300, list[value][1], 12);
			desc.autoSize = true;
			desc.alignment = CENTER;
			add(desc);
		}

		setaEsquerda = new FlxButton(45, 0, "", clickEsquerda);
		setaEsquerda.loadGraphic(Paths.image('multiplayer/submenus/seta', 'preload'));
		setaEsquerda.updateHitbox();
		add(setaEsquerda);
		setaDireita = new FlxButton(385, 0, "", clickDireita);
		setaDireita.loadGraphic(Paths.image('multiplayer/submenus/seta', 'preload'));
		setaDireita.flipX=true;
		setaDireita.updateHitbox();
		add(setaDireita);
	}

	function clickEsquerda()
	{
		if(value-1 >= 0)
			{
				value--;
			}
			else
			{
				value = list.length-1;
			}
		save();

	}

	function clickDireita()
		{
			if(value+1 < list.length)
				{
					value++;
				}
				else
				{
					value = 0;
				}
			save();
	
		}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		atual.text = list[value][0];
		if(desc!=null)
		{
			desc.text = list[value][1];
		}

	}

	function save()
	{
		Reflect.setProperty(MultiplayerMainMenuState.instance, reference, value);
	}
}
