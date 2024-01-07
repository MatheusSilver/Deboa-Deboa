package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class CreditsMusics extends MusicBeatState
{
	// var letext:FlxText;
	var bg:FlxSprite;
	// var faixa:FlxSprite;
	// var exe:FlxSprite;
	var curSelected:Int = 1;
	var curSelectedBkp:Int = 0;
	var canChange:Bool = false;
	var newcredit:FlxSprite;
	var newcredit1:FlxSprite;
	var dummycredit:FlxSprite;
	var dummycredit1:FlxSprite;
	var dummycredit2:FlxSprite;

	var creditStuff:Array<String> = [
		'mars', 'penkaru', 'saster', 'solunary', 'spookawaii', 'teles', 'ankinluu', 'apartygoer', 'c52278', 'd4rksp1ne20', 'ehtmareiner', 'jark1412',
		'kanihuman', 'panchonatorr', 'phantasmpixel', 'pikatio', 'soufon', 'shadowmario'
	];

	override function create()
	{
		FlxTransitionableState.skipNextTransOut = true;
		#if !mobile
		FlxG.mouse.visible = false;
		#end
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Vendo os créditos", null);
		#end
		/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.visible = true;
			add(bg); */

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (back)'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		bg.visible = true;
		bg.y = 720;
		add(bg);

		dummycredit = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp] + ')', "locales", true, true));
		dummycredit.antialiasing = ClientPrefs.globalAntialiasing;
		dummycredit.visible = false;
		dummycredit.y = 25;
		dummycredit1 = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp + 1] + ')', "locales", true, true));
		dummycredit1.antialiasing = ClientPrefs.globalAntialiasing;
		dummycredit1.visible = false;
		dummycredit1.y = 25;
		dummycredit2 = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelected + 1] + ')', "locales", true, true));
		dummycredit2.antialiasing = ClientPrefs.globalAntialiasing;
		dummycredit2.visible = false;
		dummycredit2.y = 25;
		newcredit = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp] + ')', "locales", true, true));
		newcredit.antialiasing = ClientPrefs.globalAntialiasing;
		// newcredit.setGraphicSize(Std.int(0.8));
		newcredit.visible = true;
		// newcredit.x=525;
		newcredit.x = -279;
		newcredit.y = 724;
		add(newcredit);

		newcredit1 = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelected] + ')', "locales", true, true));
		newcredit1.antialiasing = ClientPrefs.globalAntialiasing;
		// newcredit.setGraphicSize(Std.int(0.8));
		newcredit1.visible = true;
		// newcredit.x=525;
		newcredit1.x = 274;
		newcredit1.y = 724;
		add(newcredit1);
		add(dummycredit);
		add(dummycredit1);
		add(dummycredit2);
		FlxTween.tween(bg, {y: 0}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(newcredit, {y: 25}, 0.5, {ease: FlxEase.quartInOut, startDelay: 1});
		FlxTween.tween(newcredit1, {y: 25}, 0.6, {ease: FlxEase.quartInOut, startDelay: 1});

		new FlxTimer().start(1.65, function(tmr:FlxTimer)
		{
			canChange = true;
		});

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new SobreState());
		}

		if (canChange)
			if (controls.UI_RIGHT_P)
				changeSelection(1);
			else if (controls.UI_LEFT_P)
				changeSelection(-1, false);

		super.update(elapsed);
		if (FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

	}

	private function load_dummies(isRight:Bool){
		if (isRight){
			dummycredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp - 1 == -1 ? creditStuff.length - 1 : curSelectedBkp - 1] + ')', "locales", true, true));
			dummycredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp] + ')', "locales", true, true));
			dummycredit2.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelected] + ')', "locales", true, true));
		}else{
			dummycredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelected] + ')', "locales", true, true));
			dummycredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelected + 1 == creditStuff.length ? 0 : curSelected + 1] + ')', "locales", true, true));
			dummycredit2.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp] + ')', "locales", true, true));
		}

	}

	private function restore_values()
	{
		dummycredit2.visible = dummycredit.visible = dummycredit1.visible = false;
		newcredit.visible = newcredit1.visible = canChange = true;
	}

	function changeSelection(dir:Int, goRight:Bool = true)
	{
		canChange = false;
		GlobalSoundManager.play('scrollMenu');

		curSelectedBkp += dir;
		curSelected += dir;

		if (curSelectedBkp == creditStuff.length)
			curSelectedBkp = 0;
		else if (curSelectedBkp == -1)
			curSelectedBkp = creditStuff.length - 1;
		
		if (curSelected == creditStuff.length)
			curSelected = 0;
		else if (curSelected == -1)
			curSelected = creditStuff.length - 1;

		load_dummies(goRight);

		dummycredit.visible = true;
		dummycredit.x = newcredit.x;
		dummycredit.y = newcredit.y;

		dummycredit1.visible = true;
		dummycredit1.x = newcredit1.x;
		dummycredit1.y = newcredit1.y;
		dummycredit2.visible = true;
		dummycredit2.x = 900;

		newcredit.visible = false;
		newcredit1.visible = false;

		if (goRight){
		FlxTween.tween(dummycredit, {x: -900}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(dummycredit1, {x: newcredit.x}, 0.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(dummycredit2, {x: newcredit1.x}, 0.7, {ease: FlxEase.quartInOut, onComplete:function(twn:FlxTween){
			restore_values();
		}});
		}else{
			dummycredit2.x = -900;
			FlxTween.tween(dummycredit1, {x: FlxG.width+900}, 0.5, {ease: FlxEase.quartInOut});
			FlxTween.tween(dummycredit, {x: newcredit1.x}, 0.6, {ease: FlxEase.quartInOut});
			FlxTween.tween(dummycredit2, {x: newcredit.x}, 0.7, {ease: FlxEase.quartInOut, onComplete:function(twn:FlxTween){
				restore_values();
			}});
		}


		newcredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelectedBkp] + ')', "locales", true, true));
		newcredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[curSelected] + ')', "locales", true, true));

	}
}
