#if mobile
import extension.webview.WebView;
import flixel.FlxSubState;
#else
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Input.Control;
import openfl.events.Event;
import hxvlc.flixel.FlxVideoSprite;
import Videos.MP4Sprite;
#end
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.lists.FlxGamepadButtonList;
import flixel.input.gamepad.FlxGamepad;
import ajustes.InputLabel;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

using StringTools;

#if mobile
class VideoState extends MusicBeatState
{
	var changecount = 0;

	public static var androidPath:String = 'file:///android_asset/';

	public var nextState:FlxState;

	var text:FlxText;

	public function new(source:String, toTrans:FlxState)
	{
		super();

		text = new FlxText(0, 0, 0, Linguagem.LangUtil.getString("webview_touch", "data"), 48);
		text.screenCenter();
		text.alpha = 0;
		add(text);

		nextState = toTrans;

		// FlxG.autoPause = false;
		source = source.replace('.${Paths.VIDEO_EXT}', '');

		WebView.onClose = onClose;
		WebView.onURLChanging = onURLChanging;

		WebView.open(androidPath + source + '.html', false, null, ['http://exitme(.*)']);
	}

	public override function update(dt:Float)
	{
		if (Utils.BSLTouchUtils.justTouched() || FlxG.android.justReleased.BACK)
			onClose();

		super.update(dt);
	}

	function onClose()
	{ // not working
		text.alpha = 0;
		changecount = 0;
		// FlxG.autoPause = true;
		trace('close!');
		trace(nextState);
		MusicBeatState.switchState(nextState);
	}

	function onURLChanging(url:String)
	{
		if (changecount == 2)
		{ // Hacks mais sujos que o anterior k
			text.alpha = 0;
			onClose();
		}
		else
		{
			changecount++;
			text.alpha = 1;
		}
		if (url == 'http://exitme%28.%2A%29/')
			onClose(); // drity hack lol
		trace("WebView is about to open: " + url);
	}
}

class VideoSubState extends MusicBeatSubstate
{
	public static var androidPath:String = 'file:///android_asset/';

	var text:FlxText;
	var changecount = 0;

	public function new(source:String)
	{
		super();

		text = new FlxText(0, 0, 0, Linguagem.LangUtil.getString("webview_touch", "data"), 48);
		text.screenCenter();
		text.alpha = 0;
		add(text);

		// FlxG.autoPause = false;

		WebView.onClose = onClose;
		WebView.onURLChanging = onURLChanging;

		WebView.open(androidPath + source + '.html', false, null, ['http://exitme(.*)']);
	}

	public override function update(dt:Float)
	{
		if (Utils.BSLTouchUtils.justTouched() || FlxG.android.justReleased.BACK)
			onClose();

		super.update(dt);
	}

	function onClose()
	{ // not working
		text.alpha = 0;
		changecount = 0;
		// FlxG.autoPause = true;
		trace('aqui cabo!'); //==11x3 Fnatic :skull:
		close();
	}

	function onURLChanging(url:String)
	{
		if (changecount == 2)
			onClose();
		else
			changecount++;
		text.alpha = 1;
		if (url == 'http://exitme(.*)') //Não tenho certeza sobre isso tambem, mas deve fazer com que o player de vídeo feche sozinho.
			onClose(); // drity hack lol
		trace("WebView is about to open: " + url);
	}
}
#else
class VideoStatePC extends MusicBeatState
{
	var video:MP4Sprite;
	var skipText:SkipText;

	public static var videoPath:String = Paths.video("EngineBase/intromic");
	public static var NextState:FlxState = new TitleState();
	public static var specialSetting:Videos.GameState;

	override function create()
	{
		video = new MP4Sprite(0,0, specialSetting);
		video.canSkip = false;
		video.setParent(this);
		Main.mouse_allowed=false;
		
		/*if (specialSetting != TITLE && specialSetting != PLAYSTATE)
		{
			FlxG.sound.music.fadeIn(0.35, 0.7, 0);
		}*/

		// Nashira, és tu??????????
		// Sei que o if else if é bastante usado na unity e etc, desculpa dav!!!!

		// Até que tá mais bonitinho agora
		video.playMP4(videoPath, NextState);

		//var android:String = Linguagem.LangUtil.getString("webview_touch", "data");
		//var pc:String = Linguagem.LangUtil.getString("descVideo1") + (' ${Linguagem.LangUtil.getString("key_label_space")} ${Linguagem.LangUtil.getString("descVideo2")}');
		
		skipText = new SkipText(-50, FlxG.height - 150);
		skipText.updateHitbox();
		skipText.scrollFactor.set();
		//skipText.screenCenter(X);
		skipText.alpha = 0;

		add(video);
		add(skipText);

		super.create();
	}

	var twn:FlxTimer = new FlxTimer();
	var alphaon:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var justPressed:Bool = Input.Controls.get_ANY() #if android || BSLTouchUtils.justTouched(); #end; // Aqui vai uma fix pro Android também, já que não tinha como pular os vídeos nele.
		if (skipText.alpha == 0 && justPressed)
		{
			alphaon = true;
			twn.start(4, function(twn:FlxTimer)
			{
				CompletedTimer();
			});
		}

