package multiplayer;

import openfl.utils.Dictionary;
import multiplayer.menus.*;
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
import ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.colyseus.Client;
import io.colyseus.Room;
import io.colyseus.events.EventHandler;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import FlxScrollbar.FlxScrollableArea;
import flixel.math.FlxRect;
import openfl.utils.Assets as OpenFlAssets;
import multiplayer.schemas.*;
import multiplayer.entities.*;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;
import gamejolt.*;
import Utils;
import multiplayer.menus.shared.*;
import Lambda;

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
	OPTIONS;
	SKINS;
}

class MultiplayerMainMenuState extends MusicBeatState
{
	// não é bom isso aqui ser hard coded....
	private var servidor:String = "ws://caboose.proxy.rlwy.net:26358"; 
	private var serverStatic:String = "https://modboa-servers.up.railway.app/";

	// COISAS UI
	public var canClick:Bool = false;

	// submenus
	public var curSubmenu:MultiplayerMenu;
	public var isTransitioning:Bool = true;
	var barra:Barra;

	// SUBMENU OPÇÕES
	public var isOnOptions:Bool = false;

	// SUBMENU AVISOS
	var blackTransBG:FlxSprite;
	var avisoBg:FlxSprite;
	var avisoTexto:FlxText;
	var okBt:FlxButton;

	// SERVER
    public var client:Client;
	public var curRoom:Room<LobbyState>;
	var quisSair:Bool = false;

	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;
	public var canInitMatch:Bool = false;
	//var selectedMusic:String = "soulless/soulless-hard";
	public var isPlayingMatch:Bool = false;
	public var daNoteReceived:Array<Int> = [];

	public static var instance:MultiplayerMainMenuState;

	public var keyboardMode:Bool = false;

	// SKINS
	public var skins:Array<Dynamic> = [
		[Linguagem.LangUtil.getString("skin_default", "multiplayer"), "default_notes"],
		[Linguagem.LangUtil.getString("skin_orange", "multiplayer"), "orange_notes"],
		[Linguagem.LangUtil.getString("skin_emerald", "multiplayer"), "purple_green_notes"],
		[Linguagem.LangUtil.getString("skin_blacknwhite", "multiplayer"), "black_n_white_notes"],
		[Linguagem.LangUtil.getString("skin_classic", "multiplayer"), "NOTE_assets"]
	];
	public var skinAtual:Int = 0;

	// VARIAVEIS OPÇÕES
	public var modos:Array<Dynamic> = [
		[Linguagem.LangUtil.getString("selection_score_name", "multiplayer"), Linguagem.LangUtil.getString("selection_score_desc", "multiplayer"), "pontos"],
		[Linguagem.LangUtil.getString("selection_hits_name", "multiplayer"), Linguagem.LangUtil.getString("selection_hits_desc", "multiplayer"), "precisao"],
		[Linguagem.LangUtil.getString("selection_misses_name", "multiplayer"), Linguagem.LangUtil.getString("selection_misses_desc", "multiplayer"), "erros"]
	];
	public var ModoDeJogo:Int = 0;

	public var TrocarLados:Bool = false;

	public var musicas:Array<Dynamic> = [];
	public var musicasDesbloqueadas:Array<Dynamic> = [];
	public var MusicaAtual:Int = 0;


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

