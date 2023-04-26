package;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;


class CoolUtil
{
	public static var difficultyStuff:Array<Dynamic> = [
		['Easy', '-easy'], //0
		['Normal', ''],	   //1
		['Hard', '-hard'],	//2 - honestamente estou pensando em trocar o 'Hard' por 'Difícil' mas né? a maioria da rapaziada tá acostumada com 'Hard'
		['Sonic', '-sega'], //3
		['Mario', '-nintendo'], //4
		['MX', '-mx'], //5
		['Lord-X', '-lorx-x'], //6
		['Hypno', '-hypno'] //7
	];

	public static function difficultyString():String
		{
			return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
		}
	
		public static function boundTo(value:Float, min:Float, max:Float):Float {
			var newValue:Float = value;
			if(newValue < min) newValue = min;
			else if(newValue > max) newValue = max;
			return newValue;
		}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
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
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function setFPSCap(cap:Int):Void
	{
		Main.setFPSCap(cap);
	}

	public static function getFPSCap():Int
		{
			return Std.int(openfl.Lib.current.stage.frameRate);
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	public static function getSavePath():String {
		@:privateAccess //galakxisne
		return #if (flixel < "5.0.0") 'galaccine' #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}
}
