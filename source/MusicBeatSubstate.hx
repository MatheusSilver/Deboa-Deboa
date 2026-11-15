package;

import flixel.FlxG;
import flixel.FlxSubState;
import Input.PlayerSettings;
#if mobileC
import flixel.input.actions.FlxActionInput;
import mobile.ui.FlxVirtualPad;
#end

class MusicBeatSubstate extends FlxSubState
{
	var lastMouseX:Float = 0;
	var lastMouseY:Float = 0;
	var mouseActuallyMoved:Bool = false;
	public function new()
	{
		super();
		
		#if desktop
		lastMouseX = FlxG.mouse.screenX;
		lastMouseY = FlxG.mouse.screenY;
		#end
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Input.Controls;

	inline function get_controls():Input.Controls
		return PlayerSettings.player1.controls;
	
	#if mobileC
	var _virtualpad:FlxVirtualPad;

	var trackedinputsUI:Array<FlxActionInput> = [];
	var trackedinputsNOTES:Array<FlxActionInput> = [];	

	// adding virtualpad to state
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		_virtualpad = new FlxVirtualPad(DPad, Action);
		_virtualpad.alpha = 0.75;
		add(_virtualpad);
		controls.setVirtualPadUI(_virtualpad, DPad, Action);
		trackedinputsUI = controls.trackedinputsUI;
		controls.trackedinputsUI = [];
	}
	
	override function destroy() {
		controls.removeFlxInput(trackedinputsUI);
		controls.removeFlxInput(trackedinputsNOTES);		
		
		super.destroy();
	}
	#end			

	override function update(elapsed:Float)
	{
		#if desktop mouseActuallyMoved = (FlxG.mouse.screenX != lastMouseX || FlxG.mouse.screenY != lastMouseY); #end
		if (Main.getMouseVisibility() && (FlxG.keys.justPressed.ANY || GamepadUtil.anyGamepadButtonPressed())){
			if (!Main.isKeyboard && FlxG.keys.pressed.ANY) Main.isKeyboard = true;
			else if (Main.isKeyboard && GamepadUtil.anyGamepadButtonPressed()) Main.isKeyboard = false;

			Main.mouseVisibility(false);
			
		}else if (Main.mouse_allowed && #if !mobile mouseActuallyMoved #else BSLTouchUtils.justTouched() #end){
			Main.mouseVisibility(true);
		}
		
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastStepTime:Int = 0;
		var lastSongTime:Float = 0;
		for (change in Song.Conductor.bpmChangeMap)
		{
			if (Song.Conductor.songPosition > change.songTime)
			{
				lastStepTime = change.stepTime;
				lastSongTime = change.songTime;
			}
		}

		curStep = lastStepTime + Math.floor((Song.Conductor.songPosition - lastSongTime) / Song.Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}