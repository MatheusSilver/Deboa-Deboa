package multiplayer;

import flixel.addons.display.FlxStarField.FlxStarField2D;
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
	var isOnOptions:Bool = false;


	// SERVER
	var client:Dynamic = null;
	var server:Dynamic = null;
	var isOnServer:Bool = false;
	var isHost:Bool = false;
	var myID:Int = 0;	
	var canInitMatch:Bool = false;
	var selectedMusic:String="confronting-yourself";

	// INPUT
	var keysPlayer1:Array<Bool> = [false,false,false,false];
	var keysPlayer2:Array<Bool> = [false,false,false,false];

	// BFS
	var player1BF:Boyfriend;
	var player2BF:Boyfriend;
	var nomes:Array<String> = ["Player 1", "Player 2"];
	var textinhoBF1:FlxText;
	var textinhoBF2:FlxText;


	// TO DO: UMA JANELINHA QUE INFORMA ERROS QUANDO VC TENTA SE CONECTAR E N CONSEGUE, QUANDO A SALA TA CHEIA E QUANDO O HOST SAI DA SALA

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

		bGround = new FlxSprite(0, 0).loadGraphic(Paths.image('ph'));
		bGround.setGraphicSize(Std.int(bGround.width));
		bGround.antialiasing = ClientPrefs.globalAntialiasing;
		bGround.updateHitbox();
		bGround.alpha = 1;
		add(bGround);

		add(ipBar);

		textinhoDebug = new FlxText(0,0,0,"",25,true);
		textinhoDebug.screenCenter(XY);
        
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

		FlxTween.tween(multiplayerTxt, {y: 51}, 0.75, {ease: FlxEase.expoInOut});
		FlxTween.tween(ipBar, {y: 253}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(entrarBt, {y: 488}, 1.45, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween){canClick=true;}});
		FlxTween.tween(hostearBt, {y: 348}, 1.25, {ease: FlxEase.expoInOut});

		textinhoBF1 = new FlxText(0,0,0,"",50, true);
		textinhoBF1.alignment = CENTER;
		add(textinhoBF1);
		textinhoBF2 = new FlxText(0,0,0,"",50, true);
		textinhoBF2.alignment = CENTER;
		add(textinhoBF2);
		player1BF = new Boyfriend(174, 190);
		player1BF.visible=false;
		//player1BF.flipX=true; fica estranho assimk
		player2BF = new Boyfriend(681, 190);
		player2BF.visible=false;
		player1BF.playAnim('idle', true, false, 10);
		player2BF.playAnim('idle', true, false, 10);
		add(player1BF);
		add(player2BF);
		//add(textinhoDebug);

		comecarBt = new FlxButton(FlxG.width, 100, '');
		comecarBt.loadGraphic(Paths.image('multiplayer/iniciarBt', 'preload'));
		comecarBt.setGraphicSize(Std.int(comecarBt.width * 0.6));
		comecarBt.updateHitbox();
		comecarBt.x=276;
		comecarBt.y=563;
		comecarBt.visible=false;
		add(comecarBt);

		configBt = new FlxButton(FlxG.width, 100, '');
		configBt.loadGraphic(Paths.image('multiplayer/configBt', 'preload'));
		configBt.setGraphicSize(Std.int(configBt.width * 0.6));
		configBt.updateHitbox();
		configBt.x=857;
		configBt.y=563;
		configBt.visible=false;
		add(configBt);

		blackTrans = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackTrans.alpha=0.75;
		blackTrans.visible=isOnOptions;
		add(blackTrans);

		opcoesBg = new FlxSprite(75, 20).loadGraphic(Paths.image('multiplayer/submenus/opcoesPanel', 'preload'));
		opcoesBg.antialiasing = ClientPrefs.globalAntialiasing;
		opcoesBg.updateHitbox();
		opcoesBg.x=75;
		opcoesBg.y=20;
		opcoesBg.visible=isOnOptions;
		add(opcoesBg);

		voltarBt = new FlxButton(FlxG.width, 100, '');
		voltarBt.loadGraphic(Paths.image('multiplayer/submenus/voltarBt', 'preload'));
		voltarBt.updateHitbox();
		voltarBt.x=475;
		voltarBt.y=617;
		voltarBt.visible=isOnOptions;
		add(voltarBt);

	}

	public function onOverBtns()
		{
			GlobalSoundManager.play("scrollMenu");
		}

	override function update(elapsed:Float)
		{


			// bfs texts
			textinhoBF2.alignment = CENTER;
			textinhoBF1.text=nomes[0];
			textinhoBF1.x = player1BF.x+90;
			textinhoBF1.y = player1BF.y-60;
			textinhoBF1.visible = player1BF.visible;
			textinhoBF1.alpha = player1BF.alpha;
			textinhoBF2.alignment = CENTER;
			textinhoBF2.text=nomes[1];
			textinhoBF2.x = player2BF.x+90;
			textinhoBF2.y = player2BF.y-60;
			textinhoBF2.visible = player2BF.visible;
			textinhoBF2.alpha = player2BF.alpha;
			player2BF.alpha = nomes[1]!="Player 2" ? 1 : 0.5;


			// LEMBRAR DE ARRUMAR ISSO AQ DPS
            if (controls.BACK && !ipBar.hasFocus) {
				if(isOnServer)
					{
						if(isHost){Network.destroySession(server); client.disconnectClient();}else{client.disconnectClient();}
					}
				else
					{
						FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new MainMenuStateMobile());
					}			


            }

			// pra fazer o barulhinho
			entrarBt.onOver.callback=onOverBtns;
			configBt.onOver.callback=onOverBtns;
			comecarBt.onOver.callback=canInitMatch ? onOverBtns : null;
			hostearBt.onOver.callback=onOverBtns;
			voltarBt.onOver.callback=onOverBtns;

			// click stuff
			entrarBt.onDown.callback= entrar;
			hostearBt.onDown.callback= hostear;
			configBt.onDown.callback = function(){
				if(isOnOptions)
					return;
				GlobalSoundManager.play('confirmMenu');
				isOnOptions=true;
			}
			voltarBt.onDown.callback = function(){
				if(!isOnOptions)
					return;
				GlobalSoundManager.play('confirmMenu');
				isOnOptions=false;
			};

			// alpha stuff lesgo
			hostearBt.alpha = FlxG.mouse.overlaps(hostearBt) && canClick ? 1 : 0.75;
			entrarBt.alpha = FlxG.mouse.overlaps(entrarBt) && canClick ? 1 : 0.75;
			comecarBt.alpha = FlxG.mouse.overlaps(comecarBt) && canClick && canInitMatch ? 1 : 0.75;
			configBt.alpha = FlxG.mouse.overlaps(configBt) && canClick ? 1 : 0.75;
			voltarBt.alpha = FlxG.mouse.overlaps(voltarBt) && canClick && isOnOptions ? 1 : 0.75;

			// submenu options stuff
			blackTrans.visible=isOnOptions;
			opcoesBg.visible=isOnOptions;
			voltarBt.visible=isOnOptions;


				// server shit			
				multiplayerTxt.visible=!isOnServer;
				configBt.visible=isOnServer && isHost && !isOnOptions;
				comecarBt.visible=isOnServer && isHost && !isOnOptions;
				if(isOnServer)
					{
						inputShit();
						player1BF.visible=true;
						player2BF.visible=true;

					}
					else
						{
							player1BF.visible=false;
							player2BF.visible=false;
						}
				


            super.update(elapsed);

		}

		public function hostear()
			{
				if(!canClick || ipBar.hasFocus)
					return;

				
				canClick=false;
				GlobalSoundManager.play('confirmMenu');
				server = Network.registerSession(NetworkMode.SERVER, {
					ip: '0.0.0.0',
					port: 8888,
					max_connections: 2
				  });

				  server.start();
				  
				  server.addEventListener(NetworkEvent.CONNECTED, function(e: NetworkEvent) {
					server.send({ message: 'Você entrou no servidor!', verb: 'test' });
					if(nomes[0]!="Player 1")
						{
							server.send({ message: "0\n"+nomes[0], verb: 'name' });
						}

				  });

				  server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(e: NetworkEvent) {

					if(e.data.verb == 'input')
						{
							var qualEquem:Array<String> = e.data.message.split(" ");
							mudaAeMano(qualEquem[0], qualEquem[1], qualEquem[2], true);			
						}
					else
						{
							trace(e.data.message); 
						}
					
						if(e.data.verb == "name")
							{
								var quemEqual:Array<String> = e.data.message.split("\n");
								nomes[Std.parseInt(quemEqual[0])] = quemEqual[1];
							}

				});	


				  server.addEventListener(NetworkEvent.INIT_SUCCESS, function(e: NetworkEvent) {
					canClick=true;	
					isHost = true;
					entrar();				  
					entrarBt.visible=false;
					hostearBt.visible=false;	
					ipBar.visible=false;		
					trace("to hosteando");
				  });


				  server.addEventListener(NetworkEvent.INIT_FAILURE, function(e: NetworkEvent) {			
					canClick=true;	
					trace("não consegui hostear");
				  });

				  server.addEventListener(NetworkEvent.DISCONNECTED, function(e: NetworkEvent)
					{
						Network.destroySession(server);
					});


			}

		public function entrar()
			{
				if(!canClick || ipBar.hasFocus)
					return;

					canClick=false;
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
								mudaAeMano(qualEquem[0], qualEquem[1], qualEquem[2]);
								
							}
						
							if(e.data.verb == "name")
								{
									var quemEqual:Array<String> = e.data.message.split("\n");
									nomes[Std.parseInt(quemEqual[0])] = quemEqual[1];
								}
						trace(e.data.message); 
					});	
					
					
					client.addEventListener(NetworkEvent.INIT_SUCCESS, function(e: NetworkEvent)
					{
						canClick=true;	
						myID = isHost ? 0 : 1;
						client.send({ message: myID+"\n"+ GJClient.userName, verb: 'name' });
						nomes[myID] = GJClient.userName;
						isOnServer=true;
						entrarBt.visible=false;
						hostearBt.visible=false;
						ipBar.visible=false;	
						trace(client.uuid);
						trace("to entrando");
					});

					client.addEventListener(NetworkEvent.DISCONNECTED, function(e: NetworkEvent)
						{
							client.send({ message: myID+"\n"+ "Player "+myID+1, verb: 'name' });
							isOnServer=false;
							entrarBt.visible=true;
							hostearBt.visible=true;
							ipBar.visible=true;	
							textinhoDebug.text="";
							trace("to saindo");
						});

						client.addEventListener(NetworkEvent.CLOSED, function(e: NetworkEvent)
							{
								client.send({ message: myID+"\n"+ "Player "+myID+1, verb: 'name' });
								isOnServer=false;
								entrarBt.visible=true;
								hostearBt.visible=true;
								ipBar.visible=true;	
								textinhoDebug.text="";
								trace("to saindo");
							});

					client.addEventListener(NetworkEvent.INIT_FAILURE, function(e: NetworkEvent) {		
						canClick=true;	
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

							bfAnims(one, player1BF);

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

							bfAnims(one, player2BF);
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
								if(keysPlayer1[0]==false && keysPlayer1[1]==false && keysPlayer1[2]==false && keysPlayer1[3]==false)
									{
										bfAnims(one, player1BF, true);
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

								if(keysPlayer2[0]==false && keysPlayer2[1]==false && keysPlayer2[2]==false && keysPlayer2[3]==false)
									{
										bfAnims(one, player2BF, true);
									}
								
							}
					}
		}

		function inputShit()
		{
			textinhoDebug.text=keysPlayer1.toString()+"\n"+keysPlayer2.toString();
			if(controls.NOTE_UP_P)
				{
					segureiObotao("cima");
				}
			if(controls.NOTE_DOWN_P)
				{
					segureiObotao("baixo");
				}
			if(controls.NOTE_RIGHT_P)
				{
					segureiObotao("direita");
				}
			if(controls.NOTE_LEFT_P)
				{
					segureiObotao("esquerda");
				}

				if(controls.NOTE_UP_R)
					{
						solteiObotao("cima");
					}
				if(controls.NOTE_DOWN_R)
					{
						solteiObotao("baixo");
					}
				if(controls.NOTE_RIGHT_R)
					{
						solteiObotao("direita");
					}
				if(controls.NOTE_LEFT_R)
					{
						solteiObotao("esquerda");
					}
			
		}

		function bfAnims(direction:String, qualBF:Boyfriend, ?soltou:Bool=false)
			{
				if(!soltou)
					{
							switch (direction)
							{
								case "esquerda":
									qualBF.playAnim('singLEFT', true);
								case "baixo":
									qualBF.playAnim('singDOWN', true);
								case "cima":
									qualBF.playAnim('singUP', true);
								case "direita":
									qualBF.playAnim('singRIGHT', true);
							}
					}
				
				if(soltou)
					{
						qualBF.playAnim('idle', false, false, 10);
					}

			}

            
}
