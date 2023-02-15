package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		loadAnims(skin);

		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		if(texture == null) {
			texture = 'noteSplashes';
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}

		switch(texture){
			case 'blood':
				alpha = 1;
				antialiasing=true;
				colorSwap.hue = 0;
				colorSwap.saturation = 0;
				colorSwap.brightness = 0;
				offset.set(-40, -90);
				animation.play('splash', true);

				animation.curAnim.frameRate = 24;

			case 'milk':
				alpha = 0.89;
				antialiasing=true;
				var animNum:Int = FlxG.random.int(1, 2);
				animation.play('note' + note + '-' + animNum, true);
				scale.x = 0.6;
				scale.y = 0.6;
				updateHitbox();
				offset.set(70, 90);
				
			default:
				alpha = 0.6;
				antialiasing=true;
				colorSwap.hue = hueColor;
				colorSwap.saturation = satColor;
				colorSwap.brightness = brtColor;
				if(PlayState.nomehistorico.toLowerCase() != 'noite da rapaziada'){
					offset.set(10, 10);
				} else {
					offset.set(10*0.65/0.7, 10*0.65/0.7);
				}

				var animNum:Int = FlxG.random.int(1, 2);
				animation.play('note' + note + '-' + animNum, true);

				animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		}


	}

	function loadAnims(skin:String) {
		if(openfl.utils.Assets.exists(Paths.imagechecker('splashes/'+skin))){
			frames = Paths.getSparrowAtlas('splashes/'+skin); //Aparentemente isso tenta puxar o note splash da pasta shared/images, mas e se...
			} else {
				//FlxG.log.add('não achei ' + skin + " em " + LoadingState.directoryreader + "splashes/ então vou procurar em shared");
				if(skin != null && skin.length > 0) {
					frames = Paths.getSparrowAtlas('splashes/'+skin, 'shared'); //Aparentemente isso tenta puxar o note splash da pasta shared/images, mas e se...
				}
			}
		switch(skin){
			case 'blood':
					animation.addByPrefix("splash", "Squirt", 24, false);
			case 'milk':
				for (i in 1...3) {
					animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
					animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
					animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
					animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
				}
			default:
				for (i in 1...3) {
					animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
					animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
					animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
					animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
				}
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}