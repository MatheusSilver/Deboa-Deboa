package;

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

class PauseSubState extends MusicBeatSubstate
{

	var countDownSprites:Array<FlxSprite> = [];

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Voltar para a musica', 'Modo praticar', 'Reiniciar musica', 'Botplay', 'Voltar para o menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var scrollingSound:FlxSound;

	var continuar:FlxSprite;
	var restart:FlxSprite;
	var praticar:FlxSprite;
	var bot:FlxSprite;
	var voltar:FlxSprite;

	var preto:FlxSprite;
	var bg:FlxSprite;
	var exe:FlxSprite;
	var linhabaixo:FlxSprite;
	var perfil:FlxSprite;

	var jumpscare:FlxSprite;
	var inJumpscare:Bool = false;
	var podeJumpscare:Bool = true;
	var didJumpscare:Bool = false;

	public static var jafizJumpscare:Bool = false;

	var ready:FlxSprite;
	var set:FlxSprite;
	var go:FlxSprite; //bruh + meme = breme

	var isDoingtheThing:Bool = false;
	var aberto:Bool=false;
	var blurShader:BlurFilter;
	var dummySprite:FlxSprite;
	var shaderativo:Bool;
	var jumpecare:FlxObject = new FlxObject();

	var lugarTelaX:Int;
	var lugarTelaY:Int;
	public static var aaa:Bool = true;
	var originalZoom:Float;
	var originalZoomHUD:Float;
	var originalZoomHUD2:Float;
	//var playState:PlayState;
	
