package;

import flixel.FlxG;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

class GlobalSoundManager //Originalmente feito para o port de DDTO+ Android
{ //Aparentemente isso ajuda no cache subindo até o infinito e além.
	//Mas o mais importante mesmo é que permite customizar o barulho dos efeitos sonoros.

	public static var listaDeSons:Map<String, FlxSound> = [];
	public static function play(?som:Sounds):Void
	{
		if (listaDeSons.exists(som))
			listaDeSons.get(som).play();
		else{
			var temp = new FlxSound().loadEmbedded(Paths.sound(som, "preload"));
			temp.volume = ClientPrefs.efeitosVolume;
			temp.persist = true;
			FlxG.sound.list.add(temp);
			listaDeSons.set(som, temp);
			temp.play();
		}
	}
	public static function destroyAll(){
		for (sound in listaDeSons) {
			sound.destroy();
			FlxG.sound.list.remove(sound);
		}
		listaDeSons = [];
	}
}

enum abstract Sounds(String) to String from String {
	var confirmMenu = "confirmMenu";
	var cancelMenu = "cancelMenu";
	var scrollMenu = "scrollMenu";
	var click = "click";
	var negado = "negado";
}