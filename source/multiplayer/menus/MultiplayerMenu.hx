package multiplayer.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxStringUtil;
import flixel.FlxObject;

using StringTools;

enum TransitionTweenType {
	OPEN;
    CLOSE;
}

class MultiplayerMenu extends FlxTypedGroup<FlxBasic> 
{
    public var objectPool:Map<String, Dynamic> = [];

    var tweensEntrada:Array<VarTween> = [];
    var tweensSaida:Array<VarTween> = [];
    
    var transitionSpeed:Float = 0.25;

    public var buttons:Map<Int, Dynamic> = [];
    public var lastBtSelected:Int = -1;
    
    public function close(nextMenu:MultiplayerMenu, ?makeTween:Bool = true) {
        MultiplayerMainMenuState.instance.isTransitioning = true;
        if (!makeTween) return;
        
        playTweens(tweensSaida, nextMenu, function(){
            MultiplayerMainMenuState.instance.isTransitioning = false;
            this.visible = false;
        });
    }

    public function open(oldMenu:MultiplayerMenu) {
        this.visible = true;
        MultiplayerMainMenuState.instance.isTransitioning = true;
        playTweens(tweensEntrada, oldMenu, function() {
            MultiplayerMainMenuState.instance.isTransitioning = false;
            MultiplayerMainMenuState.instance.HandleKeyboardMode(true);
        });
    }

    public function preload(isFirst:Bool) {
		MultiplayerMainMenuState.instance.add(this);
        if (!isFirst) {
            playTweens(tweensSaida, null, null, true);
        }
        this.visible = false;
    }

    function playTweens(tweenList:Array<VarTween>, otherMenu:MultiplayerMenu, ?callback:()->Void = null, ?semEsperar:Bool = false) {

        for(tween in tweenList) {
			if (tween._object == null) continue;
            tween.clone().start();
		}

        new FlxTimer().start(transitionSpeed, function(tmr:FlxTimer)
		{

            if (callback == null) return;
            callback();
		});
    }

    public function amActive():Bool {
        return MultiplayerMainMenuState.instance.curSubmenu == this && !MultiplayerMainMenuState.instance.isTransitioning && MultiplayerMainMenuState.instance.canClick;
    }

    public function addButton(bt:Dynamic, index:Int) {
        if (buttons.get(index) != null) return;

        buttons.set(index, bt);
    }

    public function resetButton() {
        buttons.clear();
    }

	public function addToMenu(basico:FlxObject, entrada:Dynamic, saida:Dynamic, ?reference:String) {
        add(basico);
        addTween(basico, entrada, saida, reference);
    }

    public function addTween(basico:FlxObject, entrada:Dynamic, saida:Dynamic, ?reference:String) {
        tweensSaida.push(FlxTween.tween(basico, saida, transitionSpeed, {ease: FlxEase.sineInOut}, false));
        tweensEntrada.push(FlxTween.tween(basico, entrada, transitionSpeed, {ease: FlxEase.sineInOut}, false));
    }
}