package mobile;

#if MOBILE_CONTROLS
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import mobile.Config;
import mobile.ui.FlxVirtualPad;
import mobile.ui.Hitbox;

class MobileControls extends FlxSpriteGroup
{
	public var mode:ControlsGroup = HITBOX;
	public var _hitbox:Hitbox;
	public var _virtualPad:FlxVirtualPad;

	public function new()
	{
		super();

		// load control mode num from Config.hx
		mode = Config.returnEnumFromMode(Config.getcontrolmode());

		switch (mode)
		{
			case VIRTUALPAD_RIGHT:
				initVirtualPad(0);
			case VIRTUALPAD_LEFT:
				initVirtualPad(1);
			case VIRTUALPAD_CUSTOM:
				initVirtualPad(2);
			case HITBOX:
				_hitbox = new Hitbox();
				add(_hitbox); 
			case KEYBOARD:
		}
	}

	function initVirtualPad(vpadMode:Int)
	{
		switch (vpadMode)
		{
			case 1:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
			case 2:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
				_virtualPad = Config.loadcustom(_virtualPad);
			default:
				_virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
		}

		_virtualPad.alpha = 0.75;
		add(_virtualPad);
	}
}

enum ControlsGroup
{
	VIRTUALPAD_RIGHT;
	VIRTUALPAD_LEFT;
	KEYBOARD;
	VIRTUALPAD_CUSTOM;
	HITBOX;
}
#end