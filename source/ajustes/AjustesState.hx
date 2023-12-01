package ajustes;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class AjustesState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var boom:FlxSprite;
	var gameJoltBG:FlxSprite;

	var configuracoesbotao:FlxButton;
	var controlesbotao:FlxButton;
	var setasbotao:FlxButton;
	var gamejoltbotao:FlxButton;
	var letext:FlxText;
	var isCoolBeat:Bool=true;
	//var gradientBar:FlxGradient;
	
	var optionShit:Array<String> = ['configuracoes','controles', 'setatipos', 'gamejooj'];

	var machine:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var logoBl:FlxSprite;
	var checkiftouch:Bool = false;
    var line:FlxSprite;
    var trees:FlxSprite;
	var pode:Bool = false;

	override function create()
	{
		//Conductor.changeBPM(112);
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Nas configurações.", null);
		#end
		
		if(FlxG.sound.music.volume==0) {
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		/*camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];*/
		#if !mobile
		FlxG.mouse.visible = Main.mouse;
		#end
		//FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/bg-wfiltro'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(FlxG.width);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);


		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);



		machine = new FlxSprite(0).loadGraphic(Paths.image('optionsmenu/ajuste_back', 'preload'));
		machine.scrollFactor.x = 0;
		machine.scrollFactor.y = 0;
		machine.setGraphicSize(FlxG.width, FlxG.height);
		machine.updateHitbox();
		machine.screenCenter();
		machine.visible = true;
		machine.antialiasing = ClientPrefs.globalAntialiasing;
		add(machine);

        trees = new FlxSprite(0).loadGraphic(Paths.image('optionsmenu/ajuste_arvores', 'preload'));
		trees.scrollFactor.x = 0;
		trees.scrollFactor.y = 0;
		trees.setGraphicSize(FlxG.width, FlxG.height);
		trees.updateHitbox();
		trees.screenCenter();
		trees.visible = true;
		trees.antialiasing = ClientPrefs.globalAntialiasing;

		boom = new FlxSprite(0, 0); //ok
		boom.frames = Paths.getSparrowAtlas('optionsmenu/sunkyajustes', 'preload');
		boom.animation.addByPrefix('idle', "sunkyajustes bump",30);
		boom.antialiasing = ClientPrefs.globalAntialiasing;
		boom.setGraphicSize(Std.int(boom.width*1.5));
		boom.updateHitbox();
		boom.y =-1035;
		boom.x = -1100;
		boom.alpha=1;
		//boom.flipX=true;
		add(boom);

        add(trees);

		configuracoesbotao = new FlxButton(FlxG.width, 15 - 250 + 198 - 50, '');
		configuracoesbotao.loadGraphic(Paths.image('optionsmenu/configuracoes', 'preload'));
		configuracoesbotao.setGraphicSize(Std.int(configuracoesbotao.width * 0.6));
		configuracoesbotao.updateHitbox();

        configuracoesbotao.alpha = 0.75;
		configuracoesbotao.x = FlxG.width;
		configuracoesbotao.y = 150;
        add(configuracoesbotao);

		controlesbotao = new FlxButton(FlxG.width, 15 + configuracoesbotao.y + configuracoesbotao.height - 367, '');
		controlesbotao.loadGraphic(Paths.image('optionsmenu/controls', 'preload'));
		controlesbotao.setGraphicSize(Std.int(controlesbotao.width * 0.6));

		controlesbotao.updateHitbox();
        controlesbotao.alpha = 0.75;

		controlesbotao.x = FlxG.width;
		controlesbotao.y = 15 + configuracoesbotao.y + configuracoesbotao.height;

        add(controlesbotao);


		setasbotao = new FlxButton(FlxG.width, 15 + controlesbotao.y + controlesbotao.height, '');
		setasbotao.loadGraphic(Paths.image('optionsmenu/setas', 'preload'));
		setasbotao.alpha = 0.75;
		setasbotao.setGraphicSize(Std.int(setasbotao.width * 0.6));

		setasbotao.updateHitbox();

		setasbotao.x = FlxG.width;
		setasbotao.y = 15 + controlesbotao.y + controlesbotao.height;
		add(setasbotao);

		gamejoltbotao = new FlxButton(FlxG.width, 15 + setasbotao.y + setasbotao.height, '');
		if(!GJClient.logged && !TitleState.ModoOffline)
			{
				gamejoltbotao.loadGraphic(Paths.image('optionsmenu/gamejooj', 'preload'));
				gamejoltbotao.alpha = 0.75;
			}
			else
			{
				gamejoltbotao.loadGraphic(Paths.image('optionsmenu/gamejooj-locked', 'preload'));
				gamejoltbotao.alpha = 1;
			}
		gamejoltbotao.setGraphicSize(Std.int(gamejoltbotao.width * 0.6));

		gamejoltbotao.updateHitbox();
		gamejoltbotao.x = FlxG.width;
		gamejoltbotao.y = 15 + setasbotao.y + setasbotao.height;
        add(gamejoltbotao);

        line = new FlxSprite(0).loadGraphic(Paths.image('optionsmenu/ajuste_linhas', 'preload'));
		line.scrollFactor.x = 0;
		line.scrollFactor.y = 0;
		line.setGraphicSize(FlxG.width, FlxG.height);
		line.updateHitbox();
		line.screenCenter();
		line.visible = true;
		line.antialiasing = ClientPrefs.globalAntialiasing;
		add(line);


		/*gameJoltBG = new FlxSprite(0).loadGraphic(Paths.image('gamejoltUserBar', 'preload'));
		gameJoltBG.setGraphicSize(Std.int(gameJoltBG.width*0.5));
		gameJoltBG.updateHitbox();
		gameJoltBG.x=-630;
		gameJoltBG.y=-350;
		gameJoltBG.visible = true;
		gameJoltBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(gameJoltBG);

		letext = new FlxText(50, FlxG.height - 200, FlxG.width - 200, "DESCONECTADO", 32);
		letext.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.scrollFactor.set();
		letext.x=-355;
		letext.y=27;
		letext.alpha = 1;
		add(letext);*/

		//haxe me obrigou a ser um cara organizado, mas ainda assim sou rebelde
		//musica de novela de 2010 starts playing

		new FlxTimer().start(0.1, function(tmr:FlxTimer) {
		FlxTween.tween(configuracoesbotao, {x: FlxG.width - 2.5*configuracoesbotao.width + 696 + 90}, 0.6, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.4, function(tmr:FlxTimer) {
		FlxTween.tween(controlesbotao, {x: FlxG.width - 2.5*controlesbotao.width + 696 + 90}, 0.6, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.7, function(tmr:FlxTimer) {
		FlxTween.tween(setasbotao, {x: FlxG.width - 2.5*setasbotao.width + 696 + 90}, 0.6, {ease: FlxEase.expoInOut});
		});
			new FlxTimer().start(1, function(tmr:FlxTimer) {	
			FlxTween.tween(gamejoltbotao, {x: FlxG.width - 2.5*gamejoltbotao.width + 696 + 90}, 0.6, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {pode=true;
				}});
			});

		super.create();
	}

	var selectedSomethin:Bool = false;

	function sumidao(selecionado:Int){
		pode=false;
			if (selecionado == 0){
				configuracoesbotao.alpha=1;
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					FlxTween.tween(configuracoesbotao, {x: FlxG.width - configuracoesbotao.width}, 0.5, {ease: FlxEase.expoInOut});
					});
						new FlxTimer().start(0.65, function(tmr:FlxTimer) {
						FlxTween.tween(configuracoesbotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
						});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(controlesbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(setasbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(gamejoltbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
			} else if (selecionado == 1){
				controlesbotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			FlxTween.tween(controlesbotao, {x: FlxG.width - controlesbotao.width}, 0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(controlesbotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(configuracoesbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(setasbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(gamejoltbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if(selecionado == 2) {
				setasbotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) { //!!!
			FlxTween.tween(setasbotao, {x: FlxG.width - setasbotao.width},0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(setasbotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(configuracoesbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(controlesbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(gamejoltbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if (selecionado == 3) {
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			FlxTween.tween(gamejoltbotao, {x: FlxG.width - gamejoltbotao.width}, 0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(gamejoltbotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(configuracoesbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(controlesbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(setasbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			}
	}

	override function update(elapsed:Float)
	{
		/*if(GJClient.logged)
			{
				letext.text = GJClient.userName;
				if(FlxG.keys.justPressed.SPACE)
					{
						GJClient.trophieAdd(179877);
						trace('getting trophie');
					}
				letext.alpha = 1;
			}
			else
				{
					letext.text = "DESCONECTADO";
				}*/
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		if(pode)
			//Silvio ser bulo de mais pra entender isso.
			{
				configuracoesbotao.updateHitbox();
				controlesbotao.updateHitbox();
				setasbotao.updateHitbox();
				gamejoltbotao.updateHitbox();
				configuracoesbotao.onOver.callback = configuracoesHover;
				configuracoesbotao.onOut.callback = configuracoesOut;
				controlesbotao.onOver.callback = controlesHover;
				controlesbotao.onOut.callback = controlesOut;
				setasbotao.onOver.callback = setasHover;
				setasbotao.onOut.callback = setasOut;
				gamejoltbotao.onOver.callback = gamejoltHover;
				gamejoltbotao.onOut.callback = gamejoltOut;
				FlxG.mouse.visible = Main.mouse;
				
				if(configuracoesbotao.justPressed && !checkiftouch){
					configuracoesbotao.alpha=1;
					curSelected = 0;
					checkiftouch = true;
				}
				if(controlesbotao.justPressed && !checkiftouch){
					controlesbotao.alpha=1;
					curSelected = 1;
					checkiftouch = true;
				}
				if(setasbotao.justPressed && !checkiftouch){
					setasbotao.alpha=1;
					curSelected = 2;		
					checkiftouch = true;
				}
				if(gamejoltbotao.justPressed && !checkiftouch){
					if(!GJClient.logged && !TitleState.ModoOffline)
						{
							gamejoltbotao.alpha=1;
							curSelected = 3;
							checkiftouch = true;
						}
				}
			}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{

			if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
			{
				selectedSomethin = true;
				GlobalSoundManager.play('cancelMenu');
				ClientPrefs.save();
				MusicBeatState.switchState(new MainMenuStateMobile());
			}

			if (/*controls.ACCEPT ||*/ checkiftouch) //Tecnicamente, a pessoa não pode escolher entre opções então né?
			{
				#if debug
				FlxG.mouse.visible = false;
				#end 
					selectedSomethin = true;
					GlobalSoundManager.play('confirmMenu');
							checkiftouch = false; //This should be enough
							var daChoice:String = optionShit[curSelected];
							sumidao(curSelected);
							new FlxTimer().start(1.7, function(tmr:FlxTimer) {
							switch (daChoice)
							{
								case 'configuracoes':
								MusicBeatState.switchState(new ajustes.BaseOptionsMenu()); //graficos, gameplay e etc.
								case 'controles':
								// fiz isso pois tem gente que joga de teclado no mobile.
								#if desktop
								MusicBeatState.switchState(new ajustes.KeysSubstate());
								#elseif mobile
								MusicBeatState.switchState(new ajustes.ControlesState());
								#end
								case 'setatipos':
								MusicBeatState.switchState(new ajustes.NotesSubState());
								case 'gamejooj':
                                if(GJClient.logged || TitleState.ModoOffline)
                                {
                                	
                                }
                                else{
                                    MusicBeatState.switchState(new GameJoltLoginState());
                                }
							}							
						});
				}
		}
			#if desktop
			#if debug
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new editors.MasterEditorMenu());
			}
			#end
			#end
			super.update(elapsed);	
		}

		function configuracoesHover():Void
		{
			configuracoesbotao.alpha=1;
			GlobalSoundManager.play('scrollMenu');
		}
	 
		function configuracoesOut():Void
		{
			configuracoesbotao.alpha=0.75;
		}

		function controlesHover():Void
		{
			controlesbotao.alpha=1;
			GlobalSoundManager.play('scrollMenu');
		}
		 
		function controlesOut():Void
		{
			controlesbotao.alpha=0.75;
		}

		function setasHover():Void
			{
				setasbotao.alpha=1;
				GlobalSoundManager.play('scrollMenu');
			}
			 
			function setasOut():Void
			{
				setasbotao.alpha=0.75;
			}
				
			function gamejoltHover():Void
			{
				if(!GJClient.logged && !TitleState.ModoOffline)
					{
						gamejoltbotao.alpha=1;
						GlobalSoundManager.play('scrollMenu');
					}
			}
			 
			function gamejoltOut():Void
			{
				if(!GJClient.logged && !TitleState.ModoOffline)
					{
						gamejoltbotao.alpha=0.75;
					}
			}

			override function beatHit()
			{
				super.beatHit();
				if(isCoolBeat){boom.animation.play('idle', true);}
					isCoolBeat = !isCoolBeat;
			}


}