package;

import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
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
    var loginbotao:FlxButton;
	
	override function create()
		{
            if(GJClient.logged)
            {
                MusicBeatState.switchState(new AlreadyLogged());
            }
			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Logando", null);
			#end
			var supbg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ph'));
			supbg.antialiasing = ClientPrefs.globalAntialiasing;
			supbg.updateHitbox();
			supbg.alpha = 1;
			add(supbg);
            userBar = new FlxUIInputText(0, 0, 500, "USERNAME", 50, FlxColor.BLACK, FlxColor.WHITE, true);
            userBar.screenCenter(XY);
            add(userBar);
            tokenBar = new FlxUIInputText(0, 0, 500, "TOKEN", 50, FlxColor.BLACK, FlxColor.WHITE, true);
            tokenBar.x = userBar.x;
            tokenBar.y = userBar.y-75;
            add(tokenBar);
			letext = new FlxText(50, FlxG.height - 700, FlxG.width - 95, "LOGIN", 32);
			letext.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			letext.scrollFactor.set();
			letext.alpha = 1;
			add(letext);
            loginbotao = new FlxButton(FlxG.width, 100, '');
			loginbotao.loadGraphic(Paths.image('mainmenu/btlogar', 'preload'));
			loginbotao.setGraphicSize(Std.int(loginbotao.width * 0.75));
	
			loginbotao.updateHitbox();
			loginbotao.x = 385;
			loginbotao.y = 425;
			loginbotao.alpha = 0.75;
			add(loginbotao);
            pretobg = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/pretobg', 'preload'));
			pretobg.antialiasing = ClientPrefs.globalAntialiasing;
			pretobg.updateHitbox();
            pretobg.screenCenter(XY);
			pretobg.alpha = 0;
			add(supbg);
            loadingBar = new FlxText(50, FlxG.height - 700, FlxG.width - 95, "CARREGANDO", 32);
			loadingBar.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			loadingBar.scrollFactor.set();
			loadingBar.alpha = 0;
            loadingBar.screenCenter(XY);
			add(loadingBar);

            falhouBar = new FlxText(50, FlxG.height, FlxG.width, "O LOGIN FALHOU!", 40);
			falhouBar.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			falhouBar.scrollFactor.set();
			falhouBar.alpha = 0;
            falhouBar.screenCenter(XY);
			add(falhouBar);
	
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

            if(falhouBar.alpha == 1)
                {
                    new FlxTimer().start(1.5, function(tmr:FlxTimer){
                        falhou=true;
                    });
                }
            if(falhou==true)
                {
                    falhouBar.alpha = falhouBar.alpha-1;
                }

            if(falhouBar.alpha == 0)
                {
                    falhou=false;
                }
                
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
                falhouBar.alpha = 1;
                pretobg.alpha = 0;
                tokenBar.alpha=1;
                userBar.alpha=1;
                loadingBar.alpha=0;
            }
        public static function IrParaMenu():Void
            {
                FlxG.save.data.user =userBar.text;
                FlxG.save.data.token =tokenBar.text;
                MusicBeatState.switchState(new MainMenuStateMobile());
            }
            
}