		if (alphaon && skipText.alpha != 1)
		{
			skipText.alpha = skipText.alpha + 0.25;
			video.canSkip = false;
		}
		else if (alphaon && skipText.alpha == 1)
		{
			video.canSkip = true;
		}

		if (!alphaon && skipText.alpha != 0)
		{
			skipText.alpha = skipText.alpha - 0.25;
			video.canSkip = false;
		}
		else if (!alphaon && skipText.alpha == 0)
		{
			video.canSkip = false;
		}
	}

	function CompletedTimer()
	{
		video.canSkip = false;
		alphaon = false;
	}
}

class SkipText extends FlxSpriteGroup {
	var letext:FlxText;
	var key:FlxSprite;

	public function new(x:Float, y:Float) {
		super(x, y);

		letext = new FlxText(100, 0, 0, Linguagem.LangUtil.getString("descVideo3"), 32);
		letext.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.updateHitbox();
		add(letext);

		key = new FlxSprite(0,-32).loadGraphic(Paths.image(InputLabel.instance.getKeyLabelPath("accept")));
		key.updateHitbox();
		add(key);
		
	}

	override function update(elapsed:Float){
		super.update(elapsed);
		key.loadGraphic(Paths.image(InputLabel.instance.getKeyLabelPath("accept")));
	}
}

class MP4Sprite extends FlxVideoSprite
{
	public var nextState:FlxState;
	public var canSkip:Bool = false;
	public var paused:Bool = false;
	public var queronaoviver:Bool = false;
	public var oldPosition:Float = 0;
	private var curState:GameState;
	var parentState:FlxState;

	public var controls(get, never):Input.Controls;
	inline function get_controls():Input.Controls
		return Input.PlayerSettings.player1.controls;

	
	public function new(x:Int=0, y:Int=0, curState:GameState)
	{
		super(x,y);
		this.moves = false;
		this.curState = curState;
		FlxG.autoPause = false;

		this.bitmap.onOpening.add(onVLCVideoReady);
		this.bitmap.onEndReached.add(onVLCComplete);
		this.bitmap.onEncounteredError.add(onVLCError);
	}

	public function setParent(parent:FlxState)
	{
		parentState = parent;
	}

	public function playMP4(file:String, ?repeat:UInt=0, ?oldPosition:Float, ?nextState:FlxState):Void
	{
		this.oldPosition = oldPosition;
		this.load(checkFile(file), repeat);
		this.play();
		this.nextState = nextState;
		this.bitmap.mute = false;
		canSkip=false;
		queronaoviver = curState == PLAYSTATE;
	}

	inline private function checkFile(fileName:String):String {return Utils.Asset2File.getPath(fileName); }

	function onVLCVideoReady()
	{
		#if debug
		trace("video loaded!");
		#end
		if(curState == GameState.PLAYSTATE)
			{
				var tempoPraPular:Float = (Song.Conductor.songPosition / 1000)-oldPosition;
				if(tempoPraPular/60>=0.0002)
				{
					this.seek(tempoPraPular/60);
				}
				#if debug
				trace(tempoPraPular/60);
				#end
			}
	}

	public function onVLCComplete()
	{
		if (curState == EDITOR)
			this.play(); //Fazer função de replay (maybe...)
		else if (curState == GameState.LUA)
			PlayState.instance.callOnLuas('onLuaVideoEnd', []);
		else{
			if(curState != GameState.ABOUT) {
				canSkip=false;

				#if debug
				trace("exibi o video");
				#end

				if (curState != null && curState != GameState.TITLE)
				{
					if(curState == GameState.NORMAL) // acho que da pra otimizar esses ifs aqui mas n to com mto tempo pra gastar nisso
					{
						if(parentState!=null)
						{
							parentState.openSubState(new LoadingState.LoadingsState());
						}
						LoadingState.loadAndSwitchState(new PlayState());
					}
					else if(curState != GameState.PLAYSTATE && curState != GameState.NORMAL)
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
				}else
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
		var justPressed:Bool = controls.ACCEPT #if android || BSLTouchUtils.justTouched(); #end; // Aqui vai uma fix pro Android também, já que não tinha como pular os vídeos nele.
		if (justPressed && canSkip==true && curState != GameState.ABOUT && curState != GameState.PLAYSTATE && !queronaoviver && this.bitmap.isPlaying) {
			this.bitmap.mute = true;
			this.onVLCComplete();
		}


		if(curState != TITLE) canSkip=false;
        super.update(elapsed);//LINHA MAGICA OMAGAAAAAAAAWD
	}

	public function pausarvideo1(h:Bool) // pq h????  
	{									// h de hugo
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
enum GameState {
	TITLE;
	PLAYSTATE;
	ABOUT;
	NORMAL;
	EDITOR;
	LUA;
}
#end