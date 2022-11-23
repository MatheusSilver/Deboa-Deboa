import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import LoadingState.LoadingsState;
import openfl.utils.Assets as OpenFlAssets;
import flixel.tweens.FlxTween;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class ConsoleClashSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var escolhaSonic:FlxSprite;
	var escolhaMario:FlxSprite;
	var alphabetArray:Array<Alphabet> = [];
	var onYes:Bool = true;
	var yesText:Alphabet;
	var noText:Alphabet;
	var clashsupBG:FlxSprite;
	var paracomessapohameno:Bool = false;

	var song:String;
	var week:Int;
	private static var crossDifficulty:Int = 3;

	// Week -1 = Freeplay
	public function new(song:String, week:Int = -1)
	{

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Escolhendo um lado na \n Guerra de Consoles", null);
		#end

		this.song = song;
		this.week = week;

		new FlxTimer().start(1.0, function(tmr:FlxTimer) {
			paracomessapohameno = true;
		});

		super();

		var name:String = song;
		if(week > -1) {
			name = WeekData.weeksLoaded.get(WeekData.weeksList[week]).weekName;
		}

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var tooLong:Float = ('Nesta guerra de consoles'.length > 18) ? 0.8 : 1; //Fucking Winter Horrorland
		var text:Alphabet = new Alphabet(0, 50, "Escolha seu lado", true);
		text.screenCenter(X);
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);
		var text:Alphabet = new Alphabet(0, text.y + 90, 'Nesta guerra de consoles', true, false, 0.05, tooLong);
		if(week == -1) text.x += 60 * tooLong;
		alphabetArray.push(text);
		text.alpha = 0;
		text.screenCenter(X);
		add(text);

		clashsupBG = new FlxSprite(0,0).loadGraphic(Paths.image('menus/escolhaCINZA'));
		clashsupBG.antialiasing = ClientPrefs.globalAntialiasing;
		clashsupBG.scale.x = 4;
		clashsupBG.scale.y = 2;
		clashsupBG.updateHitbox();
		clashsupBG.screenCenter(XY);
		add(clashsupBG);

		escolhaMario = new FlxSprite(0,0).loadGraphic(Paths.image('menus/escolhaMARIO'));
		escolhaMario.antialiasing = ClientPrefs.globalAntialiasing;
		escolhaMario.scale.x = 4;
		escolhaMario.scale.y = 2;
		escolhaMario.updateHitbox();
		escolhaMario.screenCenter(XY);
		escolhaMario.visible = false;
		add(escolhaMario);

		escolhaSonic = new FlxSprite(0,0).loadGraphic(Paths.image('menus/escolhaSONIC'));
		escolhaSonic.antialiasing = ClientPrefs.globalAntialiasing;
		escolhaSonic.scale.x = 4;
		escolhaSonic.scale.y = 2;
		escolhaSonic.updateHitbox();
		escolhaSonic.screenCenter(XY);
		escolhaSonic.visible = true;
		add(escolhaSonic);

		


		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		bg.alpha += elapsed * 1.5;
		if(bg.alpha > 0.6) bg.alpha = 0.6;

		for (i in 0...alphabetArray.length) {
			var spr = alphabetArray[i];
			spr.alpha += elapsed * 2.5;
		}

		if(controls.UI_LEFT_P || controls.UI_RIGHT_P) { //ok
			FlxG.sound.play(Paths.sound('scrollMenu'), 1);
			onYes = !onYes;
			updateOptions();
		}
		if(controls.BACK) { //ok
			FlxG.sound.play(Paths.sound('cancelMenu'), 1);
			FlxG.switchState(FlxG.state);
			paracomessapohameno = false;

		} else if(controls.ACCEPT && paracomessapohameno) 
		{
			FreeplayState.infoextended = 'Cross Console Clash';
			persistentUpdate = false;
			PlayState.isStoryMode = false;
			if(onYes) {
				crossDifficulty = 3;
				var songLowercase:String = Paths.formatToSongPath(song);
				var poop:String = Highscore.formatSong(songLowercase, crossDifficulty);
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					poop = songLowercase;
					crossDifficulty = 3;
					trace('Couldnt find file');
				}
				trace(poop);
	
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.storyDifficulty = crossDifficulty;
	
				FlxG.camera.flash(FlxColor.BLUE, 1.0);
				openSubState(new LoadingsState());
				new FlxTimer().start(3.5, function(tmr:FlxTimer) {
					LoadingState.loadAndSwitchState(new PlayState());
				});
	
				FlxG.sound.music.volume = 0;
						
				FreeplayState.destroyFreeplayVocals();
			}
			else if(!onYes) {
				crossDifficulty = 4;
				var songLowercase:String = Paths.formatToSongPath(song);
				var poop:String = Highscore.formatSong(songLowercase, crossDifficulty);
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					poop = songLowercase;
					crossDifficulty = 4;
					trace('Couldnt find file');
				}
				trace(poop);
	
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.storyDifficulty = crossDifficulty;
	
				FlxG.camera.flash(FlxColor.RED, 1.0);
				openSubState(new LoadingsState());
				new FlxTimer().start(3.5, function(tmr:FlxTimer) {
					LoadingState.loadAndSwitchState(new PlayState());
				});
	
				FlxG.sound.music.volume = 0;
						
				FreeplayState.destroyFreeplayVocals();
		}
		}
		super.update(elapsed);
	}

	function updateOptions() {
		if(onYes){
		escolhaSonic.visible = true;
		escolhaMario.visible = false;
		} else {
			escolhaSonic.visible = false;
			escolhaMario.visible = true;
		}

	}
}