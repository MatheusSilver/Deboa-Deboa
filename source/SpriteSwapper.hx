package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxAxes;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;

class SpriteSwapper extends FlxSprite{
    public var target:Int;
    public var tweenController:FlxTween;
    private var spaceBetween:Int;
    public var tweenTimer:Float=0.5;
    private var activeAxis:FlxAxes;
    private final num_objects:Int;
    private final objectsList:Int;
    public var specialOffset:Float = 0;
    
    public function new (target:Int, sprite:FlxGraphic, objects_on_screen:Int=1, space_between:Int=1, swipe_axis:FlxAxes=X, size_mult:Float=1,objects_in_list=1)
    {
        this.num_objects=objects_on_screen-1;
        this.objectsList=objects_in_list;
        if (num_objects < 1)
            num_objects = 1; //nope, isso não nescessariamente representa o numero de objetos na tela
                             //Ou representa se você contar o ZERO
        
        super(0,0);
        this.spaceBetween=space_between;
        this.activeAxis = swipe_axis;

        this.loadGraphic(sprite);
        this.setTarget(target);
        if (activeAxis==X){
            this.setGraphicSize(Std.int(FlxG.width/num_objects*size_mult));
            this.setPosition(((FlxG.width/this.num_objects)*this.target-this.width)/2+this.target*this.spaceBetween,0);
            this.screenCenter(Y);
        }else if (activeAxis==Y){
            this.setGraphicSize(Std.int(FlxG.height/num_objects*size_mult));
            this.setPosition(0,(FlxG.height/this.num_objects*this.target-this.height)/2+this.target*this.spaceBetween);
            this.screenCenter(X);
        }     
    }
    public function checkTween():Void{
        if (tweenController != null)
            tweenController.cancel();
    }
    public function updateTarget(manual:Bool = false):Void{
        this.checkTween();

        if (activeAxis == X){
            if (!manual)
                this.setTarget(Math.round((2*this.x+this.width)/((FlxG.width/num_objects)+2*this.spaceBetween)));

            tweenController = FlxTween.tween(this, {x:(FlxG.width/num_objects*target-this.width)/2+target*this.spaceBetween+specialOffset}, tweenTimer, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                tweenController = null;
            }});
        }else if (activeAxis == Y){
            if (!manual)
                this.setTarget(Math.round((2*this.y+this.height)/((FlxG.height/num_objects)+2*this.spaceBetween)));
            tweenController = FlxTween.tween(this, {y:(FlxG.height/num_objects*target-this.height)/2+target*this.spaceBetween+specialOffset}, tweenTimer, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                tweenController = null;
            }});
        }
    }

    public inline function getTarget():Int{return this.target;}

    public function setTarget(target):Void{
        this.target = target; //usa isso pra trocar fazer o scroll 
        this.visible = Math.abs(this.target) <= 4;
        if (this.target <= -5){
            this.target += this.objectsList;
        }else if(this.target > this.objectsList-5){
            this.target-= this.objectsList;
        }
    }
}