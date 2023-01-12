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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
using StringTools;

class TimeDaVio extends MusicBeatState
{
	var videoMenu:FlxSprite = new FlxSprite(0,0);
	var video:MP4Handler = new MP4Handler();
	//var letext:FlxText;
	var bg:FlxSprite;
	var icon:FlxSprite;
    var perfil:FlxSprite;
    var desc:FlxSprite;
    var estante:FlxSprite;
    var discord:FlxButton;
    var youtube:FlxButton;
    var twitter:FlxButton;
    var mic:FlxSprite;
	var curSelected:Int=0;
    var curSelectedBkp:Int=0;
    var canChange:Bool=false;
    /*var newcredit:FlxSprite;
    var dummycredit:FlxSprite;*/

    var creditStuff:Array<String> = ['vio', 'dav', 'ash', 'silver', 'konan', 'x02', 'hugo', 'cat',  
                                    /*daqui pra frente é elenco*/ 
                                    'vio', 'blue', 'brunito', 'jinzo', 'lightwuz', 'lonny', 'mayoral', 'molten', 'neko', 'nih', 'orochi', 'sah', 'vinizitooo', 'sayuri'];


    var discordLink:Array<String> = ['https://discord.gg/G3BmXXeshA', 'https://discord.gg/G3BmXXeshA', 'https://discord.gg/G3BmXXeshA', 'https://discord.gg/G3BmXXeshA', 'https://discord.gg/G3BmXXeshA', 
                                    'https://discord.gg/kprH8WnP8Q', 'https://discord.gg/G3BmXXeshA', 'https://discord.gg/G3BmXXeshA', 
                                    /*daqui pra frente é elenco*/ 
                                    'https://discord.gg/G3BmXXeshA',
                                    '',
                                    'https://discord.gg/nU3ZRvQfwP', 
                                    'https://discord.gg/YxMwmAY39p',
                                    'https://discord.com/invite/5prgn8H2P8', 
                                    'https://discord.gg/a7PEnvCaxU', 
                                    '', 
                                    '',
                                    '', 
                                    '',
                                    '',
                                    '',
                                    'https://discord.gg/B3uAXgyr',
                                    'https://www.facebook.com/MarianaSayuriFandubsFansings'];

                                    
    var twitterLink:Array<String> = ['https://twitter.com/galaccine', 'https://twitter.com/Davizinhn', 'https://twitter.com/Ashuro_Privety', 'https://twitter.com/galaccine', 'https://twitter.com/Konan_Hatake13', 
                                    'https://twitter.com/mateus_x02', 'https://twitter.com/Hugo09723233', 'https://twitter.com/galaccine', 
                                    /*daqui pra frente é elenco*/ 
                                    'https://twitter.com/galaccine',
                                    'https://twitter.com/bluetufie',
                                    'https://twitter.com/brunitofnf',
                                    'https://twitter.com/JinzoM',
                                    'https://twitter.com/lightwuz',
                                    'https://twitter.com/lonejustchillin',
                                    'https://www.facebook.com/christian.palheta', 
                                    'https://twitter.com/M0lt3nziito',
                                    'https://twitter.com/Nekop9123',
                                    'https://twitter.com/DiazNih_',
                                    'https://twitter.com/orochigad0',
                                    'https://twitter.com/sahriell_',
                                    'https://twitter.com/RealVinizitooo', 'https://twitter.com/mariana_sayuri'];


    var youtubeLink:Array<String> = ['https://www.youtube.com/c/galaccine', 'https://www.youtube.com/@Davizinhn', 'https://www.youtube.com/c/galaccine', 'https://www.youtube.com/c/matheussilver', 
                                    'https://www.youtube.com/@konan_hatake13', 'https://www.youtube.com/channel/UCPh9ueTFJh50NRlF2CLsbbA', 'https://www.youtube.com/c/galaccine', 'https://www.youtube.com/@GAT0192/', 
                                    /*daqui pra frente é elenco*/ 
                                    'https://www.youtube.com/c/galaccine',
                                    'https://www.youtube.com/@bluezinkk',
                                    'https://www.youtube.com/@brunitomusic',
                                    '',
                                    'https://www.youtube.com/@Lightwuz',
                                    'https://www.youtube.com/@samelonny', 
                                    'https://www.youtube.com/channel/UCModzG9hcT1XggjsQtmBc7g', 
                                    'https://www.youtube.com/channel/UCModzG9hcT1XggjsQtmBc7g',//
                                    'https://www.youtube.com/@M0lt3nziito',
                                    'https://www.youtube.com/@nihdiaz1145',
                                    'https://www.youtube.com/c/OrochiDubzkkk',
                                    'https://www.youtube.com/c/SahChan2019','https://www.youtube.com/@vinizitooo-lol', 'https://www.youtube.com/@MarianaSayuri'];
	
