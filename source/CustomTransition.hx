package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;


class CustomTransition extends MusicBeatSubstate {

	//Bom, explicando tudo certinho:
	//As booleans estão como false por padrão, caso quiser iniciar a cutscene com uma imagem especifíca
	//Antes do switchState, coloque o code:
	//cc, ou sonicb, ou mariob = true;
	//openSubState(new CustomTransition());
	//new FlxTimer().start(1, function(tmr:FlxTimer) {
	// MusicBeatState.switchState(new seustate());		
	//}
	//Ah Mateus, isso é muito ruim e que não sei o que e que o code é feito que nem um homem das cavernas faria: não tô nem aí
	

	
	
	public static var cc:Bool = false; //Só definir pra true e a transição vira o mic do canal
	
	public static var sonicb:Bool = false; //Silhueta do Sonic

	public static var mariob:Bool = false; //Silhueta do Sonic
	
	public static var finishCallback:Void->Void;

	var ccmic:FlxSprite;

	var sonic:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;

		ccmic = new FlxSprite().loadGraphic(Paths.image('transições/galaccine'));
		ccmic.setGraphicSize(FlxG.width, FlxG.height);
		if(cc) {
		add(ccmic);
		}

		sonic = new FlxSprite().loadGraphic(Paths.image('transições/sonic'));
		sonic.setGraphicSize(FlxG.width, FlxG.height);
		if(sonicb) {
		add(sonic);
		}

		mario = new FlxSprite().loadGraphic(Paths.image('transições/mario'));
		mario.setGraphicSize(FlxG.width, FlxG.height);
		if(mariob) {
		add(mario);
		}	
	

		new FlxTimer().start(1, function(tmr:FlxTimer) {
			if(sonic) {
				sonic.visible = false;
			} else if(cc) {
				ccmic.visible = false;
			} else if(mario){
				mario.visible = false;
			}

			super.closeSubState();
	}

	override function update(elapsed:Float) {
		if(FlxG.keys.justPressed.SHIFT) {
			mariob = false;
			cc = false;
			sonicb = false;
			super.closeSubState();
		}
		super.update(elapsed);
	}
}