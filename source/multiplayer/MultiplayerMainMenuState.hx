package multiplayer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
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
	var client:Dynamic = null;
	var server:Dynamic = null;
	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;
	//var	keysArray:Array<Dynamic>;
						// cima, baixo, direita, esquerda
	var keysPlayer1:Array<Bool> = [false,false,false,false];
	var keysPlayer2:Array<Bool> = [false,false,false,false];

	var textinhoDebug:FlxText;


	override function create()
		{
			textinhoDebug = new FlxText(0,0,0,"",25,true);
			textinhoDebug.screenCenter(XY);
			add(textinhoDebug);
			/*keysArray = [
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
				ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
				];*/
            hostearBt = new FlxButton(FlxG.width, 100, 'HOSTEAR');
			hostearBt.updateHitbox();
			hostearBt.x = 100; // 405
			hostearBt.y = 100;
			add(hostearBt);
			entrarBt = new FlxButton(FlxG.width, 100, 'ENTRAR');
			entrarBt.updateHitbox();
			entrarBt.x = 200; // 405
			entrarBt.y = 200;
			add(entrarBt);
			super.create();
		}
	override function update(elapsed:Float)
		{
            if (controls.BACK && !isOnServer) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuStateMobile());
            }
			hostearBt.onDown.callback= hostear;
			if(isOnServer)
				{inputShit();}
			entrarBt.onDown.callback= entrar;
            super.update(elapsed);

		}

		public function hostear()
			{
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

		public function entrar()
			{
					var server_ip = '127.0.0.1';
					
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
						trace(client.uuid);
						trace("to entrando");
					});


					client.addEventListener(NetworkEvent.INIT_FAILURE, function(e: NetworkEvent) {			
						trace("não consegui entrar");
					});

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

            
}
