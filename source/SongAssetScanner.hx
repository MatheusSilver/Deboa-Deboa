package;

using StringTools;

typedef LuaImageRef =
{
	var key:String;
	var library:Null<String>;
	var atlas:Bool;
	var gpu:Bool;
}

typedef LuaScanResult =
{
	var images:Array<LuaImageRef>;
	var sounds:Array<String>;
	var characters:Array<String>;
	var songScripts:Array<String>;
	var globalScripts:Array<String>;
}

class SongAssetScanner
{
	static inline var CALL_PATTERN:String = "\\b(makeLuaSprite|makeLuaTiledSprite|makeAnimatedLuaSprite|loadGraphic|precacheImageEspecial|precacheImage|precacheSound|playSound|addCharacterToList|pushScriptData|addLuaScript)\\s*\\(";

	public static function scanLua(source:String):LuaScanResult
	{
		var result:LuaScanResult = {images: [], sounds: [], characters: [], songScripts: [], globalScripts: []};
		var code:String = stripComments(source);
		var call:EReg = new EReg(CALL_PATTERN, '');
		var pos:Int = 0;
		while (call.matchSub(code, pos))
		{
			var match = call.matchedPos();
			pos = match.pos + match.len;
			collect(result, call.matched(1), readArguments(code, pos));
		}
		return result;
	}

	static function collect(result:LuaScanResult, name:String, args:Array<String>):Void
	{
		switch (name)
		{
			case 'makeLuaSprite' | 'loadGraphic':
				addImage(result, literalAt(args, 1), null, false, true);
			case 'makeLuaTiledSprite':
				addImage(result, literalAt(args, 1), null, false, false);
			case 'makeAnimatedLuaSprite':
				addImage(result, literalAt(args, 1), null, true, true);
			case 'precacheImage':
				addImage(result, literalAt(args, 0), null, false, true);
			case 'precacheImageEspecial':
				addImage(result, literalAt(args, 0), literalAt(args, 1), false, args.length < 3 || args[2] != 'false');
			case 'precacheSound' | 'playSound':
				addUnique(result.sounds, literalAt(args, 0));
			case 'addCharacterToList':
				addUnique(result.characters, literalAt(args, 0));
			case 'pushScriptData':
				addUnique(result.songScripts, withLuaExtension(literalAt(args, 0)));
			case 'addLuaScript':
				addUnique(result.globalScripts, withLuaExtension(literalAt(args, 0)));
		}
	}

	static function addImage(result:LuaScanResult, key:Null<String>, library:Null<String>, atlas:Bool, gpu:Bool):Void
	{
		if (key == null || key.length == 0)
			return;
		for (image in result.images)
		{
			if (image.key == key)
			{
				image.atlas = image.atlas || atlas;
				image.gpu = image.gpu && gpu;
				return;
			}
		}
		result.images.push({key: key, library: library, atlas: atlas, gpu: gpu});
	}

	static function addUnique(list:Array<String>, value:Null<String>):Void
	{
		if (value != null && value.length > 0 && !list.contains(value))
			list.push(value);
	}

	static function withLuaExtension(name:Null<String>):Null<String>
	{
		if (name == null)
			return null;
		return name.endsWith('.lua') ? name : name + '.lua';
	}

	static function literalAt(args:Array<String>, index:Int):Null<String>
	{
		return index < args.length ? literal(args[index]) : null;
	}

	static function literal(arg:String):Null<String>
	{
		if (arg.length < 2)
			return null;
		var quote:String = arg.charAt(0);
		if ((quote != "'" && quote != '"') || skipString(arg, 0) != arg.length)
			return null;
		return arg.substring(1, arg.length - 1);
	}

	static function readArguments(code:String, start:Int):Array<String>
	{
		var args:Array<String> = [];
		var depth:Int = 0;
		var argStart:Int = start;
		var i:Int = start;
		while (i < code.length)
		{
			var c:String = code.charAt(i);
			if (c == "'" || c == '"')
			{
				i = skipString(code, i);
				continue;
			}
			if (c == '(' || c == '{' || c == '[')
				depth++;
			else if (c == ')' || c == '}' || c == ']')
			{
				if (depth == 0)
				{
					args.push(code.substring(argStart, i).trim());
					return args;
				}
				depth--;
			}
			else if (c == ',' && depth == 0)
			{
				args.push(code.substring(argStart, i).trim());
				argStart = i + 1;
			}
			i++;
		}
		args.push(code.substring(argStart).trim());
		return args;
	}

	static function skipString(code:String, start:Int):Int
	{
		var quote:String = code.charAt(start);
		var i:Int = start + 1;
		while (i < code.length)
		{
			var c:String = code.charAt(i);
			if (c == '\\')
				i += 2;
			else if (c == quote)
				return i + 1;
			else if (c == '\n')
				return i;
			else
				i++;
		}
		return code.length;
	}

	static function stripComments(source:String):String
	{
		var out:StringBuf = new StringBuf();
		var i:Int = 0;
		while (i < source.length)
		{
			var c:String = source.charAt(i);
			if (c == "'" || c == '"')
			{
				var end:Int = skipString(source, i);
				out.add(source.substring(i, end));
				i = end;
			}
			else if (c == '-' && source.charAt(i + 1) == '-')
			{
				var level:Int = longBracketLevel(source, i + 2);
				var close:String = level >= 0 ? ']' + ''.lpad('=', level) + ']' : '\n';
				var end:Int = source.indexOf(close, i + 2);
				i = end < 0 ? source.length : (level >= 0 ? end + close.length : end);
			}
			else
			{
				out.add(c);
				i++;
			}
		}
		return out.toString();
	}

	static function longBracketLevel(source:String, pos:Int):Int
	{
		if (source.charAt(pos) != '[')
			return -1;
		var i:Int = pos + 1;
		while (source.charAt(i) == '=')
			i++;
		return source.charAt(i) == '[' ? i - pos - 1 : -1;
	}
}
