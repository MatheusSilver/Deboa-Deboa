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
		FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
		jarodou = true;
		var random1:Int = FlxG.random.int(1, 175); // Tava muito difícil de ver
		if (FlxG.save.data.firstTime != null || !ClientPrefs.firstTime || FlxG.save.data.flashing != null) // Algum desses caras tem que funfar
		{
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				#if desktop
				VideoStatePC.specialSetting = TITLE;
				#end
				if (openfl.utils.Assets.exists(Paths.video('VideosRandoms/haha' + random1)))
					#if desktop
					VideoStatePC.videoPath = Paths.video('VideosRandoms/haha' + random1);
				#elseif mobile
					MusicBeatState.switchState(new VideoState(Paths.video('VideosRandoms/haha' + random1),  new TitleState()));
				else
					MusicBeatState.switchState(new VideoState('assets/videos/EngineBase/intromic',  new TitleState()));
				#end

				#if desktop
				MusicBeatState.switchState(new VideoStatePC());
				#end
			});
		} else {
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				#if desktop
				MusicBeatState.switchState(new VideoStatePC());
				#elseif mobile
				MusicBeatState.switchState(new VideoState('assets/videos/EngineBase/intromic',  new TitleState()));
				#end
			});
		}
		super.create();
	}
}