	override function create()
		{
			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo os créditos", null);
			#end
			/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
			add(bg);*/


			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/back'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
            bg.y=720;
			add(bg);

            perfil = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/perfil'));
			perfil.antialiasing = ClientPrefs.globalAntialiasing;
			perfil.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			perfil.alpha = 1;
            perfil.x = 1280;
			add(perfil);

            estante = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/estante'));
			estante.antialiasing = ClientPrefs.globalAntialiasing;
			estante.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			estante.alpha = 1;
            estante.x=-593;
			add(estante);

            discord = new FlxButton(FlxG.width, 100, '');
			discord.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-discord', 'preload'));
			discord.updateHitbox();
			discord.x = -148; // 405
			discord.y = 203; 
			discord.alpha = 0.75;
			add(discord);


            twitter = new FlxButton(FlxG.width, 100, '');
			twitter.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-twitter', 'preload'));
			twitter.updateHitbox();
			twitter.x = -148; // 93
			twitter.y = 203;
			twitter.alpha = 0.75;
			add(twitter);

            youtube = new FlxButton(FlxG.width, 100, '');
            youtube.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-youtube', 'preload'));
            youtube.updateHitbox();
			youtube.x = -148; // 248
			youtube.y = 203;
			youtube.alpha = 0.75;
			add(youtube);

            icon = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/icon'));
			icon.antialiasing = ClientPrefs.globalAntialiasing;
			icon.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			icon.alpha = 1;
            icon.x=-665;
			add(icon);
            desc = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/desc'));
			desc.antialiasing = ClientPrefs.globalAntialiasing;
			desc.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			desc.alpha = 1;
            desc.x=-631;
			add(desc);

            mic = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/microfone-galaccine'));
			mic.antialiasing = ClientPrefs.globalAntialiasing;
			mic.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			mic.alpha = 1;
            mic.x = 257;
			add(mic);

            FlxTween.tween(bg, {y: 0}, 1.15, {ease: FlxEase.quartInOut});
            FlxTween.tween(mic, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
            FlxTween.tween(perfil, {x: 0}, 1.45, {ease: FlxEase.quartInOut});
            FlxTween.tween(desc, {x: 0}, 1.5, {ease: FlxEase.quartInOut});
            FlxTween.tween(estante, {x: 0}, 1.6, {ease: FlxEase.quartInOut});
            FlxTween.tween(youtube, {x: 248}, 1.65, {ease: FlxEase.quartInOut});
            FlxTween.tween(twitter, {x: 93}, 1.65, {ease: FlxEase.quartInOut});
            FlxTween.tween(discord, {x: 405}, 1.65, {ease: FlxEase.quartInOut});
            FlxTween.tween(icon, {x: 0}, 1.7, {ease: FlxEase.quartInOut});


            new FlxTimer().start(1.8, function(tmr:FlxTimer){
                canChange=true;
            });

            updateButtons();
			#if mobileC
			addVirtualPad(LEFT_RIGHT, A_B);
			#end
			super.create();
		}
	override function update(elapsed:Float)
		{
            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new SobreState());
            }

			if(controls.UI_RIGHT_P) { //ok
                if(canChange)
                    {
                        if(curSelected+1 > creditStuff.length-1)
                            {
                                curSelectedBkp=curSelected;
                                curSelected=0;
                                changeSelection(curSelected);
                            }
                        else
                            {
                                curSelectedBkp=curSelected;
                                curSelected=curSelected+1; 
                                changeSelection(curSelected);
                            }
                        canChange=false;
                        FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                    }
			}

