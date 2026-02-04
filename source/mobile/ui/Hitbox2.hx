package mobile.ui;

#if mobileC
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import ui.FlxButton;
import flixel.graphics.FlxGraphic;

/**
 *  Reescrevi esse code, tentando deixar tudo mais limpo e melhor de ler
 */
class Hitbox2 extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
    public var buttonSpace:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	private var size:Float;
	private var buttonsCoords:Array<Float> = []; // Adaptei isso pra ser dependente da resolução.

	public function new()
	{
		super();
       
		size = FlxG.width / 5; // Tenho em mente que isso será sempre 1280x720, o que confirma o 256. mas vai que né?
        buttonsCoords = [0, size, size * 2 , size * 3, size * 4]; // Antes dessa correção, um botão ia sobrepor o outro.
        
		var hint:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('hitboxExtra_hint', 'mobilecontrols'));
		hint.setGraphicSize(FlxG.width, FlxG.height);
		hint.screenCenter();
		hint.moves = false;
		hint.antialiasing = ClientPrefs.globalAntialiasing;
		add(hint);

		add(buttonLeft = createHitbox(buttonsCoords[0], "1"));
		add(buttonDown = createHitbox(buttonsCoords[1], "2"));
        add(buttonSpace = createHitbox(buttonsCoords[2], "3"));
		add(buttonUp = createHitbox(buttonsCoords[3], "4"));
		add(buttonRight = createHitbox(buttonsCoords[4], "5"));
	}

	private function createHitbox(x:Float, anim:String):FlxButton
	{
		var button:FlxButton = new FlxButton(x, 0);
		button.loadGraphic(loadHitboxGraphic(anim));
		button.setGraphicSize(Std.int(size), FlxG.height);
		button.updateHitbox();
		button.alpha = 0;

		var tween:FlxTween = null; // Silenciando aquele aviso chato da compilação.

		button.onDown.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(button, {alpha: 0.75}, 0.075, {ease: FlxEase.circInOut});
		};

		button.onUp.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(button, {alpha: 0}, 0.15, {ease: FlxEase.circInOut});
		}

		button.onOut.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.tween(button, {alpha: 0}, 0.15, {ease: FlxEase.circInOut});
		}

		return button;
	}

	override public function destroy():Void
	{
		super.destroy();
		buttonLeft = buttonDown = buttonSpace = buttonUp = buttonRight = null;
	}

    inline public static function loadHitboxGraphic(frame:String):FlxGraphic
		return FlxGraphic.fromFrame(Paths.getSparrowAtlas('hitboxExtra', 'mobilecontrols').getByName(frame));
}
#end