	public function HandleKeyboardMode(?force:Bool = false) {
		if (Main.getMouseVisibility()) 
			return;

		if (!canClick) {
			if (okBt != null && controls.ACCEPT) {
				if (!okBt.visible) return; 
				okBt.onDown.fire();
			}	
			return;
		}
		
		if (isTransitioning) return;
		if (isPlayingMatch) return;

		var oldSelected:Int = curSubmenu.lastBtSelected;
		var max:Int = Lambda.count(curSubmenu.buttons);


		if (oldSelected == -1) {
			curSubmenu.lastBtSelected = 0;
			for (index => bt in curSubmenu.buttons) {
				if (bt == null) continue;

				if (bt.onOut.callback == null) {
					bt.alpha = 0.5;
				} else {
					bt.onOut.fire();
				}
			}
		} else {
			if (max == 1) {
				curSubmenu.lastBtSelected = 0;
			} else {
				if (controls.UI_DOWN_P || controls.UI_RIGHT_P) {
					if (curSubmenu.lastBtSelected+1 < max) {
						curSubmenu.lastBtSelected+=1;
					} else {
						curSubmenu.lastBtSelected = 0;
					}
				} else if (controls.UI_UP_P || controls.UI_LEFT_P) {
					if (curSubmenu.lastBtSelected-1 >= 0) {
						curSubmenu.lastBtSelected-=1;
					} else {
						curSubmenu.lastBtSelected = 0;
					}
				}
			}
		}


		for (index => bt in curSubmenu.buttons) {
			if (bt == null) continue;

			if (index != curSubmenu.lastBtSelected) {
				if (oldSelected == index) {
					if (bt.onOut.callback == null) {
						bt.alpha = 0.5;
					} else {
						bt.onOut.fire();
					}
				}
				continue;
			}

			if (controls.ACCEPT) {
				bt.onDown.fire();
				bt.onUp.fire();
				break;
			}

			if (oldSelected == index && !force) continue;

			if (bt.onOver.callback == null) {
				bt.alpha = 1;
				GlobalSoundManager.play(scrollMenu);
			} else {
				bt.onOver.fire();
			}
		}

		if (barra.configButton.visible == false) return;

		var ctrl = FlxG.keys.justPressed.CONTROL || GamepadUtil.checkGamepadPressedButton(3);
		if (ctrl) {
			barra.configButton.onUp.fire();
		}
	}

	function getAllUnlockedSongs():Array<Dynamic> 
	{
		var myPossibleSongs:Int = ProgressionUtil.terminouHistoria() && FlxG.save.data.freeplayProgress > 0 ? ProgressionUtil.getSaveSum()+Std.int(FlxG.save.data.freeplayProgress-1) : ProgressionUtil.getSaveSum();
		var retornar:Array<Dynamic> = new Array<Dynamic>();
		for (i in 0...musicas.length) {
			if(i < myPossibleSongs-1) {
				retornar.push(musicas[i]);
			}
		}
		
		return retornar;
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
		barra.backButton.visible=false;
		barra.configButton.visible=false;
		barra.changeLabelText("");
	}

	var preloadedMenus:Map<MenuEnum, MultiplayerMenu> = [];
	function preloadAllMenus() {
		preloadedMenus = [MAIN => new MainMenu(), ROOMLIST => new JoinMenu(), SKINS => new NoteSkins(), LOBBY => new Lobby(), CONNECTING => new Connecting(), OPTIONS => new RoomOptions()];
		
		var isFirst:Bool = true;
		for (menu in preloadedMenus) {
			menu.preload(isFirst);
			isFirst = false;
		}
	}

