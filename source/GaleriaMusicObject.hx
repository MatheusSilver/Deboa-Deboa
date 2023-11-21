package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

using StringTools;

class GaleriaMusicObject extends FlxSpriteGroup
{
    public function new(file_name:String, show_name:String)
    {
        super();

        var thumb:FlxSprite;
        var music_name:FlxText;
        var letra_brasileira:FlxText; //Se não fosse a corzinha diferente isso aqui nem existiria

        thumb = new FlxSprite(100,100).loadGraphic(Paths.image("scrolling/artes/scroll-" + file_name + " (scroll)", 'preload'));
        thumb.setGraphicSize(Std.int(thumb.width*0.125));
        thumb.updateHitbox();
        thumb.x = 420;
        thumb.y = FlxG.height - 75;
        thumb.antialiasing=ClientPrefs.globalAntialiasing;
        add(thumb);
        
        music_name = new FlxText(thumb.x + thumb.width + 20, thumb.y, 200, show_name, 14);
		music_name.setFormat(Paths.font("Roboto-Black.ttf"), 16, 0xffffff, LEFT);
        music_name.antialiasing=ClientPrefs.globalAntialiasing;
		add(music_name);

        letra_brasileira = new FlxText(music_name.x, music_name.y + music_name.height + 5, 200, "Com letra brasileira", 14);
		letra_brasileira.setFormat(Paths.font("Roboto-Regular.ttf"), 16, 0xc6c6c6, LEFT);
        letra_brasileira.antialiasing=ClientPrefs.globalAntialiasing;
		add(letra_brasileira);
    }
}