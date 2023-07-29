package;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;

using StringTools;

class PreTitleState extends MusicBeatState
{
	public static var jarodou:Bool = false;

	override function create()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		jarodou = true;
		var random1:Int = FlxG.random.int(0, 350);
		if (FlxG.save.data.firstTime != null || !ClientPrefs.firstTime || FlxG.save.data.flashing != null) // Algum desses caras tem que funfar
		{
			#if desktop
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				if (openfl.utils.Assets.exists('assets/videos/VideosRandoms/haha' + random1 + '.mp4'))
				{
					VideoStatePC.videoPath = 'assets/videos/VideosRandoms/haha' + random1 + '.mp4';
				}

				MusicBeatState.switchState(new VideoStatePC());
			});
			#elseif mobile
			// aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				if (openfl.utils.Assets.exists('assets/videos/VideosRandoms/haha' + random1 + '.mp4'))
				{
					MusicBeatState.switchState(new VideoState('assets/videos/VideosRandoms/haha' + random1, (new TitleState())));
				}
				else
				{
					MusicBeatState.switchState(new VideoState('assets/videos/EngineBase/intromic', (new TitleState())));
				}
			});
			#end
		}
		else
		{
			#if desktop
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new VideoStatePC());
			});
			#elseif mobile
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new VideoState('assets/videos/EngineBase/intromic', (new TitleState())));
			});
			#end
		}
		super.create();
	}
}
