package;

import LoadingState.LoadingsState;
import WeekData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxState;

using StringTools;
#if rpc
import Discord.DiscordClient;
#end

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	public static var nooptions:Bool = false;

	public static var justread:String =''; //Provavelmente tinha solução melhor mas né? É só uma string poh.

	var selector:FlxText;
	private static var curSelected:Int = 0;
	private static var canSelect:Bool = false;
	private static var curDifficulty:Int = 2;
	public static var infoextended:String = '';
	var engrenagem:FlxButton;
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
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	

	var bg:FlxSprite;
	var perfilSprite:FlxSprite = null;
	var outroperfilSprite:FlxSprite = null; //Fuuuuuuuuuuuuuuuuuuuuuuu

	// fps fix stuff
	// Eu acho, mas acho que isso tá dando um pouco de problema no PC/Android
	private var UPDATE_INTERVAL:Float = 1.0 / 60.0; 
    private var timeAccumulated:Float = 0.0;

	public static var progressFreeplay:Int = 1;
	public static var totalMusicas:Int = 9;

	public static var modifiersOpened:Bool = false;

	public static function addProgress()
	{
		trace("curSelected: "+Std.string(curSelected)+"\nprogressFreeplay: "+Std.string(progressFreeplay)+"\nweekLength: "+ Std.string(totalMusicas));
		if(progressFreeplay < totalMusicas)
		{
			if(curSelected+1 == progressFreeplay)
			{
				progressFreeplay++;
				GameJoltLoginState.syncProgressFreeplay();
			}
		}
	}
	
	override function create()
	{
		if(instance == null){instance=this;}
		if(FlxG.save.data.freeplayProgress != null)
		{
			progressFreeplay = FlxG.save.data.freeplayProgress;
		}
		else
		{
			FlxG.save.data.freeplayProgress = progressFreeplay;
		}
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		WeekData.reloadWeekFiles(true); //note for future silver 
		//Este code, SEMPRE, deve ser colocado quando não se utiliza 'dapreselected', ele é quem carrega as weeks.

		apertavel = false;

		//WeekData.reloadWeekFiles(false);
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_freeplay", "rpc"), null);
		#end

		
		//FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));
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
			for (song in leWeek.songs) {
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3) {
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), song[3]);
			}
		}
		WeekData.setDirectoryFromWeek();

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('Freeplay/menu/bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(FlxG.width, FlxG.height);
		add(bg);
		Main.mouse_allowed = false;
		//Todos os lugares que tem esse trem do mouse devem ter uma restrição #ifmobile.

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		var borda:FlxSprite = new FlxSprite().loadGraphic(Paths.image('top_icons/freeplay', "locales", true, true));
		borda.antialiasing = ClientPrefs.globalAntialiasing;
		
		for (i in 0...progressFreeplay)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i), songs[i].display.toLowerCase(), false, false, 0.05, 0.7, 'alfabetovio');
			songText.isMenuTrem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
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
		
		if(curSelected >= songs.length) curSelected = 0;

		var leText:String = LangUtil.getStringArray("label_play_sample", "data", [#if desktop "Espaço" #else "X" #end, #if desktop "CTRL" #else "Y" #end]);
		//space ou algum outro botão ainda a ser programado para ouvir uma prévia da musica.
		var text:FlxText = new FlxText(-200 - 578 + 753, FlxG.height - 40, FlxG.width, leText, 18);
		text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		disc.loadGraphic(Paths.image("freeplay-disc/disco", 'preload')); 
		disc.x = (FlxG.width - 460) / 2 - 250; //Bem vindo a turma de matemática avançada
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
		disc.x=disc.x-82.5;
		perfilSprite.x = 18 + 38;
		perfilSprite.alpha = 0;
		outroperfilSprite.alpha = 0;
		outroperfilSprite.x = 18 + 38;

		changeSelection(true);

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			apertavel = true;
		});

		// Ordem importa
		#if mobileC
		addVirtualPad(FULL, A_B_X_Y);
		#end
		
		super.create();
	}

	override function closeSubState() {
		changeSelection();
		super.closeSubState();
	}

	private function cd_spin()
	{
			FlxTween.tween(disc, {angle: disc.angle+180}, 30, {ease: FlxEase.linear,
				onComplete: function(twn:FlxTween) {
					cd_spin();
				}
			});
	}

	public function addSong(songName:String,weekNum:Int, songCharacter:String, color:Int, display:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, display));
	}

	public function closeModifiers(substate:MusicBeatSubstate)
	{
		substate.close();
		apertavel = true;
		modifiersOpened = false;
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_freeplay", "rpc"), null);
		#end
	}

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{

		super.update(elapsed);
		perfilSprite.angle = disc.angle;
		outroperfilSprite.angle = disc.angle;

		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		}
		
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		#if debug
		if (FlxG.keys.justPressed.SEVEN){
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				poop = songLowercase;
				curDifficulty = 2;
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

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;
		if (Math.abs(lerpMultiplier - intendedMultiplier) <= 0.001)
			lerpMultiplier = intendedMultiplier;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) {
			ratingSplit.push('');
		}

		while(ratingSplit[1].length < 2) {
			ratingSplit[1] += '0';
		}

		scoreText.text = LangUtil.getString("label_high_score", "data")+' ('+Math.round(lerpMultiplier*100)/100+"X) " + lerpScore + ' (' + ratingSplit.join('.') + '%)';

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = #if desktop FlxG.keys.justPressed.SPACE #elseif mobileC ui.FlxVirtualPad.instance.buttonX.justPressed #end;
		var ctrl = #if desktop FlxG.keys.justPressed.CONTROL #elseif mobileC ui.FlxVirtualPad.instance.buttonY.justPressed #end;
		

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (upP && apertavel)
		{
			changeSelection(-shiftMult);
		}
		if (downP && apertavel)
		{
			changeSelection(shiftMult);
		}

		if(ctrl && !modifiersOpened && apertavel && MainMenuStateMobile.passouCY) {
			//modifiers.ModifiersMenuState.freeplay = true;
			apertavel = false;
			modifiersOpened = true;
			openSubState(new modifiers.ModifiersMenuState(true));
		}


		if (controls.BACK && apertavel)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new MainMenuStateMobile());
		}

		if(space && instPlaying != curSelected && apertavel)
		{
			destroyFreeplayVocals();
			Paths.currentModDirectory = songs[curSelected].folder;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songs[curSelected].songName, curDifficulty);
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				poop = songLowercase;
				curDifficulty = 2;
				trace('Couldnt find file');
			}
			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);

			// Modboa com vozes :scary:
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
		}
		else if (accepted && apertavel)
			{
				persistentUpdate = false;
				var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
				infoextended = songs[curSelected].display;
				var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					poop = songLowercase;
					curDifficulty = 2;
					trace('Couldnt find file');
				}
				trace(poop);

				weekNombre = WeekData.freeplayList[songs[curSelected].week]; //Array dentro de array dentro de array k
				trace(weekNombre);
	
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
	
				justread = songs[curSelected].songName;

				new FlxTimer().start(0.5, function(tmr:FlxTimer) {
					openSubState(new LoadingsState()); 
				});
				if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 1.5);
				new FlxTimer().start(2.0, function(tmr:FlxTimer) {
					LoadingState.loadAndSwitchState(new PlayState());
					PlayState.limparCache = true;
				});
	
				FlxG.sound.music.volume = 0;
						
				destroyFreeplayVocals();
			}
	}

	private function finishSong():Void
	{
		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyStuff.length-1;
		if (curDifficulty >= CoolUtil.difficultyStuff.length)
			curDifficulty = 0;

		#if !switch
		intendedMultiplier = Highscore.getMultiplier(songs[curSelected].songName, curDifficulty);
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
	}

	function changeSelection(change:Int = 0, firstTime:Bool = false)
	{
		GlobalSoundManager.play('scrollMenu');

		apertavel = false;

		curSelected += change;

		if (curSelected < 0)
			curSelected = progressFreeplay - 1;
		if (curSelected >= progressFreeplay)
			curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		intendedMultiplier = Highscore.getMultiplier(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.4;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		Paths.currentModDirectory = songs[curSelected].folder;
			var curtimer:Float = 0.3;
			
			FlxTween.tween(outroperfilSprite, {alpha: 0}, curtimer, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.imagechecker("freeplay-disc/disc-"+ songs[curSelected].songName.toLowerCase(), 'preload'))) { //anti crashing moment 
						outroperfilSprite.loadGraphic(Paths.image("freeplay-disc/disc-"+ songs[curSelected].songName.toLowerCase(), 'preload')); 
						outroperfilSprite.updateHitbox();
						outroperfilSprite.screenCenter(Y);
						outroperfilSprite.alpha = 1;
						outroperfilSprite.scale.x = 1.05;
						outroperfilSprite.scale.y = 1.05;
					} else {
						FlxG.log.warn('Não foi possível achar ' + "freeplay-disc/disc-"+ songs[curSelected].songName.toLowerCase());
					}
				}
			});
			if(OpenFlAssets.exists(Paths.imagechecker("freeplay-disc/disc-"+ songs[curSelected].songName.toLowerCase(), 'preload'))) { //anti crashing moment 
				perfilSprite.loadGraphic(Paths.image("freeplay-disc/disc-"+ songs[curSelected].songName.toLowerCase(), 'preload')); 
				perfilSprite.updateHitbox();
				perfilSprite.screenCenter(Y);
				perfilSprite.alpha = 0;
				perfilSprite.scale.x = 1.05;
				perfilSprite.scale.y = 1.05;
			} else {
				FlxG.log.warn('Não foi possível achar ' + "freeplay-disc/disc-"+ songs[curSelected].songName.toLowerCase());
			}
			FlxTween.tween(perfilSprite, {alpha: 1}, curtimer, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					perfilSprite.alpha = 0;
					apertavel = true;
					if (firstTime){
						cd_spin();
						firstTime=false;
					}
				}
			});
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
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

	public function new(song:String, week:Int, songCharacter:String, color:Int, display:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.display = display;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}