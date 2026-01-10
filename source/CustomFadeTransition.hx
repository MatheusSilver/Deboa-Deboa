package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class CustomFadeTransition extends MusicBeatSubstate
{
	public static var finishCallback:Void->Void;

	private var leTween:FlxTween = null;

	public static var nextCamera:FlxCamera;

	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;
	var imagem:FlxSprite;

	public function new(duration:Float, isTransIn:Bool)
	{
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);

		transBlack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		transBlack.scrollFactor.set();
		transBlack.visible = false;
		add(transBlack);
		imagem = new FlxSprite();
		imagem.loadGraphic(Paths.image('transicoes/transition', 'preload'));
		imagem.antialiasing = true; // A imagem tava muito pixelada pro meu gosto então fiz isso
		imagem.scrollFactor.set();
		imagem.screenCenter(XY);
		add(imagem);
		if (isTransIn)
		{
			transBlack.visible = true;
			imagem.scale.x = 0.5;
			imagem.scale.y = 0.5;
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				transBlack.visible = false;
				if(imagem==null)
					return;
				FlxTween.tween(imagem.scale, {x: 240, y: 240}, duration, {
					onComplete: function(twn:FlxTween)
					{
						close();
					},
					ease: FlxEase.linear
				});
			});
		}
		else
		{
			imagem.scale.x = 230;
			imagem.scale.y = 230;
			leTween = FlxTween.tween(imagem.scale, {x: 0.5, y: 0.5}, duration, {
				onComplete: function(twn:FlxTween)
				{
					transBlack.visible = true;
					if (finishCallback != null)
					{
						finishCallback();
					}
				},
				ease: FlxEase.linear
			});
		}

		if (nextCamera != null)
		{
			imagem.cameras = [nextCamera];
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function destroy()
	{
		if (leTween != null)
		{
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}
