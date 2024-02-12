package;

import openfl.display.BitmapData;
import flixel.FlxG;
import haxe.crypto.Md5;
import openfl.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

/**
 * Usada pra usar a mesma função pra plataformas diferentes (Mobile e Android)
 */
class Utils
{
	/**
	 * Lê o conteúdo de um arquivo.
	 * @param id Arquivo que será lido pela função
	 */
	public static function getContent(id:String):String
	{
		#if mobile
		return Assets.getText(id);
		#else
		return File.getContent(id);
		#end
	}

	/**
	 * Retorna entre verdadeiro ou falso a existência do arquivo especificado
	 * @param id Arquivo para verificação
	 */
	public static function exists(id:String):Bool
	{
		#if mobile
		return Assets.exists(id);
		#else
		return FileSystem.exists(id);
		#end
	}

	/**
	 * Lê um arquivo binário (Eu acho :skull:)
	 * @param id Arquivo que será lido pela função
	 */
	public static function getBytes(id:String)
	{
		#if mobile
		return Assets.getBytes(id);
		#else
		return File.getBytes(id);
		#end
	}

	/**
	 * Retorna o nome de todos os arquivos dentro do diretório especificado
	 * @param id Diretório que será lido
	 */
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

	/**
	 * Cria um novo BitmapData de um arquivo.
	 * @param id Arquivo que será usado pra criar o Bitmap
	 */
	public static function fromFile(id:String)
	{
		#if mobile
		return Assets.getBitmapData(id);
		#else
		return BitmapData.fromFile(id);
		#end
	}

	/**
	 * Copia o conteúdo de uma string para o seu histórico do CTRL + C (PC) ou pro teclado (Mobile)
	 * @param id String que será copiada
	 */
	public static function copiarclipboard(coisa:String)
	{
		openfl.system.System.setClipboard(coisa.trim());
	}
}

/**
 * Usado principalmente pro .lua (PC e Android)
 */
class Asset2File
{
	public static var path:String = lime.system.System.applicationStorageDirectory;

	/**
	 * Retorna o Path completo de um arquivo (Desde o caminho de onde ele foi aberto).
	 * @param id Arquivo que será lido pela função
	 */
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

/**
 * Usado para funções de touch (Mobile) e mouse (Desktop)
 */
class BSLTouchUtils
{
	// Code por Matheus Silver e Lorena provavelmente
	public static var prevTouched:Int = -1;

	/**
	 * Retorna verdadeiro ou falso caso você dê um Toque na tela (Mobile) ou aperte o botão do Mouse (Desktop)
	 */
	public static function justTouched():Bool // Copiado do Hsys k
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
		return FlxG.mouse.justPressed; // Isso aqui é mais válido pro modboa mas né?
		#end
	}

	/**
	 * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop).
	 */
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

	/**
	 * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop).
	 */
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

	/**
	 * Função para tocar em uma coisa duas vezes para poder realmente selecionar ele
	 * @param coisas As coisas uai
	 * @param coisasID Socorro Silvio nunca entendi como sua função (ou função da Lorena 🤔) funciona
	 */
	public static function aperta(coisas:Dynamic,
			coisasID:Int):String // Esse code foi feito só pq em outro projeto, eu usei um padrãozinho deste várias vezes e fiquei com preguiça de fazer isso de novo
	{
		var leToqueOrdem:String = '';
		#if desktop
		if (over(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID)
		{
			leToqueOrdem = 'segundo';
		}
		else if (over(coisas) && FlxG.mouse.justPressed)
		{
			prevTouched = coisasID;
			leToqueOrdem = 'primeiro';
		}
		#elseif mobile
		for (touch in FlxG.touches.list)
		{
			if (over(coisas) && touch.justPressed && prevTouched == coisasID)
				leToqueOrdem = 'segundo';
			else if (over(coisas) && touch.justPressed)
			{
				prevTouched = coisasID;
				leToqueOrdem = 'primeiro';
			}
		}
		#end
		return leToqueOrdem;
	}

	/**
	 * Retorna verdadeiro ou falso caso você tenha apertado um objeto
	 * @param coisa Texto, sprite ou qualquer coisa que será apertada
	 */
	public static function apertasimples(coisa:Dynamic):Bool
	{
		#if desktop
		if (over(coisa) && FlxG.mouse.justPressed)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justPressed)
				return true;
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso o touch (Mobile) ou cursor (Desktop) sobreponha um objeto
	 * @param coisa ..a coisa uai
	 */
	public static function over(coisa:Dynamic):Bool
	{
		#if desktop
		if (!Main.getMouseVisibility())
			return false; // Provavelmente a única coisa que faz o BSLTouchUtils se pagar no ModBoa.
		return FlxG.mouse.overlaps(coisa);
		#elseif mobile
		for (touch in FlxG.touches.list)
			return touch.overlaps(coisa);
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop) em um objeto.
	 * @param coisa ............. Tu já sabe né?
	 */
	public static function pressionando(coisa:Dynamic):Bool
	{
		#if desktop
		return (over(coisa) && FlxG.mouse.pressed);
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justPressed && !touch.justReleased)
				return true;
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop) em um objeto.
	 * @param coisa ............. Tu já sabe né?
	 */
	public static function solto(coisa:Dynamic):Bool
	{
		#if desktop
		if (over(coisa) && FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justReleased)
				return true;
		#end

		return false;
	}

