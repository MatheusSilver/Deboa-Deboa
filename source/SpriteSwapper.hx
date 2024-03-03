package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxAxes;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;

class SpriteSwapper extends FlxSprite{
    public var target:Int;
    private var tweenController:FlxTween;
    public var tweenTimer:Float=0.5;
    private var activeAxis:FlxAxes;
    private final num_objects:Int;
    
    public function new (target:Int, sprite:FlxGraphic, objects_on_screen:Int=1, space_between:Int=1, swipe_axis:FlxAxes=X)
    {
        this.num_objects=objects_on_screen-1;
        if (num_objects < 2)
            num_objects = 2; //nope, isso não nescessariamente representa o numero de objetos na tela
                             //Ou representa se você contar o ZERO

        this.activeAxis = swipe_axis;

        this.loadGraphic(sprite);
        this.visible = target <= 2;
        this.ID = target;
        if (activeAxis==X){
            this.setGraphicSize(Std.int(FlxG.width/num_objects-space_between/2));
            super(((FlxG.width/num_objects)*target-this.width)/2,0);
            this.screenCenter(Y);
        }else if (activeAxis==Y){
            this.setGraphicSize(Std.int(FlxG.height/num_objects-space_between/2));
            super(0,((FlxG.height/num_objects*target)-this.height)/2);
            this.screenCenter(X);
        }     
    }
    public function updateTarget():Void{
        if (tweenController != null)
            tweenController.cancel();

        if (activeAxis == X){
            this.target = Math.round((this.x+FlxG.width/2)*num_objects/FlxG.width);
            tweenController = FlxTween.tween(this.x, ((FlxG.width/num_objects)*target-this.width)/2, tweenTimer, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                tweenController = null;
            }});
        }else if (activeAxis == Y){
            this.target = Math.round((this.y+FlxG.height/2)*num_objects/FlxG.height);
            tweenController = FlxTween.tween(this.x, ((FlxG.width/num_objects)*target-this.width)/2, tweenTimer, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                tweenController = null;
            }});
        }
    }
    public function checkVisibility():Void{
        if (this.activeAxis == X && this.x > -this.width && this.x < FlxG.width + this.width)
            this.visible = true;
        else if (this.activeAxis == Y && this.y > -this.height && this.y < FlxG.height +this.height)
            this.visible = true;
        else
            this.visible = false;
    }
}