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
    public var players:Array<LobbyPlayer> = [new LobbyPlayer(203, -10, true, "0"), new LobbyPlayer(522, 218, false, "0")];
    var go:FlxButton;


    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/lobby/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
        add(bg);

        for (player in players) {
            add(player);
        }

        go = new FlxButton(1126,511, "", function(){
			if(MultiplayerMainMenuState.instance.canInitMatch && !MultiplayerMainMenuState.instance.isPlayingMatch)
				{	
					MultiplayerMainMenuState.instance.curRoom.send("toggle-ready");
				}
        });
        go.loadGraphic(Paths.image("multiplayer/menus/go", 'preload'));
        add(go);
    }
}

class LobbyPlayer extends FlxSpriteGroup
{
    public var gjID:String;
    public var sessionId:String = "";
	public var noteSkin:String = "NOTE_assets";
    public var faixa:FaixaLobby;
	public var bf:FlxSprite;
    public var isPlayer1:Bool;

    public function new(x:Float, y:Float, isPlayer1:Bool, gamejoltID:String)
	{
		super(x,y);
        this.isPlayer1 = isPlayer1;
        bf = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/lobby/"+(isPlayer1?"exe":"bf")));
        bf.setGraphicSize(Std.int(bf.width * 0.6667), Std.int(bf.height * 0.6667));
        add(bf);
        updatePlayer(gamejoltID);
	}

    public function updatePlayer(newGJID:String) {
        if(gjID == newGJID)
            return;

        gjID=newGJID;

        this.alpha = gjID == "0" ? 0.75 : 1;
        if(faixa!=null && faixa.text!=null) {
            for(texto in faixa.text) {
                faixa.remove(texto);
            }
            remove(faixa);
        }
		faixa = new FaixaLobby(gjID, 0, bf.y+78, isPlayer1);
        faixa.visible = true;
        if(isPlayer1) {
            faixa.x-=(faixa.width)+(938*0.64);
            faixa.x+=faixa.width;
        } else {
            faixa.y-=260;
            faixa.x+=120;
        }
        add(faixa);
    }

    public function getName():String {
        if(gjID == "0")
            return "Epaminondas";
        var userData:User = GJClient.getUserData(Std.parseInt(gjID));
        return userData == null ? "Epaminondas" : userData.username; 
    }
}