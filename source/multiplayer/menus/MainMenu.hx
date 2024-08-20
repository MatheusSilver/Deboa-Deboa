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

using StringTools;

class MainMenu extends FlxTypedGroup<FlxBasic> 
{
    public static var instance:MainMenu;

    var bg:FlxSprite;
    var fleet:FlxSprite;
	var label:FlxSprite;
	var faixa:Faixa;

    var hostBt:MainMenuButton;
    var joinBt:MainMenuButton;
    var skinsBt:MainMenuButton;

    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/mainmenu/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
        add(bg);

		faixa = new Faixa(0, 177);
		add(faixa);

		fleet = new FlxSprite(426, -187);
		fleet.frames = Paths.getSparrowAtlas('multiplayer/menus/mainmenu/FleetwayMulti', 'preload');
		fleet.animation.addByPrefix('Idle', "Idle", 30);
		fleet.setGraphicSize(Std.int(fleet.width/1.3));
		fleet.antialiasing = ClientPrefs.globalAntialiasing;
		add(fleet);
		fleet.animation.play('Idle', true, false);
		fleet.animation.finishCallback = (a:String)->{
			fleet.animation.play('Idle', true, false);
		}

        label = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/mainmenu/label", 'preload'));
        label.x = 40;
        label.y = 78;
        add(label);

        hostBt = new MainMenuButton(Linguagem.LangUtil.getString("main_host_bt", "multiplayer"), 40, 300, false, function(){
			MultiplayerMainMenuState.instance.hostear();
		});
		add(hostBt);

		joinBt = new MainMenuButton(Linguagem.LangUtil.getString("main_join_bt", "multiplayer"), 40, 400, true, function(){
			MultiplayerMainMenuState.instance.changeMenu(ROOMLIST);
		});
		add(joinBt);

		skinsBt = new MainMenuButton(Linguagem.LangUtil.getString("main_skins_bt", "multiplayer"), 40, 500, false, function(){
			MultiplayerMainMenuState.instance.changeMenu(SKINS);
		});
		add(skinsBt);
    }
}

class MainMenuButton extends FlxButton
{
    public function new(label:String, x:Float, y:Float, ?isOrange:Bool = false, ?callback:Function = null, ?arg:Dynamic= null, ?parent:FlxState) {
        super(x,y);
		this.loadGraphic(Paths.image("multiplayer/menus/mainmenu/" + (isOrange ? "bt-orange" : "bt"), 'preload'));
        this.updateHitbox();

		if(label != null)
		{
			this.label = new FlxText(0, 0, this.width, label);
			this.label.setFormat(Linguagem.LangUtil.getFont("gameboy"), 56, isOrange ? FlxColor.fromRGB(16, 7, 2) : FlxColor.fromRGB(245, 90, 15), CENTER);
			this.label.offset.y = -3;
		}
		this.alpha = 0.75;
		this.onOver.callback = function() {
			if(!this.visible || !MultiplayerMainMenuState.instance.canClick || !MainMenu.instance.visible)
				return;
			GlobalSoundManager.play(scrollMenu);
			this.alpha=1;
		}
		this.onOut.callback = function() {
			if(!this.visible || !MultiplayerMainMenuState.instance.canClick || !MainMenu.instance.visible)
				return;
			this.alpha=0.75;
		}
		this.onDown.callback = function() {
			if(!this.visible || callback == null || !MultiplayerMainMenuState.instance.canClick || !MainMenu.instance.visible)
				return;
			GlobalSoundManager.play(confirmMenu);
			if(arg != null)
			{
				callback(arg);
			}
			else
			{
				callback();
			}
			this.alpha=0.75;
		}
    }
}

