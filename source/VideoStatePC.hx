package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import lime.utils.Assets;
using StringTools;

class VideoStatePC extends MusicBeatState
{
	var videoMenu:FlxSprite = new FlxSprite(0,0);
	var video:MP4Handler = new MP4Handler();
	var letext:FlxText;
	public static var videoPath:String = "";
	public static var NextState:String = "";


	override function create()
		{
			#if desktop
			// Updating Discord Rich Presence
			//DiscordClient.changePresence("", null);
			#end
			FlxG.sound.music.fadeIn(0.35, 0.7, 0);
			add(videoMenu);
			if(NextState == "mainmenu")
				{
					video.playMP4(videoPath, new MainMenuStateMobile(), videoMenu);
				}
			else if(NextState == "sobremenu")
				{
					video.playMP4(videoPath, new SobreState(), videoMenu);
				}
			else
			{
				video.playMP4(videoPath, new MainMenuStateMobile(), videoMenu);
			}
			letext = new FlxText(50, FlxG.height - 100, FlxG.width - 100, "Aperte espaço para sair", 32); //Achei cringe
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
			if(letext.alpha == 0 && FlxG.keys.justReleased.ANY)
				{
					alphaon=true;
					twn.start(4, function(twn:FlxTimer){CompletedTimer();});
				}

				if(alphaon && letext.alpha!=1)
					{
						letext.alpha= letext.alpha+0.25;
						video.canSkip = false;
					}
					else if(alphaon && letext.alpha==1)
						{
							video.canSkip = true;
						}

						if(!alphaon && letext.alpha!=0)
							{
								letext.alpha= letext.alpha-0.25;
								video.canSkip = false;
							}
							else if(!alphaon && letext.alpha==0)
								{
									video.canSkip = false;
								}
				
		}
	function CompletedTimer()
		{
			video.canSkip=false;
			alphaon=false;
		}
}
