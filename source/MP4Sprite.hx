package;

import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;

enum GameState {
	TITLE;
	PLAYSTATE;
	ABOUT;
	NORMAL;
	EDITOR;
	LUA;
}

class MP4Sprite extends hxvlc.flixel.FlxVideoSprite
{
	public var nextState:FlxState;
	public var canSkip:Bool = false;
	public var paused:Bool = false;
	public var queronaoviver:Bool = false;
	public var oldPosition:Float = 0;

	private var curState:GameState;
	var parentState:FlxState;

	var isPrecached:Bool = false;

	public var videoName:String;

	public var controls(get, never):Input.Controls;

	inline function get_controls():Input.Controls
		return Input.PlayerSettings.player1.controls;

	public function new(x:Int = 0, y:Int = 0, curState:GameState, ?precached:Bool = false)
	{
		super(x, y);
		this.moves = false;
		this.curState = curState;
		this.isPrecached = precached;

		FlxG.autoPause = false;

		this.bitmap.onOpening.add(onVLCVideoReady);
		this.bitmap.onEndReached.add(onVLCComplete);
		this.bitmap.onEncounteredError.add(onVLCError);
	}

	public function setParent(parent:FlxState)
	{
		parentState = parent;
	}

	public function precache(file:String)
	{
		this.load(checkFile(file), 0);
		this.videoName = file;
		canSkip = false;
	}

	public function playMP4(file:String, ?repeat:UInt = 0, ?oldPosition:Float, ?nextState:FlxState):Void
	{
		this.oldPosition = oldPosition;
		if (!isPrecached)
		{
			this.load(checkFile(file), repeat);
		}
		this.play();
		this.nextState = nextState;
		this.bitmap.mute = false;
		canSkip = false;
		queronaoviver = curState == PLAYSTATE;
	}

	inline private function checkFile(fileName:String):String
		return Utils.Asset2File.getPath(fileName);

	function onVLCVideoReady()
	{
		#if debug
		trace("video loaded!");
		#end
		if (curState == GameState.PLAYSTATE)
		{
			var tempoPraPular:Float = (Song.Conductor.songPosition / 1000) - oldPosition;
			if (tempoPraPular / 60 >= 0.0002)
			{
				this.seek(tempoPraPular / 60);
			}
			#if debug
			trace(tempoPraPular / 60);
			#end
		}
	}

	var alreadySkipped:Bool = false;

	public function onVLCComplete()
	{
		if (curState == EDITOR)
			this.play(); // Fazer função de replay (maybe...)
		else if (curState == GameState.LUA)
			PlayState.instance.callOnLuas('onLuaVideoEnd', []);
		else
		{
			if (curState != GameState.ABOUT)
			{
				canSkip = false;

				#if debug
				trace("exibi o video");
				#end

				if (curState != null && curState != GameState.TITLE)
				{
					if (curState == GameState.NORMAL) // acho que da pra otimizar esses ifs aqui mas n to com mto tempo pra gastar nisso
					{
						if (parentState != null && !alreadySkipped)
						{
							alreadySkipped = true;
							parentState.openSubState(new LoadingState.LoadingsState());
						}
						LoadingState.loadAndSwitchState(new PlayState());
					}
					else if (curState != GameState.PLAYSTATE && curState != GameState.NORMAL)
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
				else if (nextState != null && curState == GameState.TITLE && curState != GameState.PLAYSTATE)
				{
					FlxG.camera.fade(FlxColor.BLACK, 0, false);
					MusicBeatState.switchState(nextState);
				}
				else
					this.destroy();
			}
		}
	}

	function onVLCError()
	{
		if (nextState != null)
			LoadingState.loadAndSwitchState(nextState);
	}

	override public function update(elapsed:Float)
	{
		var justPressed:Bool = controls.ACCEPT #if android || BSLTouchUtils.justTouched() #end; // Aqui vai uma fix pro Android também, já que não tinha como pular os vídeos nele.
		if (justPressed && canSkip == true && curState != GameState.ABOUT && curState != GameState.PLAYSTATE && !queronaoviver && this.bitmap.isPlaying)
		{
			this.bitmap.mute = true;
			this.onVLCComplete();
		}

		if (curState != TITLE)
			canSkip = false;
		super.update(elapsed); // LINHA MAGICA OMAGAAAAAAAAWD
	}

	public function pausarvideo1(h:Bool) // pq h????
	{ // h de hugo
		if (h)
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

class SkipText extends flixel.group.FlxSpriteGroup {
	var letext:FlxText;
	var key:FlxSprite;
	var keyLabelPath:String;

	public function new(x:Float, y:Float) {
		super(x, y);

		letext = new FlxText(100, 0, 0, Linguagem.LangUtil.getString("descVideo3"), 32);
		letext.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.updateHitbox();
		add(letext);

		keyLabelPath = ajustes.InputLabel.instance.getKeyLabelPath("accept");
		key = new FlxSprite(0,-32).loadGraphic(Paths.image(keyLabelPath));
		key.updateHitbox();
		add(key);

	}

	override function update(elapsed:Float){
		super.update(elapsed);

		var newKeyLabelPath:String = ajustes.InputLabel.instance.getKeyLabelPath("accept");
		if (newKeyLabelPath != keyLabelPath) {
			keyLabelPath = newKeyLabelPath;
			key.loadGraphic(Paths.image(keyLabelPath));
		}
	}
}