            if(controls.UI_LEFT_P) { //ok
                if(canChange)
                    {
                        if(curSelected-1 < 0)
                            {
                                curSelectedBkp=curSelected;
                                curSelected=creditStuff.length-1;
                                changeSelection(curSelected);
                            }
                        else
                            {
                                curSelectedBkp=curSelected;
                                curSelected=curSelected-1; 
                                changeSelection(curSelected);
                            }
                        canChange=false;
                        FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                    }
			}
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }

		}

        function changeSelection(newCurselected:Int)
            {
                /*dummycredit.loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelectedBkp]));
                dummycredit.alpha=1;
                dummycredit.y=0;
                FlxTween.tween(dummycredit, {y: 724}, 0.5, {ease: FlxEase.quartInOut});

                FlxTween.tween(newcredit, {y: 0}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.6});

                new FlxTimer().start(1.1, function(tmr:FlxTimer){
                    canChange=true;
                });
                newcredit.y=-724;
                newcredit.loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelected]));*/
                if(curSelectedBkp>7)
                    {
                        FlxTween.tween(bg, {y: 728}, 0.8, {ease: FlxEase.quartInOut});
                        FlxTween.tween(perfil, {x: -1280}, 0.5, {ease: FlxEase.quartInOut});
                        FlxTween.tween(desc, {x: 663}, 0.7, {ease: FlxEase.quartInOut});
                        FlxTween.tween(estante, {x: 593}, 0.9, {ease: FlxEase.quartInOut});
                        FlxTween.tween(icon, {x: 700}, 1, {ease: FlxEase.quartInOut});
                        FlxTween.tween(youtube, {x: 1291}, 0.95, {ease: FlxEase.quartInOut});
                        FlxTween.tween(twitter, {x: 1291}, 0.95, {ease: FlxEase.quartInOut});
                        FlxTween.tween(discord, {x: 1291}, 0.95, {ease: FlxEase.quartInOut});
                    }
                else
                    {
                        FlxTween.tween(bg, {y: 728}, 0.8, {ease: FlxEase.quartInOut});
                        FlxTween.tween(mic, {x: 257}, 0.9, {ease: FlxEase.quartInOut});
                        FlxTween.tween(perfil, {x: 1280}, 0.5, {ease: FlxEase.quartInOut});
                        FlxTween.tween(desc, {x: -663}, 0.7, {ease: FlxEase.quartInOut});
                        FlxTween.tween(estante, {x: -593}, 0.9, {ease: FlxEase.quartInOut});
                        FlxTween.tween(icon, {x: -665}, 1, {ease: FlxEase.quartInOut});
                        FlxTween.tween(youtube, {x: -148}, 0.95, {ease: FlxEase.quartInOut});
                        FlxTween.tween(twitter, {x: -148}, 0.95, {ease: FlxEase.quartInOut});
                        FlxTween.tween(discord, {x: -148}, 0.95, {ease: FlxEase.quartInOut});
                    }

                new FlxTimer().start(1.05, function(tmr:FlxTimer){
                    if(curSelected>7)
                        {
                            estante.x = 593;
                            perfil.x=-1280;
                            desc.x=663;
                            icon.x=700;
                            youtube.y=378;
                            youtube.x=1291;
                            discord.y=378;
                            discord.x=1291;
                            twitter.y=378;
                            twitter.x=1291;
                            bg.loadGraphic(Paths.image('sobremenu/creditos/elenco/'+creditStuff[curSelected]+'/back'));
                            perfil.loadGraphic(Paths.image('sobremenu/creditos/elenco/'+creditStuff[curSelected]+'/perfil'));
                            estante.loadGraphic(Paths.image('sobremenu/creditos/elenco/'+creditStuff[curSelected]+'/estante'));
                            icon.loadGraphic(Paths.image('sobremenu/creditos/elenco/'+creditStuff[curSelected]+'/icon'));
                            desc.loadGraphic(Paths.image('sobremenu/creditos/elenco/'+creditStuff[curSelected]+'/desc'));

                            FlxTween.tween(bg, {y: 0}, 1.15, {ease: FlxEase.quartInOut});
                            FlxTween.tween(perfil, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(desc, {x: 0}, 1.45, {ease: FlxEase.quartInOut});
                            FlxTween.tween(estante, {x: 0}, 1.55, {ease: FlxEase.quartInOut});
                            FlxTween.tween(youtube, {x: 768}, 1.60, {ease: FlxEase.quartInOut});
                            FlxTween.tween(twitter, {x: 1072}, 1.60, {ease: FlxEase.quartInOut});
                            FlxTween.tween(discord, {x: 921}, 1.60, {ease: FlxEase.quartInOut});
                            FlxTween.tween(icon, {x: 0}, 1.65, {ease: FlxEase.quartInOut});
                        }
                    else
                        {
                            estante.x = -593;
                            perfil.x=1280;
                            desc.x=-663;
                            icon.x=-665;
                            youtube.y=203;
                            youtube.x=-148;
                            discord.y=203;
                            discord.x=-148;
                            twitter.y=203;
                            twitter.x=-148;
                            bg.loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/back'));
                            perfil.loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/perfil'));
                            estante.loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/estante'));
                            icon.loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/icon'));
                            desc.loadGraphic(Paths.image('sobremenu/creditos/timedavio/'+creditStuff[curSelected]+'/desc'));
                            FlxTween.tween(bg, {y: 0}, 1.15, {ease: FlxEase.quartInOut});
                            FlxTween.tween(perfil, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(mic, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
                            FlxTween.tween(desc, {x: 0}, 1.45, {ease: FlxEase.quartInOut});
                            FlxTween.tween(estante, {x: 0}, 1.55, {ease: FlxEase.quartInOut});
                            FlxTween.tween(youtube, {x: 248}, 1.60, {ease: FlxEase.quartInOut});
                            FlxTween.tween(twitter, {x: 93}, 1.60, {ease: FlxEase.quartInOut});
                            FlxTween.tween(discord, {x: 405}, 1.60, {ease: FlxEase.quartInOut});
                            FlxTween.tween(icon, {x: 0}, 1.65, {ease: FlxEase.quartInOut});
                        }
                    updateButtons();
                    new FlxTimer().start(1.7, function(tmr:FlxTimer){
                        canChange=true;
                    });
                });
            }

        function updateButtons()
            {
                if(curSelected==14)
                    {
                        twitter.loadGraphic(Paths.image('sobremenu/creditos/elenco/elenco-fb', 'preload'));
                    }
                    else
                        {
                            twitter.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-twitter', 'preload'));
                        }
                        if(curSelected==21)
                            {
                                discord.loadGraphic(Paths.image('sobremenu/creditos/elenco/elenco-fb', 'preload'));
                            }
                            else
                                {
                                    discord.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-discord', 'preload'));
                                }
                twitter.alpha=0.75;
                youtube.alpha=0.75;
                discord.alpha=0.75;
                twitter.onOver.callback = function()
                    {
                        if(twitterLink[curSelected]!='')
                            {
                                FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                                twitter.alpha=1;
                            }
                    };
        
                    twitter.onOut.callback = function()
                    {
                        if(twitterLink[curSelected]!=''){
                            FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                            twitter.alpha=0.75;
                        }
                    };
        
        
                    twitter.onDown.callback = function()
                    {
                        if(twitterLink[curSelected]!='')
                            {
                                FlxG.sound.play(Paths.sound('confirmMenu'));
                                twitter.alpha=1;
                            }
                        if(twitterLink[curSelected]!='')
                            {
                                CoolUtil.browserLoad(twitterLink[curSelected]);
                            }
                        else
                            {
                               // CoolUtil.browserLoad(twitterLink[0]);
                            }
                    };

                    youtube.onOver.callback = function()
                        {
                            if(youtubeLink[curSelected]!=''){

                            
                                FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                                youtube.alpha=1;
                            }
                        };
            
                        youtube.onOut.callback = function()
                        {
                            if(youtubeLink[curSelected]!='')
                                {
                                    FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                                    youtube.alpha=0.75;
                                }
                        };
            
            
                        youtube.onDown.callback = function()
                        {
                            if(youtubeLink[curSelected]!='')
                                {
                                    FlxG.sound.play(Paths.sound('confirmMenu'));
                                    youtube.alpha=1;
                                }
                            if(youtubeLink[curSelected]!='')
                                {
                                    CoolUtil.browserLoad(youtubeLink[curSelected]);
                                }
                            else
                                {
                                    //CoolUtil.browserLoad(youtubeLink[0]);
                                }
                        };

                        discord.onOver.callback = function()
                            {
                                if(discordLink[curSelected]!='')
                                    {                                    FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                                discord.alpha=1;}
                            };
                
                            discord.onOut.callback = function()
                            {
                                if(discordLink[curSelected]!='')
                                    {                                FlxG.sound.play(Paths.sound('scrollMenu'), 1);
                                discord.alpha=0.75;}
                            };
                
                
                            discord.onDown.callback = function()
                            {
                                if(discordLink[curSelected]!='')
                                    {                                    FlxG.sound.play(Paths.sound('confirmMenu'));
                                discord.alpha=1;

                                    }
                                if(discordLink[curSelected]!='')
                                    {
                                        CoolUtil.browserLoad(discordLink[curSelected]);
                                    }
                                else
                                    {
                                       // CoolUtil.browserLoad(discordLink[0]);
                                    }
                            };
            }

}