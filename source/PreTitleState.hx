package;

import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
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
			#if desktop
            new FlxTimer().start(1.5, function(tmr:FlxTimer){
                MusicBeatState.switchState(new VideoStatePC());
            });
			#elseif mobile
			new FlxTimer().start(1.5, function(tmr:FlxTimer){
                MusicBeatState.switchState(new VideoState('assets/videos/intromic', (new TitleState()))); 
            });
			#end
			//First time seria válido aqui tambem?
			// nn, é pra tocar toda hora que a pessoa entrar mesmo
			super.create();
		}
}
