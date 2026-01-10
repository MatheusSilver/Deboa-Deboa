package;

import flixel.FlxG;
import flixel.FlxState;
#if desktop
import MP4Sprite;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;

class VideoStatePC extends MusicBeatState
{
	var video:MP4Sprite;
	var skipText:SkipText;

	public static var videoPath:String = Paths.video("EngineBase/intromic");
	public static var NextState:FlxState = new TitleState();
	public static var specialSetting:MP4Sprite.GameState;

	override function create()
	{
		video = new MP4Sprite(0,0, specialSetting);
		video.canSkip = false;
		video.setParent(this);
		Main.mouse_allowed=false;
		
		video.playMP4(videoPath, NextState);
		
		skipText = new SkipText(-50, FlxG.height - 150); // Isso é exclusivo daqui, não é usado no Android e nem no MP4Sprite.
		skipText.updateHitbox();
		skipText.scrollFactor.set();
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
		var justPressed:Bool = Input.Controls.get_ANY() #if android || BSLTouchUtils.justTouched() #end; // Aqui vai uma fix pro Android também, já que não tinha como pular os vídeos nele.
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
#end