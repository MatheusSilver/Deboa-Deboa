import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import LoadingState.LoadingsState;

using StringTools;

class ControlSongSubstate extends MusicBeatSubstate
{
		var bg:FlxSprite;
		var alphabetArray:Array<Alphabet> = [];
		var explanationtext:FlxText;
		var confirmInt:Int;
		var onYes:Bool = false;
		var yesText:Alphabet;
		var noText:Alphabet;
		public static var gifPermitido:Bool;
		var escolheualgo:Bool = false;


		public function tweenpracima():Void
			{
				FlxTween.tween(explanationtext, {y: yesText.height + yesText.y + 100}, 3, {ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween) {
					tweenprabaixo();
				}});
			}
	
			public function tweenprabaixo():Void
			{
				FlxTween.tween(explanationtext, {y: FlxG.height - explanationtext.height - 5}, 3, {ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween) {
					tweenpracima();
				}});
			}
	
			public function updateOptions():Void 
			{
				var scales:Array<Float> = [0.75, 1];
				var alphas:Array<Float> = [0.6, 1.25];
				confirmInt = onYes ? 0 : 1;
				if (confirmInt == 0) {
					explanationtext.text = 'Um GIF irá aparecer em certas partes igual ao mod original\nmas pode não ser compátivel com certos computadores.';
				} else if (confirmInt == 1){
					explanationtext.text = 'Você terá a mesma experiência do mod original \nmas os GIFs não serão mais um problema, isso tambem irá melhorar a performance.';
				}
	
				noText.alpha = alphas[confirmInt];
				noText.scale.set(scales[confirmInt], scales[confirmInt]);
				yesText.alpha = alphas[1 - confirmInt];
				yesText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
			}

		public function new()
		{
			super();

			bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			add(bg);

			var text:Alphabet = new Alphabet(0, 180, "Deseja ativar os GIF's?", true);
			text.screenCenter(X);
			alphabetArray.push(text);
			text.alpha = 0;
			add(text);

			yesText = new Alphabet(0, text.y + 150, 'Sim', true);
			yesText.screenCenter(X);
			yesText.x -= 200;
			add(yesText);
			noText = new Alphabet(0, text.y + 150, 'Nope', true);
			noText.screenCenter(X);
			noText.x += 200;
			add(noText);
			explanationtext = new FlxText(0, FlxG.height - 5, FlxG.width, '', 24);
			explanationtext.setFormat(Paths.font("GhoulFriAOE.ttf"), 32, FlxColor.WHITE, CENTER);
			explanationtext.screenCenter(X);
			explanationtext.scrollFactor.set();
			
			add(explanationtext);

			updateOptions();
			tweenpracima();

			#if mobileC
			addVirtualPad(LEFT_RIGHT, A_B);
			#end

		}


		override function update(elapsed:Float)
		{
			bg.alpha += elapsed * 1.5;
			if(bg.alpha > 0.6) {bg.alpha = 0.6;}

		for (i in 0...alphabetArray.length) {
			var spr = alphabetArray[i];
			spr.alpha += elapsed * 2.5;
		}
		if (!escolheualgo){
		if(controls.UI_LEFT_P || controls.UI_RIGHT_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 1);
			onYes = !onYes;
			updateOptions();
		}
		if(controls.ACCEPT) {

			var songLowercase:String = Paths.formatToSongPath('control');
			var poop:String = Highscore.formatSong(songLowercase, 2);
			if(!openfl.utils.Assets.exists(Paths.json(songLowercase + '/' + poop))) {
				poop = songLowercase;
				trace('Couldnt find file');
			}
			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.storyDifficulty = 2;

			FlxG.sound.music.volume = 0;
			escolheualgo = true;
			if(confirmInt == 0) {
					gifPermitido = true;
					FlxG.camera.flash(FlxColor.BLACK, 1.0);
					openSubState(new LoadingsState());
					new FlxTimer().start(1.5, function(tmr:FlxTimer) {
						LoadingState.loadAndSwitchState(new PlayState());
					});
					FlxG.sound.play(Paths.sound('confirmMenu'), 1);

					}
					else if(confirmInt == 1) {
						gifPermitido = false;
						FlxG.camera.flash(FlxColor.BLACK, 1.0);
						openSubState(new LoadingsState());
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							LoadingState.loadAndSwitchState(new PlayState());
						});
						FlxG.sound.play(Paths.sound('confirmMenu'), 1);
					}
				}
			super.update(elapsed);
		}

	}
}