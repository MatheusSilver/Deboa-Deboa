package;

import flixel.FlxG;
import flixel.util.FlxTimer;

using StringTools;

class PreTitleState extends MusicBeatState
{
	override function create()
		{
			var random1:Int = FlxG.random.int(0, 300);
			if(!ClientPrefs.firstTime)
				{
					#if desktop
		
						new FlxTimer().start(1.5, function(tmr:FlxTimer){
							if(openfl.utils.Assets.exists('assets/videos/VideosRandom/haha' + random1+ '.mp4')) {
								VideoStatePC.videoPath='assets/videos/VideosRandom/haha' + random1 + '.mp4';
							}
							MusicBeatState.switchState(new VideoStatePC());
						});

					#elseif mobile
					//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
					new FlxTimer().start(1.5, function(tmr:FlxTimer){
						if(openfl.utils.Assets.exists('assets/videos/VideosRandom/haha' + random1+ '.mp4')) {
							MusicBeatState.switchState(new VideoState('assets/videos/VideosRandom/haha' + random1, (new TitleState()))); 
						} else{
							MusicBeatState.switchState(new TitleState()); 
						}						
					});
					#end
				}
			else
				{
					#if desktop
					new FlxTimer().start(1.5, function(tmr:FlxTimer){MusicBeatState.switchState(new VideoStatePC());});
					#elseif mobile
					new FlxTimer().start(1.5, function(tmr:FlxTimer){FlxG.switchState(new VideoState('assets/videos/EngineBase/intromic', (new TitleState())));});
					#end
				}
			super.create();
		}
}
