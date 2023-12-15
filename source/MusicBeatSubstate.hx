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
	var _cimabt:FlxButton;
	var _baixobt:FlxButton;

	// TO DO: FAZER ISSO SER EXCLUSIVO E FUNCIONAL NO MOBILE
	// EXCLUSIVO = IMAGENS NA PASTA MOBILECONTROLS
	// FUNCIONAL = FAZER FUNÇÃO DO SCROLL DO MOUSE
	public function addbotoes(xc:Float = 1185*0.8, yc:Float = 5477, xb:Float = 1185*0.8, yb:Float = 577)
	{
		_cimabt = new FlxButton(xc, yc, function()
		{
			trace("botao cima apertado");
		});
		_cimabt.loadGraphic(Paths.image('assets/mobilecontrols/images/cimabt')); //  Não sei se isso deve ser carregado na GPU, mas acredito que não
		_cimabt.updateHitbox();
		add(_cimabt);

		_baixobt = new FlxButton(xb, yc, function()
		{
			trace("botao baixo apertado");
		});
		_baixobt.loadGraphic(Paths.image('assets/mobilecontrols/images/baixobt')); //  Não sei se isso deve ser carregado na GPU, mas acredito que não
		_baixobt.updateHitbox();
		add(_baixobt);
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