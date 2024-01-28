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

class Utils {
	// Code por Idklool
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

		public static function copiarclipboard(coisa:String) {
			#if mobile
			// Isso faz que o jogo copie as coisas no mobile
			// Tipo copiar um texto
			openfl.system.System.setClipboard(coisa.trim());
			#end
		}
}

class Asset2File {
	// Code por luckydog (eu acho?)
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
	// Code por Matheus Silver e Lorena provavelmente
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

	public static function touched():Bool
		{
			#if (flixel && android)
			var touched:Bool = false;
	
			for (touch in FlxG.touches.list)
			{
				if (touch.pressed)
					touched = true;
			}
	
			return touched;
			#else
			return FlxG.mouse.pressed;
			#end
		}

		public static function justSolto():Bool
			{
				#if (flixel && android)
				var justReleased:Bool = false;
		
				for (touch in FlxG.touches.list)
				{
					if (touch.justReleased)
						justReleased = true;
				}
		
				return justReleased;
				#else
				return FlxG.mouse.justReleased;
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

	public static function over(coisa:Dynamic):Bool
    {
	    #if desktop
		return FlxG.mouse.overlaps(coisa);
	    #elseif mobile
		for (touch in FlxG.touches.list)
			return touch.overlaps(coisa);
	    #end

		return false;
    }

	public static function pressionando(coisa:Dynamic):Bool
	{
		#if desktop
		return (FlxG.mouse.overlaps(coisa) && FlxG.mouse.pressed);
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justPressed && !touch.justReleased)
				return true;
		#end

		return false;
	}
	
	public static function solto(coisa:Dynamic):Bool
	{
		#if desktop
		if (FlxG.mouse.overlaps(coisa) && FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (touch.overlaps(coisa) && touch.justReleased)
				return true;
		#end
	
		return false;
	}

	#if desktop
	public static function pegarpos(pos:String):Int
	{
		if (pos == 'x')
			return FlxG.mouse.x;
		
		if (pos == 'y')
			return FlxG.mouse.y;

		return 0;
	}
	#elseif mobile

	public static function pegarpos(?touch:flixel.input.touch.FlxTouch, pos:String):Int
	{
		if (pos == 'x')
			return touch.x;

		if (pos == 'y')
			return touch.y;

		return 0;
	}

	#end
		
}

/*
Caso quiser uma visualização com cores, e com mais qualidade, entre em:
https://mateuzinhox02.github.io/viniccius13-ascii/
Zoom no 50%!
*/


//.........,,,,,,,,*******/////(((((##############################################
//.........,,,,,,,,********//////(((((###########(((((((((((((/((((((((###%%%#####
//...........,,...,,,,,,,****//////////////////////(((((###############%%%%&%###%#
//   ....,***///(((#########((###%%%%%%%%####%%%%&&&&&&&&%%%%%%%%&&&&&&&%%%%%%%%&#
//.**(((((##%%&&&&&&&%%%%%%&&&&&&&&%%%%%&&&&&&&&&&&&&%&&&&&&&@@@&&&&%%%&&&&&&&&%&#
//,*/%%&&&&&&&&&&%%%%&&&&&&&&&&&&&&&@@@@@&&&&&&&&&@@@@@@&&&&&&&&&&@@@@&&&&&&&&&&&%
//*/#&@@&&&&&&&%&&&@@@@&&&&&@@@@@@@@@@&&@@@@@@@@@@&&&&&&&&&&@@@@%#/*//********/&&&
////%&@@@&&&&&@@@@@********(#%%%%%%%&&&&&@@%.,.,........&@@@@@@&&&&&&%&&&%(*,,*&&&
//*/(%@@@@@&&@@@@@%***#&@@@@@@@@&#/*,,..............,,,,,,,,,,,,,,,,**/(%&&&%//&&&
//(((((((#((@@@&&&&%%&%%%%%%%&&&&&&%%%%&&@@@&&&&&&&&&&&&&&&&&&&&&%%%%%%%&&&&&&%%%%
// ...,*/#(#@@@&@@&&&&&&&&&&&&%%%%&&&@@@@&&&&&&#####&@@&&&&&&%%%%%%&&&&&%%%%####%(
// ,,,.,,(((&@@/&@@@@@&&%%%%%%&&&&&&&%%%%&&&&(.....,,%@@&%%%%&&&&&&%%%#######%%%%/
//..,, .,/((&@@//@@&&%%&&&@@@&&&%%%%%%%%%&&%.,,......,/@@@@@&&&&%%%######%%%&&&&//
//..,,*///((#&%***(&@@@@@&&&%%%%%%##((////,,,,,,...............,,,,,,,,,,,*****%//
//,**///((((#**/***,,*/,,,,***,..........,,,,,,,,,...........       .....,,,***&&/
//  ..,********(****,,,/@@&%(/*,...       /,,,,,,,,,,,,,,.............,,,,,****&@@
//*  .,,*******(****,,,,,*&&&&&&%%%%%#.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%%%((###((
//,....,*****/*//***,,,,,,,,,*###((((*...,.,,,,,,,,,,,,,,,,,,,,,,,,,,,&&&%#//(##//
//,,..,..,,**//*****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********&@&%#(//*%,,
//(((((##%%%&&&&/*******,*,,,,,********************///((##%%%%&&&&&&&@@@&&%%%#(*,,
//&&&&&%%%%&&&&&&%**********/((#%%%&&%/////////////////***/#%#####%%%%%%#%%%%#(#*,
//%%%######&%%%&&&&@&&&%#((((##%%%%%#####/*/********,,,(#(%#######((((##((%%%#((#%
//%%%%%%%%#%%%%%%%&&&&%%%###(######(((((///(((#############(((((######((((&%%#((((
//##%&%%&&%#%%%%###%%%%%%#((%%((((((((((((##############(((#####(%#((#(((#@%%%%%%%
//&&%##%&&%####(%@@@@&%(###((#@@%((#%%%###########(((((##(((((%@@((##((##%&&&&&&&&
//@@&&&%%#(#%@@@@@@@@&&%((###(%@@@@@&#((###%#####((((((((#&@@@@@%(##((###&&@@@@@@@
//@@@@&%%*#%&&&@@@@@@&&&%#((###@@@@@@@@@@@@&#((((##&@@@@@@@@@@@@(#%(((###@@@@@@#(/
//@@@@....#%%&&&@@@@@@&%%%%#(##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(%%%#%%#%@@@@/////

