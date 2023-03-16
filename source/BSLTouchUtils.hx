package; //Rosbado do port de Doki Doki (Basicamente pra me lembrar de ajustar algumas coisas mobile specific depois

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxG;

class BSLTouchUtils
{
	public static var prevTouched:Int = -100;

	public static function justTouched():Bool //Copiado do Hsys k
	{
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				justTouched = true;
		}

		#if (flixel && android)
		return justTouched;
		#else
		return false;
		#end
	}

	public static function aperta(coisas:FlxSprite, coisasID:Int):String 
    {
        var leToqueOrdem:String = '';
		if (FlxG.mouse.overlaps(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID){
            leToqueOrdem = 'segundo';
		}else if (FlxG.mouse.overlaps(coisas) && FlxG.mouse.justPressed){
			prevTouched = coisasID;
			leToqueOrdem = 'primeiro';
        }
		return leToqueOrdem;
    }

    //Mais funções conforme forem nescessárias
}
