package mobile.ui;

#if mobileC
import flixel.group.FlxSpriteGroup;
import ui.FlxButton;

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

	private var buttonsCoords:Array<Int> = []; // Adaptei isso pra ser dependente da resolução.
	public function new()
	{
		super();

        var size:Int = FlxG.width != null ? FlxG.width / 5 : 320;
        buttonsCoords = [0, size, size, size * 2, size * 3];
        
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
		return FlxGraphic.fromFrame(getSparrowAtlas('hitboxExtra', 'mobilecontrols').getByName(frame));
}
#end