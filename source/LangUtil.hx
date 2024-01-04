package;

import firetongue.Replace;

using StringTools;

// for reference: https://www.techonthenet.com/js/language_tags.php
class LangUtil
{
	public static function getFont(type:String = 'letravio'):String
	{
		var font:String = '';

		switch (type.toLowerCase())
		{
            
            case "sonic-1":
                font = "sonic-1-hud-font.ttf";
			default:
				font = 'letravio.ttf';
		}

		return font;
	}

	// public static function getFontOffset(type:String = 'aller'):Float
	// {
	// 	var offset:Float = 0;

	// 	if (type.toLowerCase() == 'pixel' || type.toLowerCase() == 'waifu') {
	// 		// none because they all use LanaPixel
	// 		return 0;
	// 	} else {
	// 		return offset;
	// 	}
	// }

	public static function getString(flag:String, context:String = 'data', ?replace:Dynamic):String
	{
		var str:String = Main.tongue.get(flag, context);

		if (replace != null)
			str = Replace.flags(str, ["<X>"], [Std.string(replace)]);

		return str;
	}
}
