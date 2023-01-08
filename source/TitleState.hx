package;

import flixel.util.FlxGradient;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
//import GameJolt;
//import GameJolt.GameJoltAPI;
#end
import gamejolt.formats.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flash.display.Sprite;
import FunkinLua;
import Shaders;
import openfl.filters.ShaderFilter;
import haxe.io.Bytes;
import HSys;

using StringTools;

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 1, 0xFFFF0000);
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var easterEggEnabled:Bool = true; //Disable this to hide the easter egg
	var easterEggKeyCombination:Array<FlxKey> = [FlxKey.B, FlxKey.B]; //bb stands for bbpanzu cuz he wanted this lmao
	var lastKeysPressed:Array<FlxKey> = [];

	var mustUpdate:Bool = false;
	public static var updateVersion:String = '';

	override public function create():Void
	{
		GJClient.initialize();
		//FlxG.switchState(new GameJoltLogin());
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
		//FunkinLua.addShaderToCamera('orig', new BloomEffect(0.05/512.0,0.05));
		//FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));
		#if (polymod && !android)
		if (HSys.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in HSys.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.HSys.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end
		
		#if CHECK_FOR_UPDATES
		if(!closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");
			
			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuStateMobile.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}
			
			http.onError = function (error) {
				trace('error: $error');
			}
			
			http.request();
		}
		#end

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('modboa' #if (flixel < "5.0.0"), 'galaccine' #end);
		ClientPrefs.loadPrefs();
		/*PlayState.addShaderToCamera('game', new VCRDistortionEffect(0.5,true,false,true));
		PlayState.addShaderToCamera('hud', new VCRDistortionEffect(0.5,true,false,true));*/
		Highscore.load();

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		#if desktop
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
		#end
		if (ClientPrefs.pibby){
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new PibbyTela());
		}else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		
		#end

		#if desktop
		//GameJoltAPI.connect();
		//GameJoltAPI.authDaUser(FlxG.save.data.gjUser, FlxG.save.data.gjToken);
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Na tela de titulo", null);
		#end
	}

	var logoBl:FlxSprite;
	var logoBl1:FlxSprite;
	//var menuGif:FlxSprite;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;
	var opacidade:Float = 0;
	var opacidadesuporte:Int = -1;
	var candothething:Bool = false;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('newmenu'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}
	
		//GJClient.setUserInfo(FlxG.save.data.user, FlxG.save.data.token);
		//GJClient.setUserInfo(FlxG.save.data.user, FlxG.save.data.token);
		//GJClient.initialize();

		Conductor.changeBPM(112);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(FlxG.width);
		bg.updateHitbox();
		bg.screenCenter(XY);
		add(bg);

		var supbg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('BGPrincipal'));
		supbg.antialiasing = ClientPrefs.globalAntialiasing;
		supbg.setGraphicSize(Std.int(supbg.width * 0.60));
		supbg.updateHitbox();
		supbg.alpha = 1;
		
		logoBl = new FlxSprite(-150, -400).loadGraphic(Paths.image('LogoModBoaEXE'));

		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.updateHitbox();
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.5));
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		var logoBl2:FlxSprite;
		logoBl2 = new FlxSprite(0, 0);
		logoBl2.frames = Paths.getSparrowAtlas('effects/estatica');
		logoBl2.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl2.scale.set(5, 1.95);
		logoBl2.animation.addByPrefix('muitomedo', 'TitleMenuSSBG instance 1', 24);
		logoBl2.animation.play('muitomedo');
		logoBl2.updateHitbox();

		var logoBl3:FlxSprite;
		logoBl3 = new FlxSprite(0, 0);
		logoBl3.frames = Paths.getSparrowAtlas('effects/Phase3Static');
		logoBl3.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl3.setGraphicSize(Std.int(logoBl3.width * 5));
		logoBl3.alpha = 0.5;
		logoBl3.color = FlxColor.RED;
		logoBl3.animation.addByPrefix('muitomuitomedo', 'Phase3Static instance 1', 48);
		logoBl3.animation.play('muitomuitomedo');
		logoBl3.updateHitbox();

		

		logoBl1 = new FlxSprite(150 - 140, 60 - 491 + 434 - 10);
		logoBl1.frames = Paths.getSparrowAtlas('vioDanceTitle');
		logoBl1.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl1.setGraphicSize(Std.int(logoBl1.width * 1.35));
		logoBl1.animation.addByPrefix('bump', 'MODBOA inicio', 24);
		//logoBl1.animation.play('bump');
		logoBl1.updateHitbox();

		/*
		menuGif = new FlxSprite(0, 0).loadGraphic(Paths.image('funMenu.gif'));
		menuGif.scale.set(1, 1);
		menuGif.antialiasing = ClientPrefs.globalAntialiasing;
		menuGif.updateHitbox();
		*/


		swagShader = new ColorSwap();
		//add(menuGif);
		add(logoBl2);
		add(supbg);
		add(logoBl3);
		add(logoBl1);

		add(logoBl);
		candothething = true;
	//	logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(-80, 600).loadGraphic(Paths.image('titleEnter'));
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.setGraphicSize(Std.int(titleText.width * 1.1));
		//titleText.y=550;
		titleText.updateHitbox();
		titleText.screenCenter(X);
		
		add(titleText);
		

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackScreen.setGraphicSize(FlxG.width);
		credGroup.add(blackScreen);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00060A4D, 0xAAFF0000], 2, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		gradientBar.scale.y = 0;
		gradientBar.updateHitbox();
		add(gradientBar);
		FlxTween.tween(gradientBar, {'scale.y': 1.3}, 8, {ease: FlxEase.quadInOut}); // long gradient tween

		credTextShit = new Alphabet(0, 0, "", true, false, 0.075, 1, 'alfabetovio');
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{

		if(candothething == true){

			if (opacidade > 1)
				opacidadesuporte = -1;
			else if (opacidade < 0)
				opacidadesuporte = 1; //Yeah yeah químico das matemática muito loka
	
			titleText.alpha = opacidade;
		}
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		/*
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		*/

		gradientBar.updateHitbox();
		gradientBar.y = FlxG.height - gradientBar.height;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		// EASTER EGG

		if (!transitioning && skippedIntro)
		{
			if(pressedEnter)
			{

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate) {
						MusicBeatState.switchState(new OutdatedState());
					} else {
						if(ClientPrefs.firstTime)
							{
								MusicBeatState.switchState(new PreMainMenuState());
							}
							else
								{
									MusicBeatState.switchState(new MainMenuStateMobile()); //lembrar de colocar o menu dps
								}
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			else if(easterEggEnabled)
			{
				var finalKey:FlxKey = FlxG.keys.firstJustPressed();
				if(finalKey != FlxKey.NONE) {
					lastKeysPressed.push(finalKey); //Convert int to FlxKey
					if(lastKeysPressed.length > easterEggKeyCombination.length)
					{
						lastKeysPressed.shift();
					}
					
					if(lastKeysPressed.length == easterEggKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length) {
							if(lastKeysPressed[i] != easterEggKeyCombination[i]) {
								isDifferent = true;
								break;
							}
						}

						if(!isDifferent) {
							trace('Easter egg triggered!');
							FlxG.save.data.psykaEasterEgg = !FlxG.save.data.psykaEasterEgg;
							FlxG.sound.play(Paths.sound('secretSound'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {onComplete:
								function(twn:FlxTween) {
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							lastKeysPressed = [];
							closedState = true;
							transitioning = true;
						}
					}
				}
			}
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		} 

		opacidade += 0.01 * opacidadesuporte;

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false, 0.5, 1, 'alfabetovio');
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false, 0.5, 1, 'alfabetovio');
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0;
	private static var closedState:Bool = false;
	override function beatHit()
	{
		if(logoBl1 != null){
			logoBl1.animation.play('bump', true);}
		super.beatHit();

		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					GJClient.initialize();
					createCoolText(['Psych Engine por'], 45);
				case 3:
					addMoreText('Shadow Mario', 45);
					addMoreText('RiverOaken', 45);
				case 4:
					deleteCoolText();
				case 5:
					createCoolText(['ok ok'], -60);
				case 7:
					addMoreText('Só a galáxia é o limite!', -60);
				case 8:
					deleteCoolText();
				case 9:
					createCoolText([curWacky[0]]);
				case 11:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
				case 13:
					
				case 14:
					//addMoreText('FNF');
				case 15:
					//addMoreText('ModBoa');
					skipIntro();
				case 16:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			remove(gradientBar);
			skippedIntro = true;

			FlxTween.tween(logoBl, {y: -100}, 1.4, {ease: FlxEase.expoInOut});

			logoBl.angle = -7;

			new FlxTimer().start(0.005, function(tmr:FlxTimer)
			{
				if (logoBl.angle == -7)
					FlxTween.angle(logoBl, logoBl.angle, 7, 3, {ease: FlxEase.quartInOut});
				if (logoBl.angle == 7)
					FlxTween.angle(logoBl, logoBl.angle, -7, 3, {ease: FlxEase.quartInOut});
			}, 0);
			
		}
	}


}