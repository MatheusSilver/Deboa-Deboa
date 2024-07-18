package ajustes;

import flixel.FlxObject;
import Input.Controls;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.lists.FlxGamepadButtonList;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import Utils.InputDevices;

class InputLabel extends FlxObject{

    var keyboardMode:Bool = true;
	var gamepadModel:InputDevices = AUTO;
	var gamepad:FlxGamepad;
    public static var instance:InputLabel;

    public function new(){
        instance = this;
        super(x,y);
		updateWithChange();
    }

	function updateWithChange() {
		if (FlxG.gamepads.anyButton() && keyboardMode){
			keyboardMode = false;
			updateGamepad();
		} else if (FlxG.keys.pressed.ANY && !keyboardMode){
			keyboardMode = true;
		}
	}

	public function getKeyLabelPath(bind:String):String {
		updateWithChange();

		var keys:Array<Dynamic>;
		if (keyboardMode) keys = ClientPrefs.keyBinds.get(bind);
		else 			  keys = ClientPrefs.keyBindsGamepad.get(bind);

		var model:Dynamic = keyboardMode ? "Keyboard" : gamepadModel;
        return 'input/${model}/${formatKey(keys[0])}';
	}

	private function formatKey(inputData:Dynamic):String
		{
			if (keyboardMode) return Input.InputFormatter.getKeyName(inputData);
			else 			  return Input.InputFormatter.getKeyNameGamepad(inputData);
		}

	private function updateGamepad():Void
	{
		if (FlxG.gamepads.lastActive != null){
			keyboardMode = false;
			gamepad = FlxG.gamepads.lastActive;
			gamepadModel = Utils.GamepadUtil.getDisplayGamepadModel();
		}else
			keyboardMode = true;
			gamepad = null;
	}
}