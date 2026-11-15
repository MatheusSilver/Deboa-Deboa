package ui;

import Input.Controls;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import Input.PlayerSettings;
import flixel.FlxCamera;

class FakeMouse extends FlxSprite {
    public var baseSpeed:Float;
    public var _acceleration:Float;
    public var maxSpeed:Float;
    public var speedX:Float = 0;
    public var speedY:Float = 0;
    public var enabled:Bool = false;

    public static var instance:FakeMouse;

    public function new(center:Bool = true, BaseSpeed:Float = 700, Acceleration:Float = 300, MaxSpeed:Float = 1300) {
        super(center ? (FlxG.width / 2) - 10 : 0, center ? (FlxG.height / 2) - 10 : 0);
        loadGraphic(Paths.image('input/fakePointer', 'preload'));
        updateHitbox();
        baseSpeed = BaseSpeed;
        _acceleration = Acceleration;
        maxSpeed = MaxSpeed;
        instance = this;
    }

    private var UPDATE_INTERVAL:Float = 1.0 / 60.0;
    private var timeAccumulated:Float = 0.0;

    private function shouldUpdate():Bool {
        return timeAccumulated >= UPDATE_INTERVAL;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        timeAccumulated += elapsed;

        this.visible = enabled;
        enabled = !Main.getMouseVisibility();

        while (shouldUpdate()) {
            if (controls.UI_LEFT) {
                speedX -= _acceleration * UPDATE_INTERVAL;
                if (speedX < -maxSpeed) speedX = -maxSpeed;
            } else if (controls.UI_RIGHT) {
                speedX += _acceleration * UPDATE_INTERVAL;
                if (speedX > maxSpeed) speedX = maxSpeed;
            } else {
                if (speedX > 0) {
                    speedX -= baseSpeed * UPDATE_INTERVAL;
                    if (speedX < 0) speedX = 0;
                } else if (speedX < 0) {
                    speedX += baseSpeed * UPDATE_INTERVAL;
                    if (speedX > 0) speedX = 0;
                }
            }

            if (controls.UI_UP) {
                speedY -= _acceleration * UPDATE_INTERVAL;
                if (speedY < -maxSpeed) speedY = -maxSpeed;
            } else if (controls.UI_DOWN) {
                speedY += _acceleration * UPDATE_INTERVAL;
                if (speedY > maxSpeed) speedY = maxSpeed;
            } else {
                if (speedY > 0) {
                    speedY -= baseSpeed * UPDATE_INTERVAL;
                    if (speedY < 0) speedY = 0;
                } else if (speedY < 0) {
                    speedY += baseSpeed * UPDATE_INTERVAL;
                    if (speedY > 0) speedY = 0;
                }
            }

            x += speedX * UPDATE_INTERVAL;
            y += speedY * UPDATE_INTERVAL;

            timeAccumulated -= UPDATE_INTERVAL;
        }

        if (x < 0) x = 0;
        if (x > FlxG.width - width) x = FlxG.width - width;
        if (y < 0) y = 0;
        if (y > FlxG.height - height) y = FlxG.height - height;
    }

    public var controls(get, never):Input.Controls;

    inline function get_controls():Input.Controls {
        return PlayerSettings.player1.controls;
    }
}