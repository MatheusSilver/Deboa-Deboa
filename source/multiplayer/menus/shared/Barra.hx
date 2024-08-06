package multiplayer.menus.shared;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import ui.FlxButton;
import flixel.text.FlxText;
import Linguagem.LangUtil;


class Barra extends FlxSpriteGroup
{
    public var backButton:FlxButton;
    var label:FlxText;

	public function new(color:FlxColor) {
		super();

		var barraCima:FlxSprite;
		var barraBaixo:FlxSprite;

		barraCima = new FlxSprite(0,0).makeGraphic(FlxG.width, 52, color);
		barraBaixo = new FlxSprite(0,0).makeGraphic(FlxG.width, 52, color);
		barraBaixo.setPosition(0,FlxG.height-52);
		
		add(barraCima);
		add(barraBaixo);

        backButton = new FlxButton(barraCima.x+21,barraCima.y+8, "", function(){
			if(!MultiplayerMainMenuState.instance.canClick || !backButton.visible)
				return;
			MultiplayerMainMenuState.instance.voltarMenu();
		});
		backButton.loadGraphic(Paths.image("multiplayer/menus/voltar"));
		add(backButton);

		label = new FlxText(FlxG.width-10, 6, 0, "", 8);
		label.setFormat(LangUtil.getFont("gameboy"), 29, FlxColor.WHITE, FlxTextAlign.RIGHT);
		label.x = FlxG.width-(label.fieldWidth+10);
		add(label);
	}

    public function changeLabelText(text:String) {
        label.text = text;
		label.x = FlxG.width-(label.fieldWidth+10);
    }


}