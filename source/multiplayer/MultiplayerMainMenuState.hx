package multiplayer;

import openfl.events.KeyboardEvent;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import networking.Network;
import networking.sessions.Session;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import flixel.util.FlxTimer; 

using StringTools;
#if desktop
import Discord.DiscordClient;
#end

class MultiplayerMainMenuState extends MusicBeatState
{
	var hostearBt:FlxButton;
	var entrarBt:FlxButton;
	var bGround:FlxSprite;
	var ipBar:FlxUIInputText;
	var multiplayerTxt:FlxText;
	var client:Dynamic = null;
	var server:Dynamic = null;
	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;
	/*private var controlArray:Array<String>;
	private var keysArray:Array<Dynamic>;
	private var translator:Array<String> = ['esquerda','baixo','cima','direita'];*/
	var keysPlayer1:Array<Bool> = [false,false,false,false];
	var keysPlayer2:Array<Bool> = [false,false,false,false];

	var canClick:Bool = false;

	var textinhoDebug:FlxText;

	// TO DO: UMA JANELINHA QUE INFORMA ERROS QUANDO VC TENTA SE CONECTAR E N CONSEGUE, QUANDO A SALA TA CHEIA E QUANDO O HOST SAI DA SALA

	/*private function parseKeys(?suffix:String = ''):Array<Bool>
		{
			var ret:Array<Bool> = [];
			for (i in 0...controlArray.length)
			{
				ret[i] = Reflect.getProperty(controls, controlArray[i] + suffix);
			}
			return ret;
		}*/


	override function create()
	{
		multiplayerTxt = new FlxText(0, 0, FlxG.width - 95, "MULTIPLAYER", 100);
		multiplayerTxt.setFormat(Paths.font("letravio.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		multiplayerTxt.y=-1500;
		multiplayerTxt.screenCenter(X);

		ipBar = new FlxUIInputText(0, 0, 575, "127.0.0.1", 50, FlxColor.BLACK, FlxColor.WHITE, true);
		ipBar.screenCenter(X);
		ipBar.y = 1500;
		ipBar.alignment = CENTER;

		#if mobile
		FlxG.stage.window.textInputEnabled = true;
		#end
		bGround = new FlxSprite(0, 0).loadGraphic(Paths.image('ph'));
		bGround.setGraphicSize(Std.int(bGround.width));
		bGround.antialiasing = ClientPrefs.globalAntialiasing;
		bGround.updateHitbox();
		bGround.alpha = 1;
		add(bGround);

		add(ipBar);

		textinhoDebug = new FlxText(0,0,0,"",25,true);
		textinhoDebug.screenCenter(XY);
		add(textinhoDebug);
        
		hostearBt = new FlxButton(FlxG.width, 100, '');
		hostearBt.loadGraphic(Paths.image('multiplayer/hospedarBt', 'preload'));
		hostearBt.setGraphicSize(Std.int(hostearBt.width * 0.6));
		hostearBt.updateHitbox();
		hostearBt.screenCenter(X);
		hostearBt.y = 1500;
		add(hostearBt);
		entrarBt = new FlxButton(FlxG.width, 100, '');
		entrarBt.loadGraphic(Paths.image('multiplayer/entrarBt', 'preload'));
		entrarBt.setGraphicSize(Std.int(entrarBt.width * 0.6));
		entrarBt.updateHitbox();
		entrarBt.screenCenter(X);
		entrarBt.y = 1500;
		add(entrarBt);

		add(multiplayerTxt);
		super.create();

		/*FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		controlArray = [
			'NOTE_LEFT',
			'NOTE_DOWN',
			'NOTE_UP',
			'NOTE_RIGHT'
			];
		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];*/

		FlxTween.tween(multiplayerTxt, {y: 51}, 0.75, {ease: FlxEase.expoInOut});
		FlxTween.tween(ipBar, {y: 253}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(entrarBt, {y: 488}, 1.95, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween){canClick=true;}});
		FlxTween.tween(hostearBt, {y: 348}, 1.25, {ease: FlxEase.expoInOut});
	}
	override function update(elapsed:Float)
		{
            if (controls.BACK && !ipBar.hasFocus) {
				if(isOnServer)
					{
						if(isHost){Network.destroySession(server);}else{client.disconnectClient();}
					}
				else
					{
						FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new MainMenuStateMobile());
					}

            }
			hostearBt.onDown.callback= hostear;

			hostearBt.alpha = FlxG.mouse.overlaps(hostearBt) && canClick ? 1 : 0.75;
			
			if((FlxG.mouse.overlaps(hostearBt) || FlxG.mouse.overlaps(entrarBt)) && canClick)
				{
					GlobalSoundManager.play('scrollMenu');
				}

			entrarBt.alpha = FlxG.mouse.overlaps(entrarBt) && canClick ? 1 : 0.75;

			entrarBt.onDown.callback= entrar;

				if(isOnServer){inputShit();}


            super.update(elapsed);

		}

