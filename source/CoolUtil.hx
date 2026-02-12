package;

import flixel.FlxG;
import lime.utils.Assets;
import flixel.util.FlxColor;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

using StringTools;

class CoolUtil
{
	/**
	 * Umma Array que contém o nome e prefixo das dificuldades.
	 */
	public static var difficultyStuff:Array<Dynamic> = [
		['Easy', '-easy'], // 0
		['Normal', ''], // 1
		['Hard', '-hard'], // 2 - honestamente estou pensando em trocar o 'Hard' por 'Difícil' mas né? a maioria da rapaziada tá acostumada com 'Hard'
		['Sonic', '-sega'], // 3
		['Mario', '-nintendo'], // 4
		['MX', '-mx'], // 5
		['Lord-X', '-lorx-x'], // 6
		['Hypno', '-hypno'] // 7
	];

	/**
	 * Uma função aproximadamente 2-6 vezes mais rápida do que a do Math. (Margem de < 0.05% de erros - pode ser impreciso)
	 * @param Número que será utilizado na função
	 * @return Float
	 */
	inline public static function seno(n:Float):Float {
		return FlxMath.fastSin(n);
	}

	/* Essa é uma solução beeeeeeeeeeeeeem gambiarrada, mas é mais rápido do que repensar essas coisas como int*/
	inline public static function stableOneDigitSum(variable:Float, sum:Int):Float {
		return (Std.int(Math.round(variable*10)) + sum)/10;
	}

	/**
	 * Uma função aproximadamente 2-6 vezes mais rápida do que a da classe 'Math'. (Margem de < 0.05% de erros - pode ser impreciso)
	 * @param Número que será utilizado na função
	 * @return Float
	 */
	inline public static function cosseno(n:Float):Float {
		return FlxMath.fastCos(n);
	}

	/**
	 * Uma função que retorna um número aproximado de pi.
	 * @return Float (Math.PI)
	 */
	 inline public static function pi():Float {
		return Math.PI;
	}

	// Não sei o que isso faz
	inline public static function formatScore(zeros_vezes:Int, num_vezes:Int):String
	{
		var zeros:String = repeat("0",
			zeros_vezes - (Std.int(Math.log(num_vezes) / Math.log(10)) + 1)); // Maldito haxe que não tem função log10 já imbutida :skull:
		var num:String = Std.string(num_vezes);

		return zeros + num;
	}

	// Não sei o que isso faz
	// Isso faz com que uma parte de uma string se repita uma certa quantidade de vezes
	// Iria usar em algum lugar dos achievements mas por conta do sistema de locales, acabei só tirando.
					// Silvio
	inline public static function repeat(str:String, times:Int):String
	{
		var result:String = "";
		for (i in 0...times)
			result += str;
		return result;
	}

	inline public static function checkPlayState(){
		if (PlayState.instance != null) return PlayState.instance.isPlayState;
		return false;
	}

	// Não sei o que isso faz
	public static function mathClamp(n:Float, min:Float, max:Float):Int
	{
		return Std.int(Math.min(Math.max(n, min), max));
	}

	public static inline function randomFloat(from:Float, to:Float):Float
    {
        return (from + ((to - from) * Math.random()));
    }

	/**
	 * Formata um texto deixando ele bonitinho (Letras maíusculas e minúsculas)
	 * @param text O texto que você vai capitalizar. (nem sei se essa palavra existe pra ser bem sincero)
	 */
	inline public static function capitalize(text:String)
	{
		return text.charAt(0).toUpperCase() + text.substr(1);
	}

	/**
	 * Retorna uma cor de uma String.
	 * @param color A cor em formato de String. 
	 * @return Retorna um FlxColor.
	 */
	inline public static function colorFromString(color:String):FlxColor // Já estava ficando deveras pito com isso...
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x'))
			color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if (colorNum == null)
			colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	/**
	 * Função que retorna a dificuldade em Uppercase.
	 * @return Retorna uma String que representa a dificuldade em Uppercase. (EASY, NORMAL, HARD.)
	 */
	public static function difficultyString():String
	{
		return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
	}

	// Não sei o que isso faz
	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;
		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;
		return newValue;
	}
	
	/**
	 * Carrega um arquivo de Texto (pode carregar outros arquivos também, mas o foco principal são arquivos .txt)
	 * @param path Caminho do seu arquivo
	 * @return Retorna uma Array<String> que contém o seu texto.
	 */
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		if (Assets.exists(path))
			daList = Assets.getText(path).trim().split('\n');
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	/**
	 * Transforma uma String em Array usando o método .split para criar linebreaks.
	 * @param string A String que será utilizada para criar a lista.
	 * @return Retorna uma lista (Array<String>) com as linhas da Array separadas.
	 */
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	// Não sei o que isso faz
	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
					{
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					}
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					{
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	/**
	 * Cria uma Array de números
	 * @param max O número máximo que sua Array terá. 
	 * @param min O número mínimo que sua Array terá. (Já é 0 por padrão.)
	 * @return Array completa com números entre min e max
	 */
	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	// Não sei pra que isso serve, então aqui não tem explicação
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	/**
	 * Abre um URL.
	 * @param URL do Site que você deseja abrir.
	 */
	public static function browserLoad(site:String)
	{
		#if linux // pego da CNE.
		// generally `xdg-open` should work in every distro
		var cmd = Sys.command("xdg-open", [site]);
		// run old command JUST IN CASE it fails, which it shouldn't
		if (cmd != 0) cmd = Sys.command("/usr/bin/xdg-open", [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/**
	 * Retorna o path da Savedata do jogo (Compatível com as versões antigas e novas do Flixel.)
	 * @return Path da Savedata
	 */
	public static function getSavePath():String
	{
		@:privateAccess // galakxisne
		return #if (flixel < "5.0.0") 'galaccine' #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}
}