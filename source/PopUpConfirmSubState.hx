package;

import GlobalSoundManager.Sounds;
import Linguagem.LangUtil;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import gamejolt.InviteBackEnd;

class PopUpConfirmSubState extends PopUpSubState
{
	var yesButton:FlxButton;
	var noButton:FlxButton;
	var onYes:() -> Void;
	var onNo:() -> Void;
	var yesSelected:Bool = false;
	var answered:Bool = false;

	public function new(titleID:String, contentID:String, camera:FlxCamera, onYes:() -> Void, onNo:() -> Void, ?yValue:Float = 150, ?otherFont:Bool = false)
	{
		super(titleID, contentID, camera, null, yValue, otherFont);
		this.onYes = onYes;
		this.onNo = onNo;
		FlxTween.cancelTweensOf(okButton);
		remove(okButton, true);
		okButton.destroy();
		yesButton = makeButton(popupBG.x + popupBG.width / 2 - 227, 'button_yes', camera);
		noButton = makeButton(popupBG.x + popupBG.width / 2, 'button_no', camera);
	}

	function makeButton(x:Float, labelID:String, camera:FlxCamera):FlxButton
	{
		var button:FlxButton = new FlxButton(x, popupBG.y + 425);
		button.loadGraphic(Paths.image('buttons_base/yes_no_button', 'preload'));
		button.setGraphicSize(Std.int(button.width * 0.5));
		button.updateHitbox();
		button.alpha = 0;
		if (camera != null)
			button.cameras = [camera];
		add(button);

		var label:FlxText = new FlxText(button.x + 62, button.y, 143, LangUtil.getString(labelID, 'popupTitles'));
		label.setFormat(LangUtil.getFont('sonic-1'), 30, 0xFFC8F5FC, CENTER);
		label.y = button.y + (button.height - label.height) / 2;
		label.alpha = 0;
		if (camera != null)
			label.cameras = [camera];
		add(label);

		FlxTween.tween(button, {alpha: 1}, 0.5);
		FlxTween.tween(label, {alpha: 1}, 0.5);
		return button;
	}

	override function update(elapsed:Float)
	{
		if (answered || !canClick)
			return;

		var pointer:Bool = InviteBackEnd.curInvites.length == 0;
		if (Main.getMouseVisibility())
		{
			if (pointer && BSLTouchUtils.over(yesButton) && !yesSelected)
			{
				yesSelected = true;
				GlobalSoundManager.play(Sounds.scrollMenu);
			}
			else if (pointer && BSLTouchUtils.over(noButton) && yesSelected)
			{
				yesSelected = false;
				GlobalSoundManager.play(Sounds.scrollMenu);
			}
		}
		else if ((controls.UI_LEFT_P && !yesSelected) || (controls.UI_RIGHT_P && yesSelected))
		{
			yesSelected = !yesSelected;
			GlobalSoundManager.play(Sounds.scrollMenu);
		}

		yesButton.color = yesSelected ? FlxColor.WHITE : FlxColor.GRAY;
		noButton.color = yesSelected ? FlxColor.GRAY : FlxColor.WHITE;

		if (pointer && BSLTouchUtils.apertasimples(yesButton))
			answer(true);
		else if (pointer && BSLTouchUtils.apertasimples(noButton))
			answer(false);
		else if (controls.ACCEPT)
			answer(yesSelected);
		else if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
			answer(false);
	}

	function answer(yes:Bool):Void
	{
		answered = true;
		GlobalSoundManager.play(yes ? Sounds.confirmMenu : Sounds.cancelMenu);
		if (yes)
			onYes();
		else
			onNo();
	}
}
