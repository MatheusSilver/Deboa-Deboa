package;

//Tudo isso foi baseado no DDTO com algumas mudanças sutís.

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class LanguageBootState extends MusicBeatState
{
	var backdrop:FlxBackdrop;
	var titleText:FlxText;

	var curSelected:Int = 0;

	var textMenuItems:Array<String> = [];
	var localeList:Array<String> = [];

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	override function create()
	{
		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ph'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		// Featuring: working around dumb library issues
		// https://github.com/larsiusprime/firetongue/issues/48
		localeList = CoolUtil.coolTextFile(Paths.txt('languages', 'preload'));

		for (i in 0...localeList.length)
			textMenuItems.push(Main.tongue.getIndexString(LanguageBilingual, localeList[i], ClientPrefs.lingua));

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(0, 300 + (i * 43), 0, textMenuItems[i]);
			trace(textMenuItems[i]);
			optionText.setFormat(LangUtil.getFont('letravio'), 27, FlxColor.RED, LEFT);
			optionText.screenCenter(X);
			optionText.borderStyle = OUTLINE;
			optionText.borderColor = FlxColor.BLACK;
			optionText.antialiasing = ClientPrefs.globalAntialiasing;
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}

		titleText = new FlxText(0, 150, 0, LangUtil.getString('langMenu'));
		titleText.setFormat(LangUtil.getFont('letravio'), 48, 0xFFD71616, CENTER);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.screenCenter(X);
		add(titleText);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected -= 1;
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected += 1;
			}

			if (curSelected < 0)
				curSelected = textMenuItems.length - 1;

			if (curSelected >= textMenuItems.length)
				curSelected = 0;

			titleText.text = LangUtil.getString('langMenu');
			for (i in 0...localeList.length)
				textMenuItems.push(Main.tongue.getIndexString(LanguageBilingual, localeList[i], localeList[curSelected]));

			grpOptionsTexts.forEach(function(txt:FlxText)
			{
				if (txt.ID == curSelected)
					txt.setBorderStyle(OUTLINE, 0xFFFFA7F3);
				else
					txt.setBorderStyle(OUTLINE, 0xFFEB489C);
			});

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpOptionsTexts.forEach(function(txt:FlxText)
				{
					if (curSelected != txt.ID)
					{
						FlxTween.tween(txt, {alpha: 0}, 1.3, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								txt.kill();
							}
						});
					}
					else
					{
						ClientPrefs.lingua = localeList[curSelected];
						trace('Game language set to ${ClientPrefs.lingua}');
						Main.tongue.initialize({locale: ClientPrefs.lingua});
						ClientPrefs.save();

						if (ClientPrefs.flashing)
						{
							FlxFlicker.flicker(txt, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								GlobalSoundManager.play("confirmMenu");
								MusicBeatState.switchState(new TitleState());
							});
						}
						else
						{
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								MusicBeatState.switchState(new TitleState());
							});
						}
					}
				});
			}
		}
	}
}