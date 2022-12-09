package;

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
import sys.FileSystem;
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
    public static var userBar:FlxUIInputText;
    public static var tokenBar:FlxUIInputText;
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
			loginbotao.loadGraphic(Paths.image('mainmenu/btnao', 'preload'));
			loginbotao.setGraphicSize(Std.int(loginbotao.width * 0.75));
	
			loginbotao.updateHitbox();
			loginbotao.x = 470;
			loginbotao.y = 425;
			loginbotao.alpha = 0.75;
			add(loginbotao);

            loadingBar = new FlxText(50, FlxG.height - 700, FlxG.width - 95, "CARREGANDO", 32);
			loadingBar.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			loadingBar.scrollFactor.set();
			loadingBar.alpha = 0;
            loadingBar.screenCenter(XY);
			add(loadingBar);
	
			super.create();
		}
	override function update(elapsed:Float)
		{
            if (FlxG.keys.justReleased.ESCAPE) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuStateMobile());
            }
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }
            loginbotao.onOver.callback = loginHover;
			loginbotao.onOut.callback = loginOut;
			loginbotao.onDown.callback = loginClick;
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
                                GJClient.setUserInfo(null, tokenBar.text);
                                GJClient.initialize();
                                EsconderTudo();
                            }
                        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                    }
        public static function EsconderTudo():Void
            {
                tokenBar.alpha=0;
                userBar.alpha=0;
                loadingBar.alpha=1;
            }
        public static function Desesconder():Void
            {
                tokenBar.alpha=1;
                userBar.alpha=1;
                loadingBar.alpha=0;
            }
        public static function IrParaMenu():Void
            {
                MusicBeatState.switchState(new MainMenuStateMobile());
            }
}