		/*private function getKeyFromEvent(key:FlxKey):Int
			{
				if(key != NONE)
				{
					for (i in 0...keysArray.length)
					{
						for (j in 0...keysArray[i].length)
						{
							if(key == keysArray[i][j])
							{
								return i;
							}
						}
					}
				}
				return -1;
			}*/

		public function hostear()
			{
				if(!canClick)
					return;

				GlobalSoundManager.play('confirmMenu');
				server = Network.registerSession(NetworkMode.SERVER, {
					ip: '0.0.0.0',
					port: 8888,
					max_connections: 2
				  });

				  server.start();
				  
				  server.addEventListener(NetworkEvent.CONNECTED, function(e: NetworkEvent) {
					server.send({ message: 'Você entrou no servidor!', verb: 'test' });
				  });

				  server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(e: NetworkEvent) {

					if(e.data.verb == 'input')
						{
							var qualEquem:Array<String> = e.data.message.split(" ");
							//trace("\nCliente: "+qualEquem[0] +"\nSeta: "+qualEquem[1] +"\nAcao: "+qualEquem[2]);
							
							mudaAeMano(qualEquem[0], qualEquem[1], qualEquem[2], true);

							//trace("Player 1 Input: "+keysPlayer1);
							//trace("Player 2 Input: "+keysPlayer2);							
						}
					else
						{
							trace(e.data.message); 
						}

				});	


				  server.addEventListener(NetworkEvent.INIT_SUCCESS, function(e: NetworkEvent) {
					isHost = true;
					entrar();				  
					entrarBt.visible=false;
					hostearBt.visible=false;	
					ipBar.visible=false;		
					multiplayerTxt.visible=false;	
					trace("to hosteando");
				  });


				  server.addEventListener(NetworkEvent.INIT_FAILURE, function(e: NetworkEvent) {			
					trace("não consegui hostear");
				  });

