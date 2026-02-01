import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class Speed extends FlxSpriteGroup
{
	private var input_allowed:Bool = false;
	public var speed:FlxSprite;

	public function new() {
		super();

		Main.mouseVisibility(true);
		input_allowed = true;

		speed = new FlxSprite();
		speed.frames = Paths.getSparrowAtlas('speed', 'shared');
		speed.antialiasing = ClientPrefs.globalAntialiasing;
		speed.moves = false;

		speed.scale.set(0.3, 0.3); // Vi que no GifWindow vocês usaram 300x300 e como cada frame é 1000x1000 so usei proporcionalidade
		speed.updateHitbox();

		speed.setPosition(0, 0);
		speed.scrollFactor.set(0, 0);

		speed.animation.addByPrefix('speed', 'speed', 24); // Fiz o spritesheet com base nos delays do ezgif usando em consideração 24fps
		speed.animation.play('speed');

		add(speed);
	}

	public static inline function float(from:Float, to:Float):Float
		return from + ((to - from) * Math.random());

	override function update(elapsed:Float) {
		if (input_allowed && BSLTouchUtils.apertasimples(speed))
			close();

		super.update(elapsed);
	}

	private function close() {
		Main.mouseVisibility(false);
		input_allowed = visible = false;
	}
}