	public function changeMenu(nextMenu:MenuEnum)
	{
		deactivateAll();
		trace("Changing to menu: "+nextMenu.getName());
		switch(nextMenu)
		{
			case LOBBY:
				makeMenuChange(preloadedMenus[LOBBY]);
				barra.backButton.visible=true;
				barra.configButton.visible=isHost;
				barra.changeLabelText("LOBBY"); // font issues
			case OPTIONS:
				if (!isHost) return;
				if (!isOnServer) return;
				if (isOnOptions) return;
				if (isPlayingMatch) return;

				makeMenuChange(preloadedMenus[OPTIONS], false);
				barra.backButton.visible=true;
				barra.changeLabelText("OPTIONS");
			case ROOMLIST:
				makeMenuChange(preloadedMenus[ROOMLIST]);
				barra.backButton.visible=true;
				barra.changeLabelText("MULTIPLAYER");
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
							avisarAlgo(Linguagem.LangUtil.getString("alert_room_unavailable", "multiplayer"), new MainMenuStateMobile());
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
					makeMenuChange(preloadedMenus[MAIN]);
					barra.backButton.visible=true;
				}
			case CONNECTING:
				makeMenuChange(preloadedMenus[CONNECTING]);
			case SKINS:
				makeMenuChange(preloadedMenus[SKINS]);
				barra.backButton.visible = true;
				barra.changeLabelText("SKINS");
			default:
				trace("esse menu ainda não foi adicionado");
		}
		curMenu = nextMenu;
	}

	function makeMenuChange(newMenu:MultiplayerMenu, ?tweenar:Bool = true) {
		if (curSubmenu == null) {
			curSubmenu = newMenu;
			newMenu.open(curSubmenu);
			return;
		}
		
		newMenu.open(curSubmenu);
		curSubmenu.close(newMenu, tweenar);

		curSubmenu = newMenu;
	}

	public function voltarMenu()
		{
			if (isTransitioning) return;
			if (isPlayingMatch) return;

			GlobalSoundManager.play(cancelMenu);
			switch(curMenu)
			{
				case LOBBY:
					changeMenu(CONNECTING);
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
				case OPTIONS:
					changeMenu(LOBBY);
				default:
					trace("n tem menu anterior");
			}
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
		musicasDesbloqueadas = musicas;//getAllUnlockedSongs();

		super.create();

		preloadAllMenus();
		barra = new Barra(FlxColor.fromRGB(17, 12, 8));
		add(barra);
		changeMenu(CONNECTING);
		checkServers();
	}

	function checkServers()
	{
		trace('checking for update');
		var http = new haxe.Http(serverStatic);
		
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
				avisarAlgo(Linguagem.LangUtil.getString("alert_old_version", "multiplayer"), new MainMenuStateMobile());
				voltarMenu = true;
			}
		}

		http.onError = function(error)
		{
			trace('error: $error');
			avisarAlgo(Linguagem.LangUtil.getString("alert_connection_error", "multiplayer"), new MainMenuStateMobile());
			voltarMenu = true;
		}

		http.request();
		if(!voltarMenu)
		{
			changeMenu(MAIN);
			canClick = true;
		}
	}

	public function getIsOnServer():Bool
	{
		return isOnServer;
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK && !isOnOptions && canClick && !isPlayingMatch)
		{
			voltarMenu();
		}

		canInitMatch = isOnServer && !isPlayingMatch;

		HandleKeyboardMode();

		super.update(elapsed);
	}

	function eventHandlers()
	{
		curRoom.onMessage("lobbyPlayers", function(message) {
			switch(message.type)
			{
				case "entrou":
					Lobby.instance.players[message.playerIndex].sessionId = message.sessionId;
					Lobby.instance.players[message.playerIndex].noteSkin = message.noteSkin;
					Lobby.instance.players[message.playerIndex].updatePlayer(message.gamejoltId);
				case "saiu":
					Lobby.instance.players[message.playerIndex].sessionId = "";
					Lobby.instance.players[message.playerIndex].noteSkin = "NOTE_assets";
					Lobby.instance.players[message.playerIndex].updatePlayer("0");
			}
		});


		curRoom.onMessage("everyoneReady", function(message){
			if(!isHost || isPlayingMatch)
				return;

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

		curRoom.onMessage("enviarFinalScore", function(message) {
			if(!isPlayingMatch)
				return;
			MultiplayerPlayState.instance.oppCombo = message.combo;
			MultiplayerPlayState.instance.oppResults = message.hits;
			MultiplayerPlayState.instance.oppAccuracy = message.accuracy;
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

		curRoom.onMessage("newReady", function(message) {
			Lobby.instance.updateReadyText(Linguagem.LangUtil.getString("lobby_ready_label", "multiplayer") + " "+Std.string(message)+"/2");
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
						avisarAlgo(Linguagem.LangUtil.getString("alert_host_disconnected", "multiplayer"));
					default:
						avisarAlgo(Linguagem.LangUtil.getString("alert_default", "multiplayer")+"\n"+Std.string(message.cause));
				}
		});

		curRoom.connection.onClose = function() {
			if(isPlayingMatch)
			{
				MultiplayerPlayState.instance.podeTerminar+=2;
			}
			if(isHost && !quisSair)
			{
				avisarAlgo(Linguagem.LangUtil.getString("alert_connection_error", "multiplayer"));
			}
			reiniciarTudo();
		};

		curRoom.onLeave+=reiniciarTudo;
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
		roomOptions.set("gamejoltId", GJClient.myID);
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

			Lobby.instance.players[0].noteSkin = skins[skinAtual];
			Lobby.instance.players[0].sessionId = curRoom.sessionId;
			Lobby.instance.players[0].updatePlayer(GJClient.myID);

			eventHandlers();

			canClick = true;

		});
	}

	public function entrar(room:RoomAvailable, ?force:Bool = false)
	{
		if (!canClick && !force)
			return;

		canClick = false;
		changeMenu(CONNECTING);

		var roomOptions:Map<String, Dynamic> = new Map<String, Dynamic>();
		roomOptions.set("myName", GJClient.userName);
		roomOptions.set("myChar", "bf");
		roomOptions.set("isHost", "1");
		roomOptions.set("noteSkin", skins[skinAtual][1]);
		roomOptions.set("gamejoltId", GJClient.myID);

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
						Lobby.instance.players[1].noteSkin = skins[skinAtual];
						Lobby.instance.players[1].sessionId = curRoom.sessionId;
						Lobby.instance.players[1].updatePlayer(GJClient.myID);
			
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
				avisarAlgo(Linguagem.LangUtil.getString("alert_room_unavailable", "multiplayer"));
				changeMenu(MAIN);
			}
		});

	}

	public function initMatch()
	{
		if(isPlayingMatch || curRoom == null)
			return;
		isPlayingMatch = true;
		var url:String = serverStatic+"charts/"+musicas[MusicaAtual][1]+".json";
		openSubState(new multiplayer.MultiplayerPlayState(0, url, isHost, TrocarLados, ModoDeJogo, Lobby.instance.players[getIndexBySession(curRoom.sessionId)], Lobby.instance.players[getOtherIndexBySession(curRoom.sessionId)]));
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

	public function send_results(hits:Array<Int>, combo:Int, accuracy:Float)
	{
		if(!isPlayingMatch || curRoom == null)
			return;
		curRoom.send("enviarFinalScore", {hits: hits, combo: combo, accuracy: accuracy});
	}

	public function endMatch()
	{
		if(!isPlayingMatch)
			return;
		//openSubstate(new ResultsSubstate([sicks, goods, bads, shits], 1, combo, songScore, GJClient.username));
		isPlayingMatch = false;

		daNoteReceived = [];
		FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		if(isHost)
		{
			curRoom.send("endedMatch");
		}
	}

	public function getAvailableRooms():Array<RoomAvailable>
	{
		var salas:Array<RoomAvailable> = [];
		client.getAvailableRooms("gameRoom", function(err, rooms) {
			salas = rooms;
		  });
		return salas;
	}
	
	function getIndexBySession(sessionId:String):Int
	{
		for (i in 0...Lobby.instance.players.length)
		{
			if(Lobby.instance.players[i].sessionId == sessionId)
			{
				return i;
			}
		}
		return -1;
	}

	function getOtherIndexBySession(sessionId:String):Int
	{
		for (i in 0...Lobby.instance.players.length)
		{
			if(Lobby.instance.players[i].sessionId != sessionId)
			{
				return i;
			}
		}
		return -1;
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
			button.label.setFormat(Linguagem.LangUtil.getFont("sonic-3"), 44, FlxColor.WHITE, LEFT);
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