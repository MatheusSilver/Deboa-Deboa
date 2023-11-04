package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class TimeDaVio extends MusicBeatState
{
	//	var videoMenu:FlxSprite = new FlxSprite(0,0);
	//	var video:MP4Handler = new MP4Handler();
	// var letext:FlxText;
	var bg:FlxSprite;
	var icon:FlxSprite;
	var perfil:FlxSprite;
	var desc:FlxSprite;
	var estante:FlxSprite;
	var discord:FlxButton;
	var youtube:FlxButton;
	var twitter:FlxButton;
	var mic:FlxSprite;
	var curSelected:Int = 0;
	var curSelectedBkp:Int = 0;
	var canChange:Bool = false;
	
	// nome,  discord,  twitter,  youtube
	var creditInfo:Array<Dynamic> = [
		[	'vio', 'https://discord.gg/G3BmXXeshA', 'https://twitter.com/galaccine', 'https://www.youtube.com/c/galaccine'],
		[	'dav',  '',  'https://twitter.com/Davizinhn',  'https://www.youtube.com/@Davizinhn' ],
		[	'ash',  '',  'https://twitter.com/Ashuro_Privety',  '' ],
		[	'silver',  '',  '',  'https://www.youtube.com/c/matheussilver' ],
		[	'konan',  '',  'https://twitter.com/Konan_Hatake13',  'https://www.youtube.com/@konan_hatake13' ],
		[	'x02',  'https://discord.gg/G3BmXXeshA',  'https://twitter.com/matex02_',  'https://www.youtube.com/channel/UCPh9ueTFJh50NRlF2CLsbbA' ],
		[	'hugo',  '',  'https://twitter.com/Hugo09723233',  '' ],
		[	'cat',  '',  'https://twitter.com/Point15104219',  '' ],
		/* daqui pra frente é elenco */
		[   'vio', 'https://discord.gg/G3BmXXeshA', 'https://twitter.com/galaccine', 'https://www.youtube.com/c/galaccine'],
		[	'blue',   '',  'https://twitter.com/bluetufie',  'https://www.youtube.com/@bluezinkk' ],
		[	'brunito',   'https://discord.gg/nU3ZRvQfwP',  'https://twitter.com/brunitofnf',  'https://www.youtube.com/@brunitomusic' ],
		[	'jinzo',   'https://discord.gg/YxMwmAY39p',  'https://twitter.com/JinzoM',  '' ],
		[	'lightwuz',   'https://discord.com/invite/5prgn8H2P8',  'https://twitter.com/lightwuz',  'https://www.youtube.com/@Lightwuz' ],
		[	'lonny',   'https://discord.gg/a7PEnvCaxU',  'https://twitter.com/lonejustchillin',  'https://www.youtube.com/@samelonny' ],
		[	'mayoral',   '',  'https://www.facebook.com/christian.palheta',  'https://www.youtube.com/channel/UCModzG9hcT1XggjsQtmBc7g' ],
		[	'molten',   '',  'https://twitter.com/M0lt3nziito',  'https://www.youtube.com/@M0lt3nziito' ],
		[	'neko',   '',  '',  'https://www.youtube.com/@nihdiaz1145' ],
		[	'nih',   'https://discord.gg/jNdV8BEUZU',  'https://twitter.com/orochigad0',  'https://www.youtube.com/c/OrochiDubzkkk' ],
		[	'orochi',   '',  'https://twitter.com/sahriell_',  'https://www.youtube.com/c/SahChan2019' ],
		[	'sah',   'https://www.facebook.com/MarianaSayuriFandubsFansings',  'https://twitter.com/RealVinizitooo',  'https://www.youtube.com/@vinizitooo-lol' ],
		[	'sayuri',  '',  'https://twitter.com/mariana_sayuri',  'https://www.youtube.com/@MarianaSayuri']
	];

	override function create()
	{
		FlxG.mouse.visible = Main.mouse;
		/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
			add(bg); */

		FlxTransitionableState.skipNextTransOut = true;
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/back'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		bg.alpha = 1;
		bg.y = 720;
		add(bg);

		perfil = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/perfil'));
		perfil.antialiasing = ClientPrefs.globalAntialiasing;
		perfil.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		perfil.alpha = 1;
		perfil.x = 1280;
		add(perfil);

		estante = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/estante'));
		estante.antialiasing = ClientPrefs.globalAntialiasing;
		estante.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		estante.alpha = 1;
		estante.x = -593;
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

		icon = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/icon'));
		icon.antialiasing = ClientPrefs.globalAntialiasing;
		icon.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		icon.alpha = 1;
		icon.x = -665;
		add(icon);
		desc = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/desc'));
		desc.antialiasing = ClientPrefs.globalAntialiasing;
		desc.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		desc.alpha = 1;
		desc.x = -631;
		add(desc);

		mic = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/microfone-galaccine'));
		mic.antialiasing = ClientPrefs.globalAntialiasing;
		mic.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
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

		new FlxTimer().start(1.8, function(tmr:FlxTimer)
		{
			canChange = true;
		});

		updateButtons();
		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end
		super.create();
	}

	override function update(elapsed:Float)
	{
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Vendo os créditos do(a) " + creditInfo[curSelected][0], null);
		#end

		#if android
		KizzyBackend.trocardetalhes("FNF: Modboa.EXE", "Vendo os créditos do(a) " + creditInfo[curSelected][0]);
		#end
		if (controls.BACK)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new SobreState());
		}

		if (controls.UI_RIGHT_P)
		{ // ok
			if (canChange)
			{
				if (curSelected + 1 > creditInfo.length - 1)
				{
					curSelectedBkp = curSelected;
					curSelected = 0;
					changeSelection(curSelected);
				}
				else
				{
					curSelectedBkp = curSelected;
					curSelected = curSelected + 1;
					changeSelection(curSelected);
				}
				canChange = false;
				GlobalSoundManager.play('scrollMenu');
			}
		}

		if (controls.UI_LEFT_P)
		{ // ok
			if (canChange)
			{
				if (curSelected - 1 < 0)
				{
					curSelectedBkp = curSelected;
					curSelected = creditInfo.length - 1;
					changeSelection(curSelected);
				}
				else
				{
					curSelectedBkp = curSelected;
					curSelected = curSelected - 1;
					changeSelection(curSelected);
				}
				canChange = false;
				GlobalSoundManager.play('scrollMenu');
			}
		}
		super.update(elapsed);
		if (FlxG.sound.music.volume == 0)
		{
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
			newcredit.loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelected])); */

		if (curSelectedBkp > 7)
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

		new FlxTimer().start(1.05, function(tmr:FlxTimer)
		{
			if (curSelected > 7)
			{
				estante.x = 593;
				perfil.x = -1280;
				desc.x = 663;
				icon.x = 700;
				youtube.y = 378;
				youtube.x = 1291;
				discord.y = 378;
				discord.x = 1291;
				twitter.y = 378;
				twitter.x = 1291;
				bg.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/back'));
				perfil.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/perfil'));
				estante.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/estante'));
				icon.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/icon'));
				desc.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/desc'));

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
				perfil.x = 1280;
				desc.x = -663;
				icon.x = -665;
				youtube.y = 203;
				youtube.x = -148;
				discord.y = 203;
				discord.x = -148;
				twitter.y = 203;
				twitter.x = -148;
				bg.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/back'));
				perfil.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/perfil'));
				estante.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/estante'));
				icon.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/icon'));
				desc.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/desc'));
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
			new FlxTimer().start(1.7, function(tmr:FlxTimer)
			{
				canChange = true;
			});
		});
	}

	function updateButtons()
	{
		// tudo veio
		if (curSelected == 14)
		{
			twitter.loadGraphic(Paths.image('sobremenu/creditos/elenco/elenco-fb', 'preload'));
		}
		else
		{
			twitter.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-twitter', 'preload'));
		}
		if (curSelected == 21)
		{
			discord.loadGraphic(Paths.image('sobremenu/creditos/elenco/elenco-fb', 'preload'));
		}
		else
		{
			discord.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-discord', 'preload'));
		}

		twitter.alpha = 0.75;
		youtube.alpha = 0.75;
		discord.alpha = 0.75;
		twitter.onOver.callback = function()
		{
			if (creditInfo[curSelected][2] != '')
			{
				GlobalSoundManager.play('scrollMenu');
				twitter.alpha = 1;
			}
		};

		twitter.onOut.callback = function()
		{
			if (creditInfo[curSelected][2] != '')
			{
				twitter.alpha = 0.75;
			}
		};

		twitter.onDown.callback = function()
		{
			if (creditInfo[curSelected][2] != '')
			{
				GlobalSoundManager.play('confirmMenu');
				twitter.alpha = 1;
			}
			if (creditInfo[curSelected][2] != '')
			{
				CoolUtil.browserLoad(creditInfo[curSelected][2]);
			}
		};

		youtube.onOver.callback = function()
		{
			if (creditInfo[curSelected][3] != '')
			{
				GlobalSoundManager.play('scrollMenu');
				youtube.alpha = 1;
			}
		};

		youtube.onOut.callback = function()
		{
			if (creditInfo[curSelected][3]  != '')
			{
				youtube.alpha = 0.75;
			}
		};

		youtube.onDown.callback = function()
		{
			if (creditInfo[curSelected][3]  != '')
			{
				GlobalSoundManager.play('confirmMenu');
				youtube.alpha = 1;
			}
			if (creditInfo[curSelected][3]  != '')
			{
				CoolUtil.browserLoad(creditInfo[curSelected][3] );
			}
			else
			{
				// CoolUtil.browserLoad(youtubeLink[0]);
			}
		};

		discord.onOver.callback = function()
		{
			if (creditInfo[curSelected][1] != '')
			{
				GlobalSoundManager.play('scrollMenu');
				discord.alpha = 1;
			}
		};

		discord.onOut.callback = function()
		{
			if (creditInfo[curSelected][1] != '')
			{
				discord.alpha = 0.75;
			}
		};

		discord.onDown.callback = function()
		{
			if (creditInfo[curSelected][1] != '')
			{
				GlobalSoundManager.play('confirmMenu');
				discord.alpha = 1;
			}
			if (creditInfo[curSelected][1] != '')
			{
				CoolUtil.browserLoad(creditInfo[curSelected][1]);
			}
		};
	}
}
