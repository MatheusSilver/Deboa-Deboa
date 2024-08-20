package ui;

// Eu sinto uma vontade grande de reescrever esse code dos controles por inteiro
// Isso aqui tá meio datado e já tá dando alguns problemas nessas engines mais novas por algum motivo que eu não sei qual...

#if mobileC
import ui.Mobilecontrols.FlxDPadMode;
import ui.Mobilecontrols.FlxActionMode;
import flash.display.BitmapData;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import openfl.utils.ByteArray;
import ui.FlxButton;
import Utils.Config;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

@:keep @:bitmap("assets/mobilecontrols/images/virtual-input.png")
class GraphicVirtualInput extends BitmapData {}

@:file("assets/mobilecontrols/images/virtual-input.txt")
class VirtualInputData extends #if (lime_legacy || nme) ByteArray #else ByteArrayData #end {}

class FlxVirtualPad extends FlxSpriteGroup
{	
	public var buttonA:FlxButton;
	public var buttonB:FlxButton;
	public var buttonC:FlxButton;
	public var buttonY:FlxButton;
	public var buttonX:FlxButton;
	public var buttonDodge:FlxButton;
	public var buttonLeft:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	public var buttonDown:FlxButton;

	public static var instance:FlxVirtualPad;

	public var dPad:FlxSpriteGroup;
	public var actions:FlxSpriteGroup;

	public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode)
	{
		super();
		instance = this;
		scrollFactor.set();

		if (DPad == null)
			DPad = FULL;
		if (Action == null)
			Action = A_B_C;

		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();

		switch (DPad)
		{
			case UP_DOWN:
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));
			case LEFT_RIGHT:
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "right")));
			case UP_LEFT_RIGHT:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "right")));
			case FULL:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "right")));
				dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));
			case RIGHT_FULL:
				dPad.add(add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(FlxG.width - 130 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, "right")));
				dPad.add(add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 45 * 3, "down")));
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
			case B:
				actions.add(add(buttonB = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
			case A_B:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
			case A_B_C:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				actions.add(add(buttonC = createButton(FlxG.width - (45 * 3), FlxG.height / 2 - 45 / 2, 44 * 3, 45 * 3, "c")));
			case A_B_X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 86 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, "y")));
				actions.add(add(buttonX = createButton(FlxG.width - 44 * 3, FlxG.height - 85 * 3, 44 * 3, 45 * 3, "x")));
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
			case D:
				actions.add(add(buttonDodge = createButton(FlxG.width - (45 * 3), FlxG.height / 2 - 45 / 2, 44 * 3, 45 * 3, "d")));
			case NONE: // do nothing
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		dPad = FlxDestroyUtil.destroy(dPad);
		actions = FlxDestroyUtil.destroy(actions);

		dPad = null;
		actions = null;
		buttonA = null;
		buttonB = null;
		buttonC = null;
		buttonY = null;
		buttonX = null;
		buttonLeft = null;
		buttonUp = null;
		buttonDown = null;
		buttonRight = null;
	}

	public function createButton(X:Float, Y:Float, Width:Int, Height:Int, Graphic:String, ?OnClick:Void->Void):FlxButton
	{
		var button = new FlxButton(X, Y);
		var frame = getVirtualInputFrames().getByName(Graphic);
		button.frames = FlxTileFrames.fromFrame(frame, FlxPoint.get(Width, Height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();

		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end

		if (OnClick != null)
			button.onDown.callback = OnClick;

		return button;
	}

	public static function getVirtualInputFrames():FlxAtlasFrames
	{
		#if !web
		var bitmapData = new GraphicVirtualInput(0, 0);
		#end

		#if !web
		var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmapData);
		return FlxAtlasFrames.fromSpriteSheetPacker(graphic, Std.string(new VirtualInputData()));
		#else
		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(Paths.image('virtual-input', 'mobilecontrols'));
		return FlxAtlasFrames.fromSpriteSheetPacker(graphic, Std.string(new VirtualInputData()));
		#end
	}
}

enum FlxDPadMode
{
	NONE;
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	RIGHT_FULL;
	FULL;
}

enum FlxActionMode
{
	NONE;
	A;
	B;
	A_B;
	A_B_C;
	A_B_X_Y;
	D;
}

class Modes extends FlxSpriteGroup
{
	public var mode:ControlsGroup = HITBOX;

	public var _hitbox:Hitbox;
	public var _hitbox2:Hitbox2;
	public var _virtualPad:FlxVirtualPad;

	public function new()
	{
		super();

		// load control mode num from Config.hx
		mode = getModeFromNumber(Config.getcontrolmode());
		trace(Config.getcontrolmode());

		switch (mode)
		{
			case VIRTUALPAD_RIGHT:
				initVirtualPad(0);
			case VIRTUALPAD_LEFT:
				initVirtualPad(1);
			case VIRTUALPAD_CUSTOM:
				initVirtualPad(2);
			case HITBOX:
				_hitbox = new Hitbox();
				add(_hitbox);
			case KEYBOARD:
		}
	}

	function initVirtualPad(vpadMode:Int)
	{
		switch (vpadMode)
		{
			case 1:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
			case 2:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
				_virtualPad = Config.loadcustom(_virtualPad);
			default: // 0
				_virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
		}

		_virtualPad.alpha = 0.75;
		add(_virtualPad);
	}

