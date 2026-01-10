package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	final accept_text:String = Linguagem.LangUtil.getString("flashing_accept_" #if desktop + "desktop" #elseif mobile + "mobile" #end, "data", "\n");
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width, Linguagem.LangUtil.getString("flashing_warning", "data", "\n") + accept_text, 25);
		warnText.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		warnText.screenCenter(XY);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if(controls.ACCEPT #if mobile || BSLTouchUtils.justTouched() #end) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				GlobalSoundManager.play(confirmMenu);
				ClientPrefs.firstBoot = false;
				FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
					new FlxTimer().start(0.5, function (tmr:FlxTimer) {
						ClientPrefs.save();
						MusicBeatState.switchState(new TitleState());
					});
				});
			}else if(controls.BACK #if mobile || FlxG.android.justReleased.BACK #end){
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				GlobalSoundManager.play(confirmMenu);
				ClientPrefs.firstBoot = false;
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						ClientPrefs.gore = false;
						ClientPrefs.flashing = false;
						ClientPrefs.save();
						MusicBeatState.switchState(new TitleState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
