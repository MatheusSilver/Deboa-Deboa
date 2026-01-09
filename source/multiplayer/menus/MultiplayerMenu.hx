package multiplayer.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
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
    
    public function close(nextMenu:MultiplayerMenu) {
        MultiplayerMainMenuState.instance.isTransitioning = true;
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
        var objectosAResetar:Array<Dynamic> = [];

        for(tween in tweenList) {
			if (tween._object == null) continue;

            if (otherMenu != null) {
                var irmao: Dynamic = findObjectInMap(findObjectNameInMap(tween._object), otherMenu);
                if (irmao != null) {
                    objectosAResetar.push([tween._object, {x: tween._object.x, y:tween._object.y, height: tween._object.height, width: tween._object.width}]);

                    var newTween:VarTween = FlxTween.tween(tween._object, irmao, semEsperar ? 0 : transitionSpeed, {ease: FlxEase.sineInOut}, false);
                    newTween.start();
                    continue;
                }
            }

            tween.clone().start();
		}

        new FlxTimer().start(transitionSpeed, function(tmr:FlxTimer)
		{
            for(objecto in objectosAResetar) {
                var resetTween:VarTween = FlxTween.tween(objecto[0], objecto[1], 0, {ease: FlxEase.linear}, false);
                resetTween.start();
            }

            if (callback == null) return;
            callback();
		});
    }

    function findObjectNameInMap(instance:FlxObject):String {
        for (key => objecto in objectPool) {
            if (objecto[1] == instance) {
                return key;
            }
        }

        return null;
    }

    function findObjectInMap(key:String, otherState:MultiplayerMenu):Dynamic {
        var coiso:Dynamic = otherState.objectPool.get(key);
        if (coiso == null) return null;

        return coiso[0];
    }

    public function amActive():Bool {
        return MultiplayerMainMenuState.instance.curSubmenu == this && !MultiplayerMainMenuState.instance.isTransitioning && MultiplayerMainMenuState.instance.canClick;
    }

	public function addToMenu(basico:FlxObject, entrada:Dynamic, saida:Dynamic, ?reference:String) {
        add(basico);
        tweensSaida.push(FlxTween.tween(basico, saida, transitionSpeed, {ease: FlxEase.sineInOut}, false));
        tweensEntrada.push(FlxTween.tween(basico, entrada, transitionSpeed, {ease: FlxEase.sineInOut}, false));

        // deixa pra la
        //if (reference == null || reference == "") return;
        //objectPool.set(reference, [{x: basico.x, y: basico.y, width: basico.width, height: basico.height}, basico.toString()]);
    }
}