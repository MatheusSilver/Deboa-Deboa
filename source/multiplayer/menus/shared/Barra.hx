package multiplayer.menus.shared;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class Barra extends FlxSpriteGroup
{
	public function new(color:FlxColor) {
		super();

		var barraCima:FlxSprite;
		var barraBaixo:FlxSprite;

		barraCima = new FlxSprite(0,0).makeGraphic(FlxG.width, 52, color);
		barraBaixo = new FlxSprite(0,0).makeGraphic(FlxG.width, 52, color);
		barraBaixo.setPosition(0,FlxG.height-52);
		
		add(barraCima);
		add(barraBaixo);
	}
}