 package;
 import Controls.Control;
 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.FlxState;
 import flixel.util.FlxColor;
 import flixel.util.FlxTimer;
 import openfl.events.Event;
 import hxvlc.flixel.FlxVideoSprite;

// THIS IS FOR TESTING
// DONT STEAL MY CODE >:(

//Na atual situação, nem sei se tem algo do code original aqui k

enum GameState {
    TITLE;
    PLAYSTATE;
    ABOUT;
	NORMAL;
	EDITOR;
}

class MP4Sprite extends FlxVideoSprite
{
	public var nextState:FlxState;
	public var canSkip:Bool = false;
	public var videoVolume:Float = 1;
	public var paused:Bool = false;
	public var queronaoviver:Bool = false;
	public var oldPosition:Float = 0;
	private var curState:GameState;
	
	public function new(x:Int=0, y:Int=0, curState:GameState)
	{
		super(x,y);
		this.curState = curState;
		FlxG.autoPause = false;

		this.bitmap.onOpening.add(onVLCVideoReady);
		this.bitmap.onEndReached.add(onVLCComplete);
		this.bitmap.onEncounteredError.add(onVLCError);
	}

	public function playMP4(file:String, ?repeat:UInt=0, ?oldPosition:Float, ?nextState:FlxState):Void
	{
		this.load(checkFile(file), repeat);
		this.play();
		this.oldPosition = oldPosition;
		this.nextState = nextState;
		canSkip=false;
		queronaoviver = curState == PLAYSTATE;
	}

	inline private function checkFile(fileName:String):String {return Utils.Asset2File.getPath(fileName); }

	function onVLCVideoReady()
	{
		#if debug
		trace("video loaded!");
		#end
	}

	public function onVLCComplete()
	{
		if (curState == EDITOR)
			this.play(); //Fazer função de replay (maybe...)
		else{
			if(curState != GameState.ABOUT) {
				canSkip=false;

				#if debug
				trace("exibi o video");
				#end

				if (curState != null && curState != GameState.TITLE)
				{
					if(curState != GameState.PLAYSTATE)
						{
							FlxG.camera.fade(FlxColor.BLACK, 0, false);
							LoadingState.loadAndSwitchState(nextState);
						}
					else
						{
							trace('beep bop skidep');
							PlayState.instance.deletarSpriteNAAAAO();
						}
				}
				else if(nextState != null && curState == GameState.TITLE && curState != GameState.PLAYSTATE)
					{
						FlxG.camera.fade(FlxColor.BLACK, 0, false);
						MusicBeatState.switchState(nextState);
					}
				this.destroy();
			}
		}
		

	}

	function onVLCError()
	{
		if (nextState != null) LoadingState.loadAndSwitchState(nextState);
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.SPACE && canSkip==true && curState != GameState.ABOUT && curState != GameState.PLAYSTATE && !queronaoviver && this.bitmap.isPlaying)
			this.onVLCComplete();

		if(curState != TITLE) canSkip=false;
	}

	public function pausarvideo1(h:Bool) // pq h????
	{
		if(h)
		{
			trace('tentei pausar');
			this.pause();
		}
		else
		{
			trace('tentei resumir');
			this.resume();
		}
	}
}