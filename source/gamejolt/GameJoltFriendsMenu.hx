package gamejolt;

// Aparentemente as coordenadas ficam bugadas em substates...
// Talvez eu precise usar camera, mas não tenho certeza
import Utils.BSLTouchUtils;
import flixel.math.FlxMath;
import Utils.BSLSwipeUtils;
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
import openfl.events.Event;
import openfl.events.ErrorEvent;
import openfl.display.Loader;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import Utils.FlxScrollableArea;
import flixel.util.FlxTimer;
#if rpc
import Discord.DiscordClient;
#end
import flixel.FlxCamera;

using StringTools;

class GameJoltFriendsMenu extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var fakeBG:FlxSprite;
    var voltar_button:FlxButton;
    var label:FlxText;
    public var camElementos:FlxCamera;
    var sumidao:Bool = false;
    var canSumir:Bool = false;
    var blur:BlurFilter;
    var invisible_button:FlxButton;
    public var amigos:Array<FriendObject> = [];
    var amigosList:FlxSpriteGroup;
    var scrollBar:FlxScrollableArea;

	public function new()
        {
            super();
            invisible_button = new FlxButton();
            invisible_button.setGraphicSize(Std.int(FlxG.width*0.89),Std.int(FlxG.height*0.8));
            invisible_button.y = FlxG.height*0.15;
            invisible_button.x = FlxG.width*0.05;
            invisible_button.updateHitbox();
            invisible_button.alpha = 0.001;
            add(invisible_button);
            if(ClientPrefs.shaders)
                {
                    blur = new BlurFilter();
                    blur.blurX = 0;
                    blur.blurY = 0;
                }

                BSLSwipeUtils.resetScrolls();
                Main.mouse_allowed = true;
                BSLSwipeUtils.max_x = 2;
                BSLSwipeUtils.mouseScrollMultiplier=15;
                
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
        bg.updateHitbox();
        bg.cameras = [camElementos];
		add(bg);

        
        voltar_button = new FlxButton(973, 63+1280, function() {
            sair();
        });
        voltar_button.alpha = 0;
        voltar_button.visible = true;
        voltar_button.label = new FlxText(0, 3, 229, LangUtil.getString("menu_back", "menu"), 50);
        voltar_button.label.setFormat(Paths.font("letravio.ttf"), 50, FlxColor.WHITE, CENTER);
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
        
        fakeBG = new FlxSprite(-74, -162).loadGraphic(Paths.image("menus/gamejolt/amigos/BG"));
		fakeBG.antialiasing = ClientPrefs.globalAntialiasing;
        fakeBG.cameras = [camElementos];
        fakeBG.scrollFactor.set(0, 0);
        
        amigosList = cast add(new FlxSpriteGroup());
		amigosList.add(fakeBG);
        
        var amiguineos:Array<User> = GJClient.getFriendsList(); // pra evitar ele a ficar dando fetch toda hora
        // ninguém nunca me respondeu, estou triste :cry:
        var x1:Float = 1; // bora x1?
        for(user in amiguineos)
            {
                var friendo:FriendObject = new FriendObject((5*x1)+10, 20, user);
                friendo.cameras = [camElementos];
                friendo.alpha = 0;
                amigos.push(friendo);
                amigosList.add(friendo);
                x1+=75;
            }
            
        amigosList.setPosition(0, 2560);
        var viewPortRect:FlxRect = new FlxRect( 74, 162, 1132, 508 );
        scrollBar = new FlxScrollableArea(viewPortRect, amigosList.getHitbox(), Utils.ResizeMode.FIT_HEIGHT, 0, FlxColor.GRAY);
        tweenEntrar();
        }
        
        function sair()
            {
                if(sumidao || !canSumir)
                    return;
                sumidao = true;
                tweenSair();
            }
            
    override function update(elapsed:Float)
    {
        voltar_button.label.alpha = 1;
        if(controls.BACK)
        {
            sair();
        }
        if(canSumir && amigos.length > 0)
        {
            swipes();
        }
        super.update(elapsed);
        voltar_button.label.alpha = 1;
    }

    function swipes(){
        var numeroSuperManeiro:Float = 745;
        var canSwipeRight:Bool = true;
        var canSwipeLeft:Bool = true;
        var ultimoAmigo:Int = amigos.length-1;
        canSwipeRight = amigos[ultimoAmigo].x > numeroSuperManeiro;
        canSwipeLeft = amigos[0].x <= 15;

        if (!Main.getMouseVisibility()){
            if(canSwipeLeft && controls.UI_LEFT)
            {
                for (amigo in amigos){
                    amigo.x += 20;
                }
            }
            else if(canSwipeRight && controls.UI_RIGHT)
            {
                for (amigo in amigos){
                    amigo.x -= 20;
                }
            }
        }
        else
        {
            BSLSwipeUtils.swipeHorizontal();

            if(canSwipeLeft && BSLSwipeUtils.scrollX > 0 || canSwipeRight && BSLSwipeUtils.scrollX < 0)
            {
                for (amigo in amigos){
                    amigo.x += BSLSwipeUtils.scrollX;
                }
            }

        }

        if(amigos[0].x > 15)
        {
            for(amigo in amigos)
            {
                amigo.x -= 2;
            }
        }
        else if(amigos[ultimoAmigo].x < numeroSuperManeiro)
        {
            for(amigo in amigos)
                {
                    amigo.x += 2;
                }
        }

    }

    function tweenEntrar()
    {
        if(ClientPrefs.shaders)
        {
            MainMenuStateMobile.instance.camGame.setFilters([blur]);
            MainMenuStateMobile.instance.camAchievement.setFilters([blur]);
            FlxTween.tween(blur, {blurX: 3, blurY: 3}, 0.5, {ease: FlxEase.quartInOut});
        }

        FlxTween.tween(label, {y: 65}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(voltar_button, {y: 63}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(bg, {y: 0}, 0.5, {ease: FlxEase.expoInOut, onComplete: function(e:FlxTween) {
            FlxG.cameras.add(scrollBar);
            for(amigo in amigos)
            {
                FlxTween.tween(amigo, {alpha: 1}, 0.5, {ease: FlxEase.expoInOut});
            }
            new FlxTimer().start(0.5, function(e:FlxTimer) {
                canSumir = true;
            });
        }});
        /*for(amigo in amigos)
        {
            FlxTween.tween(amigo, {y: 184}, 0.5, {ease: FlxEase.expoInOut});
        }*/
    }

    function tweenSair()
    {
        canSumir = false;
        for(amigo in amigos)
            {
                //FlxTween.tween(amigo, {y: 1464}, 0.5, {ease: FlxEase.expoInOut});
                FlxTween.tween(amigo, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
            }

        new FlxTimer().start(0.5, function(e:FlxTimer) {
            FlxG.cameras.remove(scrollBar, true);
            MainMenuStateMobile.instance.voltarUser();
            if(ClientPrefs.shaders)
                {
                    FlxTween.tween(blur, {blurX: 0, blurY: 0}, 0.5, {ease: FlxEase.quartInOut});
                }
            FlxTween.tween(label, {y: 65+1280}, 0.5, {ease: FlxEase.expoInOut});
            FlxTween.tween(voltar_button, {y: 63+1280}, 0.5, {ease: FlxEase.expoInOut});
            FlxTween.tween(bg, {y: 1280}, 0.5, {ease: FlxEase.expoInOut, onComplete: function(e:FlxTween) {
                #if rpc
                DiscordClient.changePresence(LangUtil.getString("rpc_main_menu", "rpc"), null);
                #end
                MainMenuStateMobile.canClick = true;
                if(ClientPrefs.shaders)
                    {
                        MainMenuStateMobile.instance.camGame.setFilters([]);
                        MainMenuStateMobile.instance.camAchievement.setFilters([]);
                    }
                close();
            }});
        });

    }
}

class FriendObject extends FlxSpriteGroup
{
    var user:User;
    var bg:FlxSprite;
    public var icon:FlxSprite;
    public var name:FlxText;
    public var desc:FlxText;

    public function new(x:Float, y:Float, user:User)
    {
        super(x,y);
        this.user = user;
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/amigos/perfil"));
        bg.updateHitbox();
        add(bg);

        name = new FlxText(0, 0, 360, user.username, 30);
        name.setFormat(Paths.font("letravio.ttf"), 70, FlxColor.WHITE, CENTER);
        name.size = Std.int(Math.max(40, Math.min(70, Math.ceil(700 / user.username.length))));
        name.x+=5;
        name.y+=5;
		name.alignment=CENTER;
        add(name);

        icon = new FlxSprite(80+30, 132).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
        icon.antialiasing = ClientPrefs.globalAntialiasing;
        icon.setGraphicSize(152, 152);
        icon.y = 132;
        icon.x = 110;
        add(icon);
        
        desc = new FlxText(0, 0, 360, "", 30);
        desc.setFormat(Paths.font("letravio.ttf"), 40, FlxColor.WHITE, CENTER);
        desc.x+=5;
        desc.y+=340;

        var isOnline:String = GJClient.getStatus(Std.string(user.id));
        trace(isOnline); // sus
        if(isOnline == "true")
        {
            desc.text = LangUtil.getString("menu_friends_online", "menu");
            desc.color = FlxColor.GREEN;
        }
        else
        {
            desc.text = LangUtil.getString("menu_friends_offline", "menu");
            desc.color = FlxColor.RED;
        }

        add(desc);

        icon.y+=30;
        name.y+=45;

        pegarIcon();
    }

    function pegarIcon()
    {
        var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
            if(!user.avatar_url.contains("no-avatar"))
            {
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
		loader.load(new URLRequest(user.avatar_url.replace("/60/",'/${Std.int(icon.height)}/').replace(".webp", ".png")));
    }
}

