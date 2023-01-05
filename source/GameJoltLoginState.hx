package;

import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import lime.system.System;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIInputText;
import FunkinLua;
import Shaders;
using StringTools;

class GameJoltLoginState extends MusicBeatState
{
	var letext:FlxText;
    var loggedtext:FlxText;
    public static var loadingBar:FlxText;
    public static var falhouBar:FlxText;
    public static var userBar:FlxUIInputText;
    public static var tokenBar:FlxUIInputText;
    public static var pretobg:FlxSprite;
    public static var logobg:FlxSprite;
    public static var referencebg:FlxSprite;
    var loginbotao:FlxButton;
	
	override function create()
		{
            /*if(GJClient.logged)
            {
                MusicBeatState.switchState(new AlreadyLogged());
            }*/
			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Logando", null);
			#end
            //FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));
			var supbg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_back'));		
			supbg.antialiasing = ClientPrefs.globalAntialiasing;
			//supbg.updateHitbox();
			supbg.alpha = 1;
			add(supbg);
            userBar = new FlxUIInputText(0, 0, 575, "USERNAME", 50, FlxColor.WHITE, FlxColor.TRANSPARENT, true);
            userBar.background=false;
            //userBar.fieldBorderColor = FlxColor.WHITE;
            //userBar.fieldBorderThickness = 3;
            userBar.x = 354;
            userBar.y = 195;
            tokenBar = new FlxUIInputText(0, 0, 575, "TOKEN", 50, FlxColor.WHITE, FlxColor.TRANSPARENT, true);
            /*tokenBar.fieldBorderColor = FlxColor.WHITE;
            tokenBar.fieldBorderThickness = 3;*/
            tokenBar.background=false;
            //tokenBar.height = 100;
            tokenBar.x = 354;
            tokenBar.y = 306;
			/*letext = new FlxText(50, 0, 0, "a", 32);
			letext.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			letext.scrollFactor.set();
			letext.alpha = 1;*/
            loginbotao = new FlxButton(FlxG.width, 100, '');
			loginbotao.loadGraphic(Paths.image('optionsmenu/login_button', 'preload'));
			loginbotao.setGraphicSize(Std.int(loginbotao.width * 1));
	
			loginbotao.updateHitbox();
			loginbotao.x = 354;
			loginbotao.y = 401;
			loginbotao.alpha = 0.75;
            /*pretobg = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_back', 'preload'));
			pretobg.antialiasing = ClientPrefs.globalAntialiasing;
			pretobg.updateHitbox();
            pretobg.screenCenter(XY);
			pretobg.alpha = 0;
            add(pretobg)*/
			add(supbg);
            logobg = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_logo', 'preload'));
			logobg.antialiasing = ClientPrefs.globalAntialiasing;
			//logobg.updateHitbox();
            logobg.screenCenter(XY);
			logobg.alpha = 1;
			add(logobg);
            referencebg = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_reference', 'preload'));
			referencebg.antialiasing = ClientPrefs.globalAntialiasing;
			//referencebg.updateHitbox();
            referencebg.screenCenter(XY);
			referencebg.alpha = 1;
			add(referencebg);
            loadingBar = new FlxText(50, FlxG.height - 700, FlxG.width - 95, "CARREGANDO", 32);
			loadingBar.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			loadingBar.scrollFactor.set();
			loadingBar.alpha = 0;
            loadingBar.screenCenter(XY);
			add(loadingBar);
			//add(letext);
            add(loginbotao);
            add(tokenBar);
            falhouBar = new FlxText(50, FlxG.height, FlxG.width, "O LOGIN FALHOU!", 40);
			falhouBar.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			falhouBar.scrollFactor.set();
			falhouBar.alpha = 0;
            falhouBar.screenCenter(XY);
			add(falhouBar);
            add(userBar);
			super.create();
		}
	override function update(elapsed:Float)
		{
            var falhou:Bool = false;
            if (FlxG.keys.justReleased.ESCAPE) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new ajustes.AjustesState());
            }
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }
            loginbotao.onOver.callback = loginHover;
			loginbotao.onOut.callback = loginOut;
			loginbotao.onDown.callback = loginClick;
            //letext.text = "X: "+Std.string(loginbotao.x)+"\nY: "+ Std.string(loginbotao.y); // debug moment
            if(falhouBar.alpha == 1)
                {
                    new FlxTimer().start(1.5, function(tmr:FlxTimer){
                        falhou=true;
                    });
                }
            if(falhou==true)
                {
                    falhouBar.alpha = falhouBar.alpha-0.0005;
                }

            if(falhouBar.alpha == 0)
                {
                    falhou=false;
                }
                loginbotao.updateHitbox();
		}

        function loginHover():Void
            {
                loginbotao.alpha=1;
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
            }
            function loginOut():Void
                {
                    loginbotao.alpha=0.75;
                }
    
                function loginClick():Void
                    {
                        if(userBar.text != "USERNAME" && tokenBar.text != "TOKEN")
                            {
                                GJClient.shitt=true;
                                GJClient.setUserInfo(userBar.text, tokenBar.text);
                                GJClient.initialize();
                                EsconderTudo();
                            }
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    }
        public static function EsconderTudo():Void
            {
                pretobg.alpha = 1;
                tokenBar.alpha=0;
                userBar.alpha=0;
                loadingBar.alpha=1;
            }
        public static function Desesconder():Void
            {
                MusicBeatState.switchState(new GameJoltLoginState());
                //falhouBar.alpha = 1;
                pretobg.alpha = 0;
                tokenBar.alpha=1;
                userBar.alpha=1;
                loadingBar.alpha=0;
                lime.app.Application.current.window.alert("O Login falhou!", "Erro");
            }
        public static function IrParaMenu():Void
            {
                FlxG.save.data.user =userBar.text;
                FlxG.save.data.token =tokenBar.text;
                MusicBeatState.switchState(new ajustes.AjustesState());
            }
            
}
