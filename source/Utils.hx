package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxSave;
import openfl.display.BitmapData;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if mobile
import lime.utils.Assets;
import haxe.crypto.Md5;
#end

/**
 * Utilizado especialmente pro FileSystem multi plataforma.
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
	public static function readDirectory(id:String):Array<String>
	{
		#if mobile
		// Isso foi pego da PR que eu falei lá no main.
		var result = [];
    
        for (library in Main.assetList.filter(archives -> archives.contains(id))) {
            if (!library.startsWith('.')) {
                var name = library.replace(id + '/', '').split('/')[0];
                // contains pero un poooco mas rapido
                if (result.indexOf(name) == -1)
                    result.push(name);
            }
        }
    
        result.sort((a, b) -> {
            return a.toUpperCase() < b.toUpperCase() ? -1 : (a.toUpperCase() > b.toUpperCase() ? 1 : 0);
        });
    
        return result;
		#else
		return FileSystem.readDirectory(id);
		#end
	}

	/**
	 * Cria um novo BitmapData de um arquivo.
	 * @param id Arquivo que será usado pra criar o Bitmap
	 */
	public static function fromFile(id:String)
	{
		#if mobile
		return openfl.utils.Assets.getBitmapData(id);
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
	/**
	 * Retorna o Path completo de um arquivo (Desde o caminho de onde ele foi aberto).
	 * @param id Arquivo que será lido pela função
	 */
	public static function getPath(id:String, ?ext:String = "")
	{
		#if android
		var file = Assets.getBytes(id);

		var md5 = Md5.encode(Md5.make(file).toString());

		if (FileSystem.exists(Main.path + md5 + ext))
			return Main.path + md5 + ext;

		File.saveBytes(Main.path + md5 + ext, file);

		return Main.path + md5 + ext;
		#else
		return #if sys Sys.getCwd() + #end id;
		#end
	}
}

// O que tem no esconderijo?
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