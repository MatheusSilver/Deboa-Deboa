package;

import flixel.group.FlxSpriteGroup;
import CustomButtons.PauseButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import lime.math.Vector2;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;
import flixel.FlxGame;
import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;
import lime.app.Application;
import lime.ui.WindowAttributes;
import flash.filters.BlurFilter;
import lime.ui.Window;
import flixel.tweens.misc.NumTween;
//import openfl.filters.ColorMatrixFilter;

class PauseSubState extends MusicBeatSubstate
{

	var countDownSprites:Array<FlxSprite> = [];

	var menuItems_names:Array<String> = ["continue", "practice", "restart", "botplay", "return"];
	private var menuItems_icons:FlxTypedGroup<PauseButton>;
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var scrollingSound:FlxSound;

	var preto:FlxSprite;
	var pretoTrans:FlxSprite;
	var bg:FlxSprite;
	var exe:FlxSprite;
	var linhabaixo:FlxSprite;
	var perfil:FlxSprite;

	var jumpscare:FlxSprite;
	var inJumpscare:Bool = false;
	var podeJumpscare:Bool = true;
	var didJumpscare:Bool = false;

	public static var jafizJumpscare:Bool = false;

	var ready:FlxSprite = new FlxSprite();
	var set:FlxSprite = new FlxSprite();
	var go:FlxSprite = new FlxSprite(); //bruh + meme = breme

	var isDoingtheThing:Bool = false;
	var aberto:Bool=false;
	var blurShader:BlurFilter;
	//var grayScale:ColorMatrixFilter;
	var dummySprite:FlxSprite;
	var shaderativo:Bool;
	var jumpecare:FlxObject = new FlxObject();
	

	var lugarTelaX:Int;
	var lugarTelaY:Int;
	public static var aaa:Bool = true;
	var originalZoom:Float;
	var originalZoomHUD:Float;
	var originalZoomLegenda:Float;
	var originalZoomOther:Float;
	var originalZoomHUD2:Float;
	var originalZoomCCC:Float;

	var saindoPause:Bool = false;

	//var playState:PlayState;
	
	public static var pauseMusicName:String = 'breakfast';

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		if(ClientPrefs.shaders) {
		blurShader = new BlurFilter();
		//grayScale = new ColorMatrixFilter();
		}
		
		var basePath:String = PlayState.SONG.song.toLowerCase() != "sunshine" ? '' : 'cenarios/saturn/';

		loadGraphics(ready, basePath + 'ready');
		loadGraphics(set, basePath + 'set');
		loadGraphics(go, basePath + 'go');

		if(FlxG.save.data.didJumpscare==null)
			{
				FlxG.save.data.didJumpscare = jafizJumpscare;
			}
		else
			{
				jafizJumpscare = FlxG.save.data.didJumpscare;
			}

		scrollingSound = new FlxSound().loadEmbedded(Paths.sound('pausescrollmenu'));
		scrollingSound.volume = 0.4;

