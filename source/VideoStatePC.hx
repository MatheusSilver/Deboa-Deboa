package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
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
	
	override function create()
		{
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo os creditos", null);
			#end
			FlxG.sound.music.fadeOut(0.35, 0.7, 0);
			video.playMP4('assets/videos/aviso.mp4', new MainMenuStateMobile(), videoMenu);
			add(videoMenu);
	
			super.create();
		}
		
}
