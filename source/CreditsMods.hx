

package;

import flixel.group.FlxSpriteGroup;
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

class CreditsMods extends MusicBeatState
{
	var bg:FlxSprite;
	var faixa:FlxSprite;
	var exe:FlxSprite;
	var curSelected:Int = 0;
	var canChange:Bool = false;
	var creditList:FlxSpriteGroup;

	var creditStuff:Array<String> = [
		'belowthedepths', 'chaosnightmare', 'endlesscycles', 'executionrecycled', 'finalescape', 'finalratio', 'funkmixmario', 'hypnoslullaby', 'piracysonic',
		'possessed', 'preyp', 'ringsofdespair', 'secrethistories', 'sonicboom', 'vssonicexe', 'vsspeedgif', 'vstailsexe'
	];

	override function create()
	{
		FlxTransitionableState.skipNextTransOut = true;
		Main.mouse_allowed = false;
		canChange = false;
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_credit_menu", "rpc"), null);
		#end
		
		/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
			add(bg); */
		new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (back)'));
				bg.antialiasing = ClientPrefs.globalAntialiasing;
				bg.updateHitbox();
				// faixa.setGraphicSize(Std.int(0.5));
				bg.alpha = 1;
				bg.y = 720;
				add(bg);

				creditList = new FlxSpriteGroup(-25,FlxG.height*4,creditStuff.length);

				for (i in 0...creditStuff.length){
					var creditSprite:SpriteSwapper;
					creditSprite = new SpriteSwapper(i, Paths.image('sobremenu/creditos/modseports/cards/card-' + creditStuff[i], "locales", true, true), 1, 200, Y, 1.7);
					creditList.add(creditSprite);
				}
				add(creditList);

				faixa = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (faixa)'));
				faixa.antialiasing = ClientPrefs.globalAntialiasing;
				faixa.updateHitbox();
				// faixa.setGraphicSize(Std.int(0.5));
				faixa.alpha = 1;
				faixa.x = 973;
				add(faixa);

				exe = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (sonic)'));
				exe.antialiasing = ClientPrefs.globalAntialiasing;
				exe.updateHitbox();
				// faixa.setGraphicSize(Std.int(0.5));
				exe.alpha = 1;
				exe.x = 1029;
				add(exe);

				FlxTween.tween(faixa, {x: 376}, 1, {ease: FlxEase.quartInOut});
				FlxTween.tween(exe, {x: 326}, 1.25, {ease: FlxEase.quartInOut});
				FlxTween.tween(bg, {y: 0}, 0.8, {ease: FlxEase.quartInOut});
				FlxTween.tween(creditList, {y: -FlxG.height*0.275}, 0.5, {ease: FlxEase.quartInOut, startDelay: 1.35});

				new FlxTimer().start(1.8, function(tmr:FlxTimer)
				{
					canChange = true;
				});

				#if mobileC
				addVirtualPad(LEFT_RIGHT, A_B);
				#end
			});

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK && canChange)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new SobreState());
		}

		if (controls.UI_RIGHT_P || controls.UI_UP_P)
		{ // ok
			if (canChange)
			{
				if (curSelected + 1 > creditStuff.length - 1)
				{
					curSelected = 0;
					changeSelection(curSelected);
				}
				else
				{
					curSelected = curSelected + 1;
					changeSelection(curSelected);
				}
				canChange = false;
				GlobalSoundManager.play('scrollMenu');
			}
		}

		if (controls.UI_LEFT_P || controls.UI_DOWN_P)
		{ // ok
			if (canChange)
			{
				if (curSelected - 1 < 0)
				{
					curSelected = creditStuff.length - 1;
					changeSelection(curSelected, true);
				}
				else
				{
					curSelected = curSelected - 1;
					changeSelection(curSelected, true);
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

	function changeSelection(newCurselected:Int, ?cima:Bool = false)
	{
		//vazio :skull: mas tem o backup no discord caso precise reaproveitar alguma ideia
	}
}
