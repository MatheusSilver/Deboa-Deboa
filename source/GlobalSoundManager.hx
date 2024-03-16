package;
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
			flixel.FlxG.sound.list.add(temp).play();
			listaDeSons.set(som, temp);
		}
	}
	//As vezes eu odeio uma mineira...
	public inline static function changeVolumes(){for (sound in listaDeSons) {sound.volume = ClientPrefs.efeitosVolume;}}
}

enum abstract Sounds(String) to String from String {
	final confirmMenu = "confirmMenu";
	final cancelMenu = "cancelMenu";
	final scrollMenu = "scrollMenu";
	final click = "click";
	final negado = "negado";
}