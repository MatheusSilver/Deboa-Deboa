package;

import Achievements;
import editors.MasterEditorMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.net.URLRequest;

using StringTools;

#if desktop
import Discord.DiscordClient;
#end

class MainMenuStateMobile extends MusicBeatState
{
	public static var psychEngineVersion:String = 'V1'; //This is also used for Discord RPC

	public var camGame:FlxCamera;
	public var camAchievement:FlxCamera;
	var clicavel:Bool = false;

	var boom:FlxSprite;
	var gameJoltBG:FlxSprite;

	var letext:FlxText;
	var isCoolBeat:Bool=true;
	public static var instance:MainMenuStateMobile;
	//var gradientBar:FlxGradient;
	
	var optionShit:Array<String> = ['historia','freeplay', 'multiplayer-locked2', 'conquistas', 'creditos', 'opcao'];
	private var menuItems:FlxTypedGroup<FlxSprite>;
	var machine:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var logoBl:FlxSprite;
	var checkiftouch:Bool = false;
	var canClick:Bool = false;
	public static var newVersion:Bool = false;
	var gameJoltIcon:FlxSprite;

	public static var version:String = '0.9.6';
	public static var changelogString:String = 'V'+version+'\nIsso é apenas um\nteste pra ver\nse isso funciona\nmesmo.\nSerá que deu\ncerto????\nass:dav';

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
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
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
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
		boom.y = -565;
		boom.flipX=true;
		boom.x = -751;
		boom.alpha=1;
		add(boom);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length){
			var botoes:FlxSprite = new FlxSprite(FlxG.width, 8.5 + FlxG.height/(optionShit.length+2)*(i));
			botoes.loadGraphic(Paths.image('mainmenu/set' + optionShit[i], 'preload'));
			botoes.setGraphicSize(Std.int(botoes.width * 0.6)); //Matemática avançada para o caso de algum dia vir a adicionar, ou remover botões daqui
			botoes.alpha = 0.75;
			botoes.ID = i;
			botoes.screenCenter(Y);
			botoes.y -= FlxG.height/optionShit.length*(optionShit.length-i)-97.5;
			menuItems.add(botoes);
			botoes.antialiasing = ClientPrefs.globalAntialiasing;
			botoes.updateHitbox();
		}

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
				letext.alpha = 1;

				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
					if(GJClient.avatarURL.contains("no-avatar"))
						{
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
						}
					else
						{
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
						}
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

		for (i in 0...optionShit.length){
				FlxTween.tween(menuItems.members[i], {x: FlxG.width - 2.22*menuItems.members[i].width}, 0.3, {ease: FlxEase.expoInOut, startDelay: 0.1*(1+2*i)});
		}

		new FlxTimer().start(0.1*(1 + 2*optionShit.length) + 0.3, function(tmr:FlxTimer){
			clicavel = true;
		});

		checkiftouch = false;

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
			var achieveID:Int = Achievements.getAchievementIndex('modboa');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
		}
		#end


		var versionShit:FlxText = new FlxText(12, FlxG.height - 34, 0, "ModBoa: EXE v" + version, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("sonic-1-hud-font.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.updateHitbox();
		add(versionShit);

		if(newVersion)
			{
				var preto:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				preto.alpha=0.75;
				preto.updateHitbox();
				preto.cameras = [camAchievement];
				add(preto);
				var novoBG:FlxSprite = new FlxSprite(421, 87, Paths.image('mainmenu/updatescreen', 'preload'));
				novoBG.cameras = [camAchievement];
				add(novoBG);
				var textinho:FlxText = new FlxText(0, 0, 0, changelogString, 12);
				textinho.scrollFactor.set();
				textinho.setFormat("sonic-1-hud-font.ttf", 36, FlxColor.GRAY, LEFT);
				textinho.x = 446;
				textinho.y = 162;
				textinho.updateHitbox();
				textinho.cameras = [camAchievement];
				add(textinho);
				var novoButton:FlxButton = new FlxButton(523, 548, '');
				novoButton.cameras = [camAchievement];
				novoButton.loadGraphic(Paths.image('mainmenu/btok', 'preload'));
				novoButton.alpha = 0.75;
				novoButton.onOver.callback = function(){novoButton.alpha=1; FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);};
				novoButton.onOut.callback = function(){novoButton.alpha=0.75;};
				novoButton.onDown.callback = function(){
					FlxG.save.data.gameVersion = version;
					ClientPrefs.saveSettings();
					novoButton.visible=false;
					novoBG.visible=false;
					preto.visible=false;
					textinho.visible=false;
					FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
					canClick = true;
				};
				add(novoButton);
				canClick=false;
			}
		else
			{
				FlxG.save.data.gameVersion = version;
				ClientPrefs.saveSettings();
				canClick=true;
			}
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

	function sumidao(selecionado:Int){
		//Honestamente, nunca pensei que um dia conseguiria fazer algo assim.
		//É simples, mas só de ver a diferença entre a primeira versão desse code, pra de agora...

		menuItems.forEach(function(spr:FlxSprite)
			{
				if(spr.ID == selecionado){
					spr.alpha = 1;
					FlxTween.tween(menuItems.members[spr.ID], {x: FlxG.width - 2.33*spr.width}, 0.5, {ease: FlxEase.expoInOut, startDelay: 0.1,
						onComplete: function(proximo:FlxTween)
						{
							FlxTween.tween(menuItems.members[spr.ID], {x: FlxG.width+10}, 1.0, {ease: FlxEase.expoInOut, startDelay: 0.3});
						}});
				}else{
					FlxTween.tween(spr, {x: FlxG.width+10}, 0.5, {ease: FlxEase.expoInOut, startDelay: 0.1});
				}
			});
		}

	function trocaDeState(state:Int){
		//FlxG.mouse.visible = false;
		selectedSomethin = true;
		clicavel = false;
		checkiftouch = true;
		sumidao(state);
		FlxG.sound.play(Paths.sound('confirmMenu'));
		var daChoice:String = optionShit[state];
		sumidao(state);
		new FlxTimer().start(1.7, function(tmr:FlxTimer) {
			switch (daChoice)
			{
				case 'historia':
					MusicBeatState.switchState(new EstadoDeLimpeza()); //Só pra garantir né???
				case 'freeplay':
					MusicBeatState.switchState(new FreeplayState());
				case 'conquistas':
					MusicBeatState.switchState(new AchievementsMenuState());
				case 'creditos':
					MusicBeatState.switchState(new SobreState());
				case 'opcao':
					MusicBeatState.switchState(new ajustes.AjustesState()); // Deixa esse por enquanto KEK
			}							
		});
	}

	override function update(elapsed:Float)
	{
		#if debug
		if(FlxG.keys.justPressed.FOUR) add(new AchievementObject('eggman_free', camAchievement));
		#end
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		FlxG.mouse.visible = true;

		if(canClick)
			{
				if(clicavel && !checkiftouch){
					menuItems.forEach(function(spr:FlxSprite){
					
						if(FlxG.mouse.overlaps(spr) && spr.alpha == 0.75 && !optionShit[spr.ID].endsWith("locked2")){
							menuItems.members[spr.ID].alpha=1;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
						}else if(!FlxG.mouse.overlaps(spr)){
							spr.alpha=0.75;
						}

						if(FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed && !optionShit[spr.ID].endsWith("locked2")){
							trocaDeState(spr.ID);
						}
					});
				}
			}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && canClick)
		{

			if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
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

	override function beatHit()
		{
			super.beatHit();
			if(isCoolBeat){boom.animation.play('idle', true);}
			isCoolBeat = !isCoolBeat;
		}
}
