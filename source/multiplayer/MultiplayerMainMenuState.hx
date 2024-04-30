package multiplayer;

import modifiers.ModifiersManager;
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
import Utils.FlxScrollableArea;
import flixel.math.FlxRect;
import openfl.utils.Assets as OpenFlAssets;
import multiplayer.schemas.*;
import multiplayer.entities.*;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;
import gamejolt.*;

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
	SKINS;
}

class MultiplayerMainMenuState extends MusicBeatState
{
	private var servidor:String = "ws://serveo.net:2567";

	// COISAS UI
	var hostearBt:FlxButton;
	var entrarBt:FlxButton;
	var skinsBt:FlxButton;
	var skinsTxt:FlxText;
	var voltarSkinsBt:FlxButton;
	var comecarBt:FlxButton;
	var configBt:FlxButton;
	var bGround:FlxSprite;
	var multiplayerTxt:FlxText;
	public var canClick:Bool = false;
	var textinhoDebug:FlxText;
	var connectingText:FlxText;
	var readyTxt:FlxText;

	// SUBMENU OPÇÕES
	public var isOnOptions:Bool = false;

	// SUBMENU AVISOS
	var blackTransBG:FlxSprite;
	var avisoBg:FlxSprite;
	var avisoTexto:FlxText;
	var okBt:FlxButton;

	// SERVER
    public var client:Client;
	var curRoom:Room<LobbyState>;
	var quisSair:Bool = false;

	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;
	var canInitMatch:Bool = false;
	//var selectedMusic:String = "soulless/soulless-hard";
	var isPlayingMatch:Bool = false;
	public var daNoteReceived:Array<Int> = [];

	// PLAYERS
	public var players:Array<LobbyPlayerObject> = [new LobbyPlayerObject(174,190, true), new LobbyPlayerObject(681,190)];
	public static var instance:MultiplayerMainMenuState;

	// SKINS
	public var skins:Array<Dynamic> = [
		[LangUtil.getString("skin_default", "multiplayer"), "default_notes"],
		[LangUtil.getString("skin_orange", "multiplayer"), "orange_notes"],
		[LangUtil.getString("skin_emerald", "multiplayer"), "purple_green_notes"],
		[LangUtil.getString("skin_blacknwhite", "multiplayer"), "black_n_white_notes"],
		[LangUtil.getString("skin_classic", "multiplayer"), "NOTE_assets"]
	];
	public var skinAtual:Int = 0;
	public var skinSelector:SkinSelector;

	// VARIAVEIS OPÇÕES
	public var modos:Array<Dynamic> = [
		[LangUtil.getString("selection_score_name", "multiplayer"), LangUtil.getString("selection_score_desc", "multiplayer")],
		[LangUtil.getString("selection_hits_name", "multiplayer"), LangUtil.getString("selection_hits_desc", "multiplayer")],
		[LangUtil.getString("selection_misses_name", "multiplayer"), LangUtil.getString("selection_misses_desc", "multiplayer")]
	];
	public var ModoDeJogo:Int = 0;

	public var TrocarLados:Bool = false;

	public var musicas:Array<Dynamic> = [];
	public var MusicaAtual:Int = 0;

	public var roomList:RoomList;
	public var curMenu:MenuEnum = CONNECTING;

	function getAllSongs():Array<Dynamic>
	{
		WeekData.reloadWeekFiles(true);
		var nomesEPaths:Array<Dynamic> = [];
		for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			for (i in 0...leWeek.songs.length) {
				var path:String = Paths.formatToSongPath(leWeek.songs[i][0]);
				nomesEPaths.push([leWeek.songs[i][3], path]);
			}
		}

