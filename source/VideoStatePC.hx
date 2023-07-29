package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class VideoStatePC extends MusicBeatState
{
	var videoMenu:FlxSprite = new FlxSprite(0, 0);
	var video:MP4Handler = new MP4Handler();
	var letext:FlxText;

	public static var videoPath:String = Paths.video("EngineBase/intromic.mp4");
	public static var NextState:String = "title";

	override function create()
	{
		video.canSkip = false;
		if (NextState != "title" && NextState != "playstate")
		{
			FlxG.sound.music.fadeIn(0.35, 0.7, 0);
		}
		add(videoMenu);

		// Nashira, és tu??????????
		// Sei que o if else if é bastante usado na unity e etc, desculpa dav!!!!

		// Até que tá mais bonitinho agora
		switch (NextState)
		{
			case "mainmenu":
				video.playMP4(videoPath, new MainMenuStateMobile(), videoMenu);
			case "sobremenu":
				video.playMP4(videoPath, new SobreState(), videoMenu);
			case "title":
				video.playMP4(videoPath, new TitleState(), videoMenu);
				FlxTransitionableState.skipNextTransOut = true;
			case "playstate":
				video.playMP4(videoPath, new PlayState(), videoMenu);
			default:
				video.playMP4(videoPath, new MainMenuStateMobile(), videoMenu);
		}

		letext = new FlxText(50, FlxG.height - 100, FlxG.width - 100, "Aperte espaço para pular", 32); // Achei cringe
		letext.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.scrollFactor.set();
		letext.alpha = 0;
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
