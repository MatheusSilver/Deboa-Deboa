package;

import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;
	var imagem:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

		/*transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
		transGradient.scrollFactor.set();
		add(transGradient);

		transBlack = new FlxSprite().makeGraphic(width, height + 400, FlxColor.BLACK);
		transBlack.scrollFactor.set();
		add(transBlack);

		transGradient.x -= (width - FlxG.width) / 2;
		transBlack.x = transGradient.x;*/
		transBlack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		transBlack.scrollFactor.set();
		transBlack.visible=false;
		add(transBlack);
		imagem = new FlxSprite();
		imagem.loadGraphic(Paths.image('transições/transition', 'preload'));
		imagem.antialiasing = ClientPrefs.globalAntialiasing;
		imagem.scrollFactor.set();
		imagem.screenCenter(XY);
		add(imagem);
		if(isTransIn) {
			transBlack.visible=true;
			imagem.scale.x=0.5;
			imagem.scale.y=0.5;
            new FlxTimer().start(0.5, function(tmr:FlxTimer){
                transBlack.visible=false;
				FlxTween.tween(imagem.scale, {x:240, y:240}, duration, {
					onComplete: function(twn:FlxTween) {
						close();
					},
				ease: FlxEase.linear});
            });

		} else {
			imagem.scale.x=230;
			imagem.scale.y=230;
			leTween = FlxTween.tween(imagem.scale, {x:0.5, y:0.5}, duration, {
				onComplete: function(twn:FlxTween) {
					transBlack.visible=true;
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.linear});
		}

		if(nextCamera != null) {
			imagem.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		/*if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}*/
		super.update(elapsed);
		/*if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}*/
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}