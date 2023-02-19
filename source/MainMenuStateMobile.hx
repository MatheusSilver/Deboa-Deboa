package;

import Achievements;
import editors.MasterEditorMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.ErrorEvent;
import flixel.graphics.frames.FlxImageFrame;
import openfl.net.URLLoader;
import flixel.graphics.FlxGraphic;
import openfl.net.URLRequest;
import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;

using StringTools;

#if desktop
import Discord.DiscordClient;
#end

class MainMenuStateMobile extends MusicBeatState
{
	public static var psychEngineVersion:String = 'V1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	public var camGame:FlxCamera;
	public var camAchievement:FlxCamera;
	var clicavel:Bool = false;

	var boom:FlxSprite;
	var gameJoltBG:FlxSprite;

	var historiabotao:FlxButton;
	var freeplaybotao:FlxButton;
	var multiplayerbotao:FlxButton;
	var achievementsbotao:FlxButton;
	var opcaobotao:FlxButton;
	var letext:FlxText;
	var sobrebotao:FlxButton;
	var isCoolBeat:Bool=true;
	public static var instance:MainMenuStateMobile;
	//var gradientBar:FlxGradient;
	
	var optionShit:Array<String> = ['story_mode','freeplay', 'awards', 'credits', 'options'];

	var machine:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var logoBl:FlxSprite;
	var checkiftouch:Bool = false;
	var gameJoltIcon:FlxSprite;

	override function create()
	{
		Main.dumpCache();
		Conductor.changeBPM(112);
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("No menu principal", null);
		#end
		if(FlxG.sound.music.volume==0) {
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		#if !mobile
		FlxG.mouse.visible = true;
		#end
		//FunkinLua.addShaderToCamera('achMenu', new VCRDistortionEffect(0,false,false,false));
		//FunkinLua.addShaderToCamera('gameMenu', new BloomEffect(0.05/512.0,0.05));
		//FunkinLua.addShaderToCamera('gameMenu', new ChromaticAberrationEffect(0.0015));
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/bg-wfiltro'));
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.screenCenter(X);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);


		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);



		machine = new FlxSprite(0).loadGraphic(Paths.image('menus/faixa', 'preload'));
		machine.scrollFactor.x = 0;
		machine.scrollFactor.y = 0;
		machine.setGraphicSize(FlxG.width, FlxG.height);
		machine.updateHitbox();
		machine.screenCenter();
		machine.visible = true;
		machine.antialiasing = ClientPrefs.globalAntialiasing;
		add(machine);

		boom = new FlxSprite(0, 0); //ok
		boom.frames = Paths.getSparrowAtlas('menus/sonicmenu1', 'preload');
		boom.animation.addByPrefix('idle', "sonicmenu1 idle",30);
		boom.antialiasing = ClientPrefs.globalAntialiasing;
		//boom.setGraphicSize(Std.int));
		//boom.flipX = true;
		boom.updateHitbox();
		boom.y = -620;
		boom.flipX=true;
		boom.x = -720;
		boom.alpha=1;
		add(boom);

		historiabotao = new FlxButton(FlxG.width, 15 - 250 + 198 - 50, '');
		historiabotao.loadGraphic(Paths.image('mainmenu/sethistoria', 'preload'));
		historiabotao.setGraphicSize(Std.int(historiabotao.width * 0.6));
		historiabotao.updateHitbox();

        historiabotao.alpha = 0.75;
		historiabotao.x = FlxG.width;
		historiabotao.y = 8.5;
        add(historiabotao);

		freeplaybotao = new FlxButton(FlxG.width, 15 + historiabotao.y + historiabotao.height - 367, '');
		freeplaybotao.loadGraphic(Paths.image('mainmenu/setfreeplay', 'preload'));
		freeplaybotao.setGraphicSize(Std.int(freeplaybotao.width * 0.6));

		freeplaybotao.updateHitbox();
        freeplaybotao.alpha = 0.75;

		freeplaybotao.x = FlxG.width;
		freeplaybotao.y = 10 + historiabotao.y + historiabotao.height;

        add(freeplaybotao);

		multiplayerbotao = new FlxButton(FlxG.width, 15 + freeplaybotao.y + freeplaybotao.height, '');
		multiplayerbotao.loadGraphic(Paths.image('mainmenu/setmultiplayer-locked2', 'preload'));
		multiplayerbotao.alpha = 1;
		multiplayerbotao.setGraphicSize(Std.int(multiplayerbotao.width * 0.6));

		multiplayerbotao.updateHitbox();

		multiplayerbotao.x = FlxG.width;
		multiplayerbotao.y = 10 + freeplaybotao.y + freeplaybotao.height;
		add(multiplayerbotao);


