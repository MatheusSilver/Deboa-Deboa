package modifiers;

import cpp.abi.Abi;
import flixel.ui.FlxSpriteButton;
import ui.FlxButton;
import flixel.FlxSubState;
#if rpc
import Discord.DiscordClient;
#end
import modifiers.ModifiersManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.FlxCamera;
import openfl.utils.Assets as OpenFlAssets;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;


using StringTools;

class ModifiersMenuState extends MusicBeatSubstate
{

    public var buttons:Array<ModifierButton> = [];
    var currentButton:ModifierButton;

    var bg:FlxSprite;
    var faixa:FlxSprite;
    public var text:FlxText;
    public var textMultiplier:FlxText;
    var textBG:FlxSprite;

    var pontosMulti:Float = 1.00;
    var pontosMultiLerp:Float = 1.00;

    var faixaY:Float;

    var canClick:Bool = false;

    var isFreeplay:Bool = false;

	public function new(isFreeplay:Bool)
	{
		super();
        this.isFreeplay = isFreeplay;
        
        Main.mouse_allowed = true;
        #if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_modifiers", "rpc"), null);
		#end

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("modifiers/bg"));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        //bg = new FlxSprite(0,0).makeGraphic(1,1, FlxColor.BLACK);
        //bg.setGraphicSize(FlxG.stage.width, FlxG.stage.height);
        bg.screenCenter(XY);
        bg.alpha = 0;
        add(bg);

        faixa = new FlxSprite(0,0).loadGraphic(Paths.image("modifiers/faixa"));
        faixa.antialiasing = ClientPrefs.globalAntialiasing;
        faixa.screenCenter(XY);
        faixa.y-=25;
        faixaY = faixa.y;
        faixa.alpha = 0;
        faixa.y = 720;
        add(faixa);

        textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
        textBG.alpha=0;
		add(textBG);

		text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "", 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();

        textMultiplier = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "X1.00", 18);
        textMultiplier.alpha = 0;
		textMultiplier.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT);
		textMultiplier.scrollFactor.set();

        var x1:Float = 30;
        var y1:Float = 334-25;
        var delay:Float = 0;
        var delayNegativo:Float = 0.765;
        for(i in 0...ModifiersManager.allModifiers.length)
        {
            if(i==9){
                y1=476-25;
                x1 = 30;
            }
            var properties:Modifier = ModifiersManager.getAllProperties(i);
            var modifierButton:ModifierButton = new ModifierButton(i, properties.id, properties.name, ModifiersManager.isEnabled(i), x1, y1, properties.description, properties.multiplier, delay, delayNegativo);
            add(modifierButton);
            buttons.push(modifierButton);
            delay+=0.045;
            delayNegativo-=0.045;
            y1-=24;
            x1+=135;
        }
        trace(delay);
        
        add(text);
        add(textMultiplier);
        calculateMultiplier();
        pontosMultiLerp = pontosMulti;
        tweenCoisos();
	}

    function tweenCoisos()
    {
        FlxTween.tween(bg, {alpha: 1}, 0.2, {ease: FlxEase.expoInOut});
        FlxTween.tween(textBG, {alpha: 1}, 0.3, {ease: FlxEase.expoInOut});
        FlxTween.tween(textMultiplier, {alpha: 1}, 0.25, {ease: FlxEase.expoInOut});
        FlxTween.tween(faixa, {y: faixaY, alpha:1}, 0.25, {ease: FlxEase.expoInOut,
            onComplete: function(twn:FlxTween) {
                for (button in buttons)
                {
                    button.tweenBotao();
                }
            }
        });
        new FlxTimer().start(1.25, function(tmr:FlxTimer) {
            canClick = true;
		});
    }

    function tweenSair()
    {
		canClick = false;
        for (button in buttons)
            {
                button.tweenBotaoSair();
            }
        FlxTween.tween(textMultiplier, {alpha: 0}, 0.25, {ease: FlxEase.expoInOut});
        FlxTween.tween(text, {alpha: 0}, 0.25, {ease: FlxEase.expoInOut});
        FlxTween.tween(textBG, {alpha: 0}, 0.3, {ease: FlxEase.expoInOut});
        FlxTween.tween(faixa, {y: 720, alpha:0}, 1, {ease: FlxEase.expoInOut, startDelay: 0.4});
        FlxTween.tween(bg, {alpha: 0}, 1.25, {ease: FlxEase.expoInOut});
        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
            if(isFreeplay)
            {
                FreeplayState.instance.closeModifiers(this);
            }
            else
            {
                MenuHistoria.instance.closeModifiers(this);
            }
		});
    }

    override function close()
    {
        Main.mouse_allowed = false;
        super.close();
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
        currentButton = null;
        for (button in buttons)
            {
                if (Utils.BSLTouchUtils.over(button) && canClick)
                {
                    currentButton = button;
                    break;
                }
            }
        if(currentButton != null && canClick)
        {
            if(!text.text.startsWith(currentButton.name.toUpperCase()))
            {
                GlobalSoundManager.play('scrollMenu');
            }
        }
        text.text = currentButton != null ?currentButton.name.toUpperCase() + ": " + currentButton.desc : ""; // só pa fica bunitu
        pontosMultiLerp = FlxMath.lerp(pontosMultiLerp, pontosMulti, CoolUtil.boundTo(elapsed * 24, 0, 2));
        if (Math.abs(pontosMultiLerp - pontosMulti) <= 0.001)
			pontosMultiLerp = pontosMulti;
        textMultiplier.text = "X"+Std.string(Math.round(pontosMultiLerp*100)/100);
        if(Utils.BSLTouchUtils.justTouched() && currentButton != null && canClick)
            {
                currentButton.clique();
                for (button in buttons)
                {
                    button.verifyStuff();
                }
                calculateMultiplier();
            }

		if (controls.BACK && canClick)
		{
			GlobalSoundManager.play('cancelMenu');
            tweenSair();
		}
	}

    function calculateMultiplier()
    {
        pontosMulti = ModifiersManager.getFinalModifier();
    }

}

