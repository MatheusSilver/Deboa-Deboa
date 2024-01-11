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
			textMenuItems.push(Main.tongue.getIndexString(Language, localeList[i], ClientPrefs.lingua));

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(0, 300 + (i * 43), FlxG.width, textMenuItems[i]);
			optionText.setFormat(LangUtil.getFont('letravio'), 27, FlxColor.WHITE, CENTER);
			optionText.screenCenter(X);
			optionText.borderStyle = OUTLINE;
			optionText.borderColor = FlxColor.TRANSPARENT;			
			optionText.antialiasing = ClientPrefs.globalAntialiasing;
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}

		titleText = new FlxText(0, 150, FlxG.width, LangUtil.getString('langMenu'));
		titleText.screenCenter(X);
		titleText.setFormat(LangUtil.getFont('letravio'), 48, FlxColor.WHITE, CENTER);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		add(titleText);

		super.create();

		changeSelection();
	}

	var selectedSomethin:Bool = false;

	function changeSelection(direction:Int = 0):Void
	{
		if (direction < 0)
			direction = textMenuItems.length - 1;
			

		if (direction >= textMenuItems.length)
			direction = 0;

		curSelected = direction;

		Main.tongue.initialize({locale: localeList[curSelected]});

		titleText.text = LangUtil.getString('langMenu');

		textMenuItems=[];

		for (i in 0...localeList.length)
			textMenuItems.push(Main.tongue.getIndexString(Language, localeList[i], localeList[curSelected]));

		grpOptionsTexts.forEach(function(txt:FlxText)
			{
				txt.text=textMenuItems[txt.ID];
				if (txt.ID == curSelected) txt.setBorderStyle(OUTLINE, FlxColor.RED);
				else txt.setBorderStyle(OUTLINE, FlxColor.TRANSPARENT);
			});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P){
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSelection(curSelected-1);
			}else if (controls.UI_DOWN_P){
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSelection(curSelected+1);
			}
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