		achievementsbotao = new FlxButton(FlxG.width, 15 + freeplaybotao.y + freeplaybotao.height, '');
		achievementsbotao.loadGraphic(Paths.image('mainmenu/setconquistas', 'preload'));
		achievementsbotao.alpha = 0.75;
		achievementsbotao.setGraphicSize(Std.int(achievementsbotao.width * 0.6));

		achievementsbotao.updateHitbox();

		achievementsbotao.x = FlxG.width;
		achievementsbotao.y = 10 + multiplayerbotao.y + multiplayerbotao.height;
		add(achievementsbotao);

		opcaobotao = new FlxButton(FlxG.width, 15 + achievementsbotao.y + achievementsbotao.height, '');
		opcaobotao.loadGraphic(Paths.image('mainmenu/setopcao', 'preload'));
		opcaobotao.setGraphicSize(Std.int(opcaobotao.width * 0.6));

		opcaobotao.updateHitbox();
		opcaobotao.x = FlxG.width;
		opcaobotao.y = 10 + achievementsbotao.y + achievementsbotao.height;
        opcaobotao.alpha = 0.75;
        add(opcaobotao);

		sobrebotao = new FlxButton(FlxG.width, 15 + opcaobotao.y + opcaobotao.height, '');
		sobrebotao.loadGraphic(Paths.image('mainmenu/setcreditos', 'preload')); //o 'preload' é apenas para não bugar após uma música.
		sobrebotao.setGraphicSize(Std.int(sobrebotao.width * 0.6));

		sobrebotao.updateHitbox();
		sobrebotao.x = FlxG.width;
		sobrebotao.y = 10 + opcaobotao.y + opcaobotao.height;
		sobrebotao.alpha = 0.75;
		add(sobrebotao);

		gameJoltBG = new FlxSprite(0).loadGraphic(Paths.image('gamejoltUserBar', 'preload'));
		gameJoltBG.setGraphicSize(Std.int(gameJoltBG.width*0.5));
		gameJoltBG.updateHitbox();
		gameJoltBG.x=-630;
		gameJoltBG.y=-350;
		gameJoltBG.visible = true;
		gameJoltBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(gameJoltBG);

		gameJoltIcon= new FlxSprite(0);
		gameJoltIcon.setGraphicSize(Std.int(gameJoltIcon.width*0.5));
		gameJoltIcon.updateHitbox();
		gameJoltIcon.visible = false;
		gameJoltIcon.antialiasing = ClientPrefs.globalAntialiasing;
		gameJoltIcon.screenCenter(XY);

		letext = new FlxText(50, FlxG.height - 200, FlxG.width - 200, "DESCONECTADO", 32);
		letext.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.scrollFactor.set();
		letext.x=-355;
		letext.y=27;
		letext.alpha = 1;
		add(letext);

