package multiplayer.menus.shared;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.ErrorEvent;
import openfl.display.Loader;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import gamejolt.GJClient;
import Utils;

using StringTools;


class Faixa extends FlxSpriteGroup {
    var icon:FlxSprite;
    var bg:FlxSprite;
    var text:Array<FlxText>;

    public function new(x:Int, y:Int) {
        super(x, y);

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/faixa"));
        bg.x = 0;
        bg.y = 0;
        add(bg);

        icon = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
        icon.antialiasing = ClientPrefs.globalAntialiasing;
        icon.setGraphicSize(62, 62);
        icon.y = 9;
        icon.x = 50;
        add(icon);

        text = Utils.createColoredText("ONLINE", [FlxColor.fromRGB(233, 99, 34), FlxColor.fromRGB(253, 246, 241)], 122, 0, 48, Linguagem.LangUtil.getFont("gobold"), -2);
        for(letra in text) {
            add(letra);
        }
        pegarIcon();
    } 

    function pegarIcon()
    {
        var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
            if(!GJClient.avatarURL.contains("no-avatar"))
            {
				var bmp:Bitmap = cast(loader.content, Bitmap);
				var bmd:BitmapData = bmp.bitmapData;
				icon.loadGraphic(FlxGraphic.fromBitmapData(bmd, false));
				icon.setGraphicSize(62, 62); // aparentemente aquele numero do link é uma mentira :womp: :womp:
				icon.updateHitbox();
				var tempMask:FlxSprite = new FlxSprite(icon.x, icon.y);
				//Por algum motivo, não posso só colocar ele pra trackear o userOutline :fist::pensive:
				tempMask.makeGraphic(62, 62, FlxColor.TRANSPARENT);
				var tempCircle:FlxSprite = FlxSpriteUtil.drawCircle(tempMask,(tempMask.width)/2,(tempMask.height)/2,Math.min(tempMask.width, tempMask.height)/2-3,FlxColor.RED);
				// add(tempCircle);
				FlxSpriteUtil.alphaMaskFlxSprite(icon, tempCircle, icon);
				tempMask.destroy();
				tempCircle.destroy();
			}
		});
		loader.load(new URLRequest(GJClient.avatarURL.replace("/62/",'/${Std.int(icon.height)}/').replace(".webp", ".png")));
    }
}