	public static var pauseMusicName:String = 'breakfast';

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();
		blurShader = new BlurFilter();
		ready = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
		set = new FlxSprite().loadGraphic(Paths.image('set', 'shared'));
		go = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));

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

		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficultyStuff.length) {
			var diff:String = '' + CoolUtil.difficultyStuff[i][0];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		preto = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		preto.alpha=0;
		add(preto);
		originalZoom = PlayState.instance.camGame.zoom;
		originalZoomHUD = PlayState.instance.camHUD.zoom;
		originalZoomHUD2 = PlayState.instance.camHUD2.zoom;
		pauseMusic = new FlxSound().loadEmbedded(Paths.music(pauseMusicName), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite(0,0).loadGraphic(Paths.image('pause/pause (linhas)'));
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

		var k:Int = 38;


		continuar = new FlxSprite().loadGraphic(Paths.image('pause/pause (continuar)'));
		continuar.alpha = 0.5;
		continuar.x=-693;
		continuar.y=FlxG.height/6- k;
		add(continuar);

		restart = new FlxSprite().loadGraphic(Paths.image('pause/pause (restart)'));
		restart.alpha = 0.5;
		restart.x=-620;
		restart.y=FlxG.height/6*3- k;
		add(restart);

		bot = new FlxSprite().loadGraphic(Paths.image('pause/botplay'+PlayState.cpuControlled));
		bot.alpha = 0.5;
		bot.x=-587;
		bot.y=FlxG.height/6*4- k;
		add(bot);

		praticar = new FlxSprite().loadGraphic(Paths.image('pause/praticar'+PlayState.practiceMode));
		praticar.alpha = 0.5;
		praticar.x=-655;
		praticar.y=FlxG.height/6*2- k;
		add(praticar);
		
		voltar = new FlxSprite().loadGraphic(Paths.image('pause/pause (voltar)'));
		voltar.alpha = 0.5;
		voltar.x=-557;
		voltar.y=FlxG.height/6*5 - k;
		add(voltar);

		add(bg);
		add(linhabaixo);
		add(perfil);
		add(exe);
		FlxTween.tween(PlayState.instance.camGame, {zoom: originalZoom+0.05}, 0.35, {ease: FlxEase.quartInOut});
		FlxTween.tween(PlayState.instance.camHUD, {zoom: originalZoomHUD+0.05}, 0.45, {ease: FlxEase.quartInOut});
		//FlxTween.tween(PlayState.instance.camHUD2, {zoom: originalZoomHUD2+0.1}, 0.6, {ease: FlxEase.quartInOut});

		FlxTween.tween(continuar, {x: -128}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(praticar, {x: -128}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {x: -128}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(bot, {x: -128}, 0.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(voltar, {x: -128}, 0.7, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){aberto=true;}});


		FlxTween.tween(preto, {alpha: 0.75}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {y: 0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(linhabaixo, {y: FlxG.height-linhabaixo.height}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(perfil, {x: FlxG.width-perfil.width}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(exe, {x: FlxG.width-exe.width}, 0.6, {ease: FlxEase.quartInOut});

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
				if(PlayState.instance.curSong.toLowerCase()!="round-a-bout")
				{
					PlayState.instance.camGame.setFilters([blurShader]);
					PlayState.instance.camHUD.setFilters([blurShader]);
				}
				FlxTween.tween(blurShader, {blurX: 3, blurY: 3}, 1.25, {ease: FlxEase.quartInOut});
			}
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
		if(inJumpscare&&!ClientPrefs.fullscreen)
			{
				shakeWindow();
			}
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP&& !inJumpscare)
		{
			changeSelection(-1);
		}
		if (downP&& !inJumpscare)
		{
			changeSelection(1);
		}

		if (accepted && !inJumpscare)
		{
			var daSelected:String = menuItems[curSelected];
			for (i in 0...difficultyChoices.length-1) {
				if(difficultyChoices[i] == daSelected) {
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.cpuControlled = false;
					return;
				}
			} 
			switch (daSelected)
			{
				case "Voltar para a musica":
					if(!isDoingtheThing && aberto)
						{
							podeJumpscare=false;
							isDoingtheThing=true;
							saindodopause();
						}
				case 'Modo praticar':
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPractice = true;
					praticar.loadGraphic(Paths.image('pause/praticar'+PlayState.practiceMode));
				case "Reiniciar musica":
					podeJumpscare=false;
					PlayState.canRegen = true;
					PlayState.canuseevents = true;
					CustomFadeTransition.nextCamera = transCamera;
					restartSong();
					if(didJumpscare){Achievements.unlockAchievement('pause_jumpscare');}
					FlxG.sound.music.volume = 0;
				case 'Botplay':
					PlayState.cpuControlled = !PlayState.cpuControlled;
					PlayState.usedPractice = true;
					bot.loadGraphic(Paths.image('pause/botplay'+PlayState.cpuControlled));
				
				case "Voltar para o menu":
					podeJumpscare=false;
					PlayState.canRegen = true;
					PlayState.canuseevents = true;
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.switchState(new EstadoDeTrocaReverso());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.usedPractice = false;
					PlayState.changedDifficulty = false;
					PlayState.cpuControlled = false;
					if(didJumpscare){Achievements.unlockAchievement('pause_jumpscare');}
			}
		}
	}

	function saindodopause(){
				FlxTween.tween(continuar, {x: 0-continuar.width}, 0.1, {ease: FlxEase.quartInOut});
				FlxTween.tween(praticar, {x: 0-praticar.width}, 0.2, {ease: FlxEase.quartInOut});
				FlxTween.tween(restart, {x: 0-restart.width}, 0.3, {ease: FlxEase.quartInOut});
				FlxTween.tween(bot, {x: 0-bot.width}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(voltar, {x: 0-voltar.width}, 0.5, {ease: FlxEase.quartInOut});
				FlxTween.tween(bg, {y: -bg.height}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(linhabaixo, {y: FlxG.height}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(perfil, {x: FlxG.width+perfil.width}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(preto, {alpha: 0}, 0.8, {ease: FlxEase.quartInOut});
				FlxTween.tween(PlayState.instance.camGame, {zoom: originalZoom}, 0.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(PlayState.instance.camHUD, {zoom: originalZoomHUD}, 0.45, {ease: FlxEase.quartInOut});
				//FlxTween.tween(PlayState.instance.camHUD2, {zoom: originalZoomHUD2}, 0.6, {ease: FlxEase.quartInOut});
				FlxTween.tween(exe, {x: FlxG.width+exe.width}, 0.6, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween)
					{
						startCountdownback();
					}
				});
				FlxTween.tween(blurShader, {blurX: 0, blurY: 0}, 1.25, {ease: FlxEase.quartInOut});
				jumpecare.destroy();
	}
	var loops:Int;
	function startCountdownback()
		{
			var manager:FlxTimerManager = new FlxTimerManager();
			manager.clear();
			loops=0;
					new FlxTimer().start(0.35, function(tmr:FlxTimer){
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
				MusicBeatState.resetState();
			}
		}

	public function jumpscareExecute():Void
		{
			if(podeJumpscare && PlayState.instance.paused)
				{
					trace('haha troxa');
					inJumpscare=true;
					FlxG.sound.volume = 1;
					jumpscare = new FlxSprite(0,0);
					jumpscare.loadGraphic(Paths.image('Tails', 'preload'));
					jumpscare.cameras = [transCamera];
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
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		//Eu queria fazer isso ser automático mas né? Não acho que esse code vá ser reutilizado depois, pelo menos não essa parte.
		continuar.alpha=0.5;
		praticar.alpha=0.5;
		restart.alpha=0.5;
		bot.alpha=0.5;
		voltar.alpha=0.5;
		switch(curSelected){
			case 0:
				continuar.alpha=1;
			case 1:
				praticar.alpha=1;
			case 2:
				restart.alpha=1;
			case 3:
				bot.alpha=1;
			case 4:
				voltar.alpha=1;
		}
	}
}