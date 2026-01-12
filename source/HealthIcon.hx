package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y); // Espero do fundo do meu coração que isso só aconteça no Freeplay.
																			 // De qualquer jeito, alguns icons não devem ter o mesmo tamanho ou mesmo offset no PNG.
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	public static function getIconPath(char:String){
		var iconPath:String ='icons/fnf/bf';
		if(OpenFlAssets.exists(Paths.imagechecker("icons/icon-" + char, "shared"))) 
			iconPath = 'icons/icon-' + char; // Psych antiga (Só pra caso alguém esqueca e coloque um icon no padrão antigo na raiz da pasta)
		else if(OpenFlAssets.exists(Paths.imagechecker("icons/" + char, "shared"))) // Padrão de icons do ModBoa (icons/pasta/icon)
			iconPath = 'icons/' + char;		
		else
			flixel.FlxG.log.warn('Could not find ${char} icon, loading BF instead');	

		return iconPath;
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			final name:String = getIconPath(char);
			
			var file:Dynamic = Paths.image(name, 'shared');

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}