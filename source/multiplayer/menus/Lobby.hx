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
import multiplayer.menus.shared.Faixa.FaixaLobby;
import Linguagem.LangUtil;

using StringTools;

class Lobby extends FlxTypedGroup<FlxBasic> 
{
    public static var instance:Lobby;

    var bg:FlxSprite;
	var faixa:FaixaLobby;
	var faixaLeft:FaixaLobby;


    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/lobby/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
        add(bg);

		faixa = new FaixaLobby(GJClient.myID, 0, 62, false);
		add(faixa);

        faixaLeft = new FaixaLobby(GJClient.myID, 0, 162, true);
		add(faixaLeft);

    }
}