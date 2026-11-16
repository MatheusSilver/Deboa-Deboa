package;

import LoadingState.LoadingsState;
import BSLTouchUtils.BSLSwipeUtils;
import BSLTouchUtils;
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
import ui.FlxTextWithIcons;

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
	var alreadyInitialized:Bool = false;

	public static var instance:FreeplayState;
	private var grpSongs:FlxTypedGroup<Alphabet>;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var perfilSprite:FlxSprite = null;
	var outroPerfilSprite:FlxSprite = null; // Fuuuuuuuuuuuuuuuuuuuuuuu

	public static var progressFreeplay:Int = 1;
	public static var modifiersOpened:Bool = false;

	var textWithIcon:FlxTextWithIcons;

	public static function addProgress()
	{
		trace("curSelected: " + Std.string(curSelected) + "\nprogressFreeplay: " + Std.string(progressFreeplay) + "\nweekLength: " + Std.string(9));
		if (progressFreeplay <= 9) {
			if (curSelected + 1 == progressFreeplay) {
				progressFreeplay++;
				GameJoltLoginState.syncProgressFreeplay();
			}
		}
	}

	override function create()
	{
		instance = this;

		alreadyInitialized = false;

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

		#if rpc DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_freeplay", "rpc"), null); #end

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

		var musicasVisiveis:Int = ProgressionUtil.musicasLiberadas() ? songs.length : progressFreeplay;
		BSLSwipeUtils.max_y = Std.int(FlxG.width / (musicasVisiveis));
		BSLSwipeUtils.mouseScrollMultiplier = 1;
		BSLSwipeUtils.reset_manual = false;

		for (i in 0...musicasVisiveis) {
			if(i >= songs.length)
				break;
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


		disc.loadGraphic(Paths.image("freeplay-disc/disco", 'preload'));
		disc.updateHitbox();
		disc.x = (FlxG.width) / 2 - disc.width * 1.1;
		disc.screenCenter(Y);
		add(disc);
		perfilSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("freeplay-disc/disco", 'preload'));
		perfilSprite.updateHitbox();
		perfilSprite.setPosition(disc.x, disc.y);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(perfilSprite);
		outroPerfilSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("freeplay-disc/disco", 'preload'));
		outroPerfilSprite.updateHitbox();
		outroPerfilSprite.setPosition(disc.x, disc.y);
		outroPerfilSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(outroPerfilSprite);
		outroPerfilSprite.alpha = 0;
		perfilSprite.alpha = 0;

		
		changeSelection(true);

		// AAAAAAAA
		#if mobileC
		addVirtualPad(NONE, X_Y);
		#end

		if(ProgressionUtil.terminouFreeplay() && !ClientPrefs.modifiersPopUp) {
			ClientPrefs.modifiersPopUp = true;
			ClientPrefs.save();
			openSubState(new PopUpSubState("modifier_unlock", "modifier_unlock", null, function() {
				closeSubState();
			}));
		}

		/*var leText:String = Linguagem.LangUtil.getStringArray("label_play_sample", "data", [#if desktop Linguagem.LangUtil.getString("key_label_space", "data") #else "X" #end]) + (ClientPrefs.modifiersPopUp ? ", " + Linguagem.LangUtil.getStringArray("label_play_sample_modifiers", "data", [#if desktop "CTRL" #else "Y" #end]) : "");
		// space ou algum outro botão ainda a ser programado para ouvir uma prévia da musica.
		var text:FlxText = new FlxText(-200 - 578 + 753, FlxG.height - 40, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);*/

		var leText:String = ClientPrefs.modifiersPopUp ? Linguagem.LangUtil.getStringArray("label_play_sample", "data", ["[X/SPACE]"]) + ", " + Linguagem.LangUtil.getStringArray("label_play_sample_modifiers", "data", ["[Y/CONTROL]"]) : Linguagem.LangUtil.getStringArray("label_play_sample", "data", ["[X/SPACE]"]);
		textWithIcon = new FlxTextWithIcons(leText, "vcr", true);
		textWithIcon.y = FlxG.height - textWithIcon.height - 62;
		textWithIcon.x = -529.1 * (textWithIcon.width/1154);
		//textWithIcon.scale.set(0.8, 0.8);
		add(textWithIcon);

		super.create();
	}

	override function closeSubState() {
		changeSelection();
		super.closeSubState();
	}

	var cdSpinTween:FlxTween;
	private function cd_spin()
	{
		cdSpinTween = FlxTween.tween(disc, {angle: disc.angle + 180}, 30, {
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
		if (cdSpinTween != null) {
			cdSpinTween = FlxTween.tween(disc, {angle: disc.angle + 180}, 30, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween) { cd_spin(); }
			});
		}
		#if rpc DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_freeplay", "rpc"), null); #end
	}

	var instPlaying:Int = -1;
	var previewSong:String = null;
	var songChosen:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (alreadyInitialized){
			perfilSprite.angle = disc.angle;
			outroPerfilSprite.angle = disc.angle;
		}

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

		scoreText.text = Linguagem.LangUtil.getString("label_high_score", "data") + (ProgressionUtil.terminouTudo() ? ' (' + Math.round(lerpMultiplier * 100) / 100 + "X) " : "") + lerpScore + ' (' + ratingSplit.join('.') + '%)';

		var upP = controls.UI_UP;
		var downP = controls.UI_DOWN;
		var accepted = controls.ACCEPT;
		var space = #if desktop FlxG.keys.justPressed.SPACE #elseif mobileC mobile.ui.FlxVirtualPad.instance.buttonX.justPressed #end || GamepadUtil.checkGamepadPressedButton(2);
		var ctrl = #if desktop FlxG.keys.justPressed.CONTROL #elseif mobileC mobile.ui.FlxVirtualPad.instance.buttonY.justPressed #end || GamepadUtil.checkGamepadPressedButton(3);


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
		if (ctrl && !modifiersOpened && apertavel && MainMenuStateMobile.passouCY #if !debug && ProgressionUtil.terminouTudo() #end) {
			apertavel = false;
			modifiersOpened = true;
			if (cdSpinTween != null) {
				cdSpinTween.cancel();
			}
			openSubState(new modifiers.ModifiersMenuState(true));
		}
		if ((controls.BACK #if android || FlxG.android.justReleased.BACK #end) && apertavel) {
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new MainMenuStateMobile());
			if (cdSpinTween != null) {
				cdSpinTween.cancel();
			}
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
			Paths.forgetSongAudio(previewSong);
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7, false);
			FlxG.sound.music.onComplete = finishSong;
			instPlaying = curSelected;
			previewSong = PlayState.SONG.song;
		}
		else if (accepted && apertavel) {
			apertavel = false;
			songChosen = true;
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
			PlayState.modohistoria = false;
			PlayState.storyDifficulty = 2;
			PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
			SongPreloader.start(PlayState.SONG);

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

		if (curSelected < 0)	curSelected = grpSongs.length - 1;
		if (curSelected >= grpSongs.length)	curSelected = 0;

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
		
		if (firstTime)
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				tweenDiscs();
			});
		else
			tweenDiscs();
	}
		
		
	private function tweenDiscs(){
		final curtimer:Float = 0.3;
		if (!apertavel) {
			FlxTween.tween(outroPerfilSprite, {alpha: 0}, curtimer, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					if (OpenFlAssets.exists(Paths.imagechecker("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'))) { // anti crashing moment
						outroPerfilSprite.loadGraphic(Paths.image("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'));
						outroPerfilSprite.updateHitbox();
						outroPerfilSprite.alpha = 1;
					} else {
						FlxG.log.warn('Não foi possível achar ' + "freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase());
					}
				}
			});
			if (OpenFlAssets.exists(Paths.imagechecker("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'))) { // anti crashing moment
				perfilSprite.loadGraphic(Paths.image("freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase(), 'preload'));
				perfilSprite.updateHitbox();
				perfilSprite.alpha = 0;
			} else {
				FlxG.log.warn('Não foi possível achar ' + "freeplay-disc/disc-" + songs[curSelected].songName.toLowerCase());
			}
			FlxTween.tween(perfilSprite, {alpha: 1}, curtimer, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					perfilSprite.alpha = 0;
					if (!songChosen)
						apertavel = true;
					if (firstTime) {
						firstTime = false;
						alreadyInitialized = true;
						cd_spin(); 
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
