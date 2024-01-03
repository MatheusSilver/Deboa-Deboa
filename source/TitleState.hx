package;

import modifiers.ModifiersManager;
import FunkinLua;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import gamejolt.formats.*;
import haxe.io.Bytes;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.filters.ShaderFilter;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
#if desktop
import sys.thread.Thread;
#end

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 1, 0xFFFF0000);
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var easterEggEnabled:Bool = false; // Disable this to hide the easter egg
	var easterEggKeyCombination:Array<FlxKey> = [FlxKey.V, FlxKey.I, FlxKey.O]; // bb stands for bbpanzu cuz he wanted this lmao
	var lastKeysPressed:Array<FlxKey> = [];
	private var urlLoader:URLLoader;

	var canSkipIntro:Bool = false;

	var mustUpdate:Bool = false;

	public static var instance:TitleState;

	public static var updateVersion:String = '';

	public static var ModoOffline:Bool = false;

	override public function create():Void
	{
		if(instance == null)
		{
			instance=this;
		}
		FlxTransitionableState.skipNextTransOut = true;
		MainMenuStateMobile.newVersion = FlxG.save.data.gameVersion != MainMenuStateMobile.version && FlxG.save.data.gameVersion != null;
		if (FlxG.save.data.progress != null)
		{
			MenuPreHistoria.curSave = FlxG.save.data.progress;
			if (GJClient.logged)
			{
				GameJoltLoginState.syncProgress();
			}
		}
		else
		{
			FlxG.save.data.progress = "1,0,0,0,0,0,0,0,0";
			MenuPreHistoria.curSave = FlxG.save.data.progress;
			if (GJClient.logged)
			{
				GameJoltLoginState.syncProgress();
			}
		}
		if (!initialized)
		{
			verificarConexao();
		}
		// FlxG.switchState(new GameJoltLogin());
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
		// FunkinLua.addShaderToCamera('orig', new BloomEffect(0.05/512.0,0.05));
		// FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));

		#if CHECK_FOR_UPDATES
		if (!closedState)
		{
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function(data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuStateMobile.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if (updateVersion != curVersion)
				{
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function(error)
			{
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

		FlxG.save.bind('modboa', CoolUtil.getSavePath());
		ClientPrefs.init();
		ClientPrefs.carregarControles();
		/*PlayState.addShaderToCamera('game', new VCRDistortionEffect(0.5,true,false,true));
			PlayState.addShaderToCamera('hud', new VCRDistortionEffect(0.5,true,false,true)); */
		Highscore.load();

		#if !mobile
		FlxG.mouse.visible = false;
		#end
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if (ClientPrefs.pibby)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new PibbyTela());
		}
		else if (FlxG.save.data.flashing == null && !FlashingState.leftState)
		{ // Só por colocar de volta mesmo
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		else if (!PreTitleState.jarodou)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new PreTitleState()); // Não atrapalha no PC, e Resolve o problema do mobile, todos ganham k
			ModifiersManager.loadSave();
		}
		else
		{
			if (initialized)
			{
				startIntro();
				canSkipIntro=true;
			}
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
					canSkipIntro=true;
				});
			}
		}
		#end

		#if desktop
		// GameJoltAPI.connect();
		// GameJoltAPI.authDaUser(FlxG.save.data.gjUser, FlxG.save.data.gjToken);
		// Updating Discord Rich Presence
		#end
	}
	public static var canVerify:Bool = true;
	public function verificarConexao():Void
		{
			if(!canVerify)
				return;
			canVerify=false;
			new FlxTimer().start(30, function(tmr:FlxTimer){
				canVerify=true;
			});
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
	
			var request = new URLRequest("https://gamejolt.com");
			urlLoader.load(request);
		}

	private function handleLoadComplete(event:Event):Void
	{
		trace("Conexão com a internet OK!");
		GJClient.initialize();
		ModoOffline = false;
	}

	private function handleLoadError(event:IOErrorEvent):Void
	{
		trace("Falha ao conectar-se à internet!");
		ModoOffline = true;
	}

	var logoBl:FlxSprite;
	var logoBl1:FlxSprite;
	// var menuGif:FlxSprite;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;
	var opacidade:Float = 0;
	var opacidadesuporte:Int = -1;
	var candothething:Bool = false;


	function startIntro()
	{
		if (!initialized)
		{
			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		// GJClient.setUserInfo(FlxG.save.data.user, FlxG.save.data.token);
		// GJClient.setUserInfo(FlxG.save.data.user, FlxG.save.data.token);
		// GJClient.initialize();

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

		swagShader = new ColorSwap();

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
		// logoBl1.animation.play('bump');
		logoBl1.updateHitbox();
		logoBl1.shader = swagShader.shader;
		logoBl.shader = swagShader.shader;

		add(logoBl2);
		add(supbg);
		add(logoBl3);
		add(logoBl1);

		add(logoBl);
		candothething = true;

		titleText = new FlxSprite(-80, 600).loadGraphic(Paths.image('titleEnter'));
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.setGraphicSize(Std.int(titleText.width * 1.1));
		// titleText.y=550;
		titleText.updateHitbox();
		titleText.screenCenter(X);

		add(titleText);

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
		if (candothething == true)
		{
			if (opacidade > 1)
				opacidadesuporte = -1;
			else if (opacidade < 0)
				opacidadesuporte = 1; // Yeah yeah químico das matemática muito loka

			titleText.alpha = opacidade;
		}
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

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
			if (pressedEnter)
			{
				if (ClientPrefs.flashing){
				FlxG.camera.flash(FlxColor.WHITE, 1);
				}
				GlobalSoundManager.play('confirmMenu');

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					if (mustUpdate)
						MusicBeatState.switchState(new MainMenuStateMobile());
					else if (FlxG.save.data.firstTime == null)
						MusicBeatState.switchState(new MainMenuStateMobile()); // aquele state la quebraria o clima da abertura k
					else
						MusicBeatState.switchState(new MainMenuStateMobile());
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			else if (easterEggEnabled)
			{
				var finalKey:FlxKey = FlxG.keys.firstJustPressed();
				if (finalKey != FlxKey.NONE)
				{
					lastKeysPressed.push(finalKey); // Convert int to FlxKey
					if (lastKeysPressed.length > easterEggKeyCombination.length)
					{
						lastKeysPressed.shift();
					}

					if (lastKeysPressed.length == easterEggKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length)
						{
							if (lastKeysPressed[i] != easterEggKeyCombination[i])
							{
								isDifferent = true;
								break;
							}
						}

						if (!isDifferent)
						{
							trace('Easter egg triggered!');
							FlxG.save.data.psykaEasterEgg = !FlxG.save.data.psykaEasterEgg;
							FlxG.sound.play(Paths.sound('secretSound'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {
								onComplete: function(twn:FlxTween)
								{
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

		if (pressedEnter && !skippedIntro && canSkipIntro)
		{
			skipIntro();
		}

		opacidade += 0.01 * opacidadesuporte;

		if (swagShader != null)
		{
			#if debug
			if (controls.UI_LEFT)
				swagShader.hue -= elapsed * 0.1;
			if (controls.UI_RIGHT)
				swagShader.hue += elapsed * 0.1;
			#end
		}

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
		if (textGroup != null)
		{
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
		if (logoBl1 != null)
		{
			logoBl1.animation.play('bump', true);
		}
		super.beatHit();

		if (!closedState)
		{
			sickBeats++;
			switch (sickBeats)
			{
				case 1: // Checar aqui depois
					createCoolText(['Time da Vio'], 45);
				case 3:
					addMoreText('Apresenta', 45);
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
					addMoreText('FNF');
				case 15:
					addMoreText('ModBoa');
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
			if (ClientPrefs.flashing){
			FlxG.camera.flash(FlxColor.WHITE, 1);
			}
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
