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
using StringTools;

class PreTitleState extends MusicBeatState
{
	override function create()
		{
            new FlxTimer().start(1.5, function(tmr:FlxTimer){
                MusicBeatState.switchState(new VideoStatePC());
            });
	
			super.create();
		}
}
