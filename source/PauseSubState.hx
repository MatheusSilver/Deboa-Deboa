package;

import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import Shaders;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var countDownSprites:Array<FlxSprite> = [];

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Voltar para a musica', 'Modo praticar', 'Reiniciar musica', 'Botplay', 'Voltar para o menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

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

	var ready:FlxSprite;
	var set:FlxSprite;
	var go:FlxSprite; //bruh + meme = breme

	var isDoingtheThing:Bool = false;
	var aberto:Bool=false;

	//var playState:PlayState;
	
	public static var pauseMusicName:String = 'breakfast';

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();

		

		ready = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
		set = new FlxSprite().loadGraphic(Paths.image('set', 'shared'));
		go = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));

		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficultyStuff.length) {
			var diff:String = '' + CoolUtil.difficultyStuff[i][0];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		preto = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		preto.alpha=0;
		add(preto);

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

		var k:Int = 40;


		continuar = new FlxSprite().loadGraphic(Paths.image('pause/pause (continuar)'));
		continuar.alpha = 0.75;
		continuar.x=-693;
		continuar.y=FlxG.height/6- k;
		add(continuar);

		restart = new FlxSprite().loadGraphic(Paths.image('pause/pause (restart)'));
		restart.alpha = 0.75;
		restart.x=-620;
		restart.y=FlxG.height/6*3- k - 15;
		add(restart);

		bot = new FlxSprite().loadGraphic(Paths.image('pause/botplaydesativado'));
		bot.alpha = 0.75;
		bot.x=-587;
		bot.y=FlxG.height/6*4- k -15;
		add(bot);

		praticar = new FlxSprite().loadGraphic(Paths.image('pause/praticardesativado'));
		praticar.alpha = 0.75;
		praticar.x=-655;
		praticar.y=FlxG.height/6*2- k -15;
		add(praticar);
		
		voltar = new FlxSprite().loadGraphic(Paths.image('pause/pause (voltar)'));
		voltar.alpha = 0.75;
		voltar.x=-557;
		voltar.y=FlxG.height/6*5 - k -15;
		add(voltar);

		add(bg);
		add(linhabaixo);
		add(perfil);
		add(exe);

		FlxTween.tween(continuar, {x: -128}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(praticar, {x: -128}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {x: -128}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(bot, {x: -128}, 0.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(voltar, {x: -128}, 0.7, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){aberto=true;}});


		FlxTween.tween(preto, {alpha: 0.45}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {y: 0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(linhabaixo, {y: FlxG.height-linhabaixo.height}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(perfil, {x: FlxG.width-perfil.width}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(exe, {x: FlxG.width-exe.width}, 0.6, {ease: FlxEase.quartInOut});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true);
			songText.isMenuTrem = true;
			songText.targetY = i;
			songText.screenCenter(X);
			songText.alpha=0;
			grpMenuShit.add(songText);
		}

		if (PlayState.useVideo)
			{
				if (GlobalVideo.get().playing)
					GlobalVideo.get().pause();
			}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];


		#if mobileC
		addVirtualPad(UP_DOWN, A);
		var camcontrol = new FlxCamera();
		FlxG.cameras.add(camcontrol);
		camcontrol.bgColor.alpha = 0;
		_virtualpad.cameras = [camcontrol];
		#end
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if(PlayState.cpuControlled)
			{
				bot.loadGraphic(Paths.image('pause/botplayativado'));
			}
		else
			{
				bot.loadGraphic(Paths.image('pause/botplaydesativado'));
			}


			if(PlayState.practiceMode)
				{
					praticar.loadGraphic(Paths.image('pause/praticarativado'));
				}
			else
				{
					praticar.loadGraphic(Paths.image('pause/praticardesativado'));
				}
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
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
							isDoingtheThing=true;
							saindodopause();
						}
						else
							{
								FlxG.sound.play(Paths.sound('negado','preload'), 0.015);
							}
				case 'Modo praticar':
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPractice = true;
				case "Reiniciar musica":
					PlayState.majinstrums = false;
					PlayState.canRegen = true;
					PlayState.canuseevents = true;
					PlayState.desesperada = false;
					CustomFadeTransition.nextCamera = transCamera;
					restartSong();
					if (PlayState.useVideo)
					{
						GlobalVideo.get().stop();
						PlayState.instance.remove(PlayState.instance.videoSprite);
						PlayState.removedVideo = true;
					}
					FlxG.sound.music.volume = 0;
				case 'Botplay':
					PlayState.cpuControlled = !PlayState.cpuControlled;
					PlayState.usedPractice = true;
				case "Voltar para o menu":
					if (PlayState.useVideo)
						{
							GlobalVideo.get().stop();
							PlayState.instance.remove(PlayState.instance.videoSprite);
							PlayState.removedVideo = true;
						}
					PlayState.majinstrums = false;
					PlayState.canRegen = true;
					PlayState.canuseevents = true;
					PlayState.desesperada = false;
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					CustomFadeTransition.nextCamera = transCamera;
					if(PlayState.modohistoria) {						
						MusicBeatState.switchState(new MenuPreHistoria());
						PlayState.modohistoria = false;
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.usedPractice = false;
					PlayState.changedDifficulty = false;
					PlayState.cpuControlled = false;

				case 'BACK':
					menuItems = menuItemsOG;
					regenMenu();
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
				FlxTween.tween(exe, {x: FlxG.width+exe.width}, 0.6, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween)
					{
						startCountdownback();
					}
				});
	}
	var loops:Int;
	function startCountdownback()
		{

			loops=0;
					new FlxTimer().start(0.35, function(tmr:FlxTimer){
						loops++;
						switch (Std.int(loops))
						{ 
							case 1:
								PlayState.instance.canPause = false;
								FlxG.sound.play(Paths.sound('intro3','shared'), 0.6);
			
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
			
								FlxG.sound.play(Paths.sound('intro2','shared'), 0.6);
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
								FlxG.sound.play(Paths.sound('intro1','shared'), 0.6);
							case 4:
								FlxG.sound.play(Paths.sound('introGo','shared'), 0.6);
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
										new FlxTimer().start(0.75, function(tmr:FlxTimer){PlayState.instance.canPause = true; isDoingtheThing=false;});
										close();
										if (PlayState.useVideo)
										{
											GlobalVideo.get().resume();
										}
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

	override function destroy()
	{
		pauseMusic.destroy();
		//FunkinLua.removeShaderFromCamera('game', new GreyscaleEffect());
		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('pausescrollmenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;


			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 0;
				// item.setGraphicSize(Std.int(item.width));
				if(item == grpMenuShit.members[0])
					{
						continuar.alpha=1;
						praticar.alpha=0.75;
						restart.alpha=0.75;
						bot.alpha=0.75;
						voltar.alpha=0.75;
					}
				else if(item == grpMenuShit.members[1])
					{
						continuar.alpha=0.75;
						praticar.alpha=1;
						restart.alpha=0.75;
						bot.alpha=0.75;
						voltar.alpha=0.75;
					}
				else if(item == grpMenuShit.members[2])
					{
						continuar.alpha=0.75;
						praticar.alpha=0.75;
						restart.alpha=1;
						bot.alpha=0.75;
						voltar.alpha=0.75;
					}
					else if(item == grpMenuShit.members[3])
						{
							continuar.alpha=0.75;
							praticar.alpha=0.75;
							restart.alpha=0.75;
							bot.alpha=1;
							voltar.alpha=0.75;
						}
						else if(item == grpMenuShit.members[4])
							{
								continuar.alpha=0.75;
								praticar.alpha=0.75;
								restart.alpha=0.75;
								bot.alpha=0.75;
								voltar.alpha=1;
							}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true);
			item.isMenuTrem = true;
			item.targetY = i;
			item.screenCenter(X);
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
}