	public static function getModeFromNumber(modeNum:Int):ControlsGroup
	{
		return switch (modeNum)
		{
			case 0: VIRTUALPAD_RIGHT;
			case 1: VIRTUALPAD_LEFT;
			case 2: KEYBOARD;
			case 3: VIRTUALPAD_CUSTOM;
			case 4: HITBOX;

			default: VIRTUALPAD_RIGHT;
		}
	}
}

enum ControlsGroup
{
	VIRTUALPAD_RIGHT;
	VIRTUALPAD_LEFT;
	KEYBOARD;
	VIRTUALPAD_CUSTOM;
	HITBOX;
}

class Hitbox extends FlxSpriteGroup
{
	public var hitbox:FlxSpriteGroup;

	var sizex:Float = 320;

	var screensizey:Int = 720;

	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	public function new(?widghtScreen:Float)
	{
		super();

		if (widghtScreen == null)
			widghtScreen = FlxG.width;

		sizex = widghtScreen != null ? widghtScreen / 4 : 320;

		// add graphic
		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();

		var hitbox_hint:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('hitbox_hint', 'mobilecontrols'));

		hitbox_hint.alpha = 0.35;

		if (sizex != 320)
		{
			hitbox_hint.setGraphicSize(FlxG.width);
			hitbox_hint.updateHitbox();
		}

		add(hitbox_hint);

		hitbox.add(add(buttonLeft = createhitbox(0, "left")));

		hitbox.add(add(buttonDown = createhitbox(sizex, "down")));

		hitbox.add(add(buttonUp = createhitbox(sizex * 2, "up")));

		hitbox.add(add(buttonRight = createhitbox(sizex * 3, "right")));
	}

	public function createhitbox(X:Float, framestring:String)
	{
		var button = new FlxButton(X, 0);
		// Eu posso estar sendo louco, mas, eu já usei o getSparrowAtlas nessa parte em outro mod e deu problema
		// Não tenho certeza, mas de qualquer jeito tá aí
		var frames = FlxAtlasFrames.fromSparrow('assets/mobilecontrols/images/hitbox/hitbox.png', 'assets/mobilecontrols/images/hitbox/hitbox.xml');

		var graphic:FlxGraphic = FlxGraphic.fromFrame(frames.getByName(framestring));

		button.loadGraphic(graphic);

		/*button.width = sizex;
			button.height = FlxG.height; */
		button.setGraphicSize(Std.int(sizex), FlxG.height);
		button.updateHitbox();

		button.alpha = 0;

		var tween:FlxTween = null;
		// Silenciando aquele aviso chato da compilação.

		button.onDown.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.num(button.alpha, 0.75, .075, {ease: FlxEase.circInOut}, function(a:Float)
			{
				button.alpha = a;
			});
		};

		button.onUp.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.num(button.alpha, 0, .15, {ease: FlxEase.circInOut}, function(a:Float)
			{
				button.alpha = a;
			});
		}

		button.onOut.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.num(button.alpha, 0, .15, {ease: FlxEase.circInOut}, function(a:Float)
			{
				button.alpha = a;
			});
		}

		return button;
	}

	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
	}
}

class Hitbox2 extends FlxSpriteGroup
{
	public var hitbox:FlxSpriteGroup;

	var sizex:Float = 256;

	var screensizey:Int = 720;

	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonSpace:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	public function new(?widghtScreen:Float)
	{
		super();

		if (widghtScreen == null)
			widghtScreen = FlxG.width;

		sizex = widghtScreen != null ? widghtScreen / 5 : 320;

		// add graphic
		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();

		var hitbox_hint:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('hitboxExtra_hint', 'mobilecontrols'));

		hitbox_hint.alpha = 0.35;

		if (sizex != 320)
		{
			hitbox_hint.setGraphicSize(FlxG.width);
			hitbox_hint.updateHitbox();
		}

		add(hitbox_hint);

		hitbox.add(add(buttonLeft = createhitbox(0, "left")));

		hitbox.add(add(buttonDown = createhitbox(sizex, "down")));

		hitbox.add(add(buttonSpace = createhitbox(sizex, "space")));

		hitbox.add(add(buttonUp = createhitbox(sizex * 2, "up")));

		hitbox.add(add(buttonRight = createhitbox(sizex * 3, "right")));
	}

	public function createhitbox(X:Float, framestring:String)
	{
		var button = new FlxButton(X, 0);
		var frames = FlxAtlasFrames.fromSparrow('assets/mobilecontrols/images/hitbox/hitboxExtra.png', 'assets/mobilecontrols/images/hitbox/hitboxExtra.xml');

		var graphic:FlxGraphic = FlxGraphic.fromFrame(frames.getByName(framestring));

		button.loadGraphic(graphic);

		/*button.width = sizex;
			button.height = FlxG.height; */
		button.setGraphicSize(Std.int(sizex), FlxG.height);
		button.updateHitbox();

		button.alpha = 0;

		var tween:FlxTween = null;
		// Silenciando aquele aviso chato da compilação.

		button.onDown.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.num(button.alpha, 0.75, .075, {ease: FlxEase.circInOut}, function(a:Float)
			{
				button.alpha = a;
			});
		};

		button.onUp.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.num(button.alpha, 0, .15, {ease: FlxEase.circInOut}, function(a:Float)
			{
				button.alpha = a;
			});
		}

		button.onOut.callback = function()
		{
			if (tween != null)
				tween.cancel();
			tween = FlxTween.num(button.alpha, 0, .15, {ease: FlxEase.circInOut}, function(a:Float)
			{
				button.alpha = a;
			});
		}

		return button;
	}

	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonSpace = null;
		buttonUp = null;
		buttonRight = null;
	}
}
#end