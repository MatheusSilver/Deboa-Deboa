package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Conductor;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;
	var burrice:Bool = true;
	var eletentou:Bool = false; //MALDITO S...

	var stageSuffix:String = "";
	var maoLord:FlxSprite;

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	var gameoverSprite:FlxSprite;
	public static var instance:GameOverSubstate;
	var nombre:String = "bf";

	override function create()
	{
		instance = this;
		gameoverSprite = new FlxSprite(0,0);
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}
	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		gameoverSprite.loadGraphic(Paths.image("gameover/" + nombre+"/sprite", "preload"));

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		Conductor.changeBPM(100);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound("vhs_entra"));
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

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				
					MusicBeatState.switchState(new PlayState()); //Não imagino que alguem vá apertar enter esperando ir pra qualquer outro lugar então né?
				
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}