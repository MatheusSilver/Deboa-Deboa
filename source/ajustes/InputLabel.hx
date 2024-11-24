package ajustes;

import flixel.FlxObject;
import Input.Controls;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.lists.FlxGamepadButtonList;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import Utils.InputDevices;

class InputLabel extends FlxObject{
	var gamepadModel:InputDevices = AUTO;
	var gamepad:FlxGamepad;
    public static var instance:InputLabel;

    public function new(){
        instance = this;
        super(x,y);
		updateWithChange();
    }

	function updateWithChange() {
		if (Utils.GamepadUtil.anyGamepadButtonPressed() && Main.isKeyboard){
			Main.isKeyboard = false;
			gamepadModel = Utils.GamepadUtil.getDisplayGamepadModel();
		} else if (FlxG.keys.pressed.ANY && !Main.isKeyboard){
			Main.isKeyboard = true;
		}
	}

	public function getKeyLabelPath(bind:String):String {
		updateWithChange();

		var keys:Array<Dynamic>;
		if (Main.isKeyboard) keys = ClientPrefs.keyBinds.get(bind);
		else 			  keys = ClientPrefs.keyBindsGamepad.get(bind);

		var model:Dynamic = Main.isKeyboard ? "Keyboard" : gamepadModel;
        return 'input/${model}/${formatKey(keys[0])}';
	}

	private function formatKey(inputData:Dynamic):String
		{
			if (Main.isKeyboard) return Input.InputFormatter.getKeyName(inputData);
			else 			  return Input.InputFormatter.getKeyNameGamepad(inputData);
		}
}