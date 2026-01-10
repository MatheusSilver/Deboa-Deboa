package mobile;

#if mobileC
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import mobile.MobileControls.ControlsGroup;
import mobile.ui.FlxVirtualPad;

class Config
{
	public static function getcontrolmode():Int
	{
		// load control mode num from FlxSave
		if (ClientPrefs.buttonsMode != null)
			return ClientPrefs.buttonsMode[0];
		return 0;
	}

	public static function setcontrolmode(mode:Int = 0):Int
	{
		// save control mode num from FlxSave
		if (ClientPrefs.buttonsMode == null)
			ClientPrefs.buttonsMode = new Array();
		ClientPrefs.buttonsMode[0] = mode;
		ClientPrefs.save();

		return ClientPrefs.buttonsMode[0];
	}

	public static function savecustom(_pad:FlxVirtualPad)
	{
		trace("CONTROLES MOBILE: configuração customizada salva...");

		if (ClientPrefs.buttons == null)
		{
			ClientPrefs.buttons = new Array();

			for (buttons in _pad)
			{
				ClientPrefs.buttons.push(FlxPoint.get(buttons.x, buttons.y));
			}
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in _pad)
			{
				ClientPrefs.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}
		ClientPrefs.save();
	}

	public static function loadcustom(_pad:FlxVirtualPad):FlxVirtualPad
	{
		if (ClientPrefs.buttons == null)
			return _pad;
		var tempCount:Int = 0;

		for (buttons in _pad)
		{
			buttons.x = ClientPrefs.buttons[tempCount].x;
			buttons.y = ClientPrefs.buttons[tempCount].y;
			tempCount++;
		}
		return _pad;
	}

	public static function returnEnumFromMode(mode:Int):ControlsGroup
	{
		return switch (mode)
		{
			case 0: VIRTUALPAD_RIGHT;
			case 1: VIRTUALPAD_LEFT;
			case 2: KEYBOARD;
			case 3: VIRTUALPAD_CUSTOM;
			case 4: HITBOX;

			default: VIRTUALPAD_RIGHT;
		}
	}
}
#end