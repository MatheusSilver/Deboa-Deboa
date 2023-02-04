package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Voltar para a musica', 'Modo praticar', 'Reiniciar musica', 'Botplay', 'Voltar para o menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var botplayText:FlxText;

	var continuar:FlxSprite;
	var restart:FlxSprite;
	var praticar:FlxSprite;
	var bot:FlxSprite;
	var voltar:FlxSprite;
	
	var warningText:FlxText;


	public static var pauseMusicName:String = 'breakfast';

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();

		


		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficultyStuff.length) {
			var diff:String = '' + CoolUtil.difficultyStuff[i][0];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		var preto:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		preto.alpha=0;
		add(preto);

		pauseMusic = new FlxSound().loadEmbedded(Paths.music(pauseMusicName), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pause/pause (linhas)'));
		bg.alpha = 0;
		//bg.scrollFactor.set();
		bg.screenCenter(XY);
	
		var perfil:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pause/pause (perfil)'));
		perfil.alpha = 1;
		perfil.x = 640;
		//bg.scrollFactor.set();
		//perfil.screenCenter(XY);

	
		var exe:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pause/pause (sonicexe)'));
		exe.alpha = 1;
		exe.x = 674;
		//bg.scrollFactor.set();
		//exe.screenCenter(XY);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		if (PlayState.isStoryMode){
			levelInfo.text += PlayState.nomehistorico;
		} else {
		levelInfo.text += FreeplayState.infoextended;
		}
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);

		//Eu vi que eu tinha feito merda KKKKKKK Problemas com plural
		if(PlayState.deathCounter == 1) {
		blueballedTxt.text = "Morreu: " + PlayState.deathCounter + " vez.";
		} else {
		blueballedTxt.text = "Morreu: " + PlayState.deathCounter + " vezes.";
		}

		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "MODO DE TREINO", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.practiceMode;
		//add(practiceText);

		botplayText = new FlxText(20, FlxG.height - 40, 0, "BOTPLAY", 32);
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.font('vcr.ttf'), 32);
		botplayText.x = FlxG.width - (botplayText.width + 20);
		botplayText.updateHitbox();
		botplayText.visible = PlayState.cpuControlled;
		//add(botplayText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		continuar = new FlxSprite().loadGraphic(Paths.image('pause/pause (continuar)'));
		continuar.alpha = 0.75;
		continuar.x=-693;
		//continuar.screenCenter(XY);
		add(continuar);

		restart = new FlxSprite().loadGraphic(Paths.image('pause/pause (restart)'));
		restart.alpha = 0.75;
		restart.x=-620;
		//restart.screenCenter(XY);
		add(restart);

		bot = new FlxSprite().loadGraphic(Paths.image('pause/botplaydesativado'));
		bot.alpha = 0.75;
		bot.x=-587;
		//bot.screenCenter(XY);
		add(bot);

		praticar = new FlxSprite().loadGraphic(Paths.image('pause/praticardesativado'));
		praticar.alpha = 0.75;
		praticar.x=-655;
		//praticar.screenCenter(XY);
		add(praticar);
		
		voltar = new FlxSprite().loadGraphic(Paths.image('pause/pause (voltar)'));
		voltar.alpha = 0.75;
		voltar.x=-557;
		//voltar.screenCenter(XY);
		add(voltar);

		add(bg);
		add(perfil);
		add(exe);

		FlxTween.tween(continuar, {x: -128}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(praticar, {x: -128}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(restart, {x: -128}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(bot, {x: -128}, 0.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(voltar, {x: -128}, 0.7, {ease: FlxEase.quartInOut});


		FlxTween.tween(preto, {alpha: 0.55}, 0.3, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(perfil, {x: 0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(exe, {x: 0}, 0.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 0, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 0, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 0, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});


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
					if (PlayState.useVideo)
						{
							GlobalVideo.get().resume();
						}
					FlxG.sound.play(Paths.sound('unpause'), 0.4);
					close();

			//	case 'Mudar dificuldade':
			//		menuItems = difficultyChoices;
			//		regenMenu();
				case 'Modo praticar':
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPractice = true;
					practiceText.visible = PlayState.practiceMode;
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
					botplayText.visible = PlayState.cpuControlled;
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
