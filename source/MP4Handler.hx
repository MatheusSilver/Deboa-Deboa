 package;
#if desktop
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.events.Event;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import vlc.VlcBitmap;

// THIS IS FOR TESTING
// DONT STEAL MY CODE >:(

class MP4Handler
{
	public static var video:Video;
	public static var netStream:NetStream;
	public static var finishCallback:FlxState;
	public var vimdoplaystatemano:Bool;
	public var canSkip:Bool = false;
	public var sprite:FlxSprite;
	public var videoVolume:Float = 1;
	public var paused:Bool = false;
	public static var iAmSobre:Bool = false;
	#if desktop
	public static var vlcBitmap:VlcBitmap;
	#end
	public var queronaoviver:Bool = false;
	var oldPosition:Float = 0;

	public function new()
	{
		FlxG.autoPause = false;

		if (FlxG.sound.music != null)
		{
			//FlxG.sound.music.stop();
		}
	}

	public function playMP4(path:String, callback:FlxState, ?outputTo:FlxSprite = null, ?oldPosition:Float, ?repeat:Bool = false, ?isWindow:Bool = false, ?isFullscreen:Bool = false):Void
	{
		#if html5
		FlxG.autoPause = false;

		if (FlxG.sound.music != null)
		{
			//FlxG.sound.music.stop();
		}

		finishCallback = callback;

		video = new Video();
		video.x = 0;
		video.y = 0;

		FlxG.addChildBelowMouse(video);

		var nc = new NetConnection();
		nc.connect(null);

		netStream = new NetStream(nc);
		netStream.client = {onMetaData: client_onMetaData};

		nc.addEventListener("netStatus", netConnection_onNetStatus);

		netStream.play(path);
		#else
		this.oldPosition = oldPosition;
		finishCallback = callback;

		vlcBitmap = new VlcBitmap();
		//vlcBitmap.set_height(FlxG.stage.stageHeight);
		//vlcBitmap.set_width(FlxG.stage.stageHeight * (16 / 9));

		//trace("Setting width to " + FlxG.stage.stageHeight * (16 / 9));
		//trace("Setting height to " + FlxG.stage.stageHeight);

		vlcBitmap.onVideoReady = onVLCVideoReady;
		vlcBitmap.onComplete = onVLCComplete;
		vlcBitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (repeat)
			vlcBitmap.repeat = -1;
		else
			vlcBitmap.repeat = 0;

		vlcBitmap.inWindow = isWindow;
		vlcBitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(vlcBitmap);
		vlcBitmap.play(checkFile(path));

		
		if (outputTo != null)
		{
			// lol this is bad kek
			vlcBitmap.alpha = 0;
	
			sprite = outputTo;
		}
		#end
		canSkip=false;
		if(vimdoplaystatemano)
			{
				queronaoviver=true;
			}
	}

	#if desktop
	function checkFile(fileName:String):String
	{
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1) // Not a path
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1) // C:, D: etc? ..missing "file:///" ?
			pDir = "file:///";

		return pDir + fileName;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function onVLCVideoReady()
	{
		#if debug
		trace("video loaded!");
		#end
		if (sprite != null)
			sprite.loadGraphic(vlcBitmap.bitmapData);	
			if(vimdoplaystatemano)
				{
					var tempoPraPular:Float = Math.floor(Conductor.songPosition / 1000)-oldPosition;
					vlcBitmap.seek(tempoPraPular);
					#if debug
					trace(tempoPraPular);
					#end
				}
	}

	public function onVLCComplete()
	{
		if(iAmSobre==false)
			{
				canSkip=false;
				// Clean player, just in case! Actually no.
		
		
		
				#if debug
				trace("exibi o video");
				#end
		
					if (VideoStatePC.NextState != "title")
					{
						if(!vimdoplaystatemano)
							{
								FlxG.camera.fade(FlxColor.BLACK, 0, false);
								LoadingState.loadAndSwitchState(finishCallback);
							}
						else
							{
								trace('beep bop skidep');
								PlayState.instance.deletarSpriteNAAAAO();
							}
					}
					else if(finishCallback != null && VideoStatePC.NextState == "title" && !vimdoplaystatemano)
						{
							FlxG.camera.fade(FlxColor.BLACK, 0, false);
							VideoStatePC.NextState=="no";
							MusicBeatState.switchState(new TitleState());
						}
					vlcBitmap.stop();
					if (FlxG.game.contains(vlcBitmap))
					{
						vlcBitmap.dispose();
						FlxG.game.removeChild(vlcBitmap);
					}	
			}
		

	}

	public function stopVideo()
		{
			vlcBitmap.stop();
			if (FlxG.game.contains(vlcBitmap))
			{
				vlcBitmap.dispose();
				FlxG.game.removeChild(vlcBitmap);
			}	
		}

	function onVLCError()
	{
		if (finishCallback != null)
		{
			LoadingState.loadAndSwitchState(finishCallback);
		}
	}

	function update(e:Event)
	{
		if (FlxG.keys.justReleased.SPACE && canSkip==true && iAmSobre==false && vimdoplaystatemano==false && !queronaoviver)
		{
			if (vlcBitmap.isPlaying)
			{
				onVLCComplete();
				stopVideo();
				//VideoStatePC.canSkip=false;
			}
		}

		if(VideoStatePC.NextState != "title")
			{
				canSkip=false;
			} 
			// shitty volume fix. then make it louder.
		if (FlxG.sound.volume <= 0.00) {vlcBitmap.volume = 0;} else {vlcBitmap.volume = FlxG.sound.volume + (0.5 * videoVolume);}
	}
	#end

	public function pausarvideo1(h:Bool) // pq h????
		{
			if(h)
				{
					trace('tentei pausar');
					vlcBitmap.pause();
				}
			else
				{
					trace('tentei resumir');
					vlcBitmap.resume();
				}
		}

	/////////////////////////////////////////////////////////////////////////////////////

	function client_onMetaData(path)
	{
		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
	}

	function netConnection_onNetStatus(path)
	{
		if (path.info.code == "NetStream.Play.Complete")
		{
			finishVideo();
		}
	}

	function finishVideo()
	{
		netStream.dispose();

		if (FlxG.game.contains(video))
		{
			FlxG.game.removeChild(video);
		}

		if (finishCallback != null)
		{
			LoadingState.loadAndSwitchState(finishCallback);
		}
		else
			LoadingState.loadAndSwitchState(new MainMenuStateMobile());
	}

	// old html5 player
	/*
		var nc:NetConnection = new NetConnection();
		nc.connect(null);
		var ns:NetStream = new NetStream(nc);
		var myVideo:Video = new Video();
		myVideo.width = FlxG.width;
		myVideo.height = FlxG.height;
		myVideo.attachNetStream(ns);
		ns.play(path);
		return myVideo;
		ns.close();
	 */
}
#end