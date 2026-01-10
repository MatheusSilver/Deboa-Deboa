package ajustes;

import flixel.FlxObject;
import Input.Controls;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.lists.FlxGamepadButtonList;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import GamepadUtil.InputDevices;

class InputLabel extends FlxObject{
	var gamepadModel:InputDevices = Keyboard;
	var gamepad:FlxGamepad;
    public static var instance:InputLabel;

    public function new(){
        instance = this;
        super(x,y);
		updateWithChange();
		gamepadModel = GamepadUtil.getDisplayGamepadModel() != Keyboard ? GamepadUtil.getDisplayGamepadModel() : GamepadUtil.getActualGamepadModel();
    }

	function updateWithChange() {
		if (GamepadUtil.anyGamepadButtonPressed() && Main.isKeyboard){
			Main.isKeyboard = false;
			gamepadModel = GamepadUtil.getDisplayGamepadModel() != Keyboard ? GamepadUtil.getDisplayGamepadModel() : Xinput_Controller;
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

	public function getLiteralLabelPath(literal:String, literalKeyboard:String):String {
		updateWithChange();

		var key:Dynamic;
		if (Main.isKeyboard) key = FlxKey.fromString(literalKeyboard);
		else 			  key = FlxGamepadInputID.fromString(literal);

		var model:Dynamic = Main.isKeyboard ? "Keyboard" : gamepadModel;
        return 'input/${model}/${formatKey(key)}';
	}

	private function formatKey(inputData:Dynamic):String
		{
			if (Main.isKeyboard) return Input.InputFormatter.getKeyName(inputData);
			else 			  return Input.InputFormatter.getKeyNameGamepad(inputData);
		}
}