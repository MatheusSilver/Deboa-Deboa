package;

import Utils.BSLSwipeUtils;
import Utils.BSLTouchUtils;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class TimeDaVio extends MusicBeatState
{
	var bgBaixo:FlxSprite;
	var bgCima:FlxSprite;
	var icon:FlxSprite;
	var perfil:FlxSprite;
	var desc:FlxSprite;
	var estante:FlxSprite;
	var discord:FlxButton;
	var youtube:FlxButton;
	var twitter:FlxButton;
	var mic:FlxSprite;
	static var curSelected:Int = 0;
	static var curSelectedBkp:Int = 0;
	var canChange:Bool = false;

	private var buttonsMap:Map<String, FlxButton>;

	private final ENTRY_FIRST_POS:Array<Int> = [93,768];
	private final ENTRY_MIDDLE_POS:Array<Int> = [248,921];
	private final ENTRY_LAST_POS:Array<Int> = [405,1072];
	
	// nome,  discord,  twitter,  youtube
	final creditInfo:Array<Array<String>> = [
		[	'vio', 'https://discord.gg/G3BmXXeshA', 'https://twitter.com/galaccine', 'https://www.youtube.com/c/galaccine'],
		[	'dav',  '',  'https://twitter.com/Davizinhn',  'https://www.youtube.com/@Davizinhn' ],
		[	'ash',  '',  'https://twitter.com/Ashuro_Privety',  '' ],
		//[	'silver',  '',  '',  'https://www.youtube.com/c/matheussilver' ],
		//Deixa sem mermo, coiso meu e da Lore por enquanto.
		[	'konan',  '',  'https://twitter.com/Konan_Hatake13',  'https://www.youtube.com/@konan_hatake13' ],
		[	'x02',  '',  '',  'https://www.youtube.com/channel/UCPh9ueTFJh50NRlF2CLsbbA' ],
		[	'hugo',  '',  'https://twitter.com/Hugo09723233',  '' ],
		[	'cat',  '',  'https://twitter.com/Point15104219',  '' ],
		[	'frost',  'https://discord.gg/PegJDERhFw',  'https://twitter.com/FROST_0101?t',  'https://youtube.com/@FROST_001' ],
		/* daqui pra frente é elenco */
		[   'vio', 'https://discord.gg/G3BmXXeshA', 'https://twitter.com/galaccine', 'https://www.youtube.com/c/galaccine'],
		[	'blue',   '',  'https://twitter.com/bluetufie',  'https://www.youtube.com/@bluezinkk' ],
		[	'brunito',   'https://discord.gg/nU3ZRvQfwP',  'https://twitter.com/brunitofnf',  'https://www.youtube.com/@brunitomusic' ],
		[	'jinzo',   'https://discord.gg/YxMwmAY39p',  'https://twitter.com/JinzoM',  '' ],
		[	'lightwuz',   'https://discord.com/invite/5prgn8H2P8',  'https://twitter.com/lightwuz',  'https://www.youtube.com/@Lightwuz' ],
		[	'lonny',   'https://discord.gg/a7PEnvCaxU',  'https://twitter.com/lonejustchillin',  'https://www.youtube.com/@samelonny' ],
		[	'mayoral',   'https://www.facebook.com/christian.palheta',  '',  'https://www.youtube.com/channel/UCModzG9hcT1XggjsQtmBc7g' ],
		[	'molten',   '',  'https://twitter.com/M0lt3nziito',  'https://www.youtube.com/@M0lt3nziito' ],
		[	'neko',   '',  '',  'https://www.youtube.com/@nihdiaz1145' ],
		[	'nih',   'https://discord.gg/jNdV8BEUZU',  'https://twitter.com/orochigad0',  'https://www.youtube.com/c/OrochiDubzkkk' ],
		[	'orochi',   '',  'https://twitter.com/sahriell_',  'https://www.youtube.com/c/SahChan2019' ],
		[	'sah',   'https://www.facebook.com/MarianaSayuriFandubsFansings',  'https://twitter.com/RealVinizitooo',  'https://www.youtube.com/@vinizitooo-lol' ],
		[	'sayuri',  'https://www.facebook.com/MarianaSayuriFandubsFansings',  'https://twitter.com/mariana_sayuri',  'https://www.youtube.com/@MarianaSayuri']
	];
	override function create()
	{
		BSLSwipeUtils.max_x = Std.int(FlxG.width/2); //O cara vai ter que mandar o jutsu por pelo menos metade da tela.
		BSLSwipeUtils.mouseScrollMultiplier = 1;
		BSLSwipeUtils.reset_manual = Main.mouse_allowed = true;
		
		bgBaixo = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/back'));
		bgBaixo.antialiasing = ClientPrefs.globalAntialiasing;
		bgBaixo.alpha = 1;
		bgBaixo.y = 720;
		add(bgBaixo);
		bgCima = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/back1'));
		bgCima.antialiasing = ClientPrefs.globalAntialiasing;
		bgCima.alpha = 1;
		bgCima.y = -720;
		add(bgCima);

		perfil = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/perfil'));
		perfil.antialiasing = ClientPrefs.globalAntialiasing;
		perfil.updateHitbox();
		perfil.alpha = 1;
		perfil.x = 1280;
		add(perfil);

		estante = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/estante'));
		estante.antialiasing = ClientPrefs.globalAntialiasing;
		estante.updateHitbox();
		estante.alpha = 1;
		estante.x = -593;
		add(estante);

		#if (haxe >= "4.0.0")
		buttonsMap = new Map();
		#else
		buttonsMap = new Map<String, FlxButton>();
		#end

		discord = new FlxButton(FlxG.width, 100, '');
		discord.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-discord', 'preload'));
		discord.updateHitbox();
		discord.x = -148; // 405
		discord.y = 203;
		discord.alpha = 0.75;
		add(discord);
		buttonsMap.set("discord", discord);

		twitter = new FlxButton(FlxG.width, 100, '');
		twitter.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-twitter', 'preload'));
		twitter.updateHitbox();
		twitter.x = -148; // 93
		twitter.y = 203;
		twitter.alpha = 0.75;
		add(twitter);
		buttonsMap.set("twitter", twitter);

		youtube = new FlxButton(FlxG.width, 100, '');
		youtube.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-youtube', 'preload'));
		youtube.updateHitbox();
		youtube.x = -148; // 248
		youtube.y = 203;
		youtube.alpha = 0.75;
		add(youtube);
		buttonsMap.set("youtube", youtube);

		icon = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/icon', "locales", true, true));
		icon.antialiasing = ClientPrefs.globalAntialiasing;
		icon.updateHitbox();
		
		icon.alpha = 1;
		icon.x = -665;
		add(icon);
		desc = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/desc', "locales", true, true));
		desc.antialiasing = ClientPrefs.globalAntialiasing;
		desc.updateHitbox();
		
		desc.alpha = 1;
		desc.x = -631;
		add(desc);

		mic = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/timedavio/microfone-galaccine'));
		mic.antialiasing = ClientPrefs.globalAntialiasing;
		mic.updateHitbox();
		
		mic.alpha = 1;
		mic.x = 257;
		add(mic);

		FlxTween.tween(bgCima, {y: 0}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(bgBaixo, {y: 0}, 1.15, {ease: FlxEase.quartInOut});
		FlxTween.tween(mic, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
		FlxTween.tween(perfil, {x: 0}, 1.45, {ease: FlxEase.quartInOut});
		FlxTween.tween(desc, {x: 0}, 1.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(estante, {x: 0}, 1.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(icon, {x: 0}, 1.7, {ease: FlxEase.quartInOut});

		new FlxTimer().start(1.8, function(tmr:FlxTimer)
		{
			canChange = true;
		});
		tweenButtons(0);

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		BSLSwipeUtils.swipeHorizontal();
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_vio_team","rpc")+" " + Utils.CoolUtil.capitalize(creditInfo[curSelected][0]), null);
		#end
		if (controls.BACK)
		{
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new SobreState());
		}

		if (canChange)
		{
			if (controls.UI_RIGHT_P || BSLSwipeUtils.scrollX > 0)
			{ // ok
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
			}else if (controls.UI_LEFT_P || BSLSwipeUtils.scrollX < 0)
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
			for (key in buttonsMap.keys()){
				if (BSLTouchUtils.over(buttonsMap.get(key)) && buttonsMap.get(key).alpha != 1)
					hover(key);
				else if (BSLTouchUtils.solto(buttonsMap.get(key)))
					release(key);
				else if (!BSLTouchUtils.over(buttonsMap.get(key))&& buttonsMap.get(key).alpha == 1)
					out(key);
			}
		}

		if (FlxG.sound.music.volume == 0)
			FlxG.sound.music.fadeIn(4, 0, 0.7);

		super.update(elapsed);
	}

	function changeSelection(newCurselected:Int)
	{
		if (BSLSwipeUtils.is_swipping) BSLSwipeUtils.resetScrolls();

		if (curSelectedBkp > 7)
		{
			FlxTween.tween(bgCima, {y: -720}, 0.65, {ease: FlxEase.quartInOut});
			FlxTween.tween(bgBaixo, {y: 720}, 0.8, {ease: FlxEase.quartInOut});
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
			FlxTween.tween(bgCima, {y: -720}, 0.65, {ease: FlxEase.quartInOut});
			FlxTween.tween(bgBaixo, {y: 720}, 0.8, {ease: FlxEase.quartInOut});
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
				bgBaixo.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/back'));
				bgCima.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/back1'));
				perfil.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/perfil'));
				estante.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/estante'));
				icon.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/icon', "locales", true , true));
				desc.loadGraphic(Paths.image('sobremenu/creditos/elenco/' + creditInfo[curSelected][0] + '/desc', "locales", true , true));

				FlxTween.tween(bgCima, {y: 0}, 1, {ease: FlxEase.quartInOut});
				FlxTween.tween(bgBaixo, {y: 0}, 1.15, {ease: FlxEase.quartInOut});
				FlxTween.tween(perfil, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(desc, {x: 0}, 1.45, {ease: FlxEase.quartInOut});
				FlxTween.tween(estante, {x: 0}, 1.55, {ease: FlxEase.quartInOut});
				tweenButtons(1);
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
				bgBaixo.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/back'));
				bgCima.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/back1'));
				perfil.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/perfil'));
				estante.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/estante'));
				icon.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/icon', "locales", true, true));
				desc.loadGraphic(Paths.image('sobremenu/creditos/timedavio/' + creditInfo[curSelected][0] + '/desc', "locales", true, true));
				FlxTween.tween(bgCima, {y: 0}, 1, {ease: FlxEase.quartInOut});
				FlxTween.tween(bgBaixo, {y: 0}, 1.15, {ease: FlxEase.quartInOut});
				FlxTween.tween(perfil, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(mic, {x: 0}, 1.35, {ease: FlxEase.quartInOut});
				FlxTween.tween(desc, {x: 0}, 1.45, {ease: FlxEase.quartInOut});
				FlxTween.tween(estante, {x: 0}, 1.55, {ease: FlxEase.quartInOut});
				tweenButtons(0);
				FlxTween.tween(icon, {x: 0}, 1.65, {ease: FlxEase.quartInOut});
			}
			new FlxTimer().start(1.7, function(tmr:FlxTimer)
			{
				canChange = true;
			});
		});
	}

	private function buttonAvailable(key:String):Bool{
		switch (key){
			case "discord":
				return creditInfo[curSelected][1] != '';
			case "twitter":
				return creditInfo[curSelected][2] != '';
			case "youtube":
				return creditInfo[curSelected][3]  != '';
			default:
				return false;
		}
	}

	function hover(object:String):Void
	{
		if(buttonAvailable(object)){
			GlobalSoundManager.play("scrollMenu");
			buttonsMap.get(object).alpha = 1;
		}
	}

	function out(object:String):Void
	{
		if(buttonAvailable(object))
			buttonsMap.get(object).alpha = 0.75;
	}

	function release(object:String)
	{
		if (!buttonAvailable(object))
			return;
		GlobalSoundManager.play(confirmMenu);
		buttonsMap.get(object).alpha = 1;
		FlxTransitionableState.skipNextTransOut = true;
		switch (object){
			case "twitter":
				Utils.CoolUtil.browserLoad(creditInfo[curSelected][2]);
			case "youtube":
				Utils.CoolUtil.browserLoad(creditInfo[curSelected][3] );
			case "discord":
				Utils.CoolUtil.browserLoad(creditInfo[curSelected][1]);
		}
	}

	private var isFacebook:Bool = false;
	function updateDiscord(link:String):Void
	{
		discord.visible = link != "";
		if (link.contains("facebook") && !isFacebook) {
			discord.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-facebook', 'preload'));
			isFacebook = true;
		}else if (link.contains("discord") && isFacebook){
			discord.loadGraphic(Paths.image('sobremenu/creditos/timedavio/btt-discord', 'preload'));
			isFacebook = false;
		}
	}
	
	function updateTwitter(link:String):Void
	{
		twitter.visible = link != "";
	}
	
	function updateYT(link:String):Void
	{
		youtube.visible = link != "";
	}

	function updateButtons(teamMember:Array<String>):Void
	{
		updateDiscord(teamMember[1]);
		updateTwitter(teamMember[2]);
		updateYT(teamMember[3]);
	}

	function tweenButtons(section:Int):Void //Provavelmente isso é over enginnering mas sodasse.
	{
		updateButtons(creditInfo[curSelected]);
		var buttons:Array<FlxButton> = [];
		for (button in buttonsMap.iterator())
			if (button.visible) buttons.push(button);

		switch (buttons.length){
			case 1:
				FlxTween.tween(buttons[0], {x: ENTRY_MIDDLE_POS[section]}, 1.65, {ease: FlxEase.quartInOut});
			case 2:
				FlxTween.tween(buttons[0], {x: ENTRY_FIRST_POS[section]}, 1.65, {ease: FlxEase.quartInOut});
				FlxTween.tween(buttons[1], {x: ENTRY_LAST_POS[section]}, 1.65, {ease: FlxEase.quartInOut});
			case 3:
				FlxTween.tween(buttons[0], {x: ENTRY_FIRST_POS[section]}, 1.65, {ease: FlxEase.quartInOut});
				FlxTween.tween(buttons[1], {x: ENTRY_MIDDLE_POS[section]}, 1.65, {ease: FlxEase.quartInOut});
				FlxTween.tween(buttons[2], {x: ENTRY_LAST_POS[section]}, 1.65, {ease: FlxEase.quartInOut});
			default:
				FlxG.log.error("Não foram achadas redes sociais para este manito.");
		}
	}
}
