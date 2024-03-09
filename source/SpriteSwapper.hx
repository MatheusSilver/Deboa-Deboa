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
    private var spaceBetween:Int;
    public var tweenTimer:Float=0.5;
    private var activeAxis:FlxAxes;
    private final num_objects:Int;
    
    public function new (target:Int, sprite:FlxGraphic, objects_on_screen:Int=1, space_between:Int=1, swipe_axis:FlxAxes=X, size_mult:Float=1)
    {
        this.num_objects=objects_on_screen-1;
        if (num_objects < 1)
            num_objects = 1; //nope, isso não nescessariamente representa o numero de objetos na tela
                             //Ou representa se você contar o ZERO
        
        super(0,0);
        this.spaceBetween=space_between;
        this.activeAxis = swipe_axis;

        this.loadGraphic(sprite);
        this.visible = target <= 2;
        this.ID = target;
        if (activeAxis==X){
            this.setGraphicSize(Std.int(FlxG.width/num_objects*size_mult));
            this.setPosition(((FlxG.width/num_objects)*target-this.width)/2+target*space_between,0);
            this.screenCenter(Y);
        }else if (activeAxis==Y){
            this.setGraphicSize(Std.int(FlxG.height/num_objects*size_mult));
            this.setPosition(0,(FlxG.height/num_objects*target-this.height)/2+target*space_between);
            this.screenCenter(X);
        }     
    }
    public function updateTarget():Void{
        if (tweenController != null)
            tweenController.cancel();

        if (activeAxis == X){
            this.target = Math.round((this.x+FlxG.width/2)*num_objects/FlxG.width);
            tweenController = FlxTween.tween(this.x, ((FlxG.width/num_objects)*target-this.width)/2+target*this.spaceBetween, tweenTimer, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                tweenController = null;
            }});
        }else if (activeAxis == Y){
            this.target = Math.round((this.y+FlxG.height/2)*num_objects/FlxG.height);
            tweenController = FlxTween.tween(this.x, (FlxG.height/num_objects*target-this.height)/2+target*this.spaceBetween, tweenTimer, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                tweenController = null;
            }});
        }
    }

    public function setTarget(target):Void{
        this.target = target; //usa isso pra trocar fazer o scroll 
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