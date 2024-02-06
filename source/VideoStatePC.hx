package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class VideoStatePC extends MusicBeatState
{
	var video:MP4Sprite;
	var letext:FlxText;

	public static var videoPath:String = Paths.video("EngineBase/intromic");
	public static var NextState:FlxState = new TitleState();
	public static var specialSetting:MP4Sprite.GameState;

	override function create()
	{
		video = new MP4Sprite(0,0, specialSetting);
		video.canSkip = false;
		video.setParent(this);
		
		/*if (specialSetting != TITLE && specialSetting != PLAYSTATE)
		{
			FlxG.sound.music.fadeIn(0.35, 0.7, 0);
		}*/

		// Nashira, és tu??????????
		// Sei que o if else if é bastante usado na unity e etc, desculpa dav!!!!

		// Até que tá mais bonitinho agora
		video.playMP4(videoPath, NextState);

		letext = new FlxText(50, FlxG.height - 100, FlxG.width - 100, LangUtil.getString("descVideo"), 32); // Achei cringe
		letext.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.scrollFactor.set();
		letext.alpha = 0;

		add(video);
		add(letext);

		super.create();
	}

	var twn:FlxTimer = new FlxTimer();
	var alphaon:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (letext.alpha == 0 && FlxG.keys.justReleased.ANY)
		{
			alphaon = true;
			twn.start(4, function(twn:FlxTimer)
			{
				CompletedTimer();
			});
		}

		if (alphaon && letext.alpha != 1)
		{
			letext.alpha = letext.alpha + 0.25;
			video.canSkip = false;
		}
		else if (alphaon && letext.alpha == 1)
		{
			video.canSkip = true;
		}

		if (!alphaon && letext.alpha != 0)
		{
			letext.alpha = letext.alpha - 0.25;
			video.canSkip = false;
		}
		else if (!alphaon && letext.alpha == 0)
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
