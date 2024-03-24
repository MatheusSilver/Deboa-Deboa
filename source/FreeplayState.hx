package;

import LoadingState.LoadingsState;
import Utils.BSLSwipeUtils;
import Utils.BSLTouchUtils;
import WeekData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gamejolt.*;
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

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	public static var justread:String = ''; // Provavelmente tinha solução melhor mas né? É só uma string poh.
	private static var curSelected:Int = 0;
	public static var infoextended:String = '';
	public static var weekNombre:String = '';

	var apertavel:Bool = false;
	var disc:FlxSprite = new FlxSprite(0, 0);

	var scoreText:FlxText;
	var lerpMultiplier:Float = 1;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedMultiplier:Float = 1;
	var intendedRating:Float = 0;

	public static var instance:FreeplayState;
	private var grpSongs:FlxTypedGroup<Alphabet>;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var perfilSprite:FlxSprite = null;
	var outroperfilSprite:FlxSprite = null; // Fuuuuuuuuuuuuuuuuuuuuuuu

	public static var progressFreeplay:Int = 1;
	public static var modifiersOpened:Bool = false;

	public static function addProgress()
	{
		trace("curSelected: " + Std.string(curSelected) + "\nprogressFreeplay: " + Std.string(progressFreeplay) + "\nweekLength: " + Std.string(9));
		if (progressFreeplay < 9) {
			if (curSelected + 1 == progressFreeplay) {
				progressFreeplay++;
				GameJoltLoginState.syncProgressFreeplay();
			}
		}
	}

	override function create()
	{
		if (instance == null) { instance = this; }

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		if (FlxG.save.data.freeplayProgress != null) { progressFreeplay = FlxG.save.data.freeplayProgress; }
		else { FlxG.save.data.freeplayProgress = progressFreeplay; }
	
		firstTime = true;
		WeekData.reloadWeekFiles(true); // note for future silver
		// Este code, SEMPRE, deve ser colocado quando não se utiliza 'dapreselected', ele é quem carrega as weeks.

		apertavel = false;
		BSLSwipeUtils.resetScrolls();
		Main.mouse_allowed = true;

		#if rpc DiscordClient.changePresence(LangUtil.getString("rpc_freeplay", "rpc"), null); #end

		for (i in 0...WeekData.freeplayList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.freeplayList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];
			var leNombres:Array<String> = [];
			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
				leNombres.push(leWeek.songs[j][3]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)	colors = [146, 113, 253];
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), song[3]);
			}
		}
		WeekData.setDirectoryFromWeek();

		bg = new FlxSprite().loadGraphic(Paths.image('Freeplay/menu/bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(FlxG.width, FlxG.height);
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		var borda:FlxSprite = new FlxSprite().loadGraphic(Paths.image('top_icons/freeplay', "locales", true, true));
		borda.antialiasing = ClientPrefs.globalAntialiasing;
		#if debug progressFreeplay = songs.length; #end

		BSLSwipeUtils.max_y = Std.int(FlxG.width / (progressFreeplay));
		BSLSwipeUtils.mouseScrollMultiplier = 1;
		BSLSwipeUtils.reset_manual = false;

		for (i in 0...progressFreeplay) {
			var songText:Alphabet = new Alphabet(0, (70 * i), songs[i].display.toLowerCase(), false, false, 0.05, 0.7, 'alfabetovio');
			songText.isMenuTrem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter); // Eu fiquei um tempo tentando entender isso... enfim, mais trabalho
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
			songText.x = 600;
		}

		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(15, 15, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		add(borda);
		add(scoreText);

		if (curSelected >= songs.length)	curSelected = 0;

		var leText:String = LangUtil.getStringArray("label_play_sample", "data", [#if desktop "Espaço" #else "X" #end, #if desktop "CTRL" #else "Y" #end]);
		// space ou algum outro botão ainda a ser programado para ouvir uma prévia da musica.
		var text:FlxText = new FlxText(-200 - 578 + 753, FlxG.height - 40, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		disc.loadGraphic(Paths.image("freeplay-disc/disco", 'preload'));
		disc.x = (FlxG.width - 460) / 2 - 250; // Bem vindo a turma de matemática avançada
		add(disc);
		perfilSprite = new FlxSprite(0, 0);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(perfilSprite);
		outroperfilSprite = new FlxSprite(0, 0);
		outroperfilSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(outroperfilSprite);
		outroperfilSprite.alpha = 0;
		perfilSprite.alpha = 0;
		disc.screenCenter(Y);
		perfilSprite.screenCenter(Y);
		outroperfilSprite.screenCenter(Y);
		disc.x = 38;
		disc.x = disc.x - 82.5;
		perfilSprite.x = 18 + 38;
		perfilSprite.alpha = 0;
		outroperfilSprite.alpha = 0;
		outroperfilSprite.x = 18 + 38;

		changeSelection(true);

		new FlxTimer().start(0.3, function(tmr:FlxTimer) { apertavel = true; });

		// Ordem importa
		#if mobileC addVirtualPad(FULL, A_B_X_Y); #end
		super.create();
	}

	override function closeSubState() {
		changeSelection();
		super.closeSubState();
	}

	private function cd_spin()
	{
		FlxTween.tween(disc, {angle: disc.angle + 180}, 30, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) { cd_spin(); }
		});
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, display:String) {
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, display));
	}

	public function closeModifiers(substate:MusicBeatSubstate)
	{
		substate.close();
		apertavel = true;
		modifiersOpened = false;
		#if rpc DiscordClient.changePresence(LangUtil.getString("rpc_freeplay", "rpc"), null); #end
	}

	var instPlaying:Int = -1;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		perfilSprite.angle = disc.angle;
		outroperfilSprite.angle = disc.angle;

		if (FlxG.sound.music == null)	FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		if (FlxG.sound.music.volume < 0.7)	FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		#if debug
		if (FlxG.keys.justPressed.SEVEN)
		{
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), 2);
			if (!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop)))
			{
				poop = songLowercase;
				trace('Couldnt find file');
			}
			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			MusicBeatState.switchState(new editors.ChartingState());
		}
		#end

		lerpMultiplier = FlxMath.lerp(lerpMultiplier, intendedMultiplier, CoolUtil.boundTo(elapsed * 12, 0, 2));
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)	lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)	lerpRating = intendedRating;
		if (Math.abs(lerpMultiplier - intendedMultiplier) <= 0.001)	lerpMultiplier = intendedMultiplier;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if (ratingSplit.length < 2)	ratingSplit.push('');
		while (ratingSplit[1].length < 2)	ratingSplit[1] += '0';

		scoreText.text = LangUtil.getString("label_high_score", "data") + ' (' + Math.round(lerpMultiplier * 100) / 100 + "X) " + lerpScore + ' (' + ratingSplit.join('.') + '%)';

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = #if desktop FlxG.keys.justPressed.SPACE #elseif mobileC ui.FlxVirtualPad.instance.buttonX.justPressed #end;
		var ctrl = #if desktop FlxG.keys.justPressed.CONTROL #elseif mobileC ui.FlxVirtualPad.instance.buttonY.justPressed #end;


		if (!Main.getMouseVisibility() && apertavel) {
			if (upP) {
				GlobalSoundManager.play(scrollMenu);
				changeSelection(-1);
			}
			if (downP) {
				GlobalSoundManager.play(scrollMenu);
				changeSelection(1);
			}
		}
		else if (apertavel) {
			BSLSwipeUtils.swipeVertical();
			for (songText in grpSongs.members)
			{
				if (BSLTouchUtils.solto(songText) && songText.targetY == 0 && !BSLSwipeUtils.is_swipping) accepted = true;
				else if (BSLTouchUtils.solto(songText) && !BSLSwipeUtils.is_swipping) changeSelection(Std.int(songText.targetY));
			}
			if (Math.abs(change_swipe) <= Math.abs(BSLSwipeUtils.scrollY) && BSLSwipeUtils.scrollY != 0) change_swipe = -BSLSwipeUtils.scrollY;
			else if (change_swipe != 0) changeSelection(true);
		}
		if (ctrl && !modifiersOpened && apertavel && MainMenuStateMobile.passouCY) {
			apertavel = false;
			modifiersOpened = true;
			openSubState(new modifiers.ModifiersMenuState(true));
		}
		if (controls.BACK && apertavel) {
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
		if (space && instPlaying != curSelected && apertavel) {
			Paths.currentModDirectory = songs[curSelected].folder;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songs[curSelected].songName, 2);
			if (!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				poop = songLowercase;
				trace('Couldnt find file');
			}
			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7, false);
			FlxG.sound.music.onComplete = finishSong;
			instPlaying = curSelected;
		}
		else if (accepted && apertavel) {
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			infoextended = songs[curSelected].display;
			var poop:String = Highscore.formatSong(songLowercase, 2);
			if (!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				poop = songLowercase;
				trace('Couldnt find file');
			}
			trace(poop);

			weekNombre = WeekData.freeplayList[songs[curSelected].week]; // Array dentro de array dentro de array k
			trace(weekNombre);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;
			PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();

			justread = songs[curSelected].songName;
			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
				openSubState(new LoadingsState());
			});
			if (ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 1.5);
			new FlxTimer().start(2.0, function(tmr:FlxTimer) {
				LoadingState.loadAndSwitchState(new PlayState());
				PlayState.limparCache = true;
			});

			FlxG.sound.music.volume = 0;
		}
	}

	private function finishSong():Void {
		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}

	private var change_swipe:Int = 0;
	private var firstTime:Bool = true;

	function changeSelection(change:Int = 0, ?swipping:Bool = false) {
		if (change_swipe != 0) {
			change = Std.int(Math.abs(change_swipe) / change_swipe);
			change_swipe -= change;
		}
		if (!swipping || change_swipe == 0) apertavel = false;
		curSelected += change;

		if (curSelected < 0)	curSelected = progressFreeplay - 1;
		if (curSelected >= progressFreeplay)	curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, 2);
		intendedRating = Highscore.getRating(songs[curSelected].songName, 2);
		intendedMultiplier = Highscore.getMultiplier(songs[curSelected].songName, 2);
		#end

		var bullShit:Int = 0;
		for (i in 0...iconArray.length) {
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;
		for (item in grpSongs.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.4;

			if (item.targetY == 0) item.alpha = 1;
		}
		Paths.currentModDirectory = songs[curSelected].folder;
		var curtimer:Float = 0.3;

		if (!apertavel) {
			FlxTween.tween(outroperfilSprite, {alpha: 0}, curtimer, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					if (OpenFlAssets.exists(Paths.imagechecker("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'))) { // anti crashing moment
						outroperfilSprite.loadGraphic(Paths.image("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'));
						outroperfilSprite.updateHitbox();
						outroperfilSprite.screenCenter(Y);
						outroperfilSprite.alpha = 1;
						outroperfilSprite.scale.x = 1.05;
						outroperfilSprite.scale.y = 1.05;
					} else {
						FlxG.log.warn('Não foi possível achar ' + "freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase());
					}
				}
			});
			if (OpenFlAssets.exists(Paths.imagechecker("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'))) { // anti crashing moment
				perfilSprite.loadGraphic(Paths.image("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'));
				perfilSprite.updateHitbox();
				perfilSprite.screenCenter(Y);
				perfilSprite.alpha = 0;
				perfilSprite.scale.x = 1.05;
				perfilSprite.scale.y = 1.05;
			} else {
				FlxG.log.warn('Não foi possível achar ' + "freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase());
			}
			FlxTween.tween(perfilSprite, {alpha: 1}, curtimer, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					perfilSprite.alpha = 0;
					apertavel = true;
					if (firstTime) {
						cd_spin();
						firstTime = false;
					}
				}
			});
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var display:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int, display:String) {
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.display = display;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if (this.folder == null) this.folder = '';
	}
}