		for (i in 0...WeekData.freeplayList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.freeplayList[i]);
			for (i in 0...leWeek.songs.length) {
				var path:String = Paths.formatToSongPath(leWeek.songs[i][0]);
				nomesEPaths.push([leWeek.songs[i][3], path]);
			}
		}
		
		return nomesEPaths;
	}

	var idConvite:String = "";
	var convidei:Bool = false;
	public function aceitarConvite(id:String, convidei:Bool)
	{
		idConvite = id;
		this.convidei = convidei;
	}

	function resetInviteVars()
	{
		idConvite = "";
		convidei = false;
	}

	function deactivateAll()
	{
		entrarBt.visible = false;
		hostearBt.visible = false;
		multiplayerTxt.visible=false;

		skinsBt.visible = false;
		voltarSkinsBt.visible = false;
		skinSelector.visible = false;
		skinsTxt.visible = false;
		
		comecarBt.visible = false;
		configBt.visible = false;
		readyTxt.visible = false;

		connectingText.visible = false;

		if(roomList != null)
		{
			roomList.remover();
			roomList = null;
		}
	}

	public function changeMenu(nextMenu:MenuEnum)
	{
		deactivateAll();
		switch(nextMenu)
		{
			case LOBBY:
				if(isHost)
				{
					comecarBt.x = 276;
					comecarBt.visible = true;
					configBt.visible = true;
				}
				else
				{
					comecarBt.screenCenter(X);
				}
				readyTxt.visible = true;
			case ROOMLIST:
				if(roomList!=null)
				{
					roomList.adicionar();
					add(roomList);
				}
			case MAIN:
				if(idConvite != "")
				{
					if(!convidei)
					{
						var sala:RoomAvailable = null;
						for(room in getAvailableRooms())
						{
							if(room.metadata.displayName == idConvite)
							{
								sala = room;
								break;
							}
						}
						if(sala!=null)
						{
							entrar(sala, true);
						} else {
							trace("sala n encontrada");
							avisarAlgo(LangUtil.getString("alert_room_unavailable", "multiplayer"), new MainMenuStateMobile());
						}
						resetInviteVars();
					}
					else
					{
						hostear(true);
					}
				}
				else
				{
					skinsBt.visible = true;
					entrarBt.visible = true;
					hostearBt.visible = true;
					multiplayerTxt.visible=true;
				}
			case CONNECTING:
				connectingText.visible = true;
			case SKINS:
				skinsTxt.visible = true;
				voltarSkinsBt.visible = true;
				skinSelector.visible = true;
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
					quisSair=true;
					if(curRoom != null)
						{
							curRoom.leave();
						}
				case ROOMLIST:
					changeMenu(MAIN);
				case MAIN:
					modifiers.ModifiersManager.loadSave();
					MusicBeatState.switchState(new MainMenuStateMobile());
				case SKINS:
					changeMenu(MAIN);
				default:
					trace("n tem menu anterior");
			}
		}

	override function create()
	{
		instance = this;
		if(!MainMenuStateMobile.passouCY)
		{
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
		skinAtual = ClientPrefs.curMultiplayerNoteSkin;
		FlxG.autoPause = false;
		modifiers.ModifiersManager.currentModifiers = [];
		client = new Client(servidor);
		musicas = getAllSongs();
		multiplayerTxt = new FlxText(0, 0, FlxG.width - 95, LangUtil.getString("main_label", "multiplayer"), 100);
		multiplayerTxt.setFormat(Paths.font("letravio.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		multiplayerTxt.y = -1500;
		multiplayerTxt.screenCenter(X);

		bGround = new FlxSprite(0, 0).loadGraphic(Paths.image('ph')); // paulo henrique
		bGround.setGraphicSize(Std.int(bGround.width));
		bGround.antialiasing = ClientPrefs.globalAntialiasing;
		bGround.updateHitbox();
		bGround.alpha = 1;
		add(bGround);

		readyTxt = new FlxText(0, 0, FlxG.width - 95, LangUtil.getString("lobby_ready_label", "multiplayer") + " 0/2", 100);
		readyTxt.setFormat(Paths.font("letravio.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		readyTxt.y = 51;
		readyTxt.screenCenter(X);

		textinhoDebug = new FlxText(0, 0, 0, "", 25, true);
		textinhoDebug.screenCenter(XY);

		hostearBt = createButton('multiplayer/hospedarBt', 0.6, 0, 1500, true, true, hostear, null, LangUtil.getString("main_host_bt", "multiplayer"));
		add(hostearBt);
		entrarBt = createButton('multiplayer/entrarBt', 0.6, 0, 1500, true, true, mostrarSalas, null, LangUtil.getString("main_join_bt", "multiplayer"));
		add(entrarBt);

		add(multiplayerTxt);
		super.create();

		var num:Int = 0;
		for (player in players)
		{
			player.nome = num == 0 ? "" : "";
			add(player);
			num++;
		}

		comecarBt = createButton('multiplayer/iniciarBt', 0.6, 276, 563, false, false, function(){
			if(canInitMatch && !isPlayingMatch)
				{	
					curRoom.send("toggle-ready");
				}
		}, null, LangUtil.getString("lobby_ready_bt", "multiplayer"));
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

		connectingText = new FlxText(0, 0, 0, LangUtil.getString("txt_connecting", "multiplayer"), 24);
		connectingText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 24, 0xFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		connectingText.screenCenter(XY);
		add(connectingText);

		add(readyTxt);

		skinSelector = new SkinSelector();
		skinSelector.screenCenter(XY);
		add(skinSelector);

		voltarSkinsBt = createButton('multiplayer/voltarSkinsBt', 0.6, 0, 563, false, true,  function(){
			if (curMenu != SKINS || !canClick)
				return;
			canClick = false;
			new FlxTimer().start(0.1, function (tmr:FlxTimer) {
				voltarMenu();
				canClick = true;
			});
		}, null, LangUtil.getString("main_back_bt", "multiplayer"));

		skinsBt = createButton('multiplayer/iniciarBt', 0.6, 0, 1500, false, true, function(){
			if (curMenu != MAIN || !canClick)
				return;
			canClick = false;
			new FlxTimer().start(0.1, function (tmr:FlxTimer) {
				changeMenu(SKINS);
				canClick = true;
			});
		}, null, LangUtil.getString("main_skins_bt", "multiplayer"));
		add(skinsBt);

		add(voltarSkinsBt);

		skinsTxt = new FlxText(0, 0, FlxG.width - 95, LangUtil.getString("skins_label", "multiplayer"), 100);
		skinsTxt.setFormat(Paths.font("letravio.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skinsTxt.y = 51;
		skinsTxt.screenCenter(X);
		add(skinsTxt);

		changeMenu(CONNECTING);
		checkServers();
	}

	function checkServers()
	{
		trace('checking for update');
		var http = new haxe.Http(servidor.replace("ws", "http")+"/");
		var voltarMenu:Bool = false;
		http.onData = function(data:String)
		{
			var updateVersion:String = data.split('\n')[0].trim();
			var curVersion:String = MainMenuStateMobile.version.trim();
			trace('version online: ' + updateVersion + ', your version: ' + curVersion);
			var updateInt:Int = Std.parseInt(updateVersion.split(".")[0]+updateVersion.split(".")[1]+updateVersion.split(".")[2]);
			var curInt:Int = Std.parseInt(curVersion.split(".")[0]+curVersion.split(".")[1]+curVersion.split(".")[2]);
			if (updateInt > curInt)
			{
				trace('versao muito antiga');
				avisarAlgo(LangUtil.getString("alert_old_version", "multiplayer"), new MainMenuStateMobile());
				connectingText.visible = false;
				voltarMenu = true;
			}
		}

		http.onError = function(error)
		{
			trace('error: $error');
			avisarAlgo(LangUtil.getString("alert_connection_error", "multiplayer"), new MainMenuStateMobile());
			connectingText.visible = false;
			voltarMenu = true;
		}

		http.request();
		if(!voltarMenu)
		{
			changeMenu(MAIN);
			FlxTween.tween(multiplayerTxt, {y: 51}, 0.75, {ease: FlxEase.expoInOut});
			FlxTween.tween(entrarBt, {y: 394}, 1.45, {ease: FlxEase.expoInOut});
			FlxTween.tween(hostearBt, {y: 253}, 1.25, {ease: FlxEase.expoInOut});
			FlxTween.tween(skinsBt, {y: 535}, 1.65, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween)
			{
				canClick = true;
			}});
		}
	}

	public function onOverBtns()
	{
		if (!canClick)
			return;
		GlobalSoundManager.play(scrollMenu);
	}

	public function getIsOnServer():Bool
	{
		return isOnServer;
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK && !isOnOptions && canClick && !isPlayingMatch)
		{
			GlobalSoundManager.play(cancelMenu);
			voltarMenu();
		}


		configBt.visible = isOnServer && isHost && !isOnOptions;
		comecarBt.visible = isOnServer && !isOnOptions;
		if (isOnServer)
		{
			inputShit();
		}
		canInitMatch = isOnServer && !isPlayingMatch;
		super.update(elapsed);
	}

	function eventHandlers()
	{
		curRoom.onMessage("lobbyPlayers", function(message) {
			switch(message.type)
			{
				case "entrou":
					players[message.playerIndex].nome = message.username;
					players[message.playerIndex].charID = message.char;
					players[message.playerIndex].sessionId = message.sessionId;
					players[message.playerIndex].noteSkin = message.noteSkin;
				case "saiu":
					players[message.playerIndex].nome = "";
					players[message.playerIndex].charID = "bf";
					players[message.playerIndex].sessionId = "";
					players[message.playerIndex].noteSkin = "NOTE_assets";
			}
		});


		curRoom.onMessage("everyoneReady", function(message){
			if(!isHost || isPlayingMatch)
				return;
			if(OptionsSubstate.instance!=null)
			{
				OptionsSubstate.instance.close();
			}
			curRoom.send("init-game", {musicaAtual: MusicaAtual, trocarLados: TrocarLados, modoDeJogo: ModoDeJogo});
		});

		curRoom.onMessage("init-game", function(message) {
			if(isPlayingMatch)
				return;
			MusicaAtual = message.musicaAtual;
			TrocarLados = message.trocarLados;
			ModoDeJogo = message.modoDeJogo;
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
			daNoteReceived.push(message.note);
		});

		curRoom.onMessage("enviarMisses", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.opponentHits = message.hits;
			MultiplayerPlayState.instance.opponentMisses = message.misses;
			MultiplayerPlayState.instance.opponentScore = message.score;
		});

		curRoom.onMessage("queroSair", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.podeTerminar++;
			if(Std.parseInt(message) > 1)
			{
				MultiplayerPlayState.instance.podeTerminar+=2;
				MultiplayerPlayState.instance.endSong();
			}
		});

		curRoom.onMessage("stop-match", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.podeTerminar+=2; // DESCULPA X02 E LORENA NÃO MIM MATEM
		});

		curRoom.onMessage("lobbyInput", function(message) {
			mudaAeMano(Std.string(getIndexBySession(message.clientID)), message.qual, message.tipo, message.isHost);
		});

		curRoom.onMessage("newReady", function(message) {
			readyTxt.text = LangUtil.getString("lobby_ready_label", "multiplayer") + " "+Std.string(message)+"/2";
		});

		curRoom.onMessage("leave", function(message) {
			if(isPlayingMatch)
			{
				MultiplayerPlayState.instance.podeTerminar+=2;
			}
			curRoom.leave();
			switch(message.cause)
				{
					case 9000:
						avisarAlgo(LangUtil.getString("alert_host_disconnected", "multiplayer"));
					default:
						avisarAlgo(LangUtil.getString("alert_default", "multiplayer")+"\n"+Std.string(message.cause));
				}
		});

		curRoom.connection.onClose = function() {
			if(isPlayingMatch)
			{
				MultiplayerPlayState.instance.podeTerminar+=2;
			}
			if(isHost && !quisSair)
			{
				avisarAlgo(LangUtil.getString("alert_connection_error", "multiplayer"));
			}
			reiniciarTudo();
		};

		curRoom.onLeave+=reiniciarTudo;
	}

	function reiniciarTudo()
	{
		quisSair = false;
		curRoom = null;
		isOnServer = false;
		isPlayingMatch = false;
		isOnOptions = false;
		isHost = false;

		changeMenu(MAIN);

		var num:Int = 0;
		for (player in players)
		{
			player.nome = num == 0 ? "" : "";
			add(player);
			num++;
		}
	}

	public function hostear(?force:Bool = false)
	{
		if (!canClick && !force)
			return;

		canClick = false;
		changeMenu(CONNECTING);
		

		var roomOptions:Map<String, Dynamic> = new Map<String, Dynamic>();
		roomOptions.set("salaNome", idConvite!="" ? idConvite : GJClient.userName);
		roomOptions.set("mode", "Score");
		roomOptions.set("changeSides", false);
		roomOptions.set("myName", GJClient.userName);
		roomOptions.set("myChar", "bf");
		roomOptions.set("isHost", "0");
		roomOptions.set("noteSkin", skins[skinAtual][1]);
		roomOptions.set("privateRoom", idConvite!=""?true:false);
		resetInviteVars();

		client.create("gameRoom", roomOptions, LobbyState, function(err, room) {
			if (err != null) {
				trace("CREATE ERROR: " + err);
				avisarAlgo(Std.string(err));
				changeMenu(MAIN);
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
		if(isPlayingMatch || curRoom == null)
			return;
		isPlayingMatch = true;
		if(isHost)
		{
			if(OptionsSubstate.instance!=null)
				{
					OptionsSubstate.instance.close();
				}
		}
		var url:String = servidor.replace("ws", "http")+"/charts/"+musicas[MusicaAtual][1]+".json";
		openSubState(new multiplayer.MultiplayerPlayState(0, url, isHost, TrocarLados, ModoDeJogo, players[getIndexBySession(curRoom.sessionId)], players[getOtherIndexBySession(curRoom.sessionId)]));
	}

	public function enviarInputGame(note:Int)
	{
		if(!isPlayingMatch || curRoom == null)
			return;
		curRoom.send("input-game", {note: note});
		//trace("Enviei Input "+Std.string(note));
	}

	public function enviarToPronto()
	{
		if(!isPlayingMatch || curRoom == null)
			return;
		curRoom.send("toPronto", 1);
	}

	public function enviarQueroTerminar()
	{
		if(!isPlayingMatch || curRoom == null)
			return;
		curRoom.send("queroSair", 1);
	}

	public function enviarPrecisoTerminar()
	{
		if(!isPlayingMatch || curRoom == null)
			return;
		curRoom.send("queroSair", 2);
	}

	public function enviarMissesEHits(hits:Int, misses:Int, score:Int)
	{
		if(!isPlayingMatch || curRoom == null)
			return;
		curRoom.send("enviarMisses", {hits: hits, misses: misses, score: score});
	}

	public function send_results(hits:Array<Int>, combo:Int, score:Int, playerName:String)
	{
		var hits_message:String = '';
		for (hit in hits){hits_message += Std.string(hit) + ", ";}
		hits_message = hits_message.substring(0, hits_message.length - 2); //Serve para remover o último ", "
		//usuario.send({myID: myID, message: Std.string(myID) + "\n" + hits_message + "\n" + Std.string(combo) + "\n" + Std.string(score) + "\n" + playerName, verb: 'results'});
	}

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
		if(isHost)
		{
			curRoom.send("endedMatch");
		}
	}

	public function mostrarSalas()
	{
		if(!canClick)
			return;
		canClick = false;
		new FlxTimer().start(0.1, function (tmr:FlxTimer) {
			var roomArray:Array<RoomAvailable> = getAvailableRooms();
			changeMenu(ROOMLIST);
			roomList = new RoomList(roomArray);
			openSubState(roomList);
			canClick = true;
		});
	}

	public function getAvailableRooms():Array<RoomAvailable>
	{
		var salas:Array<RoomAvailable> = [];
		client.getAvailableRooms("gameRoom", function(err, rooms) {
			salas = rooms;
		  });
		return salas;
	}

	public function entrar(room:RoomAvailable, ?force:Bool = false)
	{
		if (!canClick && !force)
			return;
		if(roomList != null)
		{
			roomList.remover();
		}
		canClick = false;
		changeMenu(CONNECTING);

		var roomOptions:Map<String, Dynamic> = new Map<String, Dynamic>();
		roomOptions.set("myName", GJClient.userName);
		roomOptions.set("myChar", "bf");
		roomOptions.set("isHost", "1");
		roomOptions.set("noteSkin", skins[skinAtual][1]);

		client.getAvailableRooms("gameRoom", function(err, rooms) {
			if (err != null) {
			  	trace(err);
				avisarAlgo(Std.string(err));
				changeMenu(MAIN);
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
							changeMenu(MAIN);
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
				avisarAlgo(LangUtil.getString("alert_room_unavailable", "multiplayer"));
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

	function getOtherIndexBySession(sessionId:String):Int
	{
		for (i in 0...players.length)
		{
			if(players[i].sessionId != sessionId)
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
			if (players[zeroInt].keys[0] == false && players[zeroInt].keys[1] == false && players[zeroInt].keys[2] == false && players[zeroInt].keys[3] == false)
			{
				players[zeroInt].bfAnims(one, true);
			}
		}
	}

	public function inputShit()
	{
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
	}

	public function avisarAlgo(avisarIssoAqui:String, ?nextState:FlxState = null)
	{
		GlobalSoundManager.play("negado");
		canClick = false;
		blackTransBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTransBG.alpha = 0.75;
		add(blackTransBG);

		avisoBg = new FlxSprite(281, 102).loadGraphic(Paths.image('multiplayer/submenus/avisoPanel', 'locales', false, true));
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
			GlobalSoundManager.play(confirmMenu);
			if(nextState != null)
			{
				MusicBeatState.switchState(nextState);
			}
			else
			{
				canClick = true;
			}
		}
		okBt.onOver.callback = function()
		{
			okBt.alpha = 1;
			GlobalSoundManager.play(scrollMenu);
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
	public function createButton(file:String, scale:Float, x:Float, y:Float, visible:Bool = true, centralize:Bool = true, ?callback:Function = null, ?arg:Dynamic= null, ?label:String = null):FlxButton {
        var button = new FlxButton(x, y, '');
		button.loadGraphic(Paths.image(label == null ? file : "buttons_base/MultiplayerMenu", 'preload', false));
        button.setGraphicSize(Std.int(button.width * scale));
        button.updateHitbox();
		if (centralize)
        	button.screenCenter(X);
        button.visible = visible;
		if(label != null)
		{
			button.label = new FlxText(0, 0, button.width, label);
			button.label.setFormat(LangUtil.getFont("sonic-3"), 44, FlxColor.WHITE, LEFT);
			button.label.offset.x = -90;
			button.label.offset.y = -35;
		}
		button.alpha = 0.75;
		button.onOver.callback = function() {
			if(!button.visible || !canClick)
				return;
			GlobalSoundManager.play(scrollMenu);
			button.alpha=1;
		}
		button.onOut.callback = function() {
			if(!button.visible || !canClick)
				return;
			button.alpha=0.75;
		}
		button.onDown.callback = function() {
			if(!button.visible || callback == null || !canClick)
				return;
			GlobalSoundManager.play(confirmMenu);
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
	public var noteSkin:String = "NOTE_assets";
	public var keys:Array<Bool> = [false, false, false, false];
	public var bf:Boyfriend;
	public var isConnected:Bool = false;
	var textinhoBF:FlxText;

	public function new(x:Float, y:Float, flipX:Bool = false)
	{
		super(x,y);

		// BOYFRIEND LES GOOO
		bf = new Boyfriend(0, 0, charID);
		bf.playAnim('idle', false, false, 10);
		bf.flipX = flipX;
		add(bf);

		// TEXTINHO TEXTOSO
		textinhoBF = new FlxText(-15, 0, 500, "", 45, true);
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

class SkinSelector extends FlxSpriteGroup
{
	var skinAtual:Int = 0;
	var skinList:Array<Dynamic>;

	var fundo:FlxSprite;
	var atual:FlxText;
	var setaDireita:FlxButton;
	var setaEsquerda:FlxButton;

	public function new()
	{
		super();
		skinAtual = Reflect.getProperty(MultiplayerMainMenuState.instance, "skinAtual");
		skinList = Reflect.getProperty(MultiplayerMainMenuState.instance, "skins");

		fundo = new FlxSprite(0,0).makeGraphic(980, 100, FlxColor.GRAY);
		add(fundo);
		
		atual = new FlxText(95, 28, 800, skinList[skinAtual][0], 30);
		atual.wordWrap = false;
		atual.alignment = CENTER;
		add(atual);

		setaEsquerda = new FlxButton(20, 18.5, "", clickEsquerda);
		setaEsquerda.loadGraphic(Paths.image('multiplayer/submenus/seta', 'preload'));
		setaEsquerda.updateHitbox();
		add(setaEsquerda);

		setaDireita = new FlxButton(895, 18.5, "", clickDireita);
		setaDireita.loadGraphic(Paths.image('multiplayer/submenus/seta', 'preload'));
		setaDireita.flipX=true;
		setaDireita.updateHitbox();
		add(setaDireita);
	}

	function clickEsquerda()
		{
			if(!this.visible)
				return;
			if(skinAtual-1 >= 0)
				{
					skinAtual--;
				}
				else
				{
					skinAtual = skinList.length-1;
				}
			save();
	
		}
	
		function clickDireita()
			{
				if(!this.visible)
					return;
				if(skinAtual+1 < skinList.length)
					{
						skinAtual++;
					}
					else
					{
						skinAtual = 0;
					}
				save();
		
			}

	public function save()
	{
		atual.text = skinList[skinAtual][0];
		Reflect.setProperty(MultiplayerMainMenuState.instance, "skinAtual", skinAtual);
		ClientPrefs.curMultiplayerNoteSkin = skinAtual;
		ClientPrefs.save();
	}

}

class RoomList extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var scrollBar:FlxScrollableArea;
	var roomList:FlxSpriteGroup;
	var viewPortRect:FlxRect;
	var backButton:FlxButton;
	var refreshButton:FlxButton;
	
	public function new(rooms:Array<RoomAvailable>)
	{
		super();
		refresh(rooms);
		MultiplayerMainMenuState.instance.curMenu = ROOMLIST;
	}

	function arrumarOffsets(button:FlxButton)
	{
		button.label.offset.x = -75;
		button.label.offset.y = -25.5;
		button.label.size = 35;
	}

	public function refresh(rooms:Array<RoomAvailable>)
	{
		if(backButton == null)
		{
			backButton = MultiplayerMainMenuState.instance.createButton('', 0.45, 0, 535+82.5, true, true, function(){
				if(!MultiplayerMainMenuState.instance.canClick || MultiplayerMainMenuState.instance.curMenu != ROOMLIST)
					return;
				MultiplayerMainMenuState.instance.canClick = false;
				new FlxTimer().start(0.1, function (tmr:FlxTimer) {
					MultiplayerMainMenuState.instance.voltarMenu();
					MultiplayerMainMenuState.instance.canClick = true;
				});
			}, null, LangUtil.getString("main_back_bt", "multiplayer"));
			arrumarOffsets(backButton);
			add(backButton);
		}
		if(refreshButton == null)
		{
			refreshButton = MultiplayerMainMenuState.instance.createButton('', 0.5, 0, 535-30, true, true, function(){
				if(!MultiplayerMainMenuState.instance.canClick || MultiplayerMainMenuState.instance.curMenu != ROOMLIST)
					return;
				remover();
				MultiplayerMainMenuState.instance.mostrarSalas();
			}, null, LangUtil.getString("main_refresh_bt", "multiplayer"));
			arrumarOffsets(refreshButton);
			add(refreshButton);
		}


		var num:Int = 0;
		roomList = cast add(new FlxSpriteGroup());

		for (room in rooms) {
			//trace('room is private: ${room.metadata.privateRoom}');
			if(room.metadata.privateRoom == false)
			{
				var roomObject:RoomObject = new RoomObject(((100*num)+num*5), room);
				roomList.add(roomObject);
				num++;
			}
		}

		roomList.setPosition(2560);
		viewPortRect = new FlxRect( 340, 5, 600, 500 );

		scrollBar = new FlxScrollableArea(viewPortRect, roomList.getHitbox(), Utils.ResizeMode.FIT_WIDTH, -1, FlxColor.LIME, this);
		adicionar();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
			{
				GlobalSoundManager.play(cancelMenu);
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
		joinButton = new FlxButton(0, 0, "", function(){MultiplayerMainMenuState.instance.entrar(room);GlobalSoundManager.play(confirmMenu);});
		joinButton.onOver.callback = function(){this.alpha = 1;GlobalSoundManager.play(scrollMenu);} ;
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
	public static var instance:OptionsSubstate;
	var backButton:FlxButton;

	// 0 = Bool, 1 = Selection
	//name, type, desc
	var options:Array<Dynamic> = [
		[LangUtil.getString("opt_gamemode_name", "multiplayer"), 1, LangUtil.getString("opt_gamemode_desc", "multiplayer"), ["ModoDeJogo", "modos", true]],
		[LangUtil.getString("opt_cursong_name", "multiplayer"), 1, LangUtil.getString("opt_cursong_desc", "multiplayer"), ["MusicaAtual", "musicas", false]], 
		[LangUtil.getString("opt_changesides_name", "multiplayer"), 0, LangUtil.getString("opt_changesides_desc", "multiplayer"), ["TrocarLados"]]
	];

	public function new()
	{
		super();
	}

	override function create()
	{
		instance=this;
		backButton = MultiplayerMainMenuState.instance.createButton('', 0.6, 0, 435, true, true, function(){
				close();
			}, null, LangUtil.getString("main_back_bt", "multiplayer"));
		add(backButton);
		var num:Int = 1;
		optionsObjects = cast add(new FlxSpriteGroup());
		var textoOptions:FlxText = new FlxText(0, 50, 0, LangUtil.getString("opt_label", "multiplayer"), 30);
		textoOptions.screenCenter(X);
		optionsObjects.add(textoOptions);

		for (option in options) {
			var button:OptionObject = new OptionObject(((100*num)+num*5), option[0], option[1], option[2], option[3]);
			optionsObjects.add(button);
			num++;
		}

		optionsObjects.setPosition(-1280, 0);

		scrollBar = new FlxScrollableArea( new FlxRect( 0, 0, FlxG.width, FlxG.height ), optionsObjects.getHitbox(), Utils.ResizeMode.NONE, -1, FlxColor.LIME, this);
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
		instance=null;
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
			nameTxt = new FlxText(25, 20, 0, name, 30);
			add(nameTxt);
			descTxt = new FlxText(25, 50, 0, desc, 20);
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


		atual = new FlxText(97.5, 18, 300, list[value][0], 23);
		atual.wordWrap = false;
		atual.alignment = CENTER;
		add(atual);

		//se tem desc
		if(variable[2] == true)
		{
			atual.y = 12;
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
