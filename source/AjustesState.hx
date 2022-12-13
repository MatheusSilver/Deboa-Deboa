package;

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

class AjustesState extends MusicBeatState
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
	
	var optionShit:Array<String> = ['configuracoes','controles', 'setatipos', 'gamejooj'];

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
		DiscordClient.changePresence("No menu principal", null);
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
		historiabotao.loadGraphic(Paths.image('optionsmenu/configuracoes', 'preload'));
		historiabotao.setGraphicSize(Std.int(historiabotao.width * 0.6));
		historiabotao.updateHitbox();

        historiabotao.alpha = 0.75;
		historiabotao.x = FlxG.width;
		historiabotao.y = 150;
        add(historiabotao);

		freeplaybotao = new FlxButton(FlxG.width, 15 + historiabotao.y + historiabotao.height - 367, '');
		freeplaybotao.loadGraphic(Paths.image('optionsmenu/controls', 'preload'));
		freeplaybotao.setGraphicSize(Std.int(freeplaybotao.width * 0.6));

		freeplaybotao.updateHitbox();
        freeplaybotao.alpha = 0.75;

		freeplaybotao.x = FlxG.width;
		freeplaybotao.y = 15 + historiabotao.y + historiabotao.height;

        add(freeplaybotao);


		achievementsbotao = new FlxButton(FlxG.width, 15 + freeplaybotao.y + freeplaybotao.height, '');
		achievementsbotao.loadGraphic(Paths.image('optionsmenu/setas', 'preload'));
		achievementsbotao.alpha = 0.75;
		achievementsbotao.setGraphicSize(Std.int(achievementsbotao.width * 0.6));

		achievementsbotao.updateHitbox();

		achievementsbotao.x = FlxG.width;
		achievementsbotao.y = 15 + freeplaybotao.y + freeplaybotao.height;
		add(achievementsbotao);

		opcaobotao = new FlxButton(FlxG.width, 15 + achievementsbotao.y + achievementsbotao.height, '');
		opcaobotao.loadGraphic(Paths.image('optionsmenu/gamejooj', 'preload'));
		opcaobotao.setGraphicSize(Std.int(opcaobotao.width * 0.6));

		opcaobotao.updateHitbox();
		opcaobotao.x = FlxG.width;
		opcaobotao.y = 15 + achievementsbotao.y + achievementsbotao.height;
        opcaobotao.alpha = 0.75;
        add(opcaobotao);

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
		new FlxTimer().start(0.9, function(tmr:FlxTimer) {
		FlxTween.tween(achievementsbotao, {x: FlxG.width - 2.5*achievementsbotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
		});
		new FlxTimer().start(1.2, function(tmr:FlxTimer) {
		FlxTween.tween(opcaobotao, {x: FlxG.width - 2.5*opcaobotao.width + 696 + 90}, 1.5, {ease: FlxEase.expoInOut});
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
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
						});
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
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
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if(selecionado == 2) {
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
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(opcaobotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if (selecionado == 4) {
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
				FlxTween.tween(freeplaybotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				FlxTween.tween(achievementsbotao, {x: FlxG.width}, 0.5, {ease: FlxEase.expoInOut});
				});
			} else if (selecionado == 3){ //!!!
				sobrebotao.alpha=1;
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			FlxTween.tween(sobrebotao, {x: FlxG.width - sobrebotao.width}, 0.5, {ease: FlxEase.expoInOut});
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
		achievementsbotao.updateHitbox();
		opcaobotao.updateHitbox();
		historiabotao.onOver.callback = historiaHover;
        historiabotao.onOut.callback = historiaOut;
		freeplaybotao.onOver.callback = freeplayHover;
        freeplaybotao.onOut.callback = freeplayOut;
		achievementsbotao.onOver.callback = achievementsHover;
        achievementsbotao.onOut.callback = achievementsOut;
		opcaobotao.onOver.callback = opcaoHover;
        opcaobotao.onOut.callback = opcaoOut;
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
			curSelected = 3;
			if(curSelected == 3 && checkiftouch == false && clicavel){checkiftouch = true;}
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
				MusicBeatState.switchState(new MainMenuStateMobile());
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
								case 'configuracoes':
                                    openSubState(new PreferencesSubstate1());
								case 'controles':
                                    #if desktop
                                        openSubState(new ControlsSubstate1());
                                    #end
                                    #if mobile
                                        MusicBeatState.switchState(new CustomControlsState())
                                    #end
								case 'setatipos':
                                    openSubState(new NotesSubstate1());
								case 'gamejooj':
                                    if(GJClient.logged)
                                        {
                                            MusicBeatState.switchState(new AlreadyLogged());
                                        }
                                        else{
                                            MusicBeatState.switchState(new GameJoltLoginState());
                                        }
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
}

class NotesSubstate1 extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	private static var typeSelected:Int = 0;
	private var grpNumbers:FlxTypedGroup<Alphabet>;
	private var grpNotes:FlxTypedGroup<FlxSprite>;
	private var shaderArray:Array<ColorSwap> = [];
	var curValue:Float = 0;
	var holdTime:Float = 0;
	var hsvText:Alphabet;
	var nextAccept:Int = 5;

	var posX = 250;
	public function new() {
		super();

		grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
		grpNumbers = new FlxTypedGroup<Alphabet>();
		add(grpNumbers);

		for (i in 0...ClientPrefs.arrowHSV.length) {
			var yPos:Float = (165 * i) + 35;
			for (j in 0...3) {
				var optionText:Alphabet = new Alphabet(0, yPos, Std.string(ClientPrefs.arrowHSV[i][j]));
				optionText.x = posX + (225 * j) + 100 - ((optionText.lettersArray.length * 90) / 2);
				grpNumbers.add(optionText);
			}

			var note:FlxSprite = new FlxSprite(posX - 70, yPos);
			note.frames = Paths.getSparrowAtlas('NOTE_assets');
			switch(i) {
				case 0:
					note.animation.addByPrefix('idle', 'purple0');
				case 1:
					note.animation.addByPrefix('idle', 'blue0');
				case 2:
					note.animation.addByPrefix('idle', 'green0');
				case 3:
					note.animation.addByPrefix('idle', 'red0');
			}
			note.animation.play('idle');
			note.antialiasing = ClientPrefs.globalAntialiasing;
			grpNotes.add(note);

			var newShader:ColorSwap = new ColorSwap();
			note.shader = newShader.shader;
			newShader.hue = ClientPrefs.arrowHSV[i][0] / 360;
			newShader.saturation = ClientPrefs.arrowHSV[i][1] / 100;
			newShader.brightness = ClientPrefs.arrowHSV[i][2] / 100;
			shaderArray.push(newShader);
		}
		hsvText = new Alphabet(0, 0, "Hue    Saturation  Brightness", false, false, 0, 0.65);
		add(hsvText);
		#if mobileC
        addVirtualPad(FULL, A_B);
        #end

		changeSelection();
	}

	var changingNote:Bool = false;
	var hsvTextOffsets:Array<Float> = [240, 90];
	override function update(elapsed:Float) {
		if(changingNote) {
			if(holdTime < 0.5) {
				if(controls.UI_LEFT_P) {
					updateValue(-1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.UI_RIGHT_P) {
					updateValue(1);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				} else if(controls.RESET) {
					resetValue(curSelected, typeSelected);
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					holdTime = 0;
				} else if(controls.UI_LEFT || controls.UI_RIGHT) {
					holdTime += elapsed;
				}
			} else {
				var add:Float = 90;
				switch(typeSelected) {
					case 1 | 2: add = 50;
				}
				if(controls.UI_LEFT) {
					updateValue(elapsed * -add);
				} else if(controls.UI_RIGHT) {
					updateValue(elapsed * add);
				}
				if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					holdTime = 0;
				}
			}
		} else {
			if (controls.UI_UP_P) {
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_LEFT_P) {
				changeType(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.UI_RIGHT_P) {
				changeType(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if(controls.RESET) {
				for (i in 0...3) {
					resetValue(curSelected, i);
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if (controls.ACCEPT && nextAccept <= 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changingNote = true;
				holdTime = 0;
				for (i in 0...grpNumbers.length) {
					var item = grpNumbers.members[i];
					item.alpha = 0;
					if ((curSelected * 3) + typeSelected == i) {
						item.alpha = 1;
					}
				}
				for (i in 0...grpNotes.length) {
					var item = grpNotes.members[i];
					item.alpha = 0;
					if (curSelected == i) {
						item.alpha = 1;
					}
				}
				super.update(elapsed);
				return;
			}
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			var intendedPos:Float = posX - 70;
			if (curSelected == i) {
				item.x = FlxMath.lerp(item.x, intendedPos + 100, lerpVal);
			} else {
				item.x = FlxMath.lerp(item.x, intendedPos, lerpVal);
			}
			for (j in 0...3) {
				var item2 = grpNumbers.members[(i * 3) + j];
				item2.x = item.x + 265 + (225 * (j % 3)) - (30 * item2.lettersArray.length) / 2;
				if(ClientPrefs.arrowHSV[i][j] < 0) {
					item2.x -= 20;
				}
			}

			if(curSelected == i) {
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}

		if (controls.BACK || (changingNote && controls.ACCEPT)) {
			#if mobile
			remove(_virtualpad);
			#end
			changeSelection();
			if(!changingNote) {
				grpNumbers.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				grpNotes.forEachAlive(function(spr:FlxSprite) {
					spr.alpha = 0;
				});
				close();
			}
			changingNote = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = ClientPrefs.arrowHSV.length-1;
		if (curSelected >= ClientPrefs.arrowHSV.length)
			curSelected = 0;

		curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(1, 1);
			if (curSelected == i) {
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeType(change:Int = 0) {
		typeSelected += change;
		if (typeSelected < 0)
			typeSelected = 2;
		if (typeSelected > 2)
			typeSelected = 0;

		curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
	}

	function resetValue(selected:Int, type:Int) {
		curValue = 0;
		ClientPrefs.arrowHSV[selected][type] = 0;
		switch(type) {
			case 0: shaderArray[selected].hue = 0;
			case 1: shaderArray[selected].saturation = 0;
			case 2: shaderArray[selected].brightness = 0;
		}
		grpNumbers.members[(selected * 3) + type].changeText('0');
	}
	function updateValue(change:Float = 0) {
		curValue += change;
		var roundedValue:Int = Math.round(curValue);
		var max:Float = 180;
		switch(typeSelected) {
			case 1 | 2: max = 100;
		}

		if(roundedValue < -max) {
			curValue = -max;
		} else if(roundedValue > max) {
			curValue = max;
		}
		roundedValue = Math.round(curValue);
		ClientPrefs.arrowHSV[curSelected][typeSelected] = roundedValue;

		switch(typeSelected) {
			case 0: shaderArray[curSelected].hue = roundedValue / 360;
			case 1: shaderArray[curSelected].saturation = roundedValue / 100;
			case 2: shaderArray[curSelected].brightness = roundedValue / 100;
		}
		grpNumbers.members[(curSelected * 3) + typeSelected].changeText(Std.string(roundedValue));
	}
}



class ControlsSubstate1 extends MusicBeatSubstate {
	private static var curSelected:Int = -1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = 'Reset to Default Keys';
	private var bindLength:Int = 0;

	var optionShit:Array<Dynamic> = [
		['NOTES'],
		['Left', 'note_left'],
		['Down', 'note_down'],
		['Up', 'note_up'],
		['Right', 'note_right'],
		[''],
		['UI'],
		['Left', 'ui_left'],
		['Down', 'ui_down'],
		['Up', 'ui_up'],
		['Right', 'ui_right'],
		[''],
		['Reset', 'reset'],
		['Accept', 'accept'],
		['Back', 'back'],
		['Pause', 'pause'],
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedText> = [];
	private var grpInputsAlt:Array<AttachedText> = [];
	private var controlMap:Map<String, Dynamic>;
	var rebindingKey:Bool = false;
	var nextAccept:Int = 5;

	public function new() {
		super();
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		controlMap = ClientPrefs.keyBinds.copy();
		optionShit.push(['']);
		optionShit.push([defaultKey]);

		for (i in 0...optionShit.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i][0] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:Alphabet = new Alphabet(0, (10 * i), optionShit[i][0], (!isCentered || isDefaultKey), false);
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText, i);
				bindLength++;
				if(curSelected < 0) curSelected = i;
			}
		}
		changeSelection();
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		if(!rebindingKey) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK) {
				ClientPrefs.keyBinds = controlMap.copy();
				ClientPrefs.reloadControls();
				grpOptions.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if(controls.ACCEPT && nextAccept <= 0) {
				if(optionShit[curSelected][0] == defaultKey) {
					controlMap = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				} else if(!unselectableCheck(curSelected)) {
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt) {
						grpInputsAlt[getInputTextNum()].alpha = 0;
					} else {
						grpInputs[getInputTextNum()].alpha = 0;
					}
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
		} else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				var keysArray:Array<FlxKey> = controlMap.get(optionShit[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if(keysArray[opposite] == keysArray[1 - opposite]) {
					keysArray[opposite] = NONE;
				}
				controlMap.set(optionShit[curSelected][1], keysArray);

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = false;
			}

			bindingTime += elapsed;
			if(bindingTime > 5) {
				if (curAlt) {
					grpInputsAlt[curSelected].alpha = 1;
				} else {
					grpInputs[curSelected].alpha = 1;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function getInputTextNum() {
		var num:Int = 0;
		for (i in 0...curSelected) {
			if(optionShit[i].length > 1) {
				num++;
			}
		}
		return num;
	}
	
	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
								break;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
								break;
							}
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.6;
				if(!curAlt) {
					grpInputs[i].alpha = 1;
				}
				break;
			}
		}
		for (i in 0...grpInputsAlt.length) {
			if(grpInputsAlt[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputsAlt[i].alpha = 0.6;
				if(curAlt) {
					grpInputsAlt[i].alpha = 1;
				}
				break;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optionShit[num][0] == defaultKey) {
			return checkDefaultKey;
		}
		return optionShit[num].length < 2 && optionShit[num][0] != defaultKey;
	}

	private function addBindTexts(optionText:Alphabet, num:Int) {
		var keys:Array<Dynamic> = controlMap.get(optionShit[num][1]);
		var text1 = new AttachedText(InputFormatter.getKeyName(keys[0]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedText(InputFormatter.getKeyName(keys[1]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedText = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while(grpInputsAlt.length > 0) {
			var item:AttachedText = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i], i);
			}
		}


		var bullShit:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
							}
						}
					}
				}
			}
		}
	}
}



class PreferencesSubstate1 extends MusicBeatSubstate
{
	private static var curSelected:Int = 0;
	static var unselectableOptions:Array<String> = [
		'GRAPHICS',
		'GAMEPLAY'
	];
	static var noCheckbox:Array<String> = [
		'Framerate',
		'Note Delay',
		'Volume do Hitsound'
	];

	static var options:Array<String> = [
		'GRAPHICS',
		'Low Quality',
		#if windows
		'Shaders', //Infelizmente, shaders não funcionam no android. (Na verdade funcionam sim, mas é muito dificil de portar. É um conhecimento escasso. Somente os porters mais antigos sabem como deixar eles funcionais.)
		#end
		'Anti-Aliasing',
		'Persistent Cached Data',
		#if !html5
		'Framerate', //Apparently 120FPS isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		#end
		'GAMEPLAY',
		'Antimash',
		'Downscroll',
		'Middlescroll',
		'Ghost Tapping',
		'Note Delay',
		'Note Splashes',
		'Hide HUD',
		'Hide Song Length',
		'Hitsounds',
		'Volume do Hitsound',
		'Flashing Lights',
		'Legendas',
		'Camera Zooms',
		'Contadores (FPS, Mem.)'
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxArray:Array<CheckboxThingie> = [];
	private var checkboxNumber:Array<Int> = [];
	private var grpTexts:FlxTypedGroup<AttachedText>;
	private var textNumber:Array<Int> = [];

	private var showCharacter:Character = null;
	private var descText:FlxText;

	public function new()
	{
		super();
		// avoids lagspikes while scrolling through menus!
		showCharacter = new Character(840, 170, 'bf', true);
		showCharacter.setGraphicSize(Std.int(showCharacter.width * 0.8));
		showCharacter.updateHitbox();
		showCharacter.dance();
		add(showCharacter);
		showCharacter.visible = false;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var isCentered:Bool = unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, options[i], false, false);
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
			} else {
				optionText.x += 300;
				optionText.forceX = 300;
			}
			optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				var useCheckbox:Bool = true;
				for (j in 0...noCheckbox.length) {
					if(options[i] == noCheckbox[j]) {
						useCheckbox = false;
						break;
					}
				}

				if(useCheckbox) {
					var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, false);
					checkbox.sprTracker = optionText;
					checkboxArray.push(checkbox);
					checkboxNumber.push(i);
					add(checkbox);
				} else {
					var valueText:AttachedText = new AttachedText('0', optionText.width + 80);
					valueText.sprTracker = optionText;
					grpTexts.add(valueText);
					textNumber.push(i);
				}
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		for (i in 0...options.length) {
			if(!unselectableCheck(i)) {
				curSelected = i;
				break;
			}
		}
		changeSelection();
		#if mobileC
		addVirtualPad(FULL, A_B);
		#end
		reloadValues();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {			
			#if mobile 
			remove(_virtualpad); 
			#end

			grpOptions.forEachAlive(function(spr:Alphabet) {
				spr.alpha = 0;
			});
			grpTexts.forEachAlive(function(spr:AttachedText) {
				spr.alpha = 0;
			});
			for (i in 0...checkboxArray.length) {
				var spr:CheckboxThingie = checkboxArray[i];
				if(spr != null) {
					spr.alpha = 0;
				}
			}
			if(showCharacter != null) {
				showCharacter.alpha = 0;
			}
			descText.alpha = 0;
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		var usesCheckbox = true;
		for (i in 0...noCheckbox.length) {
			if(options[curSelected] == noCheckbox[i]) {
				usesCheckbox = false;
				break;
			}
		}

		if(usesCheckbox) {
			if(controls.ACCEPT && nextAccept <= 0) {
				switch(options[curSelected]) {
					case 'Contadores (FPS, Mem.)':
						ClientPrefs.showFPS = !ClientPrefs.showFPS;
						if(Main.fpsVar != null)
							Main.fpsVar.visible = ClientPrefs.showFPS;
							Main.memoryCounter.visible = ClientPrefs.showFPS;

					case 'Low Quality':
						ClientPrefs.lowQuality = !ClientPrefs.lowQuality;
					
					case 'Shaders':
						ClientPrefs.shaders = !ClientPrefs.shaders;

					case 'Anti-Aliasing':
						ClientPrefs.globalAntialiasing = !ClientPrefs.globalAntialiasing;
						showCharacter.antialiasing = ClientPrefs.globalAntialiasing;
						for (item in grpOptions) {
							item.antialiasing = ClientPrefs.globalAntialiasing;
						}
						for (i in 0...checkboxArray.length) {
							var spr:CheckboxThingie = checkboxArray[i];
							if(spr != null) {
								spr.antialiasing = ClientPrefs.globalAntialiasing;
							}
						}
						//OptionsState.menuBG.antialiasing = ClientPrefs.globalAntialiasing;

					case 'Antimash':
						ClientPrefs.resolution = !ClientPrefs.resolution;

					case 'Note Splashes':
						ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;

					case 'Flashing Lights':
						ClientPrefs.flashing = !ClientPrefs.flashing;

					case 'Hitsounds':
						ClientPrefs.hitSounds = !ClientPrefs.hitSounds;
					
					case 'Legendas':
						ClientPrefs.legendas = !ClientPrefs.legendas;	

					case 'Violence':
						ClientPrefs.violence = !ClientPrefs.violence;

					case 'Swearing':
						ClientPrefs.cursing = !ClientPrefs.cursing;

					case 'Downscroll':
						ClientPrefs.downScroll = !ClientPrefs.downScroll;

					case 'Middlescroll':
						ClientPrefs.middleScroll = !ClientPrefs.middleScroll;

					case 'Ghost Tapping':
						ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;

					case 'Camera Zooms':
						ClientPrefs.camZooms = !ClientPrefs.camZooms;

					case 'Hide HUD':
						ClientPrefs.hideHud = !ClientPrefs.hideHud;

					case 'Persistent Cached Data':
						ClientPrefs.imagesPersist = !ClientPrefs.imagesPersist;
						FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
					
					case 'Hide Song Length':
						ClientPrefs.hideTime = !ClientPrefs.hideTime;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				reloadValues();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var add:Int = controls.UI_LEFT ? -1 : 1;
				var addo:Float = controls.UI_LEFT ? -0.1 : 0.1;
				if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
				switch(options[curSelected]) {
					case 'Framerate':
						ClientPrefs.framerate += add;
						if(ClientPrefs.framerate < 60) ClientPrefs.framerate = 60;
						else if(ClientPrefs.framerate > 240) ClientPrefs.framerate = 240;

						if(ClientPrefs.framerate > FlxG.drawFramerate) {
							FlxG.updateFramerate = ClientPrefs.framerate;
							FlxG.drawFramerate = ClientPrefs.framerate;
						} else {
							FlxG.drawFramerate = ClientPrefs.framerate;
							FlxG.updateFramerate = ClientPrefs.framerate;
						}
					case 'Note Delay':
						var mult:Int = 1;
						if(holdTime > 1.5) { //Double speed after 1.5 seconds holding
							mult = 2;
						}
						ClientPrefs.noteOffset += add * mult;
						if(ClientPrefs.noteOffset < 0) ClientPrefs.noteOffset = 0;
						else if(ClientPrefs.noteOffset > 500) ClientPrefs.noteOffset = 500;
					case 'Volume do Hitsound':
						ClientPrefs.osusom += addo;
						if(ClientPrefs.violence) {
						var hitsound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('hitsound'));
						hitsound.volume = ClientPrefs.osusom;
						hitsound.play();
						}
						if(ClientPrefs.osusom < 0.1) ClientPrefs.osusom = 0.1;
						else if(ClientPrefs.osusom > 1.0) ClientPrefs.osusom = 1.0; 
				}
				reloadValues();

				if(holdTime <= 0) FlxG.sound.play(Paths.sound('scrollMenu'));
				holdTime += elapsed;
			} else {
				holdTime = 0;
			}
		}

		if(showCharacter != null && showCharacter.animation.curAnim.finished) {
			showCharacter.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}
	
	function changeSelection(change:Int = 0)
	{
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = options.length - 1;
			if (curSelected >= options.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var daText:String = '';
		switch(options[curSelected]) {
			case 'Antimash':
				daText = "Caso tu for muito nutella mesmo,\naquele cara que spamma pq\nnão sabe jogar, ative isso.";
			case 'Framerate':
				daText = "Determina o entre áspas limite do seu FPS.";
			case 'Note Delay':
				daText = "Troca o quão cedo uma nota aparece.\n(feitos para fones com delay.)";
			case 'Contadores (FPS, Mem.)':
				daText = "Se desmarcado, desativa os contadores do jogo,\ntais como o contador de FPS e de memória.";
			case 'Shaders':
				daText = "Permite o uso de efeitos especiais de tela no jogo.\n(Desmarcar aumenta a performance.)";
			case 'Low Quality':
				daText = "Se desmarcado, retira elementos do cenário.\n(Aumenta performance e diminui tempos de loading.)";
			case 'Persistent Cached Data':
				daText = "Se marcado, imagens serão salvas na memória do seu dispositivo.\n(Aumenta uso de memória ram.)";
			case 'Anti-Aliasing':
				daText = "Se marcado, desativa o AntiAliasing do jogo, deixando sprites com menos polimento.\n(Aumenta MUITA performance)";
			case 'Downscroll':
				daText = "Se marcado, as notas ficaram estilo Guitar Hero.\n(Iram pra baixo)";
			case 'Hitsounds':
				daText = "Um som é tocado quando você acerta uma nota.";
			case 'Volume do Hitsound':
				daText = "Altere aqui o volume do som da Hitsound.\n(Esquerda para abaixar, direita para aumentar.)";
			case 'Middlescroll':
				daText = "Se marcado, a nota do oponente irá sumir e a sua ficará no meio.";
			case 'Ghost Tapping':
				daText = "Se marcado, você não errará por apertar teclas aleatóriamente.\n(Não funciona caso errar uma nota da música.)";
			case 'Swearing':
				daText = "If unchecked, your mom won't be angry at you.";
			case 'Violence':
				daText = "Se desmarcado, você não verá gore, sangue, visceras, coisas ruins.\n(Desativa isso caso for sensível demais.\nP.S: Principalmente pro mod do EXE.)";
			case 'Note Splashes':
				daText = "Se desmarcado, quando acertar uma nota Sick!, as notas irão soltar uma animaçãozinha.\n(Caso estiver travando, desative isso também.)";
			case 'Flashing Lights':
				daText = "Desmarque caso for sensível com tela tremendo, luzes piscantes e etc...\n(Todos mods de agora tem isso.)";
			case 'Legendas':
				daText = "Se ativado, você irá ver as legendas nas músicas.";	
			case 'Camera Zooms':
				daText = "Se desmarcado, a tela não irá dar zoom quando acertar uma nota.";
			case 'Hide HUD':
				daText = "Se marcado, tira muitas coisas da tela.";
			case 'Hide Song Length':
				daText = "Se marcado, a barrinha com o tempo da música, sumirá.";
		}
		descText.text = daText;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}

				for (j in 0...checkboxArray.length) {
					var tracker:FlxSprite = checkboxArray[j].sprTracker;
					if(tracker == item) {
						checkboxArray[j].alpha = item.alpha;
						break;
					}
				}
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				text.alpha = 0.6;
				if(textNumber[i] == curSelected) {
					text.alpha = 1;
				}
			}
		}

		showCharacter.visible = (options[curSelected] == 'Anti-Aliasing');
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function reloadValues() {
		for (i in 0...checkboxArray.length) {
			var checkbox:CheckboxThingie = checkboxArray[i];
			if(checkbox != null) {
				var daValue:Bool = false;
				switch(options[checkboxNumber[i]]) {
					case 'Contadores (FPS, Mem.)':
						daValue = ClientPrefs.showFPS;
					case 'Shaders':
						daValue = ClientPrefs.shaders;
					case 'Low Quality':
						daValue = ClientPrefs.lowQuality;
					case 'Anti-Aliasing':
						daValue = ClientPrefs.globalAntialiasing;
					case 'Note Splashes':
						daValue = ClientPrefs.noteSplashes;
					case 'Flashing Lights':
						daValue = ClientPrefs.flashing;
					case 'Legendas':
						daValue = ClientPrefs.legendas;
					case 'Downscroll':
						daValue = ClientPrefs.downScroll;
					case 'Middlescroll':
						daValue = ClientPrefs.middleScroll;
					case 'Ghost Tapping':
						daValue = ClientPrefs.ghostTapping;
					case 'Swearing':
						daValue = ClientPrefs.cursing;
					case 'Hitsounds':
						daValue = ClientPrefs.hitSounds;
					case 'Violence':
						daValue = ClientPrefs.violence;
					case 'Camera Zooms':
						daValue = ClientPrefs.camZooms;
					case 'Hide HUD':
						daValue = ClientPrefs.hideHud;
					case 'Persistent Cached Data':
						daValue = ClientPrefs.imagesPersist;
					case 'Hide Song Length':
						daValue = ClientPrefs.hideTime;
				}
				checkbox.daValue = daValue;
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				var daText:String = '';
				switch(options[textNumber[i]]) {
					case 'Framerate':
						daText = '' + ClientPrefs.framerate;
					case 'Note Delay':
						daText = ClientPrefs.noteOffset + 'ms';
					case 'Volume do Hitsound':
						daText = ClientPrefs.osusom + '';
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
		}
	}

	private function unselectableCheck(num:Int):Bool {
		for (i in 0...unselectableOptions.length) {
			if(options[num] == unselectableOptions[i]) {
				return true;
			}
		}
		return options[num] == null || options[num].length < 1;
	}
}
