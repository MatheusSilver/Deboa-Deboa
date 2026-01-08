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

class MainMenu extends MultiplayerMenu
{
    var bg:FlxSprite;
    var fleet:FlxSprite;
	var label:FlxSprite;
	var faixa:Faixa;

	// aaaa pq que eu fazia os botoes ASSIMMMM AAAAAA MDS EU ERA UM IDIOTA
    var hostBt:MainMenuButton;
    var joinBt:MainMenuButton;
    var skinsBt:MainMenuButton;

    public function new() {
        super();

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/mainmenu/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
		addToMenu(bg, {alpha: 1}, {alpha: 0});

		faixa = new Faixa(0, 177);
		addToMenu(faixa, {x: 0}, {x:-faixa.width*1.1});

		fleet = new FlxSprite(622, -50);
		fleet.loadGraphic(Paths.image('multiplayer/menus/fleetway', 'preload'));
		fleet.antialiasing = ClientPrefs.globalAntialiasing;
		addToMenu(fleet, {alpha: 1}, {alpha: 0});

		FlxTween.tween(fleet, {y:-30}, 1, {ease: FlxEase.sineInOut, type: PINGPONG});

        label = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/mainmenu/label", 'preload'));
        label.x = 40;
        label.y = 78;
		addToMenu(label, {y: 78}, {y: -label.height*1.1});

        hostBt = new MainMenuButton(Linguagem.LangUtil.getString("main_host_bt", "multiplayer"), 40, 300, this, false, function(){
			MultiplayerMainMenuState.instance.hostear();
		}, null);
		addToMenu(hostBt, {y: 300}, {y: 1780});

		joinBt = new MainMenuButton(Linguagem.LangUtil.getString("main_join_bt", "multiplayer"), 40, 400, this, true, function(){
			MultiplayerMainMenuState.instance.changeMenu(ROOMLIST);
		}, null);
		addToMenu(joinBt, {y: 400}, {y: 1780});

		skinsBt = new MainMenuButton(Linguagem.LangUtil.getString("main_skins_bt", "multiplayer"), 40, 500, this, false, function(){
			MultiplayerMainMenuState.instance.changeMenu(SKINS);
		}, null);
		addToMenu(skinsBt, {y: 500}, {y: 1780});

    }
}

class MainMenuButton extends FlxButton
{
    public function new(label:String, x:Float, y:Float,  parent:MultiplayerMenu, ?isOrange:Bool = false, ?callback:Function = null, ?arg:Dynamic= null) {
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
			if(!this.visible || !parent.amActive())
				return;
			GlobalSoundManager.play(scrollMenu);
			this.alpha=1;
		}
		this.onOut.callback = function() {
			if(!this.visible || !parent.amActive())
				return;
			this.alpha=0.75;
		}
		this.onDown.callback = function() {
			if(!this.visible || callback == null || !parent.amActive())
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

