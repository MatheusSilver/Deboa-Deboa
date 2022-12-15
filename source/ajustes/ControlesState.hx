package ajustes;

import flixel.system.FlxSound;
import openfl.Lib;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
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
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class ControlesState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var clicavel:Bool = false;

	var tails:FlxSprite;
	var sonic1:FlxSprite;
	var boom:FlxSprite;
	var gameJoltBG:FlxSprite;

	var historiabotao:FlxButton;
	var freeplaybotao:FlxButton;
	var achievementsbotao:FlxButton;
	var opcaobotao:FlxButton;
	var letext:FlxText;
	var sobrebotao:FlxButton;
	var isCoolBeat:Bool=true;
	//var gradientBar:FlxGradient;
	
	var optionShit:Array<String> = ['mobile','keyboard'];

	var machine:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var logoBl:FlxSprite;
	var checkiftouch:Bool = false;
    var line:FlxSprite;
    var trees:FlxSprite;

	override function create()
	{
		Conductor.changeBPM(112);
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Configuração de Controles", null);
		//and dav says: EU ODEIO MEXER COM COORDENADAS
		#end


		Main.dumpCache(); // What can go wrong?
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

		//checker = new FlxBackdrop(Paths.image('soquadrados', 'preload'), 0.2, 0.2, true, true);
		
		//add(checker);
		//checker.alpha = 0.8;
		//checker.color = FlxColor.RED;
		//Isto é temporário, por algum motivo isso não tá compilando no github

		/*gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x41000000, 0x2C744100, 0x88A10000], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		gradientBar.scale.y = 0;
		gradientBar.updateHitbox();
		//add(gradientBar);*/


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

		tails = new FlxSprite(0, 0); //ok
		tails.frames = Paths.getSparrowAtlas('menus/tailsdoll_p2', 'preload');
		tails.animation.addByPrefix('idle2', "singRIGHT", 24);
		//tails.animation.play('idle2');
		tails.alpha = 0;
		tails.antialiasing = true;
		tails.setGraphicSize(Std.int(tails.width * 0.9));
		tails.updateHitbox();
		tails.x = 25 - 507 - 200 - 400 + 75 + 140;
		tails.y = 75 - 320 - 250 - 200 + 30;
		//add(tails);

		sonic1 = new FlxSprite(0, 0); //ok
		sonic1.frames = Paths.getSparrowAtlas('menus/YCR', 'preload');
		sonic1.animation.addByPrefix('idle1', "normal_down", 20);
		//sonic1.animation.play('idle1');
		sonic1.antialiasing = true;
		sonic1.setGraphicSize(Std.int(sonic1.width * 1.5));
		sonic1.updateHitbox();
		sonic1.y = 75 - 390 + 40;
		sonic1.x = 25 - 507 - 100;
		sonic1.alpha=0;
		//add(sonic1);

		boom = new FlxSprite(0, 0); //ok
		boom.frames = Paths.getSparrowAtlas('optionsmenu/sunkyajustes', 'preload');
		boom.animation.addByPrefix('idle', "sunkyajustes bump",30);
		//sonic1.animation.play('idle1');
		boom.antialiasing = true;
		boom.setGraphicSize(Std.int(boom.width*1.5));
		boom.updateHitbox();
		boom.y =-1000;
		boom.x = -1100;
		boom.alpha=1;
		add(boom);

        add(trees);

		historiabotao = new FlxButton(FlxG.width, 15 - 250 + 198 - 50, '');
		historiabotao.loadGraphic(Paths.image('optionsmenu/mobile', 'preload'));
		historiabotao.setGraphicSize(Std.int(historiabotao.width * 0.6));
		historiabotao.updateHitbox();
        historiabotao.alpha = 0.75;
		historiabotao.x = FlxG.width;
		historiabotao.y = 150;
        add(historiabotao);

		freeplaybotao = new FlxButton(FlxG.width, 15 + historiabotao.y + historiabotao.height - 367, '');
		freeplaybotao.loadGraphic(Paths.image('optionsmenu/keyboard', 'preload'));
		freeplaybotao.setGraphicSize(Std.int(freeplaybotao.width * 0.6));
		freeplaybotao.updateHitbox();
        freeplaybotao.alpha = 0.75;
		freeplaybotao.x = FlxG.width;
		freeplaybotao.y = 15 + historiabotao.y + historiabotao.height;
        add(freeplaybotao);

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

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
		FlxTween.tween(historiabotao, {x: FlxG.width - 2.5*historiabotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(0.6, function(tmr:FlxTimer) {
		FlxTween.tween(freeplaybotao, {x: FlxG.width - 2.5*freeplaybotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
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

			if (selecionado == 0){
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
			} else if (selecionado == 1){
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
			}
//manito do celta... Eu real preciso aprender a usar arrays e essas coisas...
			
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
		historiabotao.updateHitbox();
		freeplaybotao.updateHitbox();
		historiabotao.onOver.callback = historiaHover;
        historiabotao.onOut.callback = historiaOut;
		freeplaybotao.onOver.callback = freeplayHover;
        freeplaybotao.onOut.callback = freeplayOut;
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
		/*if(sobrebotao.justPressed && !checkiftouch){
			sobrebotao.alpha=1;
			curSelected = 3;
			if(curSelected == 3 && checkiftouch == false && clicavel){checkiftouch = true;}
			}*/

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
				MusicBeatState.switchState(new AjustesState());
			}

			if (controls.ACCEPT || checkiftouch)
			{
				#if debug
				FlxG.mouse.visible = false;
				#end 
					selectedSomethin = true;
					clicavel = false;
					FlxG.sound.play(Paths.sound('confirmMenu'));
							checkiftouch = false; //This should be enough
							var daChoice:String = optionShit[curSelected];
							sumidao(curSelected);
							new FlxTimer().start(1.7, function(tmr:FlxTimer) {
							switch (daChoice)
							{
								case 'mobile':
                                MusicBeatState.switchState(new CustomControlsState()); 
								case 'keyboard':
                                openSubState(new ajustes.KeysSubstate());  
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


					override function beatHit()
						{
							super.beatHit();
							if(isCoolBeat){boom.animation.play('idle', true);}
							isCoolBeat = !isCoolBeat;
							if(sonic1 != null)
								{
								sonic1.animation.play('idle1', true);
								}
							if(tails != null)
								{
									tails.animation.play('idle2', true);
								}
						}


