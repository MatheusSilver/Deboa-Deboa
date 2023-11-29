package modifiers;

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



using StringTools;

class ModifiersMenuState extends MusicBeatState
{

    public var buttons:Array<ModifierButton> = [];
    var currentButton:ModifierButton;
    var mouseTxt:FlxText;
    var mouseDesc:FlxText;

    var bg:FlxSprite;
    var faixa:FlxSprite;
    public var text:FlxText;
    public var textMultiplier:FlxText;
    /*public var setal:FlxText; //esquerda
    public var setar:FlxText; //direita*/

    var pontosMulti:Float = 1.00;
    var pontosMultiLerp:Float = 1.00;

	override function create()
	{
		#if rpc
		DiscordClient.changePresence("No menu de modifiers", null);
		#end
        
        mouseTxt = new FlxText(0, 0, 200, "", 8, true);
        mouseTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
        mouseDesc = new FlxText(0, 0, 200, "", 8, true);
        mouseDesc.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.GRAY, CENTER);

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("modifiers/bg"));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.screenCenter(XY);
        add(bg);

        faixa = new FlxSprite(0,0).loadGraphic(Paths.image("modifiers/faixa"));
        faixa.antialiasing = ClientPrefs.globalAntialiasing;
        faixa.screenCenter(XY);
        faixa.y-=25;
        add(faixa);

        var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		add(textBG);

		text = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "", 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();

        textMultiplier = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "X1.00", 18);
		textMultiplier.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT);
		textMultiplier.scrollFactor.set();

        /*setal = new FlxText(26, 0, "<", 18);
        setal.screenCenter(Y);
        setal.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT);

        setar = new FlxText(1242, 0, ">", 18);
        setal.screenCenter(Y);
        setal.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT);*/


        var x1:Float = 30;
        var y1:Float = 334-25;
        for(i in 0...ModifiersManager.allModifiers.length)
        {
            if(i==9){
                y1=476-25;
                x1 = 30;
            }
            var properties:Modifier = ModifiersManager.getAllProperties(i);
            var modifierButton:ModifierButton = new ModifierButton(i, properties.name, ModifiersManager.isEnabled(i), x1, y1, properties.description, properties.multiplier);
            add(modifierButton);
            buttons.push(modifierButton);

            y1-=24;
            x1+=135;
        }
        
        add(text);
        add(textMultiplier);
        /*add(setal);
        add(setar);*/
        calculateMultiplier();
        pontosMultiLerp = pontosMulti;
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
        currentButton = null;
        for (button in buttons)
            {
                if (FlxG.mouse.overlaps(button))
                {
                    currentButton = button;
                    break;
                }
            }

        text.text = currentButton != null ?currentButton.name.toUpperCase() + ": " + currentButton.desc : ""; // só pa fica bunitu
        pontosMultiLerp = FlxMath.lerp(pontosMultiLerp, pontosMulti, CoolUtil.boundTo(elapsed * 24, 0, 2));
        if (Math.abs(pontosMultiLerp - pontosMulti) <= 0.001)
			pontosMultiLerp = pontosMulti;
        textMultiplier.text = "X"+Std.string(Math.round(pontosMultiLerp*100)/100);
        if(FlxG.mouse.justPressed && currentButton != null)
            {
                currentButton.clique();
                for (button in buttons)
                {
                    button.verifyStuff();
                }
                calculateMultiplier();
            }



        #if android
        if(Utils.BSLTouchUtils.apertasimples(setal)) {
            //
        }
        if(Utils.BSLTouchUtils.apertasimples(setar)) {
            //
        }
        #else
        if(controls.UI_LEFT_P) {
            //
        }
        if(controls.UI_RIGHT_P) {
            //
        }
        #end
		if (controls.BACK)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new MainMenuStateMobile());
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
    public var name:String;
    public var enabled:Bool;
    public var desc:String;
    public var multiplier:Float;
    public var botao:FlxSprite;
    var outline:FlxSprite;

    public function new(id:Int, name:String, enabled:Bool, x1:Float, y1:Float, desc:String, multiplier:Float)
    {
        super(x1, y1);

        this.id = id;
        this.name = name;
        this.enabled = enabled;
        this.desc=desc;
        this.multiplier = multiplier;
        botao = new FlxSprite(0,0);
        botao.antialiasing = ClientPrefs.globalAntialiasing;
        if (OpenFlAssets.exists(Paths.imagechecker("modifiers/botoes/" + ModifiersManager.removerAcentos(this.name))))
        {
            botao.loadGraphic(Paths.image("modifiers/botoes/" + ModifiersManager.removerAcentos(this.name)));
        }
        else
        {
            botao.loadGraphic(Paths.image("modifiers/botoes/placeholder"));
        }
        botao.setGraphicSize(Std.int(botao.width *1.05));
        //botao.screenCenter(Y);
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
        //outline.screenCenter(Y);
        outline.updateHitbox();
        add(outline);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        
    }

    public function clique()
    {
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
