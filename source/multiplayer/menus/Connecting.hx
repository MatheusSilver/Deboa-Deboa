package multiplayer.menus;

import cpp.abi.Abi;
import haxe.Constraints.Function;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.addons.ui.FlxUIInputText;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.colyseus.Client;
import io.colyseus.Room;
import io.colyseus.events.EventHandler;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import Utils.FlxScrollableArea;
import flixel.math.FlxRect;
import openfl.utils.Assets as OpenFlAssets;
import multiplayer.schemas.*;
import multiplayer.entities.*;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;
import gamejolt.*;
import Utils;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;
import multiplayer.menus.shared.*;
import Linguagem.LangUtil;

using StringTools;

class Connecting extends MultiplayerMenu
{
    public static var instance:Connecting;

    var bg:FlxSprite;
	var text:FlxText;

    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("ph", 'preload')); // paulo henrique
        bg.setGraphicSize(FlxG.width, FlxG.height);
		addToMenu(bg, {alpha: 1}, {alpha: 0});

		text = new FlxText(0, 0, 0, Linguagem.LangUtil.getString("txt_connecting", "multiplayer"), 24);
		text.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 24, 0xFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.screenCenter(XY);
		addToMenu(text, {alpha: 1}, {alpha: 0});
    }
}