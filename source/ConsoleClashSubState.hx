import flixel.tweens.FlxEase;
import flixel.FlxCamera;
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
	private var entrada:Bool = true;
	public static var consoleCam:FlxCamera;

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

		var text:Alphabet = new Alphabet(0, 50, "Escolha seu lado", true);
		text.screenCenter(X);
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);

		var commonmultiplier:Float = 1;

		console = new FlxSprite(0,0).loadGraphic(Paths.image('CCC Stuff/console mix'));
		console.antialiasing = ClientPrefs.globalAntialiasing;
		console.scale.x = 1;
		console.scale.y = 1;
		console.antialiasing = false;
		console.updateHitbox();
		console.y = FlxG.height + console.height;
		console.screenCenter(X);
		add(console);

		clashsupBG = new FlxSprite(0,0).loadGraphic(Paths.image('CCC Stuff/bgPB'));
		clashsupBG.antialiasing = ClientPrefs.globalAntialiasing;
		clashsupBG.scale.x = commonmultiplier;
		clashsupBG.scale.y = commonmultiplier;
		clashsupBG.cameras = [consoleCam];
		clashsupBG.antialiasing = false;
		clashsupBG.updateHitbox();
		clashsupBG.screenCenter(XY);
		add(clashsupBG);

		bgmauro = new FlxSprite(0,0).loadGraphic(Paths.image('CCC Stuff/mauro'));
		bgmauro.antialiasing = ClientPrefs.globalAntialiasing;
		bgmauro.scale.x = commonmultiplier;
		bgmauro.scale.y = commonmultiplier;
		bgmauro.cameras = [consoleCam];
		bgmauro.antialiasing = false;
		bgmauro.updateHitbox();
		bgmauro.screenCenter(XY);
		add(bgmauro);

		bgsonico = new FlxSprite(0,0).loadGraphic(Paths.image('CCC Stuff/sonico'));
		bgsonico.antialiasing = ClientPrefs.globalAntialiasing;
		bgsonico.scale.x = commonmultiplier;
		bgsonico.scale.y = commonmultiplier;
		bgsonico.cameras = [consoleCam];
		bgsonico.antialiasing = false;
		bgsonico.updateHitbox();
		bgsonico.screenCenter(XY);
		add(bgsonico);

		sonicoanim = new FlxSprite(0, 0); //ok
		sonicoanim.frames = Paths.getSparrowAtlas('CCC Stuff/bonecos/sonic');
		sonicoanim.animation.addByPrefix('idle', "idle", 28);
		sonicoanim.animation.addByPrefix('confirm', "heyextended", 48);
		sonicoanim.animation.play('idle');
		sonicoanim.alpha = 1;
		sonicoanim.cameras = [consoleCam];
		sonicoanim.antialiasing = false;
		//sonicoanim.setGraphicSize(Std.int(sonicoanim.width * 0.32));
		sonicoanim.updateHitbox();
		add(sonicoanim);

		tailsanim = new FlxSprite(0, 0); //ok
		tailsanim.frames = Paths.getSparrowAtlas('CCC Stuff/bonecos/tails');
		tailsanim.animation.addByPrefix('idle', "idle", 28);
		tailsanim.animation.addByPrefix('confirm', "up", 48);
		tailsanim.animation.play('idle');
		tailsanim.cameras = [consoleCam];
		tailsanim.alpha = 1;
		tailsanim.antialiasing = false;
		//tailsanim.setGraphicSize(Std.int(tailsanim.width * 0.32));
		tailsanim.updateHitbox();
		add(tailsanim);

		luigianim = new FlxSprite(0, 0); //ok
		luigianim.frames = Paths.getSparrowAtlas('CCC Stuff/bonecos/luigi-ccc');
		luigianim.animation.addByPrefix('idle', "idle", 28);
		luigianim.animation.addByPrefix('confirm', "up", 48);
		luigianim.animation.play('idle');
		luigianim.alpha = 1;
		luigianim.cameras = [consoleCam];
		luigianim.flipX = true;
		luigianim.antialiasing = false;
		//luigianim.setGraphicSize(Std.int(luigianim.width * 0.32));
		luigianim.updateHitbox();
		add(luigianim);

		mauroanim = new FlxSprite(0, 0); //ok
		mauroanim.frames = Paths.getSparrowAtlas('CCC Stuff/bonecos/mario-ccc');
		mauroanim.animation.addByPrefix('idle', "idle", 28);
		mauroanim.animation.addByPrefix('confirm', "hey", 48);
		mauroanim.animation.play('idle');
		mauroanim.cameras = [consoleCam];
		mauroanim.alpha = 1;
		mauroanim.flipX = true;
		mauroanim.antialiasing = false;
		//mauroanim.setGraphicSize(Std.int(mauroanim.width * 0.32));
		mauroanim.updateHitbox();
		add(mauroanim);

		updateOptions();

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
			onSonic = !onSonic;
			updateOptions();
		}
		if(controls.BACK) { //ok
			FlxG.sound.play(Paths.sound('cancelMenu'), 1);
			FlxG.switchState(FlxG.state);
			paracomessapohameno = false; //Real tenho minhas duvidas se deveria deixar essa brecha...
			//Note for future self, quando voltar a mexer na CCC, remover a possibilidade de voltar ao menu.

		} else if(controls.ACCEPT && paracomessapohameno) 
		{
			FreeplayState.infoextended = 'Cross Console Clash';
			persistentUpdate = false;
			PlayState.isStoryMode = false;
			if(onSonic) {
				sonicoanim.animation.play('confirm');
				tailsanim.animation.play('confirm');
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
			else if(!onSonic) {
				mauroanim.animation.play('confirm');
				luigianim.animation.play('confirm');
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

		if(entrada){
			entrada = false;
			FlxTween.tween(console, {y: (FlxG.height - console.height)/2}, 0.5, {ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween) {
					consoleCam.flash(FlxColor.WHITE, 0.5);
					FlxTween.tween(clashsupBG, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween) {
							updateOptions();
						}});
				}});
		}else{
		if(onSonic){
			bgsonico.alpha = 1;
			bgmauro.alpha = 0;
			sonicoanim.animation.play('idle');
			tailsanim.animation.play('idle');
			mauroanim.animation.stop();
			luigianim.animation.stop();
		} else {
			bgsonico.alpha = 0;
			bgmauro.alpha = 1;
			mauroanim.animation.play('idle');
			luigianim.animation.play('idle');
			sonicoanim.animation.stop();
			tailsanim.animation.stop();
		}
	}
	}
}