class ModifierButton extends FlxSpriteGroup
{
    public var id:Int;
    public var nameID:String;
    public var name:String;
    public var enabled:Bool;
    public var desc:String;
    public var multiplier:Float;
    public var botao:FlxSprite;
    var outline:FlxSprite;
    var x1:Float;
    var y1:Float;
    var delayPositivo:Float;
    var delayNegativo:Float;

    public function new(id:Int, nameID:String, name:String, enabled:Bool, x1:Float, y1:Float, desc:String, multiplier:Float, delay:Float, delayNegativo:Float)
    {
        super(0,0);
        this.alpha = 0;
        this.x1 = x1;
        this.y1 = y1;
        this.id = id;
        this.name = name;
        this.nameID = nameID;
        this.enabled = enabled;
        this.desc=desc;
        this.multiplier = multiplier;
        this.delayPositivo = delay;
        this.delayNegativo = delayNegativo;
        botao = new FlxSprite(0,0);
        botao.antialiasing = ClientPrefs.globalAntialiasing;
        if(OpenFlAssets.exists(Paths.imagechecker("modifiers/botoes/" + nameID))){
            botao.loadGraphic(Paths.image("modifiers/botoes/"+nameID));
        }else{
            botao.loadGraphic(Paths.image("modifiers/botoes/placeholder"));
        }
        botao.setGraphicSize(Std.int(botao.width *1.05));
        botao.updateHitbox();
        add(botao);
        outline = new FlxSprite(0,0);
        outline.antialiasing = ClientPrefs.globalAntialiasing;
        if(this.enabled){
        outline.loadGraphic(Paths.image("modifiers/on"));
        } else {
        outline.loadGraphic(Paths.image("modifiers/off"));
        }
        outline.setGraphicSize(Std.int(outline.width *1.05));
        outline.updateHitbox();
        add(outline);
    }


    public function tweenBotao()
    {
        FlxTween.tween(this, {y: y1, x: x1, alpha: 1}, 0.3, {ease: FlxEase.expoInOut, startDelay: delayPositivo});
    }

    public function tweenBotaoSair()
    {
        FlxTween.tween(this, {y: 0, x: 0, alpha: 0}, 0.035, {ease: FlxEase.expoInOut, startDelay: delayNegativo});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        
    }

    public function clique()
    {
		GlobalSoundManager.play('confirmMenu');
        if(enabled)
        {
            ModifiersManager.removeModifier(id);
        }
        else
        {
            ModifiersManager.setModifier(id);
        }
        verifyStuff();
    }

    public function verifyStuff()
    {
        enabled = ModifiersManager.isEnabled(id);
        if(enabled){
            outline.loadGraphic(Paths.image("modifiers/on"));
            } else {
            outline.loadGraphic(Paths.image("modifiers/off"));
        }
    }
}
