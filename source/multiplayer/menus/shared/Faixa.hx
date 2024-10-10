package multiplayer.menus.shared;

import gamejolt.User;
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

class FaixaLobby extends FlxSpriteGroup {
    var gameJoltID:Int;
    var icon:FlxSprite;
    var bgInicio:FlxSprite;
    var bgFinal:FlxSprite;
    public var bgMeio:FlxSprite;
    var text:Array<FlxText>;

    var userData:User;

    public function new(gameJoltID:String, x:Float, y:Float, isLeft:Bool) {
        super(x, y);

        this.gameJoltID = Std.parseInt(gameJoltID);
        userData = GJClient.getUserData(Std.parseInt(gameJoltID));

        if(!isLeft) {
            text = Utils.createColoredText(userData!=null ? userData.username.toUpperCase() : " ", [FlxColor.fromRGB(233, 99, 34), FlxColor.fromRGB(253, 246, 241)], 122, -1, 36, Linguagem.LangUtil.getFont("gobold"), -2);

            bgInicio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa1"));
    
            bgMeio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa3"));
            bgMeio.setGraphicSize(Std.int(text[text.length-1].x-bgInicio.x)-1, 56);
            bgMeio.updateHitbox();
            add(bgMeio);
            add(bgInicio);
            bgMeio.x+=bgInicio.width;
            bgMeio.y+=1;
    
            bgFinal = new FlxSprite(bgMeio.x+bgMeio.width, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa2"));
            add(bgFinal);
    
            icon = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
            icon.antialiasing = ClientPrefs.globalAntialiasing;
            icon.setGraphicSize(62, 62);
            icon.y = -2;
            icon.x = 50;
            icon.visible = false;
            add(icon);
        } else {
            text = Utils.createColoredText(userData!=null ? userData.username.toUpperCase() : " ", [FlxColor.fromRGB(233, 99, 34), FlxColor.fromRGB(253, 246, 241)], 122, -1, 36, Linguagem.LangUtil.getFont("gobold"), -2);

            bgInicio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa2"));
            bgInicio.flipX=true;
    
            bgMeio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa3"));
            bgMeio.setGraphicSize(Std.int(text[text.length-1].x-bgInicio.x)-1, 56);
            bgMeio.updateHitbox();
            add(bgMeio);
            add(bgInicio);
            bgMeio.x+=bgInicio.width;
            bgMeio.y+=1;
    
            bgFinal = new FlxSprite(bgMeio.x+bgMeio.width, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa1"));
            bgFinal.flipX=true;
            add(bgFinal);

            for(textinho in text) {
                textinho.x+=(bgMeio.x+1)-120;
            }
    
            icon = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
            icon.antialiasing = ClientPrefs.globalAntialiasing;
            icon.setGraphicSize(62, 62);
            icon.y = -2;
            icon.x = bgFinal.x-80;
            icon.visible = false;
            add(icon);
        }



        for(letra in text) {
            add(letra);
        }
        pegarIcon();
        icon.visible = true;
    } 

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(FlxG.keys.pressed.S){
            icon.y++;
        }
        if(FlxG.keys.pressed.W){
            icon.y--;
        }
        if(FlxG.keys.pressed.A){
            icon.x--;
        }
        if(FlxG.keys.pressed.D){
            icon.x++;
        }

        FlxG.watch.addQuick("icon X", icon.x);
        FlxG.watch.addQuick("icon Y", icon.y);
    }

    function pegarIcon()
    {
        if(gameJoltID==0) {
            icon.loadGraphic(Paths.image("menus/gamejolt/userIcon"));
            icon.setGraphicSize(47, 47);

            return;
        }
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
                icon.setGraphicSize(47, 47);
			}
		});
		loader.load(new URLRequest(userData.avatar_url.replace("/62/",'/${Std.int(icon.height)}/').replace(".webp", ".png")));
    }
}