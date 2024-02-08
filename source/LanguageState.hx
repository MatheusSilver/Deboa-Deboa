package;

//Tudo isso foi baseado no DDTO com algumas mudanças sutís.

import Utils.BSLTouchUtils;
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

class LanguageState extends MusicBeatState
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

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ph2'));
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

		Main.mouse_allowed = true;
		BSLTouchUtils.prevTouched = -1;

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
				GlobalSoundManager.play("scrollMenu");
				changeSelection(curSelected-1);
			}else if (controls.UI_DOWN_P){
				GlobalSoundManager.play("scrollMenu");
				changeSelection(curSelected+1);
			}else if (Main.getMouseVisibility()){
				grpOptionsTexts.forEach(function(txt:FlxText)
					{
						if (BSLTouchUtils.aperta(txt, txt.ID) == "primeiro"){ //Honestamente essa sempre foi minha função favorita (até porque foi a primeira), pena que não dá pra usar ela muito.
							GlobalSoundManager.play("scrollMenu");
							changeSelection(txt.ID);
						}else if (BSLTouchUtils.aperta(txt, txt.ID) == "segundo")
							accept();
					});
			}
			if (controls.ACCEPT)
				accept();
		}
	}

	private function accept():Void{
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
						MusicBeatState.switchState(FlxG.save.data.flashing == null ? new TitleState() : new ajustes.AjustesState());
					});
				}
				else
				{
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(FlxG.save.data.flashing == null ? new TitleState() : new ajustes.AjustesState());
					});
				}
			}
		});
	}
}