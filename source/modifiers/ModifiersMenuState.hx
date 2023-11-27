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


using StringTools;

class ModifiersMenuState extends MusicBeatState
{

    public var buttons:Array<ModifierButton> = [];
    public var textString:String = "";
    public var textDescString:String = "";
    var mouseTxt:FlxText;
    var mouseDesc:FlxText;

	override function create()
	{
		#if rpc
		DiscordClient.changePresence("No menu de modifiers", null);
		#end
        
        mouseTxt = new FlxText(0, 0, 200, textString, 8, true);
        mouseTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
        mouseDesc = new FlxText(0, 0, 200, textDescString, 8, true);
        mouseDesc.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.GRAY, CENTER);

        var x1:Int = 0;
        for(i in 0...ModifiersManager.allModifiers.length)
        {
            //var properties:Modifier = ModifiersManager.getAllProperties(i);
            var modifierButton:ModifierButton = new ModifierButton(i, ModifiersManager.getNameById(i), ModifiersManager.isEnabled(i), x1, ModifiersManager.getDescById(i));
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
        textString = "";
        textDescString = "";
        for (button in buttons)
            {
                if (FlxG.mouse.overlaps(button))
                {
                    textString = button.name;
                    textDescString = button.desc;
                    break;
                }
            }
        mouseTxt.text = textString;
        mouseTxt.x=FlxG.mouse.x - 60;
        mouseTxt.y = FlxG.mouse.y + 40;
        mouseDesc.text = textDescString;
        mouseDesc.x=FlxG.mouse.x - 60;
        mouseDesc.y = FlxG.mouse.y + 80;
		if (controls.BACK)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
	}

}

class ModifierButton extends FlxSprite
{
    public var id:Int;
    public var name:String;
    public var enabled:Bool;
    public var desc:String;

    public function new(id:Int, name:String, enabled:Bool, x1:Int, desc:String)
    {
        super(x1, 0);

        this.id = id;
        this.name = name;
        this.enabled = enabled;
        this.loadGraphic(Paths.image("modifiers/" + Std.string(ModifiersManager.getTypeById(id))));
        this.screenCenter(Y);
        this.desc=desc;
        trace(Std.string(ModifiersManager.getTypeById(id)));
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        this.alpha = enabled ? 1 : 0.5;
    }
}
