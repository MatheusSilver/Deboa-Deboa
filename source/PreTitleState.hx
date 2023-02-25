package;

import flixel.FlxG;
import flixel.util.FlxTimer;

using StringTools;

class PreTitleState extends MusicBeatState
{

	public static var jarodou:Bool = false;
	override function create()
		{
			jarodou = true;
			var random1:Int = FlxG.random.int(0, 300);
			if(FlxG.save.data.firstTime != null || !ClientPrefs.firstTime || FlxG.save.data.flashing != null) //Algum desses caras tem que funfar
				{
					#if desktop
					#if debug
					trace('assets/videos/VideosRandoms/haha' + random1 + '.mp4'); //O nome da pasta estava errado kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
					#end
						new FlxTimer().start(1.5, function(tmr:FlxTimer){
							if(openfl.utils.Assets.exists('assets/videos/VideosRandoms/haha' + random1+ '.mp4')) {
								VideoStatePC.videoPath='assets/videos/VideosRandoms/haha' + random1 + '.mp4';
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
