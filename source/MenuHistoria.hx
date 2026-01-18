package;

import flixel.graphics.FlxGraphic;
import flixel.FlxCamera;
import Achievements.AchievementObject;
import LoadingState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;
import flixel.text.FlxText;
import flixel.math.FlxMath;

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

	var vhsSom:FlxSound; //usar isso daqui provavelmente deve evitar alguma coisa... enfim, copiei o Silver

	var subindo:Bool = true;
	var canceltweens:Bool = false;
	var musicas:Array<Dynamic> = [];
	var nombres:Array<Dynamic> = [];
	var update_rpc:Bool = true;

	public static var modifiersOpened:Bool = false;


	
	public var camAchievement:FlxCamera;

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

	public var numText:FlxText;
	public var highscoreText:FlxText;

	var intendedMultiplier:Float = 1;
	var lerpMultiplier:Float = 1;
	
	var intendedScore:Int = 0;
	var lerpScore:Int = 0;

	public static var instance:MenuHistoria;

	var canOpenModifiers:Bool = false;

	var skipFirstTrans:Bool = false;

	public override function new(?skipFirstTrans:Bool = false) {
		this.skipFirstTrans = skipFirstTrans;

		super();
	}


	override function create()
	{
		if(instance == null){instance=this;}
		FlxTransitionableState.skipNextTransOut = true;
		applySave();
		update_rpc = true;
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		}
		if (FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		vhsSom = new FlxSound().loadEmbedded(Paths.sound('vhs_entra'));
		vhsSom.volume = 2;

		var leWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
		for (j in 0...leWeek.songs.length)
		{
			musicas.push(leWeek.songs[j][0]);
			nombres.push(leWeek.songs[j][3]);
		}

		Main.mouse_allowed = true;
		if (curSelected >= WeekData.weeksList.length)
			curSelected = 0;
		persistentUpdate = persistentDraw = true;

		
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		FlxG.cameras.add(camAchievement, false);

		pastbgSprite = new FlxSprite(0, 0);
		pastbgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		bgSprite = new FlxSprite(0, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		textoSprite = new FlxSprite().loadGraphic(Paths.image('nota_invisivel', 'preload'));
		textoSprite.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('nota_invisivel', 'preload'));
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));

		lockSprite = new FlxSprite(0, 0);
		lockSprite.loadGraphic(Paths.image("Story_Mode/lock", 'preload'));
		lockSprite.screenCenter(XY);
		lockSprite.antialiasing = ClientPrefs.globalAntialiasing;
		lockSprite.alpha = 0;

		blackLock = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackLock.alpha = 0;

		numText = new FlxText(FlxG.width - 225, FlxG.height-690, 200);
		numText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 25, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		numText.borderSize = 2;
		numText.text = Std.string(curSelected+1)+"/"+Std.string(musicas.length);
		numText.updateHitbox();
		numText.alpha=0;

		highscoreText = new FlxText(FlxG.width -1250, FlxG.height -690, 600);
		highscoreText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		highscoreText.borderSize = 2;
		highscoreText.text = Linguagem.LangUtil.getString("label_high_score", "data")+ " \n0";
		highscoreText.updateHitbox();
		highscoreText.alpha=0;

		var leText:String = "Aperte " + #if desktop "CTRL" #else "Y" #end + " para abrir o menu de modifiers.";
		//space ou algum outro botão ainda a ser programado para ouvir uma prévia da musica.
		var text:FlxText = new FlxText(-200 - 578 + 753, FlxG.height - 40, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();

		add(bgSprite);
		add(pastbgSprite);
		add(perfilSprite);
		add(textoSprite);
		add(numText);
		add(highscoreText);
		//add(text);
		add(blackLock);
		add(lockSprite);

		changeSong(0, false, skipFirstTrans);

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
		
		new FlxTimer().start(2, function(tmr:FlxTimer) {
            canOpenModifiers = true;
		});
	}

	function test_unlock(achieve:String){
		#if ACHIEVEMENTS_ALLOWED
		var achieveID:Int = Achievements.getAchievementIndex(achieve);
		if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][0])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
			ClientPrefs.achievementsMap.set(Achievements.achievementsStuff[achieveID][0], true);
			giveAchievement(achieve);
			ClientPrefs.save();
		}
		#end
		return;
	}

	public function closeModifiers(substate:MusicBeatSubstate)
		{
			modifiersOpened = false;
			substate.close();
			update_rpc = true;
		}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement(achievementname) {
		add(new AchievementObject(achievementname, camAchievement));
		GlobalSoundManager.play(confirmMenu);
		trace('Giving achievement '+ achievementname);
	}
	#end

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
		if (!selectedWeek && update_rpc)
		{
			DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_story_mode_normal","rpc")+" ", 
			Linguagem.LangUtil.getString("rpc_week_label_"+dapreselected.toLowerCase(),"rpc"), null);
		}
		#end

		/*trace("APERTAVEL:"+apertavel);
		trace("MODIFIERS OPENED:"+modifiersOpened);*/
		lerpMultiplier = FlxMath.lerp(lerpMultiplier, intendedMultiplier, CoolUtil.boundTo(elapsed * 12, 0, 2));
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		highscoreText.text = Linguagem.LangUtil.getString("label_high_score", "data")+" \n"+ ( ProgressionUtil.terminouTudo() ? Math.round(lerpMultiplier*100)/100+  "X " : "") +Std.string(lerpScore);

		if (Math.abs(lerpMultiplier - intendedMultiplier) <= 0.001)
			lerpMultiplier = intendedMultiplier;

		if (textoSpriteTweens != null)
			textoSpriteTweens.active = true;
		var crossplataforma = #if desktop FlxG.keys.justPressed.CONTROL #elseif mobileC mobile.ui.FlxVirtualPad.instance.buttonX.justPressed #end;

		if(crossplataforma && !modifiersOpened && !movedBack && !selectedWeek && canOpenModifiers && MainMenuStateMobile.passouCY #if !debug && ProgressionUtil.terminouTudo() #end) {
			modifiersOpened = true;
			update_rpc = false;
			openSubState(new modifiers.ModifiersMenuState(false));
		}

		if (!movedBack && !selectedWeek && !modifiersOpened)
		{
			if (Main.getMouseVisibility()){
				//Deixar só pro mobile depois
				#if desktop
				if(FlxG.mouse.wheel != 0 && apertavel){
					changeSong(CoolUtil.mathClamp(FlxG.mouse.wheel,-1,1), CoolUtil.mathClamp(FlxG.mouse.wheel,-1,1)==-1);
					GlobalSoundManager.play(scrollMenu);
				}
				#end
			}
			if (controls.UI_LEFT_P && apertavel && musicas.length > 1) // MALUCO EU SOU MUITO BURRO...
				// Consegui cometer o mesmo erro duas vezes seguidas...
			{
				changeSong(-1, true);
				GlobalSoundManager.play(scrollMenu);
			}

			if (controls.UI_RIGHT_P && apertavel && musicas.length > 1)
			{
				changeSong(1, false);
				GlobalSoundManager.play(scrollMenu);
			}

			if (controls.BACK && !movedBack && !selectedWeek && apertavel && !naopodevoltar)
			{
				modifiersOpened = false;
				apertavel = false;
				FlxTween.tween(numText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(highscoreText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(perfilSprite, {alpha: 0}, 1.0, {ease: FlxEase.expoInOut});
				FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {
					ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						MenuPreHistoria.instance.changeWeek();
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
					FlxG.sound.music.volume = 0;
					Paths.currentModDirectory = musicas[curSelected].folder;
					var poop:String = Highscore.formatSong(musicas[curSelected].toLowerCase(), 2);
					PlayState.SONG = Song.loadFromJson(poop, musicas[curSelected].toLowerCase());
					if (PlayState.SONG.needsVoices)
						vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
					else
						vocals = new FlxSound();

					FlxG.sound.list.add(vocals);
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7, false);
					FlxG.sound.music.onComplete = finishSong;
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

	private function finishSong():Void
	{
		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectSong(toPlay:Bool)
	{
		if (stopspamming == false)
		{
			vhsSom.play(true);
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
			&& nombres[curSelected] != 'Cross Console Clash')
		{
			MenuPreHistoria.old_bg.alpha = 0;
			bgSprite.alpha = 0;
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);

			PlayState.storyDifficulty = 2;
			PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
			FlxTween.tween(numText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(highscoreText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(perfilSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
			FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(pastbgSprite, {alpha: 0}, 1.0, {ease: FlxEase.linear});
				}
			});

			// Nesse eu não vou mexer, tô com medo de ferrar alguma coisa.
			if (toPlay && nombres[curSelected] != 'Noite da Rapaziada')
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (PlayState.SONG.videonombre != null && PlayState.SONG.videonombre.length > 5)
					{
						#if desktop
						VideoStatePC.NextState = new PlayState();
						VideoStatePC.specialSetting = NORMAL;
						PlayState.limparCache = true;
						VideoStatePC.videoPath = Paths.video(PlayState.SONG.videonombre);
						MusicBeatState.switchState(new VideoStatePC());
						#elseif mobile
						LoadingState.loadAndSwitchState(new VideoState('assets/videos/' + PlayState.SONG.videonombre, new PlayState()));
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
			else if (nombres[curSelected].toLowerCase() == 'noite da rapaziada')
			{
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.music.volume = 0;
				naopodevoltar = true;
				apertavel = false;
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new PastaNightSelect());
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
		else if (nombres[curSelected].toLowerCase() == 'cross console clash')
		{
			#if rpc
			DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_story_mode_ccc","rpc"), "Cross Console Clash", null);
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
	}

	function tweenpracima()
	{
		textoSpriteTweens = FlxTween.tween(textoSprite, {y: perfilSprite.height + perfilSprite.y + 5}, 1.5/(ClientPrefs.animSpeed - 0.25), {
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
		textoSpriteTweens = FlxTween.tween(textoSprite, {y: FlxG.height - textoSprite.height * 1.2}, 1.5/(ClientPrefs.animSpeed - 0.25), {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				if (!canceltweens)
					tweenpracima();
			}
		});
	}

	function entrada(?onComplete:Void->Void, ?skipTrans:Bool = false):Void
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
						textoSprite.loadGraphic(check_locale(pasta,  musicas[curSelected]));
						textoSprite.updateHitbox();
						textoSprite.screenCenter(X);
						tweenpracima();
					}
				});
				FlxTween.tween(numText, {alpha: 1}, 0.65, {ease: FlxEase.quartInOut});
				FlxTween.tween(highscoreText, {alpha: 1}, 0.65, {ease: FlxEase.quartInOut});
			}
		});
		var songLowerCase:String = Paths.formatToSongPath(musicas[curSelected]);
		highscoreText.text = "HIGHSCORE: \n"+Std.string(Highscore.getScore(songLowerCase, 2));

		if (onComplete != null) onComplete();
	}

	public function changeSong(change:Int = 0, side:Bool = false, ?skipTrans:Bool = false):Void
	{
		apertavel = false;
		curSelected += change;
		if (curSelected < 0)
			curSelected = musicas.length - 1;
		if (curSelected >= musicas.length)
			curSelected = 0;
		var songLowerCase:String = Paths.formatToSongPath(musicas[curSelected]);
		intendedScore = Highscore.getScore(songLowerCase, 2);
		intendedMultiplier = Highscore.getMultiplier(songLowerCase, 2);
		numText.text = Std.string(curSelected+1)+"/"+Std.string(musicas.length);

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

		var curtimer:Float = skipTrans ? 0.001 : 0.3;

		if (skipTrans) {
			bgSprite.alpha = 1;
			pastbgSprite.alpha = 0;
		}

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
					textoSprite.loadGraphic(check_locale(assetName,  musicas[curSelected]));
					textoSprite.updateHitbox();
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
					textoSprite.loadGraphic(check_locale(assetName,  musicas[curSelected]));
					textoSprite.updateHitbox();
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

				entrada(null, skipTrans);
			}
		});
	}

	private function check_locale(assetName:String, key:String):FlxGraphic
	{
		if (OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + key.toLowerCase() + " (txt)",'locales',true)))
		{ // anti crashing moment
			return Paths.image("scrolling/scroll-" + assetName + "/scroll-" + key.toLowerCase() + " (txt)",'locales',true,true);
		}else
			return Paths.image("scrolling/scroll-" + assetName + "/scroll-" + key.toLowerCase() + " (txt)");
	}

	public function returnFromCCC(){
		entrada(function() {
			naopodevoltar = false;
			apertavel = true;
			persistentUpdate = true;
			selectedWeek = false;
		});
	}
}
