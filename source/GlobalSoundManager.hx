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
	public static var confirm:FlxSound;
	public static var cancel:FlxSound;
	public static var scroll:FlxSound;
	//public static var clickText:FlxSound;
	public static var click:FlxSound;

	public static var listaDeSons:Array<String> = []; //Por algum motivo a lista de FlxSound não funfa aqui... Devéras sus

	public static function init(?som:FlxSound):Void
	{
		if (som == confirm){
			confirm = null;
			confirm = new FlxSound().loadEmbedded(Paths.sound('confirmMenu'));
			//confirm.volume = ClientPrefs.efeitosVolume;
			confirm.persist = true;
			confirm.volume = ClientPrefs.efeitosVolume;
			FlxG.sound.list.add(confirm);
		}
		
		if (som == cancel)
		{
			cancel = null;
			cancel = new FlxSound().loadEmbedded(Paths.sound('cancelMenu'));
			//cancel.volume = ClientPrefs.efeitosVolume;
			cancel.persist = true;
			cancel.volume = ClientPrefs.efeitosVolume;
			FlxG.sound.list.add(cancel);
		}

		if (som == click)
		{
			click = null;
			click = new FlxSound().loadEmbedded(Paths.sound('click'));
			//click.volume = ClientPrefs.efeitosVolume;
			click.persist = true;
			click.volume = ClientPrefs.efeitosVolume;
			FlxG.sound.list.add(click);
		}


		if (som == scroll)
		{
			scroll = null;
			scroll = new FlxSound().loadEmbedded(Paths.sound('scrollMenu'));
			//scroll.volume = ClientPrefs.efeitosVolume;
			scroll.persist = true;
			scroll.volume = ClientPrefs.efeitosVolume;
			FlxG.sound.list.add(scroll);
		}

		/*if (som == clickText) //Usado nos dialogos, só não apaguei por preguiça
		{
			clickText = null;
			clickText = new FlxSound().loadEmbedded(Paths.sound('clickText'));
			clickText.volume = ClientPrefs.efeitosVolume;
			clickText.persist = false;
			FlxG.sound.list.add(clickText);
		}*/

	}

	public static function play(som:String):Void
	{
		if (0.7 > 0)
		{
			switch (som)
			{
				case 'confirmMenu':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(confirm);

					confirm.play(true);
				case 'click':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(click);

					click.play(true);
				/*case 'clickText':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(clickText);

					clickText.play(true);
				*/
				case 'scrollMenu':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(scroll);

					scroll.play(true);
				case 'cancelMenu':
					if (!verifiqueSeExisteEentaoadicione(som))
						init(cancel);

					cancel.play(true);
			}
		}
	}

	public static function verifiqueSeExisteEentaoadicione(nome:String):Bool
	{
		if (!listaDeSons.contains(nome)){
			listaDeSons.push(nome);
			return false;
		}else
			return true;
	}
}