		preto = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		preto.alpha=0;
		originalZoom = PlayState.instance.camGame.zoom;
		originalZoomHUD = PlayState.instance.camHUD.zoom;
		originalZoomLegenda = PlayState.instance.camLegenda.zoom;
		originalZoomOther = PlayState.instance.camOther.zoom;
		originalZoomHUD2 = PlayState.instance.camHUD2.zoom;
		originalZoomCCC = PlayState.instance.camCCC.zoom;
		pauseMusic = new FlxSound().loadEmbedded(Paths.music(pauseMusicName), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		
		FlxG.sound.list.add(pauseMusic);
		
		bg = new FlxSprite(0,0).loadGraphic(Paths.image('top_icons/pause', "locales", true, true));
		bg.setGraphicSize(FlxG.width);
		bg.y = -bg.height;
		
		
		linhabaixo = new FlxSprite(0,0).makeGraphic(FlxG.width, Std.int(bg.height), FlxColor.BLACK);
		linhabaixo.y = FlxG.height + linhabaixo.height;
		
		perfil = new FlxSprite().loadGraphic(Paths.image('pause/pause (perfil)'));
		perfil.alpha = 1;
		perfil.x = FlxG.width;
		
		
		exe = new FlxSprite().loadGraphic(Paths.image('pause/pause (sonicexe)'));
		exe.alpha = 1;
		exe.x = FlxG.width;
		
		menuItems_icons = new FlxTypedGroup<PauseButton>();
		
		for (i in 0...menuItems_names.length){
			var new_button:PauseButton = new PauseButton("label_pause_"+menuItems_names[i], "smb");
			new_button.x =-693+38*i;
			new_button.y= FlxG.height/6*(i+1) - 38; 
			if (menuItems_names[i] == "practice" || menuItems_names[i] == "botplay")
				new_button.changeState(menuItems_names[i] == "practice" ? PlayState.practiceMode : PlayState.cpuControlled);
			new_button.alpha = 0.5;
			new_button.button_text.x += 160+20*(i);
			new_button.ID = i;
			menuItems_icons.add(new_button);
		}
		
		super(); //Antes, prepara-se os coiso
		//Depois, são as interações.
		add(preto);
		add(bg);
		add(linhabaixo);
		add(perfil);
		add(exe);
		add(menuItems_icons);
		FlxTween.tween(PlayState.instance.camGame, {zoom: originalZoom+0.05}, 0.35, {ease: FlxEase.quartInOut});
		FlxTween.tween(PlayState.instance.camHUD, {zoom: originalZoomHUD+0.05}, 0.35, {ease: FlxEase.quartInOut});
		FlxTween.tween(PlayState.instance.camLegenda, {zoom: originalZoomLegenda+0.05}, 0.35, {ease: FlxEase.quartInOut});
		FlxTween.tween(PlayState.instance.camOther, {zoom: originalZoomOther+0.05}, 0.35, {ease: FlxEase.quartInOut});
		//FlxTween.tween(PlayState.instance.camHUD2, {zoom: originalZoomHUD2+0.05}, 0.35, {ease: FlxEase.quartInOut});
		
		for (i in 0...menuItems_icons.length){
			FlxTween.tween(menuItems_icons.members[i], {x: -128 - 20*i}, 0.2+i/10, {ease:FlxEase.quartInOut});
		}
		
		
		FlxTween.tween(preto, {alpha: 0.75}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {y: 0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(linhabaixo, {y: FlxG.height-linhabaixo.height}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(perfil, {x: FlxG.width-perfil.width}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(exe, {x: FlxG.width-exe.width}, 0.6, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){aberto=true;}});
		
		changeSelection();
		
		if(PlayState.instance.curSong.toLowerCase()=="triple-trouble" #if !debug && !jafizJumpscare #end)
			{
				aaa = false;
				jumpecare = new FlxObject();
				jumpecare.x = 0;
				FlxTween.tween(jumpecare, {x: 1000}, 180, {ease: FlxEase.linear});
			}
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
			new FlxTimer().start(0.15, function(tmr:FlxTimer){
				lugarTelaX = Lib.current.stage.window.x;
				lugarTelaY = Lib.current.stage.window.y;
			}); //Evitar crash no alt + f4
			#if mobileC
			addVirtualPad(UP_DOWN, A);
			var camcontrol = new FlxCamera();
		FlxG.cameras.add(camcontrol);
		camcontrol.bgColor.alpha = 0;
		_virtualpad.cameras = [camcontrol];
		#end
		if(ClientPrefs.shaders)
		{
			if(!PlayState.instance.shaders_running){
				PlayState.instance.camGame.setFilters([blurShader/*, grayScale*/]);
				PlayState.instance.camHUD.setFilters([blurShader/*, grayScale*/]);
				PlayState.instance.camLegenda.setFilters([blurShader/*, grayScale*/]);
				PlayState.instance.camOther.setFilters([blurShader/*, grayScale*/]);
			}
		FlxTween.tween(blurShader, {blurX: 3, blurY: 3}, 1.25, {ease: FlxEase.quartInOut});
		/*var newMatrix:Array<Float> = [
			0.5, 0.5, 0.5, 0, 0,
			0.5, 0.5, 0.5, 0, 0,
			0.5, 0.5, 0.5, 0, 0,
			0,   0,   0, 1, 0,
			];
			FlxTween.tween(grayScale, {matrix: newMatrix}, 1.25, {ease: FlxEase.quartInOut});*/
		}
		pretoTrans = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		pretoTrans.alpha = 0;
		pretoTrans.visible = false;
		add(pretoTrans);
	}
				
	override function update(elapsed:Float)
	{
		if(PlayState.instance.curSong.toLowerCase()=="triple-trouble" && podeJumpscare #if !debug && !jafizJumpscare #end)
		{
			#if debug trace(jumpecare.x); #end
			if(jumpecare.x==1000)
				{
					jumpscareExecute();
					podeJumpscare=false;
				}
		}
		#if desktop
		if(inJumpscare&&!ClientPrefs.fullscreen)
		{
			shakeWindow();
		}
		#end
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
		
		super.update(elapsed);
		
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP&& !inJumpscare && !saindoPause)
		{
			changeSelection(-1);
		}
		if (downP&& !inJumpscare && !saindoPause)
		{
			changeSelection(1);
		}

		if (accepted && !inJumpscare && !saindoPause)
		{
			var daSelected:String = menuItems_names[curSelected];
			switch (daSelected)
			{
				case "continue":
					if(!isDoingtheThing && aberto)
						{
							podeJumpscare=false;
							isDoingtheThing=true;
							saindodopause();
						}
				case "practice":
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPractice = true;
					menuItems_icons.members[1].changeState(PlayState.practiceMode);
				case "restart":
					podeJumpscare=false;
					PlayState.instance.canRegen = true;
					PlayState.vimdopause = true;
					PlayState.canuseevents = true;
					CustomFadeTransition.nextCamera = PlayState.instance.camAchievement;
					restartSong(!PlayState.instance.playingVideoMP4);
					if(didJumpscare){Achievements.unlockAchievement('pause_jumpscare');}
					FlxG.sound.music.volume = 0;
				case "botplay":
					PlayState.cpuControlled = !PlayState.cpuControlled;
					PlayState.usedPractice = true;
					menuItems_icons.members[3].changeState(PlayState.cpuControlled);
				
				case "return":
					podeJumpscare=false;
					if(PlayState.instance.playingVideoMP4)
						{
							PlayState.instance.addBlackStuff(PlayState.instance.camLegenda);
							PlayState.instance.pularVideo(true);
						}
					PlayState.instance.canRegen = true;
					PlayState.canuseevents = true;
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					CustomFadeTransition.nextCamera = transCamera;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('newmenu', 'preload'),0);
					PlayState.usedPractice = false;
					PlayState.changedDifficulty = false;
					PlayState.cpuControlled = false;
					if(didJumpscare){Achievements.unlockAchievement('pause_jumpscare');}
					pretoTrans.visible = true;
					FlxTween.tween(pretoTrans, {alpha : 1}, 0.5, {ease:FlxEase.quartInOut, onComplete: function(twn:FlxTween){
						MusicBeatState.switchState(new Limpeza.EstadoDeTrocaReverso());
					}} );
					//Achievements.syncWithGJLater();
			}
		}
	}
	function saindodopause(){
				saindoPause = true;
				for (i in 0...menuItems_icons.length){
					FlxTween.tween(menuItems_icons.members[i], {x: 0-menuItems_icons.members[i].width}, 0.1+i/10, {ease:FlxEase.quartInOut});
				}
				FlxTween.tween(bg, {y: -bg.height}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(linhabaixo, {y: FlxG.height}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(perfil, {x: FlxG.width+perfil.width}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(preto, {alpha: 0}, 0.8, {ease: FlxEase.quartInOut});
				FlxTween.tween(PlayState.instance.camGame, {zoom: originalZoom}, 0.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(PlayState.instance.camHUD, {zoom: originalZoomHUD}, 0.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(PlayState.instance.camLegenda, {zoom: originalZoomLegenda}, 0.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(PlayState.instance.camOther, {zoom: originalZoomOther}, 0.35, {ease: FlxEase.quartInOut});
				//FlxTween.tween(PlayState.instance.camHUD2, {zoom: originalZoomHUD2}, 0.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(exe, {x: FlxG.width+exe.width}, 0.6, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween) {
					if(!PlayState.instance.playingVideoMP4) // Acho que era pra ser assim...
					{
						startCountdownback();
					}
				}});
				if(ClientPrefs.shaders) {
				FlxTween.tween(blurShader, {blurX: 0, blurY: 0}, 1.25, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween)
				{
					if(!PlayState.instance.shaders_running)
					{
						PlayState.instance.camGame.setFilters([]);
						PlayState.instance.camHUD.setFilters([]);
						PlayState.instance.camLegenda.setFilters([]);
						PlayState.instance.camOther.setFilters([]);
					}
				}});
				if(!PlayState.instance.playingVideoMP4)
				{
					startCountdownback(); // não sei se vai quebrar alguma coisa, mas é algo pro bem....
				}
				/*var newMatrix:Array<Float> = [
					1, 0, 0, 0, 0,
					0, 1, 0, 0, 0,
					0, 0, 1, 0, 0,
					  0,   0,   0, 1, 0,
				];
				FlxTween.tween(grayScale, {matrix: newMatrix}, 1.25, {ease: FlxEase.quartInOut});*/
				}
				jumpecare.destroy();
	}
	var loops:Int;

	function startCountdownback()
		{
			if(PlayState.instance.playingVideoMP4) {
				close();
				return;
			}

			var manager:FlxTimerManager = new FlxTimerManager();
			manager.clear();
			loops=0;
					new FlxTimer().start(Song.Conductor.crochet / 1000, function(tmr:FlxTimer){
						loops++;
						switch (Std.int(loops))
						{ 
							case 1:
								PlayState.instance.canPause = false;
								if(isDoingtheThing&& PlayState.instance.paused){PlayState.instance.intro3.play();}
			
							case 2:
								ready.scrollFactor.set();
								ready.updateHitbox();
			
								ready.screenCenter();
								ready.antialiasing = ClientPrefs.globalAntialiasing;
								add(ready);
								countDownSprites.push(ready);
								FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, 0.4, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										countDownSprites.remove(ready);
										remove(ready);
										ready.destroy();
										FlxTween.tween(preto, {alpha: 0}, 0.5, {ease: FlxEase.quartInOut});
									}
								});
								PlayState.instance.canPause = false;
			
								if(isDoingtheThing&& PlayState.instance.paused){PlayState.instance.intro2.play();}
							case 3:
								set.scrollFactor.set();
								PlayState.instance.canPause = false;
								set.screenCenter();
								set.antialiasing = ClientPrefs.globalAntialiasing;
								add(set);
								countDownSprites.push(set);
								FlxTween.tween(set, {y: set.y += 100, alpha: 0}, 0.9, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										countDownSprites.remove(set);
										remove(set);
										set.destroy();
									}
								});
								if(isDoingtheThing && PlayState.instance.paused){PlayState.instance.intro1.play();}
							case 4:
								if(isDoingtheThing && PlayState.instance.paused)
									{
										PlayState.instance.introgo.play();
									}
								PlayState.instance.canPause = false;			
								go.scrollFactor.set();
			
								go.updateHitbox();
			
								go.screenCenter();
								go.antialiasing = ClientPrefs.globalAntialiasing;
								add(go);
								countDownSprites.push(go);
								FlxTween.tween(go, {y: go.y += 100, alpha: 0}, 0.4, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										countDownSprites.remove(go);
										remove(go);
										go.destroy();
										if(didJumpscare){PlayState.instance.startachieving('pause_jumpscare');}
										new FlxTimer().start(0.75, function(tmr:FlxTimer){PlayState.instance.canPause = true; isDoingtheThing=false; manager.clear();});
										close();
									}
								});
						}
					}, 4);
		}

	public static function restartSong(noTrans:Bool = false)
		{
			PlayState.instance.paused = true; // For lua
			FlxG.sound.music.volume = 0;
			PlayState.instance.vocals.volume = 0;
	
			if(noTrans)
			{
				flixel.addons.transition.FlxTransitionableState.skipNextTransOut = true;
				FlxG.resetState();
			}
			else
			{
				PlayState.instance.addBlackStuff(PlayState.instance.camLegenda);
				PlayState.instance.pularVideo(true);
				FlxG.resetState();
			}
		}

	public function jumpscareExecute():Void
		{
			if(podeJumpscare && PlayState.instance.paused)
				{
					trace('haha troxa'); //Nosfa dav, mas tu tá brabor?
					inJumpscare=true;
					FlxG.sound.volume = 1;
					jumpscare = new FlxSprite(0,0);
					jumpscare.loadGraphic(Paths.image('Tails', 'preload'));
					jumpscare.cameras = [PlayState.instance.camOther];
					jumpscare.setGraphicSize(Std.int(FlxG.width));
					jumpscare.screenCenter(XY);
					FlxG.sound.play(Paths.sound('TailsScreamLOL'), 1);
					Lib.current.stage.window.focus();
					new FlxTimer().start(2.5, function(tmr:FlxTimer){
						aaa=false;
						jumpscare.destroy();
						jafizJumpscare=true;
						FlxG.save.data.didJumpscare = true;
						inJumpscare=false;
						didJumpscare=true;
					});
					aaa = true;
					add(jumpscare);
				}
		}

		function loadGraphics(sprite:FlxSprite, path:String):Void {
			sprite.loadGraphic(Paths.image(path, 'week-sunshine'));
			if (PlayState.SONG.song.toLowerCase() == "sunshine") {
				sprite.scale.set(0.5, 0.5);
				sprite.screenCenter();
			}
		}

		#if desktop
		function shakeWindow():Void
			{
				var window:Window = Lib.current.stage.window;
			
				window.move(window.x-15, window.y-15);
				window.move(window.x+20, window.y+20);
				window.move(window.x-20, window.y-20);
				window.x = lugarTelaX;
				window.y = lugarTelaY;
				window.move(window.x+20, window.y+10);
				window.move(window.x+10, window.y+20);
				window.move(window.x-20, window.y+10);
				window.x = lugarTelaX;
				window.y = lugarTelaY;
				window.move(window.x+10, window.y-20);
				window.move(window.x+15, window.y+15);
				window.move(window.x-20, window.y+10);
				window.x = lugarTelaX;
				window.y = lugarTelaY;
			}
		#end

	override function destroy()
	{
		pauseMusic.destroy();
		podeJumpscare = false;
		aaa = true;
		//FunkinLua.removeShaderFromCamera('game', new GreyscaleEffect());
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		scrollingSound.play(true);

		if (curSelected < 0)
			curSelected = menuItems_names.length - 1;
		if (curSelected >= menuItems_names.length)
			curSelected = 0;

		//Eu queria fazer isso ser automático mas né? Não acho que esse code vá ser reutilizado depois, pelo menos não essa parte.
		//Sílvio do futuro vindo dizer que a busca pelo sistema automático foi concluida :sunglasses:
		menuItems_icons.forEach(function(object:FlxSpriteGroup)
		{
			if (object.ID == curSelected)
				object.alpha = 1;
			else
				object.alpha = 0.5;
		});
	}
}