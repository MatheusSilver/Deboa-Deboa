package gamejolt;

// Aparentemente as coordenadas ficam bugadas em substates...
// Talvez eu precise usar camera, mas não tenho certeza
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flash.filters.BlurFilter;
import flixel.group.FlxSpriteGroup;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.net.URLRequest; // chamoy
import flixel.util.FlxSpriteUtil;
import openfl.events.Event;
import openfl.events.ErrorEvent;
import openfl.display.Loader;
import flixel.graphics.FlxGraphic;
#if rpc
import Discord.DiscordClient;
#end
import flixel.FlxCamera;

using StringTools;

class GameJoltFriendsMenu extends MusicBeatSubstate
{
	var bg:FlxSprite;
    var voltar_button:FlxButton;
    var label:FlxText;
    public var camElementos:FlxCamera;
    var sumidao:Bool = false;
    var blur:BlurFilter;
    public var amigos:Array<FriendObject> = [];

	public function new()
	{
		super();
        if(ClientPrefs.shaders)
        {
            blur = new BlurFilter();
            blur.blurX = 0;
            blur.blurY = 0;
        }
        
        MainMenuStateMobile.canClick = false;

        camElementos = new FlxCamera();
		camElementos.bgColor.alpha = 0;
        FlxG.cameras.add(camElementos, false);

		#if rpc
		DiscordClient.changePresence(LangUtil.getString("rpc_friends", "rpc"), null);
		#end

		bg = new FlxSprite(0, 1280).loadGraphic(Paths.image("menus/gamejolt/amigos/BG"));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter(XY);
        bg.y = 1280;
        bg.cameras = [camElementos];
		add(bg);

        voltar_button = new FlxButton(973, 63+1280, function() {
            if(sumidao)
                return;
            sumidao = true;
            tweenSair();
        });
        voltar_button.alpha = 0;
        voltar_button.visible = true;
        voltar_button.label = new FlxText(0, 3, 229, LangUtil.getString("menu_back", "menu"), 50);
        voltar_button.label.setFormat(Paths.font("letravio.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        voltar_button.cameras = [camElementos];
        voltar_button.setGraphicSize(229, 103);
        voltar_button.updateHitbox();
        voltar_button.label.offset.y-=7;
        add(voltar_button);

        label = new FlxText(0, 0, 600, LangUtil.getString("menu_friends", "menu"), 70);
        label.setFormat(Paths.font("letravio.ttf"), 70, FlxColor.WHITE, LEFT);
        label.cameras = [camElementos];
        label.x = 145;
        label.y = 65+1280;
        add(label);

        var x1:Float = 1; // bora x1?
        for(user in GJClient.getFriendsList())
        {
            var friendo:FriendObject = new FriendObject(98*x1, 1464, user);
            friendo.cameras = [camElementos];
            amigos.push(friendo);
            add(friendo);
            x1+=3.85;
        }

        tweenEntrar();
	}

    function tweenEntrar()
    {
        MainMenuStateMobile.instance.camGame.setFilters([blur]);
        MainMenuStateMobile.instance.camAchievement.setFilters([blur]);
        FlxTween.tween(blur, {blurX: 3, blurY: 3}, 0.5, {ease: FlxEase.quartInOut});
        FlxTween.tween(label, {y: 65}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(voltar_button, {y: 63}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(bg, {y: 0}, 0.5, {ease: FlxEase.expoInOut});
        for(amigo in amigos)
        {
            FlxTween.tween(amigo, {y: 184}, 0.5, {ease: FlxEase.expoInOut});
        }
    }

    function tweenSair()
    {
        MainMenuStateMobile.instance.voltarUser();
        FlxTween.tween(blur, {blurX: 0, blurY: 0}, 0.5, {ease: FlxEase.quartInOut});
        FlxTween.tween(label, {y: 65+1280}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(voltar_button, {y: 63+1280}, 0.5, {ease: FlxEase.expoInOut});
        for(amigo in amigos)
            {
                FlxTween.tween(amigo, {y: 1464}, 0.5, {ease: FlxEase.expoInOut});
            }
        FlxTween.tween(bg, {y: 1280}, 0.5, {ease: FlxEase.expoInOut, onComplete: function(e:FlxTween) {
            #if rpc
            DiscordClient.changePresence(LangUtil.getString("rpc_main_menu", "rpc"), null);
            #end
            MainMenuStateMobile.canClick = true;
            MainMenuStateMobile.instance.camGame.setFilters([]);
            MainMenuStateMobile.instance.camAchievement.setFilters([]);
            close();
        }});
    }

	override function update(elapsed:Float)
	{
        voltar_button.label.alpha = 1;
		super.update(elapsed);
        voltar_button.label.alpha = 1;
	}
}

class FriendObject extends FlxSpriteGroup
{
    var user:User;
    var bg:FlxSprite;
    public var icon:FlxSprite;
    var outline:FlxSprite;
    public var name:FlxText;
    public var desc:FlxText;

    public function new(x:Float, y:Float, user:User)
    {
        super(x,y);
        this.user = user;
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/amigos/perfil"));
        add(bg);

        name = new FlxText(0, 0, 360, user.username, 30);
        name.setFormat(Paths.font("letravio.ttf"), 70, FlxColor.WHITE, CENTER);
        name.x+=5;
        name.y+=5;
        add(name);

        icon = new FlxSprite(80+30, 132).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
        icon.antialiasing = ClientPrefs.globalAntialiasing;
        icon.setGraphicSize(152, 152);
        icon.y = 132;
        icon.x = 110;
        add(icon);

        if(user.developer_description != "") // algumas pessoas n tem desc
            {
                desc = new FlxText(0, 0, 360, user.developer_description, 30);
                desc.setFormat(Paths.font("letravio.ttf"), 40, FlxColor.WHITE, CENTER);
                desc.x+=5;
                desc.y+=330;
                add(desc);
            }
        else
        {
            icon.y+=45;
            name.y+=45;
        }

        outline = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userOutline"));
        outline.antialiasing = ClientPrefs.globalAntialiasing;
        outline.setGraphicSize(152, 152);
        outline.y = icon.y;
        outline.x = icon.x;
        add(outline);
        pegarIcon();
    }

    function pegarIcon()
    {
        var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
            if(!user.avatar_url.contains("no-avatar"))
            {
				FlxG.log.add("Achei a PFP da Gamejolt");
				var bmp:Bitmap = cast(loader.content, Bitmap);
				var bmd:BitmapData = bmp.bitmapData;
				icon.loadGraphic(FlxGraphic.fromBitmapData(bmd, false));
				icon.setGraphicSize(Std.int(icon.width), Std.int(icon.height));
				icon.updateHitbox();
				var tempMask:FlxSprite = new FlxSprite(icon.x, icon.y);
				//Por algum motivo, não posso só colocar ele pra trackear o userOutline :fist::pensive:
				tempMask.makeGraphic(Std.int(icon.width), Std.int(icon.height), FlxColor.TRANSPARENT);
				var tempCircle:FlxSprite = FlxSpriteUtil.drawCircle(tempMask,(tempMask.width+3)/2,(tempMask.height+3)/2,Math.min(tempMask.width, tempMask.height)/2-3,FlxColor.RED);
				// add(tempCircle);
				FlxSpriteUtil.alphaMaskFlxSprite(icon, tempCircle, icon);
				tempMask.destroy();
				tempCircle.destroy();
			}
		});
		loader.load(new URLRequest(user.avatar_url.replace("/60/",'/${Std.int(outline.height)}/').replace(".webp", ".png")));
    }
}

