package multiplayer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.addons.ui.FlxUIInputText;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.colyseus.Client;
import io.colyseus.Room;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import ibwwg.FlxScrollableArea;
import flixel.math.FlxRect;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class MenuState extends MusicBeatState
{
    override function create()
    {
        super.create();
    }
}