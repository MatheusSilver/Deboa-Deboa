package ajustes;

import flixel.FlxObject;
import Input.Controls;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.lists.FlxGamepadButtonList;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;

class InputLabel extends FlxObject{

    var keyboardMode:Bool = true;
	var gamepadModel:String = "Keyboard";
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

		var model = keyboardMode ? "Keyboard" : gamepadModel;
        return 'input/$model/${formatKey(keys[0])}';
	}

	private function formatKey(inputData:Dynamic):String
		{
			if (keyboardMode) return Input.InputFormatter.getKeyName(inputData);
			else 			  return Input.InputFormatter.getKeyNameGamepad(inputData);
		}

	private function setGamepadModel(gamepad:FlxGamepad):Void
	{
		switch(gamepad.detectedModel){
			case PS4:
				gamepadModel = "PS4";
			case SWITCH_PRO:
				gamepadModel = "Switch";
			default:
				gamepadModel = "Xinput"; //Aparentemente os controles do Steam e do Xbox seguem o mesmo padrão. (Infelizmente não tenho um steam deck pra testar).
		}
	}

	private function updateGamepad():Void
	{
		if (FlxG.gamepads.lastActive != null){
			keyboardMode = false;
			gamepad = FlxG.gamepads.lastActive;
			setGamepadModel(gamepad);
		}else
			keyboardMode = true;
			gamepad = null;
	}
}