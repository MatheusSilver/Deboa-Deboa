package multiplayer.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxStringUtil;

using StringTools;

enum TransitionTweenType {
	OPEN;
    CLOSE;
}

class MultiplayerMenu extends FlxTypedGroup<FlxBasic> 
{
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
        for(tween in tweenList) {
			if (tween._object == null) continue;

            if (otherMenu != null) {
                var irmao: Dynamic = findPropertyInOtherState(tween._object, otherMenu);
                if (irmao != null) {
                    var newTween:VarTween = FlxTween.tween(tween._object, {x: irmao.x, y:irmao.y, "scale.x": irmao.scale.x, "scale.y": irmao.scale.y}, semEsperar ? 0 : transitionSpeed, {ease: FlxEase.sineInOut}, false);
                    newTween.start();
                    continue;
                }
            }

            tween.clone().start();
		}

        new FlxTimer().start(transitionSpeed, function(tmr:FlxTimer)
		{
            if (callback == null) return;
            callback();
		});
    }

    function findPropertyInOtherState(reference:String, otherState:Dynamic): Dynamic {
        var achado:Dynamic = Reflect.getProperty(otherState, reference.toString());

        if (achado == null) return null;
        if (!compareClass(achado, reference)) return null;

        return achado;
    }

    function getClassName(object: Dynamic): String {
        return FlxStringUtil.getClassName(object, true);
    }

    // eu sei que dava pra fazer de um jeito MTOOO melhor isso daqui pra n ser limitado a quantidade de comparações, mas assim ja serve.
    function compareClass(object1:Dynamic, object2:Dynamic) : Bool {
        var className1:String = getClassName(object1);
        var className2:String = getClassName(object2);

        return className1 == className2;
    }

    public function amActive():Bool {
        return MultiplayerMainMenuState.instance.curSubmenu == this && !MultiplayerMainMenuState.instance.isTransitioning && MultiplayerMainMenuState.instance.canClick;
    }

	public function addToMenu(basico:FlxBasic, entrada:Dynamic, saida:Dynamic) {
        add(basico);
        tweensSaida.push(FlxTween.tween(basico, saida, transitionSpeed, {ease: FlxEase.sineInOut}, false));
        tweensEntrada.push(FlxTween.tween(basico, entrada, transitionSpeed, {ease: FlxEase.sineInOut}, false));
    }
}