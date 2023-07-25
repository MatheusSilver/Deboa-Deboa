package;

import ui.FlxVirtualPad;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;

class Config
{
	// Modificado pelo Silver (Ele só pediu pra eu fazer uma commit que mudava umas coisas)
	// https://github.com/MatheusSilver/miku-public/
	
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
		trace("saved");

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
		// load pad
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
}
