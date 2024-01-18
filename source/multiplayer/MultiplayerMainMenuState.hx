package multiplayer;

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
import networking.Network;
import networking.sessions.Session;
import networking.sessions.client.Client;
import networking.sessions.items.ClientObject;
import networking.sessions.items.ServerObject;
import networking.sessions.server.Server;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import ibwwg.FlxScrollableArea;
import flixel.math.FlxRect;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end


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
	var canClick:Bool = false;
	var textinhoDebug:FlxText;

	// SUBMENU OPÇÕES
	var voltarBt:FlxButton;
	var opcoesBg:FlxSprite;
	var blackTrans:FlxSprite;
	public var isOnOptions:Bool = false;

	// SUBMENU AVISOS
	var blackTransBG:FlxSprite;
	var avisoBg:FlxSprite;
	var avisoTexto:FlxText;
	var okBt:FlxButton;

	// SERVER - acessos
	public var client:Session = null;
    public var server:Session = null;

    // Acesso ao tipo de player.
    public var usuario:Session = null;


	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;
	var canInitMatch:Bool = false;
	var selectedMusic:String = /*"confronting-yourself/confronting-yourself-hard"*/"soulless/soulless-hard";
	var isPlayingMatch:Bool = false;
	public var daNoteReceived:Array<Int> = [0];

	// PLAYERS
	public var players:Array<LobbyPlayer> = [new LobbyPlayer(174,190), new LobbyPlayer(681,190)];
	public static var instance:MultiplayerMainMenuState;

	// VARIAVEIS OPÇÕES
	public var modos:Array<Dynamic> = [
		["PONTOS", "Ganha quem tiver a maior pontuação."],
		["HITS", "Ganha quem tiver mais hits."],
		["ERROS", "Ganha quem tiver menos erros."]
	];
	public var ModoDeJogo:Int = 0;
	public var TrocarLados:Bool = false;



	override function create()
	{
		instance = this;

		multiplayerTxt = new FlxText(0, 0, FlxG.width - 95, "MULTIPLAYER", 100);
		multiplayerTxt.setFormat(Paths.font("letravio.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		multiplayerTxt.y = -1500;
		multiplayerTxt.screenCenter(X);

		ipBar = new FlxUIInputText(0, 0, 575, "127.0.0.1", 50, FlxColor.BLACK, FlxColor.WHITE, true);
		ipBar.screenCenter(X);
		ipBar.y = 1500;
		ipBar.alignment = CENTER;

		bGround = new FlxSprite(0, 0).loadGraphic(Paths.image('ph'));
		bGround.setGraphicSize(Std.int(bGround.width));
		bGround.antialiasing = ClientPrefs.globalAntialiasing;
		bGround.updateHitbox();
		bGround.alpha = 1;
		add(bGround);

		add(ipBar);

		textinhoDebug = new FlxText(0, 0, 0, "", 25, true);
		textinhoDebug.screenCenter(XY);

		hostearBt = createButton('multiplayer/hospedarBt', 0.6, 0, 1500);
		add(hostearBt);
		entrarBt = createButton('multiplayer/entrarBt', 0.6, 0, 1500);
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
			player.nome = num == 1 ? "Player 2" : GJClient.userName;
			add(player);
			num++;
		}

		comecarBt = createButton('multiplayer/iniciarBt', 0.6, 276, 563, false, false);
		add(comecarBt);

		configBt = createButton('multiplayer/configBt', 0.6, 857, 563, false, false );
		add(configBt);

		blackTrans = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTrans.alpha = 0.75;
		blackTrans.visible = isOnOptions;
		add(blackTrans);

		opcoesBg = new FlxSprite(75, 20).loadGraphic(Paths.image('multiplayer/submenus/opcoesPanel', 'preload'));
		opcoesBg.antialiasing = ClientPrefs.globalAntialiasing;
		opcoesBg.updateHitbox();
		opcoesBg.x = 75;
		opcoesBg.y = 20;
		opcoesBg.visible = isOnOptions;
		add(opcoesBg);

		voltarBt = new FlxButton(FlxG.width, 100, '');
		voltarBt.loadGraphic(Paths.image('multiplayer/submenus/voltarBt', 'preload'));
		voltarBt.updateHitbox();
		voltarBt.x = 475;
		voltarBt.y = 617;
		voltarBt.visible = isOnOptions;
		add(voltarBt);
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
		// LEMBRAR DE ARRUMAR ISSO AQ DPS
		if (controls.BACK && !ipBar.hasFocus && !isOnOptions && canClick && !isPlayingMatch)
		{
			GlobalSoundManager.play("cancelMenu");
			if (isOnServer)
			{
				Network.destroySession(client);
				if (isHost)
				{
					server.send({message: 'fechei o server mano :c ', verb: 'all-leave'});
					Network.destroySession(server);
				}
				usuario = null;
			}
			else
			{
				MusicBeatState.switchState(new MainMenuStateMobile());
			}
		}

		// pra fazer o barulhinho
		entrarBt.onOver.callback = onOverBtns;
		configBt.onOver.callback = onOverBtns;
		comecarBt.onOver.callback = canInitMatch && !isPlayingMatch ? onOverBtns : null;
		hostearBt.onOver.callback = onOverBtns;
		voltarBt.onOver.callback = onOverBtns;

		// click stuff
		if (!canClick || isOnServer)
		{
			ipBar.hasFocus = false;
		}
		entrarBt.onDown.callback = entrar;
		hostearBt.onDown.callback = hostear;
		configBt.onDown.callback = function()
		{
			if (isOnOptions)
				return;
			GlobalSoundManager.play('confirmMenu');
			isOnOptions = true;
			configBt.visible = false;
			comecarBt.visible = false;
			openSubState(new OptionsSubstate());
		}
		comecarBt.onDown.callback = function()
		{
			if(canInitMatch && !isPlayingMatch)
			{
				server.send({message: selectedMusic, verb: "init-match"});
			}
		}

		// alpha stuff lesgo
		hostearBt.alpha = Utils.BSLTouchUtils.over(hostearBt) && canClick ? 1 : 0.75;
		entrarBt.alpha = Utils.BSLTouchUtils.over(entrarBt) && canClick ? 1 : 0.75;
		comecarBt.alpha = Utils.BSLTouchUtils.over(comecarBt) && canClick && canInitMatch ? 1 : 0.75;
		configBt.alpha = Utils.BSLTouchUtils.over(configBt) && canClick ? 1 : 0.75;

		// server shit
		multiplayerTxt.visible = !isOnServer;
		configBt.visible = isOnServer && isHost && !isOnOptions;
		comecarBt.visible = isOnServer && isHost && !isOnOptions;
		if (isOnServer)
		{
			inputShit();
		}
		canInitMatch = isOnServer && !isPlayingMatch && isHost && players[1].nome != "Player 2";
		super.update(elapsed);
	}

	public function hostear()
	{
		if (!canClick || ipBar.hasFocus)
			return;

		ipBar.hasFocus = false;
		canClick = false;
		GlobalSoundManager.play('confirmMenu');
		server = Network.registerSession(NetworkMode.SERVER, {
			ip: '0.0.0.0',
			port: 8080,
			max_connections: 2
		});
		server.start();
		definirUsuario();

		server.addEventListener(NetworkEvent.CONNECTED, function(e:NetworkEvent)
		{
			server.send({message: 'Você entrou no servidor!', verb: 'test'});
			if(players[0].nome != "Player 1")
			{
				server.send({message: "0\n" + players[0].nome, verb: 'name'});
			}
		});

		server.addEventListener(NetworkEvent.CLOSED, function(e:NetworkEvent)
		{
			server.send({message: 'fechei o server mano :c ', verb: 'all-leave'});
		});

		server.addEventListener(NetworkEvent.DISCONNECTED, function(e:NetworkEvent)
		{
			players[1].nome = "Player 2";
		});

		server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(e:NetworkEvent)
		{
			if (e.data.verb == 'input')
			{
				var qualEquem:Array<String> = e.data.message.split(" ");
				mudaAeMano(qualEquem[0], qualEquem[1], qualEquem[2], true);
			}
			if (e.data.verb == "name")
			{
				var quemEqual:Array<String> = e.data.message.split("\n");
				players[Std.parseInt(quemEqual[0])].nome = quemEqual[1];
			}
			if (e.data.verb == 'version')
			{
				if (e.data.message != MainMenuStateMobile.version)
				{
					server.send({message: "versao incompativel", verb: 'all-leave'});
				}
			}
			if (e.data.verb == "init-match")
			{
				selectedMusic = e.data.message;
				initMatch();
			}

			if(e.data.verb == 'input-game')
				{
					var allMessage:Array<String> = e.data.message.split("\n");
					if(Std.parseInt(allMessage[0]) != myID)
					{
						daNoteReceived.push(Std.parseInt(allMessage[1]));
					}
					else
					{
						server.send({message: e.data.message, verb: 'input-game'});
					}
				}

			if(e.data.verb == 'carreguei')
				{
					if(myID != Std.parseInt(e.data.message))
					{
						MultiplayerPlayState.instance.podeComecar++;
					}
					else
					{
						server.send({message: e.data.message, verb: 'carreguei'});
					}
				}
			if (e.data.verb == "results"){
				var data:Array<String> = CoolUtil.listFromString(e.data.message);
				for (hit in data[1].split(",")){
					ResultsSubstate.opp_data.push(Std.parseInt(hit));
				}
				ResultsSubstate.opp_high_combo = Std.parseInt(data[1]);
				ResultsSubstate.opp_score = Std.parseInt(data[2]);
			}

			if(e.data.verb == 'hits-e-misses')
			{
				var allMessage:Array<String> = e.data.message.split("\n");
				if(Std.parseInt(allMessage[0]) != myID)
				{
					MultiplayerPlayState.instance.opponentHits = Std.parseInt(allMessage[1]);
					MultiplayerPlayState.instance.opponentMisses = Std.parseInt(allMessage[2]);
				}
			}
		});

		server.addEventListener(NetworkEvent.INIT_SUCCESS, function(e:NetworkEvent)
		{
			canClick = true;
			isHost = true;
			entrar();
			entrarBt.visible = false;
			hostearBt.visible = false;
			ipBar.visible = false;
			players[0].nome = GJClient.userName;
			trace("to hosteando");
		});

		server.addEventListener(NetworkEvent.INIT_FAILURE, function(e:NetworkEvent)
		{
			avisarAlgo("Erro no servidor");
		});
	}

	public function initMatch()
	{
		if(isPlayingMatch)
			return;
		isPlayingMatch = true;
		openSubState(new multiplayer.MultiplayerPlayState(0, selectedMusic, isHost));
	}

	public function enviarInputGame(note:Int)
	{
		usuario.send({message: Std.string(myID) + "\n" + Std.string(note), verb: 'input-game'});
		//trace("Enviei Input "+Std.string(note));
	}

	public function enviarToPronto()
	{
		client.send({message: Std.string(myID), verb: 'carreguei'});
	}

	public function enviarMissesEHits(hits:Int, misses:Int)
	{
		usuario.send({message: Std.string(myID) + "\n" + Std.string(hits) + "\n" + Std.string(misses), verb: 'hits-e-misses'});
	}

	public function send_results(hits:Array<Int>, combo:Int, score:Int)
	{
		var hits_message:String = '';
		for (hit in hits){hits_message += Std.string(hit) + ", ";}
		hits_message = hits_message.substring(0, hits_message.length - 2); //Serve para remover o último ", "
		usuario.send({message: Std.string(myID) + "\n" + hits_message + "\n" + Std.string(combo) + "\n" + Std.string(score), verb: 'results'});
	}

	private function definirUsuario():Void {usuario = isHost ? server : client;}

	public function endMatch()
	{
		if(!isPlayingMatch)
			return;
		isPlayingMatch = false;
		daNoteReceived = [];
		FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
	}

	public function entrar()
	{
		if (!canClick || ipBar.hasFocus)
			return;

		ipBar.hasFocus = false;
		canClick = false;
		GlobalSoundManager.play('confirmMenu');
		var server_ip = isHost ? "127.0.0.1" : ipBar.text;

		client = Network.registerSession(NetworkMode.CLIENT, {
			ip: server_ip,
			port: 8080
		});

		client.start();
		definirUsuario();

		client.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(e:NetworkEvent)
		{
			if (e.data.verb == 'input' && myID == 1)
			{
				var qualEquem:Array<String> = e.data.message.split(" ");
				mudaAeMano(qualEquem[0], qualEquem[1], qualEquem[2]);
			}

			if(e.data.verb == 'input-game')
			{
				var allMessage:Array<String> = e.data.message.split("\n");
				if(Std.parseInt(allMessage[0]) != myID)
				{
					daNoteReceived.push(Std.parseInt(allMessage[1]));
				}
			}

			if (e.data.verb == 'name')
			{
				var quemEqual:Array<String> = e.data.message.split("\n");
				players[Std.parseInt(quemEqual[0])].nome = quemEqual[1];
			}

			if (e.data.verb == 'all-leave' && !isHost)
			{
				client.disconnectClient();
				players[1].nome = "Player 2";
				if (e.data.message == "versao incompativel")
				{
					avisarAlgo("Versões incompatíveis");
				}
			}
			if (e.data.verb == "init-match")
			{
				selectedMusic = e.data.message;
				initMatch();
			}

			if(e.data.verb == 'carreguei')
				{
					if(myID != Std.parseInt(e.data.message))
					{
						MultiplayerPlayState.instance.podeComecar++;
					}
				}

				if(e.data.verb == 'hits-e-misses')
					{
						var allMessage:Array<String> = e.data.message.split("\n");
						if(Std.parseInt(allMessage[0]) != myID)
						{
							MultiplayerPlayState.instance.opponentHits = Std.parseInt(allMessage[1]);
							MultiplayerPlayState.instance.opponentMisses = Std.parseInt(allMessage[2]);
						}
					}
		});

		client.addEventListener(NetworkEvent.INIT_SUCCESS, function(e:NetworkEvent)
		{
			canClick = true;
			myID = isHost ? 0 : 1;
			client.send({message: myID + "\n" + GJClient.userName, verb: 'name'});

			players[myID].nome = GJClient.userName;
			isOnServer = true;
			entrarBt.visible = false;
			hostearBt.visible = false;
			ipBar.visible = false;
			trace("to entrando");
			client.send({message: MainMenuStateMobile.version, verb: 'version'});
		});

		client.addEventListener(NetworkEvent.DISCONNECTED, function(e:NetworkEvent)
		{
			client.send({message: myID + "\n" + "Player " + myID + 1, verb: 'name'});
			isOnServer = false;
			entrarBt.visible = true;
			hostearBt.visible = true;
			ipBar.visible = true;
			textinhoDebug.text = "";
			avisarAlgo("Conexão perdida");
		});

		client.addEventListener(NetworkEvent.CLOSED, function(e:NetworkEvent)
		{
			client.send({message: myID + "\n" + "Player " + myID + 1, verb: 'name'});
			isOnServer = false;
			entrarBt.visible = true;
			hostearBt.visible = true;
			ipBar.visible = true;
			textinhoDebug.text = "";
		});

		client.addEventListener(NetworkEvent.INIT_FAILURE, function(e:NetworkEvent)
		{
			avisarAlgo("Servidor não encontrado");
		});
		client.addEventListener(NetworkEvent.SERVER_FULL, function(e:NetworkEvent)
		{
			avisarAlgo("O servidor está cheio");
		});
	}

	function segureiObotao(qual:String)
	{
		// quem clicou | oq clicou
		client.send({message: myID + " " + qual + " Segurei", verb: 'input'});
	}

	function solteiObotao(qual:String)
	{
		// quem clicou | oq clicou
		client.send({message: myID + " " + qual + " Soltei", verb: 'input'});
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
				server.send({message: zero + " " + one + " Segurei", verb: 'input'});
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
				server.send({message: zero + " " + one + " Soltei", verb: 'input'});
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
			new FlxTimer().start(1, function(tmr:FlxTimer) {
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

		avisoBg = new FlxSprite(281, 102).loadGraphic(Paths.image('multiplayer/submenus/avisoPanel', 'preload'));
		avisoBg.antialiasing = ClientPrefs.globalAntialiasing;
		avisoBg.updateHitbox();
		avisoBg.x = 281;
		avisoBg.y = 102;
		add(avisoBg);

		avisoTexto = new FlxText(281, 300, 725, avisarIssoAqui, 40, false);
		avisoTexto.alignment = CENTER;
		add(avisoTexto);

		okBt = new FlxButton(0, 0, '');
		okBt.loadGraphic(Paths.image('mainmenu/btok', 'preload'));
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
	function createButton(file:String, scale:Float, x:Float, y:Float, visible:Bool = true, centralize:Bool = true):FlxButton {
        var button = new FlxButton(x, y, '');
        button.loadGraphic(Paths.image(file, 'preload'));
        button.setGraphicSize(Std.int(button.width * scale));
        button.updateHitbox();
		if (centralize)
        	button.screenCenter(X);
        button.visible = visible;
        return button;
    }
}

class LobbyPlayer extends FlxSpriteGroup
{
	public var nome:String = "Player 1";
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
		isConnected = nome != "Player 2";
		textinhoBF.text = isConnected ? nome : "";
		bf.alpha = isConnected ? 1 : 0.5;
		bf.visible = MultiplayerMainMenuState.instance.getIsOnServer();
		textinhoBF.visible = MultiplayerMainMenuState.instance.getIsOnServer();
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
}

class OptionsSubstate extends MusicBeatSubstate
{
	var scrollBar:FlxScrollableArea;
	var optionsObjects:FlxSpriteGroup;
	// 0 = Bool, 1 = Selection
	//name, type, desc
	var options:Array<Dynamic> = [
		["Modo de Jogo", 1, "Muda o modo de jogo atual", 0],
		/*["Musica Atual", 1, "Muda a musica atual"],*/ // amanha faço isso aq e mais uns outros
		["Trocar Lados", 0, "Troca o lado dos jogadores", [MultiplayerMainMenuState.instance.TrocarLados, 2]]

	];

	public function new()
	{
		super();
	}

	override function create()
	{
		var num:Int = 1;
		optionsObjects = cast add(new FlxSpriteGroup());
		var textoOptions:FlxText = new FlxText(550, 50, 0, "OPÇÕES", 30);
		optionsObjects.add(textoOptions);

		for (option in options) {
			var button:OptionObject = new OptionObject(((100*num)+num*5), option[0], option[1], option[2], option[3]);
			optionsObjects.add(button);
			num++;
		}

		optionsObjects.setPosition(-1280, 0);

		scrollBar = new FlxScrollableArea( new FlxRect( 0, 0, FlxG.width, FlxG.height ), /*new FlxRect(-1280, 0, 1200, 100)*/optionsObjects.getHitbox(), ResizeMode.NONE, -1, FlxColor.LIME, this);
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
	var id:Int;

	//bool
	var button:FlxButton;
	var ativado:Bool;

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
					id = variable[1];
					ativado = variable[0];
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
		switch(id)
		{
			case 2:
				MultiplayerMainMenuState.instance.TrocarLados = ativado;
		}
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
	var id:Int;

	public function new(x:Float, y:Float, variable:Dynamic)
	{
		super(x, y);
		id = variable;

		switch(id)
		{
			case 0:
				value = MultiplayerMainMenuState.instance.ModoDeJogo;
				list = MultiplayerMainMenuState.instance.modos;
		}

		atual = new FlxText(97.5, 7, 300, list[value][0], 25);
		atual.autoSize = true;
		atual.alignment = CENTER;
		add(atual);
		desc = new FlxText(97.5, 30, 300, list[value][1], 12);
		desc.autoSize = true;
		desc.alignment = CENTER;
		add(desc);
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
		desc.text = list[value][1];

	}

	function save()
	{
		switch(id)
		{
			case 0:
				MultiplayerMainMenuState.instance.ModoDeJogo = value;
		}
	}
}