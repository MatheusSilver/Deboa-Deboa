package;

import flixel.ui.FlxButton;
import Conductor.BPMChangeEvent;
import flixel.FlxSubState;
#if mobileC
import flixel.input.actions.FlxActionInput;
import ui.FlxVirtualPad;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	
	#if mobileC

	// Obrigado Silver (code pego do DDTO+ Android)
	var hitboxcima:FlxButton;
	var hitboxbaixo:FlxButton;

	// TO DO: FAZER ISSO SER EXCLUSIVO E FUNCIONAL NO MOBILE
	// EXCLUSIVO = IMAGENS NA PASTA MOBILECONTROLS
	// FUNCIONAL = FAZER FUNÇÃO DO SCROLL DO MOUSE
	public function addhitboxtouch()
	{
		hitboxbaixo = new FlxButton(0, 540, function()
		{
		});
		hitboxbaixo.loadGraphic(Paths.image('notainvisivel')); //  Não sei se isso deve ser carregado na GPU, mas acredito que não
		hitboxbaixo.setGraphicSize(1280, 180); // k
		hitboxbaixo.updateHitbox();
		add(hitboxbaixo);

		hitboxcima = new FlxButton(0, 0, function()
			{
			});
			hitboxcima.loadGraphic(Paths.image('notainvisivel')); //  Não sei se isso deve ser carregado na GPU, mas acredito que não
			hitboxcima.setGraphicSize(1280, 180); // k
			hitboxcima.updateHitbox();
			add(hitboxcima);
	}
	
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
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
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