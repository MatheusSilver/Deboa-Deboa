package;

import LoadingState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
#if rpc
import Discord.DiscordClient;
#end

class MenuHistoria extends MusicBeatSubstate
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var subindo:Bool = true;
	var canceltweens:Bool = false;
	var musicas:Array<Dynamic> = [];
	var nombres:Array<Dynamic> = [];

	public static var dapreselected:String = '';
	public static var curSelected:Int = 0; // Publico pra corrigir um pequeno bugzinho de continuidade.
	public static var preHistoriaSelected:Int = 0;

	var apertavel:Bool = false;
	var textoSpriteTweens:FlxTween;

	// lock stuff
	var lockSprite:FlxSprite;
	var blackLock:FlxSprite;

	public static var musicasLockadas:Array<Bool> = new Array<Bool>();

	var naopodevoltar:Bool = false;

	// transition stuff
	var pastbgSprite:FlxSprite;

	// stuff to show
	var bgSprite:FlxSprite;
	var perfilSprite:FlxSprite;
	var textoSprite:FlxSprite;

	override function create()
	{
		FlxTransitionableState.skipNextTransOut = true;
		applySave();
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('newmenu'), 0);
		}
		if (FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		var leWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
		for (j in 0...leWeek.songs.length)
		{
			musicas.push(leWeek.songs[j][0]);
			nombres.push(leWeek.songs[j][3]);
		}

		FlxG.mouse.visible = false;
		if (curSelected >= WeekData.weeksList.length)
			curSelected = 0;
		persistentUpdate = persistentDraw = true;

		pastbgSprite = new FlxSprite(0, 0);
		pastbgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		bgSprite = new FlxSprite(0, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		textoSprite = new FlxSprite().loadGraphic(Paths.image('nota_invisivel', 'preload'));
		textoSprite.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('nota_invisivel', 'preload'));
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));

		// FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));

		lockSprite = new FlxSprite(0, 0);
		lockSprite.loadGraphic(Paths.image("Story_Mode/lock", 'preload'));
		lockSprite.screenCenter(XY);
		lockSprite.antialiasing = ClientPrefs.globalAntialiasing;
		lockSprite.alpha = 0;

		blackLock = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackLock.alpha = 0;

		add(bgSprite);
		add(pastbgSprite);
		add(perfilSprite);
		add(textoSprite);
		add(blackLock);
		add(lockSprite);

		changeSong();

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		if (curSelected >= musicas.length)
			curSelected = 0;

		if (musicasLockadas[curSelected] == true)
		{
			flixel.tweens.FlxTween.tween(lockSprite, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
			flixel.tweens.FlxTween.tween(blackLock, {alpha: 0.55}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
		}
		else
		{
			flixel.tweens.FlxTween.tween(lockSprite, {alpha: 0}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
			flixel.tweens.FlxTween.tween(blackLock, {alpha: 0}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
		}
		super.create();
	}

	function applySave()
	{
		for (i in 0...musicasLockadas.length)
		{
			musicasLockadas.splice(0, musicasLockadas.length);
		}

		var saveStr:Array<String> = MenuPreHistoria.curSave.split(",");
		var curWeekNum:Int = Std.parseInt(saveStr[MenuPreHistoria.curWeek]);
		var leWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
		for (j in 0...leWeek.songs.length)
		{
			if (curWeekNum != 0)
			{
				curWeekNum--;
				musicasLockadas.push(false);
			}
			else
			{
				musicasLockadas.push(true);
			}
		}
		trace(musicasLockadas);
	}

	var instPlaying:Int = -1;
	var executando:Bool = false;

	private static var vocals:FlxSound = null;

	override function update(elapsed:Float)
	{
		#if rpc
		if (!selectedWeek)
		{
			DiscordClient.changePresence("Escolhendo uma musica em: ", dapreselected, null);
		}
		#end

		if (textoSpriteTweens != null)
			textoSpriteTweens.active = true;

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_LEFT_P && apertavel && musicas.length > 1) // MALUCO EU SOU MUITO BURRO...
				// Consegui cometer o mesmo erro duas vezes seguidas...
			{
				changeSong(-1, true);
				GlobalSoundManager.play('scrollMenu');
			}

			if (controls.UI_RIGHT_P && apertavel && musicas.length > 1)
			{
				changeSong(1, false);
				GlobalSoundManager.play('scrollMenu');
			}

			if (controls.BACK && !movedBack && !selectedWeek && apertavel && !naopodevoltar)
			{
				FlxTween.tween(perfilSprite, {alpha: 0}, 1.0, {ease: FlxEase.expoInOut});
				FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {
					ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						MenuPreHistoria.instance.updateBG();
						close();
					}
				});
				movedBack = true;
				// curSelected = 0;
			}
			else if (FlxG.keys.justPressed.SPACE && musicasLockadas[curSelected] != true)
			{
				if (instPlaying != curSelected)
				{
					#if PRELOAD_ALL
					FreeplayState.destroyFreeplayVocals();
					FlxG.sound.music.volume = 0;
					Paths.currentModDirectory = musicas[curSelected].folder;
					var poop:String = Highscore.formatSong(musicas[curSelected].toLowerCase(), 2);
					PlayState.SONG = Song.loadFromJson(poop, musicas[curSelected].toLowerCase());
					if (PlayState.SONG.needsVoices)
						vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
					else
						vocals = new FlxSound();

					FlxG.sound.list.add(vocals);
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
					vocals.play();
					vocals.persist = true;
					vocals.looped = true;
					vocals.volume = 0.7;
					instPlaying = curSelected;
					#end
				}
			}

			if (controls.ACCEPT && apertavel #if !debug && musicasLockadas[curSelected] != true #end)
			{
				selectSong(true);
			}
			#if !debug
			else if (controls.ACCEPT && apertavel && musicasLockadas[curSelected] == true)
			{
				GlobalSoundManager.play('negado');
			}
			#end
			#if debug
			else if (FlxG.keys.justPressed.SEVEN
				&& nombres[curSelected].toLowerCase() != 'controle'
				&& nombres[curSelected] != 'Cross Console Clash'
				&& nombres[curSelected] != 'Noite da Rapaziada')
			{
				selectSong(false);
			}
			#end
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectSong(toPlay:Bool)
	{
		if (stopspamming == false)
		{
			GlobalSoundManager.play('confirmMenu');
			stopspamming = true;
		}

		selectedWeek = true;

		persistentUpdate = false;
		var songLowercase:String = Paths.formatToSongPath(musicas[curSelected]);
		FreeplayState.infoextended = nombres[curSelected]; // O cara esqueceu como funciona o sistema que ele mesmo fez...É um genio simplesmente... ;-;
		var poop:String = Highscore.formatSong(songLowercase, 2);
		if (!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop)))
		{
			poop = songLowercase;
			trace('Couldnt find file');
		}
		trace(poop);

		if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + WeekData.weeksLoaded.get(dapreselected).weekBackground + "/scroll-"
			+ musicas[curSelected].toLowerCase() + " (back)",
			'preload')))
		{
			pastbgSprite.loadGraphic(Paths.image("scrolling/scroll-" + WeekData.weeksLoaded.get(dapreselected).weekBackground + "/scroll-"
				+ musicas[curSelected].toLowerCase() + " (back)",
				'preload'));
		}
		else
		{
			FlxG.log.warn('Não foi possível achar '
				+ Paths.image("scrolling/scroll-" + WeekData.weeksLoaded.get(dapreselected).weekBackground + "/scroll-"
					+ musicas[curSelected].toLowerCase() + " (back)",
					'preload'));
			pastbgSprite.loadGraphic('assets/images/menuDesat.png');
		}
		pastbgSprite.setGraphicSize(FlxG.width);
		pastbgSprite.screenCenter(XY);

		FreeplayState.justread = musicas[curSelected];
		PlayState.isStoryMode = false;
		PlayState.modohistoria = true;
		if (nombres[curSelected].toLowerCase() != 'controle'
			&& nombres[curSelected] != 'Cross Console Clash'
			&& nombres[curSelected] != 'Noite da Rapaziada')
		{
			MenuPreHistoria.bigmenu.alpha = 0;
			bgSprite.alpha = 0;
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);

			PlayState.storyDifficulty = 2;
			FlxTween.tween(perfilSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
			FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(pastbgSprite, {alpha: 0}, 1.0, {ease: FlxEase.linear});
				}
			});

			// Nesse eu não vou mexer, tô com medo de ferrar alguma coisa.
			if (toPlay)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (PlayState.SONG.videonombre != null && PlayState.SONG.videonombre.length > 5)
					{
						#if desktop
						VideoStatePC.NextState = 'playstate';
						PlayState.limparCache = true;
						VideoStatePC.videoPath = "assets/videos/" + PlayState.SONG.videonombre + ".mp4";
						MusicBeatState.switchState(new VideoStatePC());
						#elseif mobile
						LoadingState.loadAndSwitchState(new VideoState('assets/videos/' + PlayState.SONG.videonombre.length, new PlayState()));
						PlayState.limparCache = true;
						#end
					}
					else
					{
						openSubState(new LoadingsState());
						PlayState.limparCache = true;
						LoadingState.loadAndSwitchState(new PlayState());
					}
				});
			}
			else
			{
				MusicBeatState.switchState(new editors.ChartingState());
			}

			FlxG.sound.music.volume = 0;
		}
		else if (nombres[curSelected].toLowerCase() == 'controle')
		{
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				openSubState(new ControlSongSubstate());
			});
		}
		else if (nombres[curSelected].toLowerCase() == 'noite da rapaziada')
		{
			FlxG.sound.music.volume = 0;
			naopodevoltar = true;
			apertavel = false;
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new PastaNightSelect());
			});
		}
		else if (nombres[curSelected].toLowerCase() == 'cross console clash')
		{
			#if rpc
			DiscordClient.changePresence("Escolhendo um lado em", "Cross Console Clash", null);
			#end
			naopodevoltar = true;
			apertavel = false;
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				if (textoSpriteTweens != null)
				{
					textoSpriteTweens.active = false;
					textoSpriteTweens.cancel();
				}
				FlxTween.tween(perfilSprite, {y: -perfilSprite.height}, 0.5, {ease: FlxEase.expoInOut});
				FlxTween.tween(textoSprite, {y: FlxG.height}, 0.5, {ease: FlxEase.expoInOut});
				openSubState(new ConsoleClashSubState(musicas[curSelected]));
			});
		}

		FreeplayState.destroyFreeplayVocals();
	}

	function tweenpracima()
	{
		textoSpriteTweens = FlxTween.tween(textoSprite, {y: perfilSprite.height + perfilSprite.y + 5}, 1.5, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				if (!canceltweens)
					tweenprabaixo();
			}
		});
	}

	function tweenprabaixo()
	{
		textoSpriteTweens = FlxTween.tween(textoSprite, {y: FlxG.height - textoSprite.height * 1.2}, 1.5, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				if (!canceltweens)
					tweenpracima();
			}
		});
	}

	function entrada()
	{
		var escolhaWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
		var pasta:String = escolhaWeek.weekBackground;
		FlxTween.tween(perfilSprite, {y: -FlxG.height}, 0.05, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				if (OpenFlAssets.exists(Paths.imagechecker("scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')))
				{ // anti crashing moment
					perfilSprite.loadGraphic(Paths.image("scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'));
					perfilSprite.updateHitbox();
					perfilSprite.screenCenter(X);
				}
				else
				{
					FlxG.log.warn('Não foi possível achar ' + "scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
				}
				FlxTween.tween(perfilSprite, {y: 25}, 0.15, {
					ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)",
							'preload')))
						{ // anti crashing moment
							textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)",
								'preload'));
							textoSprite.updateHitbox();
							textoSprite.screenCenter(X);
						}
						else
						{
							FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase()
								+ " (txt)");
						}
						tweenpracima();
					}
				});
			}
		});
	}

	public function changeSong(change:Int = 0, side:Bool = false):Void
	{
		apertavel = false;
		curSelected += change;

		if (curSelected < 0)
			curSelected = musicas.length - 1;
		if (curSelected >= musicas.length)
			curSelected = 0;

		var leWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
		WeekData.setDirectoryFromWeek(leWeek);

		if (musicasLockadas[curSelected] == true)
		{
			flixel.tweens.FlxTween.tween(lockSprite, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
			flixel.tweens.FlxTween.tween(blackLock, {alpha: 0.55}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
		}
		else
		{
			flixel.tweens.FlxTween.tween(lockSprite, {alpha: 0}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
			flixel.tweens.FlxTween.tween(blackLock, {alpha: 0}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
		}

		bgSprite.visible = true;
		pastbgSprite.visible = true;
		perfilSprite.visible = true;
		textoSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload')))
		{
			bgSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
		}
		else
		{
			FlxG.log.warn('Não foi possível achar '
				+ Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
			bgSprite.loadGraphic('assets/images/menuDesat.png');
		}
		if (!selectedWeek)
		{
			bgSprite.setGraphicSize(FlxG.width);
			pastbgSprite.setGraphicSize(FlxG.width);
		}

		bgSprite.screenCenter(XY);
		bgSprite.setGraphicSize(FlxG.width, FlxG.height);
		pastbgSprite.screenCenter(XY);

		var curtimer:Float = 0.3;
		FlxTween.tween(bgSprite, {alpha: 1}, curtimer * 2, {ease: FlxEase.expoInOut});
		FlxTween.tween(pastbgSprite, {alpha: 0}, curtimer * 2, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)",
					'preload')))
				{
					pastbgSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)",
						'preload'));
				}
				else
				{
					FlxG.log.warn('Não foi possível achar '
						+ Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
					pastbgSprite.loadGraphic('assets/images/menuDesat.png');
				}
				new FlxTimer().start(0.15, function(tmr:FlxTimer)
				{
					apertavel = true;
				});
				pastbgSprite.alpha = 1;
			}
		});
		if (!side && executando)
		{
			FlxTween.tween(textoSprite, {x: 0 - textoSprite.width}, curtimer, {
				ease: FlxEase.expoIn,
				onComplete: function(twn:FlxTween)
				{
					if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)",
						'preload')))
					{ // anti crashing moment
						textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)",
							'preload'));
						textoSprite.updateHitbox();
					}
					else
					{
						FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase()
							+ " (txt)");
					}
					textoSprite.x = FlxG.width + textoSprite.width;
					FlxTween.tween(textoSprite, {x: ((FlxG.width - textoSprite.width) / 2)}, curtimer, {ease: FlxEase.expoInOut});
				}
			});
			FlxTween.tween(perfilSprite, {x: 0 - perfilSprite.width}, curtimer, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					if (OpenFlAssets.exists(Paths.imagechecker("scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')))
					{ // anti crashing moment
						perfilSprite.loadGraphic(Paths.image("scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'));
						perfilSprite.updateHitbox();
					}
					else
					{
						FlxG.log.warn('Não foi possível achar ' + "scrolling/artes//scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
					}
					perfilSprite.x = FlxG.width + perfilSprite.width;
					FlxTween.tween(perfilSprite, {x: (FlxG.width - perfilSprite.width) / 2}, curtimer, {ease: FlxEase.expoInOut});
				}
			});
		}
		else if (executando)
		{
			FlxTween.tween(textoSprite, {x: FlxG.width + textoSprite.width}, curtimer, {
				ease: FlxEase.expoIn,
				onComplete: function(twn:FlxTween)
				{
					if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)",
						'preload')))
					{ // anti crashing moment
						textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)",
							'preload'));
						textoSprite.updateHitbox();
					}
					else
					{
						FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase()
							+ " (txt)");
					}
					textoSprite.x = 0 - textoSprite.width;
					FlxTween.tween(textoSprite, {x: ((FlxG.width - textoSprite.width) / 2)}, curtimer, {ease: FlxEase.expoInOut});
				}
			});
			FlxTween.tween(perfilSprite, {x: FlxG.width + perfilSprite.width}, curtimer, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					if (OpenFlAssets.exists(Paths.imagechecker("scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')))
					{ // anti crashing moment
						perfilSprite.loadGraphic(Paths.image("scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'));
						perfilSprite.updateHitbox();
					}
					else
					{
						FlxG.log.warn('Não foi possível achar ' + "scrolling/artes/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
					}
					perfilSprite.x = 0 - perfilSprite.width;
					FlxTween.tween(perfilSprite, {x: ((FlxG.width - perfilSprite.width) / 2)}, curtimer, {ease: FlxEase.expoInOut});
				}
			});
		}
		new FlxTimer().start(curtimer * 2 + 0.01, function(tmr:FlxTimer)
		{
			if (!executando)
			{
				executando = true;
				textoSprite.y = FlxG.height + textoSprite.height;
				textoSprite.screenCenter(X);
				perfilSprite.screenCenter(X);
				perfilSprite.y = -FlxG.height;
				entrada();
			}
		});
	}
}
