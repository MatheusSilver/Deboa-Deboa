package;

import openfl.Lib;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class MainMenuStateMobile extends MusicBeatState
{
	public static var psychEngineVersion:String = 'V1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var clicavel:Bool = false;

	var tails:FlxSprite;
	var sonic1:FlxSprite;

	var historiabotao:FlxButton;
	var freeplaybotao:FlxButton;
	var achievementsbotao:FlxButton;
	var opcaobotao:FlxButton;
	var sobrebotao:FlxButton;
	
	var optionShit:Array<String> = ['story_mode','freeplay', 'awards', 'credits', 'options'];

	var machine:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var logoBl:FlxSprite;
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	var checkiftouch:Bool = false;

	var checker:FlxBackdrop; 
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Silver reverso says: AMO PROGRAMAR MENUS!!!", null);
		#end


		Main.dumpCache(); // What can go wrong?


		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		#if debug
		FlxG.mouse.visible = true;
		#end 

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/bg'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(FlxG.width);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		checker = new FlxBackdrop(Paths.image('soquadrados', 'preload'), 0.2, 0.2, true, true);
		
		add(checker);
		checker.alpha = 0.8;
		checker.color = FlxColor.RED;

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x41000000, 0x2C744100, 0x88A10000], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		gradientBar.scale.y = 0;
		gradientBar.updateHitbox();
		add(gradientBar);


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

		tails = new FlxSprite(0, 0); //ok
		tails.frames = Paths.getSparrowAtlas('menus/tailsdoll_p2', 'preload');
		tails.animation.addByPrefix('idle2', "singRIGHT", 24);
		tails.animation.play('idle2');
		tails.alpha = 1;
		tails.antialiasing = true;
		tails.setGraphicSize(Std.int(tails.width * 0.9));
		tails.updateHitbox();
		tails.x = 25 - 507 - 200 - 400 + 75 + 140;
		tails.y = 75 - 320 - 250 - 200 + 30;
		add(tails);

		sonic1 = new FlxSprite(0, 0); //ok
		sonic1.frames = Paths.getSparrowAtlas('menus/YCR', 'preload');
		sonic1.animation.addByPrefix('idle1', "normal_down", 20);
		sonic1.animation.play('idle1');
		sonic1.alpha = 0.95;
		sonic1.antialiasing = true;
		sonic1.setGraphicSize(Std.int(sonic1.width * 1.5));
		sonic1.updateHitbox();
		sonic1.y = 75 - 390 + 40;
		sonic1.x = 25 - 507 - 100;
		add(sonic1);

		historiabotao = new FlxButton(FlxG.width, 15 - 250 + 198 - 50, '');
		historiabotao.loadGraphic(Paths.image('mainmenu/sethistoria', 'preload'));
		historiabotao.setGraphicSize(Std.int(historiabotao.width * 0.6));
		historiabotao.updateHitbox();

        historiabotao.alpha = 0.75;
		historiabotao.x = FlxG.width;
		historiabotao.y = 15;
        add(historiabotao);

		freeplaybotao = new FlxButton(FlxG.width, 15 + historiabotao.y + historiabotao.height - 367, '');
		freeplaybotao.loadGraphic(Paths.image('mainmenu/setfreeplay', 'preload'));
		freeplaybotao.setGraphicSize(Std.int(freeplaybotao.width * 0.6));

		freeplaybotao.updateHitbox();
        freeplaybotao.alpha = 0.75;

		freeplaybotao.x = FlxG.width;
		freeplaybotao.y = 15 + historiabotao.y + historiabotao.height;

        add(freeplaybotao);


		achievementsbotao = new FlxButton(FlxG.width, 15 + freeplaybotao.y + freeplaybotao.height, '');
		achievementsbotao.loadGraphic(Paths.image('mainmenu/setconquistas', 'preload'));
		achievementsbotao.alpha = 0.75;
		achievementsbotao.setGraphicSize(Std.int(achievementsbotao.width * 0.6));

		achievementsbotao.updateHitbox();

		achievementsbotao.x = FlxG.width;
		achievementsbotao.y = 15 + freeplaybotao.y + freeplaybotao.height;
		add(achievementsbotao);

		opcaobotao = new FlxButton(FlxG.width, 15 + achievementsbotao.y + achievementsbotao.height, '');
		opcaobotao.loadGraphic(Paths.image('mainmenu/setopcao', 'preload'));
		opcaobotao.setGraphicSize(Std.int(opcaobotao.width * 0.6));

		opcaobotao.updateHitbox();
		opcaobotao.x = FlxG.width;
		opcaobotao.y = 15 + achievementsbotao.y + achievementsbotao.height;
        opcaobotao.alpha = 0.75;
        add(opcaobotao);

		sobrebotao = new FlxButton(FlxG.width, 15 + opcaobotao.y + opcaobotao.height, '');
		sobrebotao.loadGraphic(Paths.image('mainmenu/setcreditos', 'preload')); //o 'preload' é apenas para não bugar após uma música.
		sobrebotao.setGraphicSize(Std.int(sobrebotao.width * 0.6));

		sobrebotao.updateHitbox();
		sobrebotao.x = FlxG.width;
		sobrebotao.y = 15 + opcaobotao.y + opcaobotao.height;
		sobrebotao.alpha = 0.75;
		add(sobrebotao);

		//haxe me obrigou a ser um cara organizado, mas ainda assim sou rebelde
		//musica de novela de 2010 starts playing

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
		FlxTween.tween(historiabotao, {x: FlxG.width - 2.5*historiabotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.6, function(tmr:FlxTimer) {
		FlxTween.tween(freeplaybotao, {x: FlxG.width - 2.5*freeplaybotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.9, function(tmr:FlxTimer) {
		FlxTween.tween(achievementsbotao, {x: FlxG.width - 2.5*achievementsbotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(1.2, function(tmr:FlxTimer) {
		FlxTween.tween(opcaobotao, {x: FlxG.width - 2.5*opcaobotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
		FlxTween.tween(sobrebotao, {x: FlxG.width - 2.5*sobrebotao.width + 696 + 90}, 1.5, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween) {
				clicavel = true; //Só pra garantir que a animação de entrada NÃO ocorra ao mesmo tempo que a de saida.
			}
		});
	});

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end



		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end



	var selectedSomethin:Bool = false;

	function sumidao(selecionado:Int){ //do hokage omegalul
		//provavelmente um dos códigos mais feios que já fiz, mas na real
		//não consigo pensar em outra forma de fazê-lo sem ter que reescrever tudo.

			if (selecionado == 0){
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
						FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
			} else if (selecionado == 1){
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
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if(selecionado == 2) {
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
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if (selecionado == 4) {
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
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(sobrebotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if (selecionado == 3){ //!!!
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
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			}
//manito do celta... Eu real preciso aprender a usar arrays e essas coisas...
			
	}

	override function update(elapsed:Float)
	{

		historiabotao.updateHitbox();
		freeplaybotao.updateHitbox();
		achievementsbotao.updateHitbox();
		opcaobotao.updateHitbox();
		sobrebotao.updateHitbox();

		checker.y += 0.1;

		if(historiabotao.justPressed && !checkiftouch && clicavel){
			curSelected = 0;
			if(curSelected == 0 && checkiftouch == false){checkiftouch = true;}
		}
		if(freeplaybotao.justPressed && !checkiftouch && clicavel){
			curSelected = 1;
			if(curSelected == 1 && checkiftouch == false){checkiftouch = true;}
		}
		if(achievementsbotao.justPressed && !checkiftouch && clicavel){
			curSelected = 2;		
			if(curSelected == 2 && checkiftouch == false && clicavel){checkiftouch = true;}
		}
		if(opcaobotao.justPressed && !checkiftouch){
			curSelected = 4;
			if(curSelected == 4 && checkiftouch == false && clicavel){checkiftouch = true;}
		}
		if(sobrebotao.justPressed && !checkiftouch){
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
									MusicBeatState.switchState(new StoryMenuState());
								case 'freeplay':
									MusicBeatState.switchState(new PreFreeplayState());
								case 'awards':
									MusicBeatState.switchState(new AchievementsMenuState());
								case 'credits':
								#if android
									MusicBeatState.switchState(new VideoState('assets/videos/aviso', new MainMenuStateMobile()));
									#else
									//Ai é contigo dav
									#end
								case 'options':
									MusicBeatState.switchState(new OptionsState());
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
}
