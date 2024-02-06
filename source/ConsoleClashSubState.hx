import modifiers.ModifiersManager;
import LoadingState.LoadingsState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
#if desktop

#end


class ConsoleClashSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var alphabetArray:Array<Alphabet> = [];
	var onSonic:Bool = true;
	var yesText:Alphabet;
	var noText:Alphabet;
	var clashsupBG:FlxSprite;
	var paracomessapohameno:Bool = false;
	var console:FlxSprite;
	var mauroanim:FlxSprite;
	var luigianim:FlxSprite;
	var sonicoanim:FlxSprite;
	var tailsanim:FlxSprite;
	var bgmauro:FlxSprite;
	var bgsonico:FlxSprite;
	var text:Alphabet;
	private var entrada:Bool = true;
	public static var consoleCam:FlxCamera;
	var negadoAud:FlxSound;

	var song:String;
	var week:Int;
	private static var crossDifficulty:Int = 3;

	// Week -1 = Freeplay
	public function new(song:String, week:Int = -1)
	{


		consoleCam = new FlxCamera(0, 0, 768, 672);//Ainda a calcular...

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

		text = new Alphabet(0, 25, "Escolha seu lado", true, false, 0, 1, "alfabetovio");
		text.screenCenter(X);
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);

		var commonmultiplier:Float = 0.5;

		console = new FlxSprite(0,0).loadGraphic(Paths.image('CCC Stuff/CCC-MD (MegaDrive)'));
		console.antialiasing = ClientPrefs.globalAntialiasing;
		console.scale.x = 0.5;
		console.scale.y = 0.5;
		console.y=141;
		console.antialiasing = false;
		console.updateHitbox();
		console.alpha=1;
		console.x = 160;
		console.y = 1600;
		add(console);
		flixel.tweens.FlxTween.tween(console, {y: 141}, 0.75, {ease: flixel.tweens.FlxEase.expoInOut});

		clashsupBG = new FlxSprite(0,0).loadGraphic(Paths.image('CCC Stuff/CCC-MD (MegaDrive)'));
		clashsupBG.antialiasing = ClientPrefs.globalAntialiasing;
		clashsupBG.scale.x = commonmultiplier;
		clashsupBG.scale.y = commonmultiplier;
		clashsupBG.cameras = [consoleCam];
		clashsupBG.antialiasing = false;
		clashsupBG.updateHitbox();
		//x: 160
		//y: 141
		clashsupBG.screenCenter(XY);
		add(clashsupBG);
		if(onSonic){
			console.loadGraphic(Paths.image('CCC Stuff/CCC-MD (SONIC)'));
		} else {
			console.loadGraphic(Paths.image('CCC Stuff/CCC-MD (MARIO)'));
		}
		negadoAud = new FlxSound().loadEmbedded(Paths.sound('negado','preload'));
		negadoAud.volume = 0.6;
		updateOptions();
		trace(console.x+"\n"+console.y);
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
		//text.changeText(Std.string(console.x) + "\n"+Std.string(console.y));
		if(controls.UI_LEFT_P || controls.UI_RIGHT_P) { //ok
			GlobalSoundManager.play('scrollMenu');
			onSonic = !onSonic;
			updateOptions();
		}
		if(controls.BACK) { //ok
			if(!negadoAud.playing){negadoAud.play();}
			//FlxG.switchState(FlxG.state);
			//paracomessapohameno = false; //Real tenho minhas duvidas se deveria deixar essa brecha...
			//Note for future self, quando voltar a mexer na CCC, remover a possibilidade de voltar ao menu.

		} else if(controls.ACCEPT && paracomessapohameno) 
		{
			FreeplayState.infoextended = 'Cross Console Clash';
			persistentUpdate = false;
			PlayState.isStoryMode = false;
			if(onSonic) {
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
				PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
	
				if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.BLUE, 1.0);
				
				openSubState(new LoadingsState());
				new FlxTimer().start(3.5, function(tmr:FlxTimer) {
					LoadingState.loadAndSwitchState(new PlayState());
				});
	
				FlxG.sound.music.volume = 0;
						
				FreeplayState.destroyFreeplayVocals();
			}
			else if(!onSonic) {
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
				PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
				if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.RED, 1.0);

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

		if(entrada){
			entrada = false;
				updateOptions();
		}else{
		if(onSonic){
			console.loadGraphic(Paths.image('CCC Stuff/CCC-MD (SONIC)'));
		} else {
			console.loadGraphic(Paths.image('CCC Stuff/CCC-MD (MARIO)'));
		}
	}
	}
}
