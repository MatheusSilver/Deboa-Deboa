package;

import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
import flixel.util.FlxTimer;
import FunkinLua;
import Shaders;
using StringTools;

class PreTitleState extends MusicBeatState
{
	override function create()
		{
			var random1:Int = FlxG.random.int(0, 300);
			#if desktop
            new FlxTimer().start(1.5, function(tmr:FlxTimer){
				if(random1 == 95)
					{
						VideoStatePC.videoPath='assets/videos/haha.mp4';
					}
				else if(random1==94)
					{
						VideoStatePC.videoPath='assets/videos/haha1.mp4';
					}
					else if(random1==93)
						{
							VideoStatePC.videoPath='assets/videos/haha2.mp4';
						}
						else if(random1==92)
							{
								VideoStatePC.videoPath='assets/videos/haha3.mp4';
							}
							else if(random1==91)
								{
									VideoStatePC.videoPath='assets/videos/haha4.mp4';
								}
								else if(random1==90)
									{
										VideoStatePC.videoPath='assets/videos/haha5.mp4';
									}
									else if(random1==96)
										{
											VideoStatePC.videoPath='assets/videos/haha6.mp4';
										}
										else if(random1==97)
											{
												VideoStatePC.videoPath='assets/videos/haha7.mp4';
											}
											else if(random1==98)
												{
													VideoStatePC.videoPath='assets/videos/haha8.mp4';
												}
											else
												{
													// nada '-'
												}
                MusicBeatState.switchState(new VideoStatePC());
            });
			#elseif mobile
			new FlxTimer().start(1.5, function(tmr:FlxTimer){
				if(random1 == 95)
					{
						MusicBeatState.switchState(new VideoState('assets/videos/haha', (new TitleState()))); 
					}
				else if(random1==94)
					{
						MusicBeatState.switchState(new VideoState('assets/videos/haha1', (new TitleState()))); 
					}
					else if(random1==93)
						{
							MusicBeatState.switchState(new VideoState('assets/videos/haha2', (new TitleState()))); 
						}
						else if(random1==92)
							{
								MusicBeatState.switchState(new VideoState('assets/videos/haha3', (new TitleState()))); 
							}
							else if(random1==91)
								{
									MusicBeatState.switchState(new VideoState('assets/videos/haha4', (new TitleState()))); 
								}
								else if(random1==90)
									{
										MusicBeatState.switchState(new VideoState('assets/videos/haha5', (new TitleState()))); 
									}
									else if(random1==96)
										{
											MusicBeatState.switchState(new VideoState('assets/videos/haha6', (new TitleState()))); 
										}
										else if(random1==97)
											{
												MusicBeatState.switchState(new VideoState('assets/videos/haha7', (new TitleState()))); 
											}
											else if(random1==98)
												{
													MusicBeatState.switchState(new VideoState('assets/videos/haha8', (new TitleState()))); 
												}
											else
												{
													MusicBeatState.switchState(new VideoState('assets/videos/intromic', (new TitleState()))); 
												}
            });
			#end
			//First time seria válido aqui tambem?
			// nn, é pra tocar toda hora que a pessoa entrar mesmo
			super.create();
		}
}