	#if desktop
	/**
	 * Retorna uma int da posição atual do seu mouse
	 * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
	 */
	public static function pegarpos(pos:String):Int
	{
		if (pos == 'x')
			return FlxG.mouse.x;

		if (pos == 'y')
			return FlxG.mouse.y;

		return 0;
	}
	#elseif mobile
	/**
	 * Retorna uma int da posição atual do seu toque
	 * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
	 */
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

/**
 * Usado para o Deslize na Tela (Mobile) e Scroll do Mouse (Desktop)
 */
class BSLSwipeUtils
{
	public static var scrollSpeed:Int = 0;
	public static final scrollAcceleration:Int = 1;
	public static final maxScrollSpeed:Float = 10.0;

	public static var scrollX:Int = 0;
	public static var scrollY:Int = 0;

	public static var prevTouchX:Int = 0;
	public static var prevTouchY:Int = 0;

	public static var max_y:Int = 1;
	public static var max_x:Int = 1;

	private static var touchY:Int;
	private static var touchX:Int;

	/**
	 * Função de Swipe (Mobile) e Scroll do Mouse (Desktop)
	 */
	 // foi o que eu entendi da função pelo menos
	public static function swipeHorizontal():Void
	{
		if (BSLTouchUtils.justTouched())
		{
			prevTouchX = Std.int(BSLTouchUtils.pegarpos("x") / max_x);
		}
		else if (BSLTouchUtils.touched())
		{
			touchX = Std.int(BSLTouchUtils.pegarpos("x") / max_x);
			var deltaX:Int = (touchX - prevTouchX);

			scrollX = deltaX;

			prevTouchX = touchX;
		}
		else if (Math.abs(scrollX) > 0)
		{
			if (scrollX > 0)
				scrollSpeed -= scrollAcceleration;
			else if (scrollX < 0)
				scrollSpeed += scrollAcceleration;

			scrollSpeed = Std.int(CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
		}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollX += FlxG.mouse.wheel;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollX += scrollSpeed;
		scrollX = CoolUtil.mathClamp(scrollY, -max_x, max_x);
		if (Math.abs(scrollX) <= Math.abs(scrollSpeed))
			resetScrolls();
	}

	/**
	 * Função de Swipe (Mobile) e Scroll do Mouse (Desktop)
	 */
	public static function swipeVertical():Void
	{
		if (BSLTouchUtils.justTouched())
		{
			prevTouchY = Std.int(BSLTouchUtils.pegarpos("y") / max_y);
		}
		else if (BSLTouchUtils.touched())
		{
			touchY = Std.int(BSLTouchUtils.pegarpos("y") / max_y);
			var deltaY:Int = (touchY - prevTouchY);

			scrollY = deltaY;

			prevTouchY = touchY;
		}
		else if (Math.abs(scrollY) > 0)
		{
			if (scrollY > 0)
				scrollSpeed -= scrollAcceleration;
			else if (scrollY < 0)
				scrollSpeed += scrollAcceleration;

			scrollSpeed = Std.int(CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
		}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollY -= FlxG.mouse.wheel;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollY += scrollSpeed;
		scrollY = CoolUtil.mathClamp(scrollY, -max_y, max_y);
		if (Math.abs(scrollY) <= Math.abs(scrollSpeed))
			resetScrolls();
	}

	inline public static function resetScrolls():Void
	{
		scrollX = scrollY = scrollSpeed = 0;
	}
}

/*
	Caso quiser uma visualização com cores, e com mais qualidade, entre em:
	https://mateuzinhox02.github.io/viniccius13-ascii/
	Zoom no 50%!
 */
// .........,,,,,,,,*******/////(((((##############################################
// .........,,,,,,,,********//////(((((###########(((((((((((((/((((((((###%%%#####
// ...........,,...,,,,,,,****//////////////////////(((((###############%%%%&%###%#
//   ....,***///(((#########((###%%%%%%%%####%%%%&&&&&&&&%%%%%%%%&&&&&&&%%%%%%%%&#
// .**(((((##%%&&&&&&&%%%%%%&&&&&&&&%%%%%&&&&&&&&&&&&&%&&&&&&&@@@&&&&%%%&&&&&&&&%&#
// ,*/%%&&&&&&&&&&%%%%&&&&&&&&&&&&&&&@@@@@&&&&&&&&&@@@@@@&&&&&&&&&&@@@@&&&&&&&&&&&%
//*/#&@@&&&&&&&%&&&@@@@&&&&&@@@@@@@@@@&&@@@@@@@@@@&&&&&&&&&&@@@@%#/*//********/&&&
////%&@@@&&&&&@@@@@********(#%%%%%%%&&&&&@@%.,.,........&@@@@@@&&&&&&%&&&%(*,,*&&&
//*/(%@@@@@&&@@@@@%***#&@@@@@@@@&#/*,,..............,,,,,,,,,,,,,,,,**/(%&&&%//&&&
// (((((((#((@@@&&&&%%&%%%%%%%&&&&&&%%%%&&@@@&&&&&&&&&&&&&&&&&&&&&%%%%%%%&&&&&&%%%%
// ...,*/#(#@@@&@@&&&&&&&&&&&&%%%%&&&@@@@&&&&&&#####&@@&&&&&&%%%%%%&&&&&%%%%####%(
// ,,,.,,(((&@@/&@@@@@&&%%%%%%&&&&&&&%%%%&&&&(.....,,%@@&%%%%&&&&&&%%%#######%%%%/
// ..,, .,/((&@@//@@&&%%&&&@@@&&&%%%%%%%%%&&%.,,......,/@@@@@&&&&%%%######%%%&&&&//
// ..,,*///((#&%***(&@@@@@&&&%%%%%%##((////,,,,,,...............,,,,,,,,,,,*****%//
// ,**///((((#**/***,,*/,,,,***,..........,,,,,,,,,...........       .....,,,***&&/
//  ..,********(****,,,/@@&%(/*,...       /,,,,,,,,,,,,,,.............,,,,,****&@@
//*  .,,*******(****,,,,,*&&&&&&%%%%%#.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%%%((###((
// ,....,*****/*//***,,,,,,,,,*###((((*...,.,,,,,,,,,,,,,,,,,,,,,,,,,,,&&&%#//(##//
// ,,..,..,,**//*****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********&@&%#(//*%,,
// (((((##%%%&&&&/*******,*,,,,,********************///((##%%%%&&&&&&&@@@&&%%%#(*,,
// &&&&&%%%%&&&&&&%**********/((#%%%&&%/////////////////***/#%#####%%%%%%#%%%%#(#*,
// %%%######&%%%&&&&@&&&%#((((##%%%%%#####/*/********,,,(#(%#######((((##((%%%#((#%
// %%%%%%%%#%%%%%%%&&&&%%%###(######(((((///(((#############(((((######((((&%%#((((
// ##%&%%&&%#%%%%###%%%%%%#((%%((((((((((((##############(((#####(%#((#(((#@%%%%%%%
// &&%##%&&%####(%@@@@&%(###((#@@%((#%%%###########(((((##(((((%@@((##((##%&&&&&&&&
// @@&&&%%#(#%@@@@@@@@&&%((###(%@@@@@&#((###%#####((((((((#&@@@@@%(##((###&&@@@@@@@
// @@@@&%%*#%&&&@@@@@@&&&%#((###@@@@@@@@@@@@&#((((##&@@@@@@@@@@@@(#%(((###@@@@@@#(/
// @@@@....#%%&&&@@@@@@&%%%%#(##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(%%%#%%#%@@@@/////
