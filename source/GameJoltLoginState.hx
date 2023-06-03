package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;
#if rpc
import Discord.DiscordClient;
#end

class GameJoltLoginState extends MusicBeatState
{
	var letext:FlxText;
    var loggedtext:FlxText;
    public static var msgBar:FlxText;
    public static var userBar:FlxUIInputText;
    public static var tokenBar:FlxUIInputText;
    public static var pretobg:FlxSprite;
    public static var logobg:FlxSprite;
    public static var referencebg:FlxSprite;
    public static var esconderTexto:Bool;
    var podeSair:Bool;
    var loginbotao:FlxButton;
	
	override function create()
		{
            GJClient.initialize();

            esconderTexto = false;

			FlxG.mouse.visible = true;
            
            #if mobile
            FlxG.stage.window.textInputEnabled = true;
            #end

			#if rpc
			DiscordClient.changePresence("Logando", null);
			#end

			var supbg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_back'));		
			supbg.antialiasing = ClientPrefs.globalAntialiasing;
			supbg.alpha = 1;
			add(supbg);

            userBar = new FlxUIInputText(0, 0, 575, "USERNAME", 50, FlxColor.GREEN, FlxColor.TRANSPARENT, true);
            userBar.background=false;
            userBar.x = 354;
            userBar.y = 195;
            userBar.alignment = CENTER;

            tokenBar = new FlxUIInputText(0, 0, 575, "TOKEN", 50, FlxColor.GREEN, FlxColor.TRANSPARENT, true);
            tokenBar.background=false;
            tokenBar.x = 354;
            tokenBar.y = 306;
            tokenBar.alignment = CENTER;

            loginbotao = new FlxButton(FlxG.width, 100, '');
			loginbotao.loadGraphic(Paths.image('optionsmenu/login_button', 'preload'));
			loginbotao.setGraphicSize(Std.int(loginbotao.width * 1));
			loginbotao.updateHitbox();
			loginbotao.x = 354;
			loginbotao.y = 401;
			loginbotao.alpha = 0.75;
         
			add(supbg); //?

            logobg = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_logo', 'preload'));
			logobg.antialiasing = ClientPrefs.globalAntialiasing;
            logobg.screenCenter(XY);
			logobg.alpha = 1;
			add(logobg);

            referencebg = new FlxSprite(0, 0).loadGraphic(Paths.image('optionsmenu/login_reference', 'preload'));
			referencebg.antialiasing = ClientPrefs.globalAntialiasing;
            referencebg.screenCenter(XY);
			referencebg.alpha = 1;
			add(referencebg);

            msgBar = new FlxText(0, 0, FlxG.width - 95, "", 80);
			msgBar.setFormat(Paths.font("letravio.ttf"), 80, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			msgBar.scrollFactor.set();
			msgBar.alpha = 1;
            msgBar.y=536;
            msgBar.screenCenter(X);

			add(msgBar);

            add(loginbotao);

            add(tokenBar);

            add(userBar);
            
			super.create();
		}
	override function update(elapsed:Float)
		{
            if(esconderTexto && msgBar.alpha>0)
            {
                msgBar.alpha = msgBar.alpha - 0.005;
            }

            else 

            if(esconderTexto && msgBar.alpha == 0)
            {
                msgBar.text = "";
                esconderTexto = false;
                msgBar.alpha = 1;
            }

            if (controls.BACK && podeSair) {
                GlobalSoundManager.play('cancelMenu');
                MusicBeatState.switchState(new ajustes.AjustesState());
            }

			super.update(elapsed);
            
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }

            loginbotao.onOver.callback = loginHover;
			loginbotao.onOut.callback = loginOut;
			loginbotao.onDown.callback = loginClick;
            
            podeSair = !tokenBar.hasFocus && !userBar.hasFocus; 
            loginbotao.updateHitbox();
		}

        function loginHover():Void
            {
                loginbotao.alpha=1;
                GlobalSoundManager.play('scrollMenu');
            }
            function loginOut():Void
                {
                    loginbotao.alpha=0.75;
                }
    
                function loginClick():Void
                    {
                        if(userBar.text != "USERNAME" && tokenBar.text != "TOKEN")
                            {
                                GJClient.logout();
                                GJClient.shitt=true;
                                GJClient.setUserInfo(userBar.text, tokenBar.text);
                                GJClient.login();
                                //msgBar.text="Conectando...";
                                new FlxTimer().start(2, function(tmr:FlxTimer){
                                    esconderTexto=true;
                                });
                                EsconderTudo();
                            }
                        GlobalSoundManager.play('confirmMenu');
                    }
        public static function EsconderTudo():Void
            {
                tokenBar.alpha=1;
                userBar.alpha=1;
            }
        public static function Desesconder():Void
            {
                FlxG.save.data.user ="";
                FlxG.save.data.token ="";
                if(tokenBar!=null)
                    tokenBar.alpha=1;
                    userBar.alpha=1;
                new FlxTimer().start(2, function(tmr:FlxTimer){
                    esconderTexto=true;
                });
                msgBar.text="O Login falhou!";
            }
        public static function IrParaMenu():Void
            {
                FlxG.save.data.user = userBar.text;
                FlxG.save.data.token = tokenBar.text;
                Achievements.syncAchievementsGJ();
                MainMenuStateMobile.verificaDnvIdiota = true;
                MusicBeatState.switchState(new ajustes.AjustesState());
            }

        public static function syncProgress()
            {
                var sum1:Int = 0;
                var sum2:Int = 0;
                var dataGJ:String = GJClient.getData("progress");
                for (i in 0...MenuPreHistoria.curSave.length) {

                        sum1 += Std.parseInt(MenuPreHistoria.curSave.split(",")[i]);
                        
                        if(dataGJ != null)
                        {
                                sum2 += Std.parseInt(dataGJ.split(",")[i]);
                        }
                        else
                        {
                                sum2 += Std.parseInt(MenuPreHistoria.curSave.split(",")[i]);
                        }

                }

                trace("Data GJ All: " + dataGJ);
                trace("Local Num: " + sum1);
                trace("Data GJ Num: " + sum2);

                if (sum1 > sum2) {
                    updateData();
                    FlxG.save.data.progress = MenuPreHistoria.curSave;
                    trace("Salvando o progresso local na gj");
                } else if (sum2 > sum1) {
                    MenuPreHistoria.curSave = dataGJ;
                    FlxG.save.data.progress = dataGJ;
                    trace("Salvando o progresso gj no local");
                } else if (sum2 == sum1) {
                    updateData();
                    FlxG.save.data.progress = MenuPreHistoria.curSave;
                    trace("Salvando o progresso local na gj (os dois são iguais)");
                }

                trace("New Data GJ: " + GJClient.getData("progress"));
            
            }
        public static function updateData()
            {
                GJClient.setData(MenuPreHistoria.curSave, "progress");
            }
            
}
