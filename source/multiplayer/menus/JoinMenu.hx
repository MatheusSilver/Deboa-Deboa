package multiplayer.menus;

import multiplayer.MultiplayerMainMenuState.RoomObject;
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

class JoinMenu extends MultiplayerMenu
{
    public static var instance:JoinMenu;

    var bg:FlxSprite;
    var fleet:FlxSprite;
	var faixa:Faixa;

    public var roomList:RoomList;
    var refreshBt:FlxButton;


    public function new() {
        super();
        instance = this;

        roomList = new RoomList(35, 148);
		addToMenu(roomList, {y: 148}, {y: 1780});

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/joinmenu/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
		addToMenu(bg, {alpha: 1}, {alpha: 0});

		faixa = new Faixa(0, 62);
        addToMenu(faixa, {x: 0}, {x:-faixa.width*1.1});

		fleet = new FlxSprite(622, -50);
		fleet.loadGraphic(Paths.image('multiplayer/menus/fleetway', 'preload'));
		fleet.antialiasing = ClientPrefs.globalAntialiasing;
		addToMenu(fleet, {alpha: 1}, {alpha: 0});

		FlxTween.tween(fleet, {y:-30}, 1, {ease: FlxEase.sineInOut, type: PINGPONG});

        refreshBt = new FlxButton(547, 564, "", function(){
			if(!MultiplayerMainMenuState.instance.canClick || !refreshBt.visible)
				return;
			refreshRooms();
		});
		refreshBt.loadGraphic(Paths.image("multiplayer/menus/joinmenu/refreshbutton"));
		addToMenu(refreshBt, {y: 564}, {y: 1780});
    }

    public function refreshRooms() {
        roomList.createAll();
    }
}

class RoomList extends FlxSpriteGroup
{
    var outline:FlxSprite;
    var label:FlxText;
    var fakeBG:FlxSprite;

    var roomObjects:FlxSpriteGroup;
    var objectsArray:Array<RoomButton> = new Array<RoomButton>();

    public function new(x:Int, y:Int) {
        super(x,y);
        createAll();
    }

    public function createAll() {
        fakeBG = new FlxSprite(2,3).loadGraphic(Paths.image("multiplayer/menus/joinmenu/fakebg", 'preload'));
        add(fakeBG);

        refresh(MultiplayerMainMenuState.instance.getAvailableRooms());

        outline = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/joinmenu/roomList", 'preload'));
        add(outline);

        label = new FlxText(5, 9, 574, "ROOMLIST", 46);
		label.setFormat(LangUtil.getFont("gameboy"), 46, FlxColor.WHITE, FlxTextAlign.CENTER);
		label.wordWrap = false;
		label.alignment = CENTER;
		add(label);
    }

    public function refresh(rooms:Array<RoomAvailable>) {
        clearAll();
		var num:Int = 1;
        if(rooms != null) {
            for (room in rooms) {
                if(room.metadata.privateRoom == false)
                {
                    var roomButton:RoomButton = new RoomButton(room.metadata.displayName, 0, ((88*num)+num*5), room);
                    roomObjects.add(roomButton);
                    objectsArray.push(roomButton);
                    num++;
                }
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if(BSLTouchUtils.over(this) && this.visible && objectsArray.length > 0) {
            swipes();
        }
    }

    public function swipes() {
        BSLSwipeUtils.swipeVertical();

        var canSwipeUp:Bool = true;
        var canSwipeDown:Bool = true;
        var numeroSuperManeiro:Float = 535;

        canSwipeDown = objectsArray[objectsArray.length-1].y >= numeroSuperManeiro;
        canSwipeUp = objectsArray[0].y <= 250;

        if(canSwipeUp && BSLSwipeUtils.scrollY > 0 || canSwipeDown && BSLSwipeUtils.scrollY < 0)
            {
                for (sala in objectsArray){
                    sala.y += BSLSwipeUtils.scrollY*20;
                }
            }
    }

    public function clearAll() {
        for(room in objectsArray) {
            remove(room);
        }
        roomObjects = cast add(new FlxSpriteGroup());
    }

    
}

class RoomButton extends FlxButton
{
    public function new(label:String, x:Float, y:Float, room:RoomAvailable) {
        super(x,y);
		this.loadGraphic(Paths.image("multiplayer/menus/mainmenu/bt-orange", 'preload'));
        this.updateHitbox();

		if(label != null)
		{
			this.label = new FlxText(0, 0, this.width, label);
			this.label.setFormat(Linguagem.LangUtil.getFont("gameboy"), 56, FlxColor.fromRGB(16, 7, 2), CENTER);
			this.label.offset.y = -3;
            this.label.autoSize=true;
            this.label.alignment=CENTER;
		}

		this.onDown.callback = function() {
			/*if(!MultiplayerMainMenuState.instance.canClick || !this.visible)
				return;*/
            MultiplayerMainMenuState.instance.entrar(room);
			GlobalSoundManager.play(confirmMenu);
		}
    }
}