package;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepadInputID;

enum InputDevices // Lista com todos os tipos de controle que esperamos que alguém vá usar, sentimos muito se você tem um amazon luna ou então um OUYA ou sei lá mais o que existe por ai.
{
	Keyboard;
	PS4_Controller;
	Switch_Controller;
	Xinput_Controller;
	AUTO;
}

class GamepadUtil
{
	private static final bindsBlackList:Map<InputDevices, Array<Int>> = [Switch_Controller => [-1], PS4_Controller => [-1], Xinput_Controller => [-1, 10]];

	inline public static function formatKey(inputData:Dynamic):String
	{
		if (Main.isKeyboard)
			return Input.InputFormatter.getKeyName(inputData);
		else
			return Input.InputFormatter.getKeyNameGamepad(inputData);
	}

	public static function isValidInput(keyPressed:Int, gamepadModel:InputDevices):Bool
	{
		return !bindsBlackList.get(gamepadModel).contains(keyPressed);
	}

	inline public static function getActualGamepadModel():InputDevices
	{
		if (FlxG.gamepads.lastActive != null)
		{
			switch (FlxG.gamepads.lastActive.detectedModel)
			{
				case SWITCH_PRO:
					return Switch_Controller;
				case PS4:
					return PS4_Controller;
				default:
					return Xinput_Controller;
			}
		}
		else
		{
			return Xinput_Controller;
		}
	}

	inline public static function getDisplayGamepadModel():InputDevices
	{
		if (Main.isKeyboard)
			return Keyboard;
		else if (ClientPrefs.gamepadDisplay == AUTO)
			return getActualGamepadModel();
		else
			return ClientPrefs.gamepadDisplay;
	}

	inline public static function anyGamepadButtonPressed():Bool
	{
		return (FlxG.gamepads.anyButton() && isValidInput(FlxG.gamepads.lastActive.firstJustPressedID(), getActualGamepadModel()));
	}

	inline public static function getGamepadPressedButton():Int
	{
		if (isValidInput(FlxG.gamepads.lastActive.firstJustPressedID(), getActualGamepadModel()))
			return FlxG.gamepads.lastActive.firstJustPressedID();
		return -1; // Só pra poder padronizar como none.
	}

	inline public static function checkGamepadPressedButton(button:FlxGamepadInputID):Bool
	{
		return FlxG.gamepads.anyJustPressed(button);
	}

	inline public static function getGamepadConnected():Bool
	{
		return FlxG.gamepads.lastActive != null;
	}
}