				  server.addEventListener(NetworkEvent.DISCONNECTED, function(e: NetworkEvent)
					{
						Network.destroySession(server);
					});


			}

	override function destroy() {
		/*FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);*/

		super.destroy();
	}

	/*private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
	}*/

		public function entrar()
			{
				if(!canClick)
					return;


					GlobalSoundManager.play('confirmMenu');
					var server_ip = ipBar.text;
					
					client = Network.registerSession(NetworkMode.CLIENT, {
					  ip: server_ip,
					  port: 8888
					});


					client.start();


					client.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(e: NetworkEvent) {
						if(e.data.verb == 'input' && myID==1)
							{
								var qualEquem:Array<String> = e.data.message.split(" ");
								//trace("\nCliente: "+qualEquem[0] +"\nSeta: "+qualEquem[1] +"\nAcao: "+qualEquem[2]);
								mudaAeMano(qualEquem[0], qualEquem[1], qualEquem[2]);
								
							}
						trace(e.data.message); 
					});	
					
					
					client.addEventListener(NetworkEvent.INIT_SUCCESS, function(e: NetworkEvent)
					{
						myID = isHost ? 0 : 1;
						isOnServer=true;
						entrarBt.visible=false;
						hostearBt.visible=false;
						ipBar.visible=false;	
						multiplayerTxt.visible=false;	
						trace(client.uuid);
						trace("to entrando");
					});

					client.addEventListener(NetworkEvent.DISCONNECTED, function(e: NetworkEvent)
						{
							isOnServer=false;
							entrarBt.visible=true;
							hostearBt.visible=true;
							ipBar.visible=true;	
							multiplayerTxt.visible=true;	
							textinhoDebug.text="";
							trace("to saindo");
						});

						client.addEventListener(NetworkEvent.CLOSED, function(e: NetworkEvent)
							{
								isOnServer=false;
								entrarBt.visible=true;
								hostearBt.visible=true;
								ipBar.visible=true;	
								multiplayerTxt.visible=true;	
								textinhoDebug.text="";
								trace("to saindo");
							});

					client.addEventListener(NetworkEvent.INIT_FAILURE, function(e: NetworkEvent) {			
						trace("não consegui entrar");
					});

			}


	function segureiObotao(qual:String)
		{
							// quem clicou | oq clicou
			client.send({ message: myID+" "+qual +" Segurei", verb: 'input' });
		}

	function solteiObotao(qual:String)
		{
									// quem clicou | oq clicou
			client.send({ message: myID+" "+qual +" Soltei", verb: 'input' });
		}

	function mudaAeMano(zero:String, one:String, two:String, ?isServer:Bool = false)
		{
			if(two == "Segurei")
				{
					if(zero=="0")
						{
							switch(one)
							{
								case "cima":
									keysPlayer1[0]=true;
								case "baixo":
									keysPlayer1[1]=true;
								case "direita":
									keysPlayer1[2]=true;
								case "esquerda":
									keysPlayer1[3]=true;
							}
							if(isServer){
								server.send({ message: zero+" "+one +" Segurei", verb: 'input' });
							}

						}
					else
						{
							switch(one)
							{
								case "cima":
									keysPlayer2[0]=true;
								case "baixo":
									keysPlayer2[1]=true;
								case "direita":
									keysPlayer2[2]=true;
								case "esquerda":
									keysPlayer2[3]=true;
							}
							if(isServer){
								server.send({ message: zero+" "+one +" Segurei", verb: 'input' });
							}
						}
				}
				else
					{
						if(zero=="0")
							{
								switch(one)
								{
									case "cima":
										keysPlayer1[0]=false;
									case "baixo":
										keysPlayer1[1]=false;
									case "direita":
										keysPlayer1[2]=false;
									case "esquerda":
										keysPlayer1[3]=false;
								}
								if(isServer){
									server.send({ message: zero+" "+one +" Soltei", verb: 'input' });
								}
							}
						else
							{
								switch(one)
								{
									case "cima":
										keysPlayer2[0]=false;
									case "baixo":
										keysPlayer2[1]=false;
									case "direita":
										keysPlayer2[2]=false;
									case "esquerda":
										keysPlayer2[3]=false;
								}
								if(isServer){
									server.send({ message: zero+" "+one +" Soltei", verb: 'input' });
								}
							}
					}
		}

		function inputShit()
		{
			textinhoDebug.text=keysPlayer1.toString()+"\n"+keysPlayer2.toString();
			if(FlxG.keys.justPressed.W)
				{
					segureiObotao("cima");
				}
			if(FlxG.keys.justPressed.S)
				{
					segureiObotao("baixo");
				}
			if(FlxG.keys.justPressed.D)
				{
					segureiObotao("direita");
				}
			if(FlxG.keys.justPressed.A)
				{
					segureiObotao("esquerda");
				}

				if(FlxG.keys.justReleased.W)
					{
						solteiObotao("cima");
					}
				if(FlxG.keys.justReleased.S)
					{
						solteiObotao("baixo");
					}
				if(FlxG.keys.justReleased.D)
					{
						solteiObotao("direita");
					}
				if(FlxG.keys.justReleased.A)
					{
						solteiObotao("esquerda");
					}
			
		}

            
}