		if(GJClient.logged)
			{
				letext.text = GJClient.userName;
				trace(GJClient.avatarURL);

				letext.x=-345;
				/*if(FlxG.keys.justPressed.SPACE)
					{
						Achievements.unlockAchievement("Seja bem vindo!");
						trace('getting trophie');
					}*/
				letext.alpha = 1;

				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
					var bmp:Bitmap = cast(loader.content, Bitmap);
					trace("peguei a foto");
					var bmd:BitmapData = bmp.bitmapData;
					var graphicAsset:FlxGraphic = FlxGraphic.fromBitmapData(bmd, false);
					gameJoltBG.loadGraphic(Paths.image('gamejoltUserBar2', 'preload'));
					gameJoltIcon.loadGraphic(graphicAsset);
					gameJoltIcon.setGraphicSize(Std.int(gameJoltIcon.width*1.1));
					var tempMask = new FlxSprite(gameJoltIcon.width, gameJoltIcon.height);

					var bordinha = new FlxSprite(0,0);
					bordinha.loadGraphic(Paths.image('Bordinha', 'preload'));
					tempMask.makeGraphic(100, 100, FlxColor.TRANSPARENT,true);
					FlxSpriteUtil.drawRoundRect(tempMask, 0, 0, gameJoltIcon.width, gameJoltIcon.height, 10, 10, FlxColor.WHITE);
					FlxSpriteUtil.alphaMaskFlxSprite(gameJoltIcon, tempMask, gameJoltIcon);
					gameJoltIcon.x = gameJoltBG.x+10;
					gameJoltIcon.y = gameJoltBG.y+2;
					bordinha.x = gameJoltIcon.x-6.5;
					bordinha.y = gameJoltIcon.y-4.5;
					gameJoltIcon.visible = true;
					add(gameJoltIcon);
					add(bordinha);
				});
				loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, function(event:Event):Void {
					trace("nao peguei a foto");
					gameJoltBG.loadGraphic(Paths.image('gamejoltUserBar2', 'preload'));
					gameJoltIcon.loadGraphic(Paths.image('placeholderUserIcon', 'preload'));
					gameJoltIcon.setGraphicSize(Std.int(gameJoltIcon.width*1.1));
					var tempMask = new FlxSprite(gameJoltIcon.width, gameJoltIcon.height);

					var bordinha = new FlxSprite(0,0);
					bordinha.loadGraphic(Paths.image('Bordinha', 'preload'));
					tempMask.makeGraphic(100, 100, FlxColor.TRANSPARENT,true);
					FlxSpriteUtil.drawRoundRect(tempMask, 0, 0, gameJoltIcon.width, gameJoltIcon.height, 10, 10, FlxColor.WHITE);
					FlxSpriteUtil.alphaMaskFlxSprite(gameJoltIcon, tempMask, gameJoltIcon);
					gameJoltIcon.x = gameJoltBG.x+10;
					gameJoltIcon.y = gameJoltBG.y+2;
					bordinha.x = gameJoltIcon.x-6.5;
					bordinha.y = gameJoltIcon.y-4.5;
					gameJoltIcon.visible = true;
					add(gameJoltIcon);
					add(bordinha);
				});
				loader.load(new URLRequest(GJClient.avatarURL));
				
				
			}
			else
			{
				letext.text = "DESCONECTADO";
			}

		//haxe me obrigou a ser um cara organizado, mas ainda assim sou rebelde
		//musica de novela de 2010 starts playing

		new FlxTimer().start(0.1, function(tmr:FlxTimer) {
		FlxTween.tween(historiabotao, {x: FlxG.width - 2.5*historiabotao.width + 696 + 90}, 0.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
		FlxTween.tween(freeplaybotao, {x: FlxG.width - 2.5*freeplaybotao.width + 696 + 90}, 0.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.5, function(tmr:FlxTimer) {
			FlxTween.tween(multiplayerbotao, {x: FlxG.width - 2.5*multiplayerbotao.width + 696 + 90}, 0.5, {ease: FlxEase.expoInOut});
			});
		new FlxTimer().start(0.7, function(tmr:FlxTimer) {
		FlxTween.tween(achievementsbotao, {x: FlxG.width - 2.5*achievementsbotao.width + 696 + 90}, 0.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.9, function(tmr:FlxTimer) {
		FlxTween.tween(opcaobotao, {x: FlxG.width - 2.5*opcaobotao.width + 696 + 90}, 0.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(1.1, function(tmr:FlxTimer) {
		FlxTween.tween(sobrebotao, {x: FlxG.width - 2.5*sobrebotao.width + 696 + 90}, 0.5, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween) {
				clicavel = true; //Só pra garantir que a animação de entrada NÃO ocorra ao mesmo tempo que a de saida.
			}
		});
	});

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
			var achieveID:Int = Achievements.getAchievementIndex('modboa');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
		}
		#end



		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('modboa', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "modboa"');
	}
	#end

	var selectedSomethin:Bool = false;



	function sumidao(selecionado:Int){ //do hokage omegalul
		//provavelmente um dos códigos mais feios que já fiz, mas na real
		//não consigo pensar em outra forma de fazê-lo sem ter que reescrever tudo.


		switch (selecionado) 

		// usando switchs "inteligentes"

		{
			case 0:

			//selecionado 0
			historiabotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(historiabotao, {x: FlxG.width - historiabotao.width}, 0.5, {ease: FlxEase.expoInOut});
			});
					new FlxTimer().start(0.65, function(tmr:FlxTimer) {
						FlxTween.tween(historiabotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
					});
					new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
					});
					new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(multiplayerbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
					});
					new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
					});
					new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
					});
					new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
					});

			case 1:

			freeplaybotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			FlxTween.tween(freeplaybotao, {x: FlxG.width - freeplaybotao.width}, 0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(historiabotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					FlxTween.tween(multiplayerbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});	

			case 2:

			achievementsbotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) { //!!!
			FlxTween.tween(achievementsbotao, {x: FlxG.width - achievementsbotao.width},0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(historiabotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					FlxTween.tween(multiplayerbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});

			case 3:

			sobrebotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			FlxTween.tween(sobrebotao, {x: FlxG.width - sobrebotao.width}, 0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(historiabotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					FlxTween.tween(multiplayerbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});


			case 4:

			opcaobotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) { //!!!
			FlxTween.tween(opcaobotao, {x: FlxG.width - opcaobotao.width}, 0.5, {ease: FlxEase.expoInOut});
			});
				new FlxTimer().start(0.65, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 1.0, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(historiabotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					FlxTween.tween(multiplayerbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			}

		}

	override function update(elapsed:Float)
	{

		#if debug
		if(controls.NOTE_SPACE){ //CUSTOM SILVIO'S HITBOOX WHEEEEEEEEEEEEEEEEEN?????????????????
			trace('desvio segurado');
		}
		if(controls.NOTE_SPACE_P){
			trace('desvio pressionado');
		}
		if(controls.NOTE_SPACE_R){
			trace('desvio solto');
		}
		if(FlxG.keys.justPressed.FOUR) add(new AchievementObject('eggman_free', camAchievement));
		
		#end
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		historiabotao.updateHitbox();
		freeplaybotao.updateHitbox();
		achievementsbotao.updateHitbox();
		opcaobotao.updateHitbox();
		sobrebotao.updateHitbox();
		historiabotao.onOver.callback = historiaHover;
        historiabotao.onOut.callback = historiaOut;
		freeplaybotao.onOver.callback = freeplayHover;
        freeplaybotao.onOut.callback = freeplayOut;
		achievementsbotao.onOver.callback = achievementsHover;
        achievementsbotao.onOut.callback = achievementsOut;
		opcaobotao.onOver.callback = opcaoHover;
        opcaobotao.onOut.callback = opcaoOut;
		sobrebotao.onOver.callback = sobreHover;
        sobrebotao.onOut.callback = sobreOut;
		FlxG.mouse.visible = true;
		//checker.y += 0.1;

		if(historiabotao.justPressed && !checkiftouch && clicavel){
			historiabotao.alpha=1;
			curSelected = 0;
			if(curSelected == 0 && checkiftouch == false){checkiftouch = true;}
		}
		if(freeplaybotao.justPressed && !checkiftouch && clicavel){
			freeplaybotao.alpha=1;
			curSelected = 1;
			if(curSelected == 1 && checkiftouch == false){checkiftouch = true;}
		}
		if(achievementsbotao.justPressed && !checkiftouch && clicavel){
			achievementsbotao.alpha=1;
			curSelected = 2;		
			if(curSelected == 2 && checkiftouch == false && clicavel){checkiftouch = true;}
		}
		if(opcaobotao.justPressed && !checkiftouch){
			opcaobotao.alpha=1;
			curSelected = 4;
			if(curSelected == 4 && checkiftouch == false && clicavel){checkiftouch = true;}
		}
		if(sobrebotao.justPressed && !checkiftouch){
			sobrebotao.alpha=1;
			curSelected = 3;
			if(curSelected == 3 && checkiftouch == false && clicavel){checkiftouch = true;}
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
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT || checkiftouch)
			{
				#if debug
				FlxG.mouse.visible = false;
				#end 
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					clicavel = false;
					FlxG.sound.play(Paths.sound('confirmMenu'));
							checkiftouch = false; //This should be enough
							var daChoice:String = optionShit[curSelected];
							sumidao(curSelected);
							new FlxTimer().start(1.7, function(tmr:FlxTimer) {
							switch (daChoice)
							{
								case 'story_mode':
									MusicBeatState.switchState(new MenuPreHistoria());
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'awards':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'credits':
									MusicBeatState.switchState(new SobreState());
								case 'options':
									MusicBeatState.switchState(new ajustes.AjustesState()); // Deixa esse por enquanto KEK
							}							
						});
				}
			}
			
			#if desktop
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
			
		}

		super.update(elapsed);

	}

	function historiaHover():Void
		{
			historiabotao.alpha=1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
		}
	 
		function historiaOut():Void
		{
			historiabotao.alpha=0.75;
		}

		function freeplayHover():Void
			{
				freeplaybotao.alpha=1;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
			}
		 
			function freeplayOut():Void
			{
				freeplaybotao.alpha=0.75;
			}

			function achievementsHover():Void
				{
					achievementsbotao.alpha=1;
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
				}
			 
				function achievementsOut():Void
				{
					achievementsbotao.alpha=0.75;
				}
				
			function opcaoHover():Void
				{
					opcaobotao.alpha=1;
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
				}
			 
				function opcaoOut():Void
				{
					opcaobotao.alpha=0.75;
				}

				function sobreHover():Void
					{
						sobrebotao.alpha=1;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
					}
				 
					function sobreOut():Void
					{
						sobrebotao.alpha=0.75;
					}

					override function beatHit()
						{
							super.beatHit();
							if(isCoolBeat){boom.animation.play('idle', true);}
							isCoolBeat = !isCoolBeat;
						}
}
