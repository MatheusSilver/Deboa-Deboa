import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
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
	var clashsupBG:FlxSprite;
	var paracomessapohameno:Bool = false;
	var console:FlxSprite;
	var text:Alphabet;
	private var entrada:Bool = true;
	public var consoleCam:FlxCamera;
	var negadoAud:FlxSound;
	var sonic_button:FlxButton; //Preguiça de refazer este menu, então usei o truque da primeira versão de BS Engine.
	var mario_button:FlxButton;

	var song:String;
	var week:Int;
	private var crossDifficulty:Int = 3;

	// Week -1 = Freeplay
	public function new(song:String, week:Int = -1)
	{
		Main.mouse_allowed=true;
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
		
		sonic_button=new FlxButton();
		mario_button=new FlxButton();
		sonic_button.setGraphicSize(Std.int(FlxG.width/4.5), Std.int(FlxG.height*0.65));
		mario_button.setGraphicSize(Std.int(FlxG.width/4.5), Std.int(FlxG.height*0.65));
		sonic_button.updateHitbox();
		mario_button.updateHitbox();
		sonic_button.screenCenter(X);
		mario_button.screenCenter(X);
		sonic_button.y=mario_button.y = FlxG.height*0.2;
		sonic_button.x-=sonic_button.width/2;
		mario_button.x+=mario_button.width/2;
		mario_button.visible=sonic_button.visible=false;
		mario_button.alpha=sonic_button.alpha=0.01;
		
		add(sonic_button);
		add(mario_button);
		add(console);
		FlxTween.tween(console, {y: 141}, 0.75, {ease: flixel.tweens.FlxEase.expoInOut, onComplete: function(twn:FlxTween){
			clashsupBG.visible=false;
			mario_button.visible=sonic_button.visible=true;
		}});
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
		console.loadGraphic(Paths.image('CCC Stuff/CCC-MD (${onSonic? "SONIC":"MARIO"})'));
		negadoAud = new FlxSound().loadEmbedded(Paths.sound('negado','preload'));
		negadoAud.volume = 0.6;
		
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
		if(!Main.getMouseVisibility()){
			if(controls.UI_LEFT_P || controls.UI_RIGHT_P) { //ok
				GlobalSoundManager.play(scrollMenu);
				onSonic = !onSonic;
				updateOptions();
			}
			if(controls.BACK) { //ok
				if(!negadoAud.playing) negadoAud.play();
			} else if(controls.ACCEPT && paracomessapohameno) 
			{
				confirm();
			}
		}else{
			if (Utils.BSLTouchUtils.apertasimples(sonic_button)&&!onSonic)
				onSonic=true;
			else if (Utils.BSLTouchUtils.apertasimples(mario_button)&&onSonic)
				onSonic=false;
			else if (Utils.BSLTouchUtils.apertasimples(sonic_button) || Utils.BSLTouchUtils.apertasimples(mario_button)){
				confirm();
				return;
			}
			updateOptions();
		}
		super.update(elapsed);
	}

	private function confirm(){
		FreeplayState.infoextended = 'Cross Console Clash';
		persistentUpdate = false;
		PlayState.isStoryMode = false;
		crossDifficulty = onSonic ? 3 : 4;
		var songLowercase:String = Paths.formatToSongPath(song);
		var poop:String = Highscore.formatSong(songLowercase, crossDifficulty);
		if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			trace(poop);
			trace('Couldnt find file');
			return;
		}
		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.storyDifficulty = crossDifficulty;
		PlayState.songMultiplier = modifiers.ModifiersManager.getFinalModifier();
		if(ClientPrefs.flashing) FlxG.camera.flash(onSonic ? FlxColor.BLUE : FlxColor.RED, 1.0);

		openSubState(new LoadingsState());
		new FlxTimer().start(3.5, function(tmr:FlxTimer) {
			LoadingState.loadAndSwitchState(new PlayState());
		});

		FlxG.sound.music.volume = 0;
	}

	function updateOptions() {
		if(entrada){
			entrada = false;
			updateOptions();
		}else{
			console.loadGraphic(Paths.image('CCC Stuff/CCC-MD (${onSonic? "SONIC":"MARIO"})'));
		}
	}
}
