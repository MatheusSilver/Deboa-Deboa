package;

import ui.FlxButton;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var eaepedrinho:Bool = true;
	public static var bgType:String = 'bf';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	var blackScreen:FlxSprite;

	var bg:FlxSprite;
	var retryButton:FlxButton;
	var retryTween:FlxTween;
	public static var instance:GameOverSubstate;

	public static function resetVariables() { //Padrão para deathScreen do BF.
		bgType = 'bf';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		#if desktop
		FlxG.mouse.visible = true;
		#end

		bg = new FlxSprite(0,0).loadGraphic(Paths.image('gameovers/'+bgType));
		if(bgType != 'fleeplay')
			bg.setGraphicSize(FlxG.width,FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0;
		bg.screenCenter(XY);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		retryButton = new FlxButton(0, 0, '');
		if (bgType != 'pasta')
			retryButton.loadGraphic(Paths.image('gameovers/retry_bf', 'preload'));
		else
			retryButton.loadGraphic(Paths.image('gameovers/retry_pasta', 'preload'));

		retryButton.visible = bgType != 'fleeplay';

		retryButton.y = -retryButton.height;
		retryButton.screenCenter(X);
		retryButton.angle = 0;
		retryButton.antialiasing = ClientPrefs.globalAntialiasing;
		retryButton.alpha = 0.75;
		retryButton.setGraphicSize(Std.int(retryButton.width*0.7));
		retryButton.onOver.callback = function(){retryButton.alpha=1;};
				retryButton.onOut.callback = function(){retryButton.alpha=0.75;};
				retryButton.onDown.callback = function(){
					new FlxTimer().start(0.35, function(tmr:FlxTimer)
						{
							endBullshit();
						});
				};
		add(retryButton);

		eaepedrinho = true;

		retryButton.angle = -3;

		blackScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		blackScreen.alpha = 0;
		add(blackScreen);

		super.create();
		
		FlxTween.tween(bg, {alpha: 1}, 0.7, {ease: FlxEase.linear, onComplete: function (twn:FlxTween){
			retryTween = FlxTween.tween(retryButton, {y: 15}, 0.7, {ease: FlxEase.cubeInOut});
		}});
		

	}

	public function new()
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;
		
		FlxG.sound.play(Paths.sound(deathSoundName));
		Conductor.changeBPM(100);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!isEnding){
		if (retryButton.angle == -3)
			retryTween = FlxTween.angle(retryButton, retryButton.angle, 3, 1.5, {ease: FlxEase.quartInOut});
		if (retryButton.angle == 3)
			retryTween = FlxTween.angle(retryButton, retryButton.angle, -3, 1.5, {ease: FlxEase.quartInOut});
		}

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				endBullshit();
			});
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			MusicBeatState.switchState(new EstadoDeTrocaReverso());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
		}

		if (eaepedrinho)
			{
				eaepedrinho = false;
				coolStartDeath(0.2);
				
				var exclude:Array<Int> = [];
				//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

				FlxG.sound.play(Paths.sound('gameoverfalas/' + FlxG.random.int(1, 12, exclude)), 1, false, null, true, function() {
					if(!isEnding)
					{
						FlxG.sound.music.fadeIn(0.2, 1, 4);
					}
				});
			}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
		{
			super.beatHit();
	
			//FlxG.log.add('beat');
		}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			eaepedrinho = false;
			isEnding = true;
			if (retryTween != null){
				retryTween.cancel();
				retryTween = null;
			}

			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxTween.tween(blackScreen, {alpha: 1}, 1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween)
				{
					MusicBeatState.switchState(new PlayState()); //Não imagino que alguem vá apertar enter esperando ir pra qualquer outro lugar então né?
				}});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}