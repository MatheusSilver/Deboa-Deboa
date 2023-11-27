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


using StringTools;

class ModifiersMenuState extends MusicBeatState
{

    public var buttons:Array<ModifierButton> = [];
    var currentButton:ModifierButton;
    var mouseTxt:FlxText;
    var mouseDesc:FlxText;

    var bg:FlxSprite;
    var faixa:FlxSprite;

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
        bg.screenCenter(XY);
        add(bg);

        faixa = new FlxSprite(0,0).loadGraphic(Paths.image("modifiers/faixa"));
        faixa.screenCenter(XY);
        add(faixa);

        var x1:Int = 0;
        for(i in 0...ModifiersManager.allModifiers.length)
        {
            var properties:Modifier = ModifiersManager.getAllProperties(i);
            var modifierButton:ModifierButton = new ModifierButton(i, properties.name, ModifiersManager.isEnabled(i), x1, properties.description);
            add(modifierButton);
            buttons.push(modifierButton);
            x1+=128;
        }

        add(mouseTxt);
        add(mouseDesc);

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
        mouseTxt.text = currentButton != null ? currentButton.name : "";
        mouseTxt.x=FlxG.mouse.x - 60;
        mouseTxt.y = FlxG.mouse.y + 40;
        mouseDesc.text = currentButton != null ? currentButton.desc : "";
        mouseDesc.x=FlxG.mouse.x - 60;
        mouseDesc.y = FlxG.mouse.y + 80;
        if(FlxG.mouse.justPressed && currentButton != null)
            {
                currentButton.clique();
                for (button in buttons)
                {
                    button.verifyStuff();
                }
            }
		if (controls.BACK)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
	}

}

class ModifierButton extends FlxSpriteGroup
{
    public var id:Int;
    public var name:String;
    public var enabled:Bool;
    public var desc:String;
    var botao:FlxSprite;
    var outline:FlxSprite;

    public function new(id:Int, name:String, enabled:Bool, x1:Int, desc:String)
    {
        super(x1, 0);

        this.id = id;
        this.name = name;
        this.enabled = enabled;
        this.desc=desc;
        botao = new FlxSprite(0,0);
        if (OpenFlAssets.exists(Paths.imagechecker("modifiers/botoes/" + this.name)))
        {
            botao.loadGraphic(Paths.image("modifiers/botoes/" + this.name));
        }
        else
        {
            botao.loadGraphic(Paths.image("modifiers/botoes/placeholder"));
        }
        botao.screenCenter(Y);
        botao.updateHitbox();
        add(botao);
        outline = new FlxSprite(0,0);
        if(this.enabled){
        outline.loadGraphic(Paths.image("modifiers/on"));
        } else {
        outline.loadGraphic(Paths.image("modifiers/off"));
        }
        outline.screenCenter(Y);
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
