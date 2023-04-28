package;

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import haxe.crypto.Md5;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import lime.system.System;
import openfl.display.BitmapData;


using StringTools;

// Lembrando que o FileSystem no HTML tem que usar js, então se isso for compatível lá também, tem que usar isso
class Utils {
	public static function getContent(id:String):String
		{
		  #if mobile
		  return Assets.getText(id);
		  #else
		  return File.getContent(id);
		  #end
		}

		public static function exists(id:String):Bool 
		{
		  #if mobile
		  return Assets.exists(id);
		  #else
		  return FileSystem.exists(id);
		  #end
		}

		public static function getBytes(id:String)
		{
		  #if mobile
		  return Assets.getBytes(id);
		  #else
		  return File.getBytes(id);
		  #end
		}

		public static function readDirectory(library:String):Array<String>
		{
		  var something:Array<String> = [];
		  var bruh = Assets.list();
		  #if mobile 
		  for (folder in bruh.filter(text -> text.contains('$library')))
		  {
			if (!folder.startsWith('.'))
			something.push(folder);
		  }
		  return something;
		  #else
		  return FileSystem.readDirectory(library);
		  #end
		}

		public static function fromFile(id:String)
		{
		  #if mobile 
		  return Assets.getBitmapData(id);
		  #else
		  return BitmapData.fromFile(id);
		  #end
		}
}

class Asset2File {
	public static var path:String = lime.system.System.applicationStorageDirectory;

	public static function getPath(id:String, ?ext:String = "")
	{
		#if android
		var file = Assets.getBytes(id);

		var md5 = Md5.encode(Md5.make(file).toString());

		if (FileSystem.exists(path + md5 + ext))
			return path + md5 + ext;


		File.saveBytes(path + md5 + ext, file);

		return path + md5 + ext;
		#else
		return #if sys Sys.getCwd() + #end id;
		#end
	}
}

class BSLTouchUtils
{
	public static var prevTouched:Int = -1;

	public static function justTouched():Bool //Copiado do Hsys k
	{
		#if (flixel && android)
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				justTouched = true;
		}

		return justTouched;
		#else
		return FlxG.mouse.justPressed; //Isso aqui é mais válido pro modboa mas né?
		#end
	}

	public static function aperta(coisas:Dynamic, coisasID:Int):String //Esse code foi feito só pq em outro projeto, eu usei um padrãozinho deste várias vezes e fiquei com preguiça de fazer isso de novo
    {
        var leToqueOrdem:String = '';
	    #if desktop
		if (FlxG.mouse.overlaps(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID){
            leToqueOrdem = 'segundo';
		}else if (FlxG.mouse.overlaps(coisas) && FlxG.mouse.justPressed){
			prevTouched = coisasID;
			leToqueOrdem = 'primeiro';
        }
	    #elseif mobile
		for (touch in FlxG.touches.list){
			if (touch.overlaps(coisas) && touch.justPressed && prevTouched == coisasID)
            	leToqueOrdem = 'segundo';
			else if (touch.overlaps(coisas) && touch.justPressed){
				prevTouched = coisasID;
				leToqueOrdem = 'primeiro';
        	}    
		}
	    #end
		return leToqueOrdem;
    }

	public static function apertasimples(coisa:Dynamic):Bool
    {
	    #if desktop
		if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justPressed)
			return true;
	    #elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justPressed)
				return true;
	    #end

		return false;
    }

	public static function pressionando(coisa:Dynamic):Bool
	{
		#if desktop
		if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justPressed && !FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justPressed && !touch.justReleased)
				return true;
		#end

		return false;
	}
}
