import flixel.addons.display.FlxTiledSprite;
import flixel.addons.transition.FlxTransitionableState;
import DialogueBoxPsych;
import Shaders;
import Type.ValueType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
#if LUA_ALLOWED
import llua.Convert;
import llua.Lua;
import llua.LuaL;
import llua.State;
#end


class FunkinLua {
    public static var Function_Stop = "Function_Stop";
	public static var Function_Continue = "Function_Continue";
	public static var Function_StopLua:Dynamic = "Function_StopLua";
   
	public static var camGameShaders:Array<ShaderEffect> = [];
	public static var camHUDShaders:Array<ShaderEffect> = [];
	public static var camOtherShaders:Array<ShaderEffect> = [];
 
	#if LUA_ALLOWED
	public var lua:State = null;
	#end

	public var scriptName:String = '';
	public var closed:Bool = false;

	public var accessedProps:Map<String, Dynamic> = null;
	public function new(script:String) {
		#if LUA_ALLOWED
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);
		//trace(lua); //Só pra eu ter noção de como fazer um anticheat aqui

		//trace('Lua version: ' + Lua.version());
		//trace("LuaJIT version: " + Lua.versionJIT());

		var result:Dynamic = LuaL.dofile(lua, script);
		var resultStr:String = Lua.tostring(lua, result);
		if(resultStr != null && result != 0) {
			lime.app.Application.current.window.alert(resultStr, 'Error on .LUA script!');
			trace('Error on .LUA script! ' + resultStr);
			lua = null;
			return;
		}
		scriptName = script;
		trace('Lua file loaded succesfully:' + script);

		#if (haxe >= "4.0.0")
		accessedProps = new Map();
		#else
		accessedProps = new Map<String, Dynamic>();
		#end

		var curState:Dynamic = FlxG.state;
		PlayState.instance = curState;

		// Lua shit
		set('Function_StopLua', "Function_StopLua");
        set('Function_Stop', "Function_Stop");
        set('Function_Continue', "Function_Continue");
		set('luaDebugMode', false);
		set('luaDeprecatedWarnings', true);
		set('inChartEditor', false);

		// Song/Week shit
		set('curBpm', Conductor.bpm);
		set('bpm', PlayState.SONG.bpm);
		set('scrollSpeed', PlayState.SONG.speed);
		set('crochet', Conductor.crochet);
		set('stepCrochet', Conductor.stepCrochet);
	//	set('songLength', FlxG.sound.music.length);
		set('songName', PlayState.SONG.song);
		set('startedCountdown', false);

		set('isStoryMode', PlayState.isStoryMode);
		set('stage', PlayState.SONG.stage);
		set('difficulty', PlayState.storyDifficulty);
		set('weekRaw', PlayState.storyWeek);
		set('week', WeekData.weeksList[PlayState.storyWeek]);
		set('seenCutscene', PlayState.seenCutscene);

		// Camera poo
		set('cameraX', 0);
		set('cameraY', 0);
		
		// Screen stuff
		set('screenWidth', FlxG.width);
		set('screenHeight', FlxG.height);

		// PlayState cringe ass nae nae bullcrap
		set('curBeat', 0);
		set('curStep', 0);

		set('score', 0);
		set('misses', 0);
		set('ghostMisses', 0);
		set('hits', 0);

		set('rating', 0);
		set('ratingName', '');
		set('version', MainMenuStateMobile.psychEngineVersion.trim());
		
		set('inGameOver', false);
		set('mustHitSection', false);
		set('gifPermitido', false);
		set('botPlay', PlayState.cpuControlled);

		for (i in 0...4) {
			set('defaultPlayerStrumX' + i, 0);
			set('defaultPlayerStrumY' + i, 0);
			set('defaultOpponentStrumX' + i, 0);
			set('defaultOpponentStrumY' + i, 0);
			set('defaultthirdplayerStrumX' + i, 0);
			set('defaultthirdarplayerStrumY' + i, 0);
		}

		// Default character positions woooo
		set('defaultBoyfriendX', PlayState.instance.BF_X);
		set('defaultBoyfriendY', PlayState.instance.BF_Y);
		set('defaultOpponentX', PlayState.instance.DAD_X);
		set('defaultOpponentY', PlayState.instance.DAD_Y);
		set('defaultGirlfriendX', PlayState.instance.GF_X);
		set('defaultGirlfriendY', PlayState.instance.GF_Y);

		// Character shit
		set('boyfriendName', PlayState.SONG.player1);
		set('dadName', PlayState.SONG.player2);
		set('gfName', PlayState.SONG.player3); //Fix para Endless Cycles


		set('legendaPath', PlayState.legendPath);
		// Some settings, no jokes
		set('legendas', ClientPrefs.legendas);
		set('legendasporcima', ClientPrefs.legendasporcima);
		set('gore', ClientPrefs.gore);
		set('downscroll', ClientPrefs.downScroll);
		set('middlescroll', ClientPrefs.middleScroll);
		set('framerate', ClientPrefs.framerate);
		set('ghostTapping', ClientPrefs.ghostTapping);
		set('hideHud', ClientPrefs.hideHud);
		set('hideTime', ClientPrefs.hideTime);
		set('cameraZoomOnBeat', ClientPrefs.camZooms);
		set('flashingLights', ClientPrefs.flashing);
		set('noteOffset', ClientPrefs.noteOffset);
		set('lowQuality', ClientPrefs.lowQuality);
		set('hitSounds', ClientPrefs.hitSounds);
		set('cutscene', PlayState.instance.inCutscene);
		set('isRing', PlayState.isRing);

		//stuff 4 noobz like you B)

		

		Lua_helper.add_callback(lua, "addLuaScript", function(luaFile:String, ?ignoreAlreadyRunning:Bool = false) { //would be dope asf.
			var cervix = luaFile + ".lua";
			if(luaFile.endsWith(".lua"))cervix=luaFile;
			var doPush = false;
			cervix = Paths.getPreloadPath(cervix); //Scripts adicionados com isso devem obrigatoriamente fazer referência a pasta custom_scripts
			if(OpenFlAssets.exists(cervix)) {
				doPush = true;
			}

			if(doPush)
			{
				if(!ignoreAlreadyRunning)
				{
					for (luaInstance in PlayState.instance.luaArray)
					{
						if(luaInstance.scriptName == cervix)
						{
							trace('addLuaScript: The script "' + cervix + '" is already running!');
							return;
						}
					}
				}
				PlayState.instance.luaArray.push(new FunkinLua(Utils.Asset2File.getPath(cervix))); //asset2file é apenas um micro ajuste tanto pra mobile quanto pra PC
				//trace(cervix + 'foi carregado');
				return;
			}
			trace("addLuaScript: Script doesn't exist!");
		});
		Lua_helper.add_callback(lua, "pushScriptData", function(luaFile:String, ?ignoreAlreadyRunning:Bool = false) { //Poderia ter só usado um AddLuaScript normal? Poderia mas né? Puta trampo depois pra ir procurar cada script
			var cervix = luaFile + ".lua";
			if(luaFile.endsWith(".lua"))cervix=luaFile;
			var doPush = false;
			cervix = Paths.getPreloadPath('data/' + Paths.formatToSongPath(PlayState.SONG.song) + '/'+cervix); //Scripts adicionados com isso devem obrigatoriamente fazer referência a pasta custom_scripts
			if(OpenFlAssets.exists(cervix)) { //é... Vou nem tirar trace disso pq sei que a resposta seria vergonhosa
				doPush = true;
			}

			if(doPush)
			{
				if(!ignoreAlreadyRunning)
				{
					for (luaInstance in PlayState.instance.luaArray)
					{
						if(luaInstance.scriptName == cervix)
						{
							trace('addLuaScript: The script "' + cervix + '" is already running!');
							return;
						}
					}
				}
				PlayState.instance.luaArray.push(new FunkinLua(Utils.Asset2File.getPath(cervix))); //asset2file é apenas um micro ajuste tanto pra mobile quanto pra PC
				///trace(cervix + ' foi carregado por master.lua');
				return;
			}
			trace("addLuaScript: Script doesn't exist!");
		});

		Lua_helper.add_callback(lua, "removeLuaScript", function(luaFile:String, ?ignoreAlreadyRunning:Bool = false) { //would be dope asf.
			var cervix = luaFile + ".lua";
			if(luaFile.endsWith(".lua"))cervix=luaFile;
			var doPush = false;
			cervix = Paths.getPreloadPath(cervix);
			if(OpenFlAssets.exists(cervix)) {
				doPush = true;
			}

			if(doPush)
			{
				if(!ignoreAlreadyRunning)
				{
					for (luaInstance in PlayState.instance.luaArray)
					{
						if(luaInstance.scriptName == cervix)
						{
							////luaTrace('The script "' + cervix + '" is already running!');

								PlayState.instance.luaArray.remove(luaInstance);
							return;
						}
					}
				}
				return;
			}
			//luaTrace("removeLuaScript: Script doesn't exist!", false, false);
		});

		Lua_helper.add_callback(lua, "getPropertySpecial", function(variable:String) {
			var result:Dynamic = null;
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1)
				result = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
			else
				result = getVarInArray(getInstance(), variable);
			return result;
		});
		
		Lua_helper.add_callback(lua, "getProperty", function(variable:String) {
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = null;
				if(PlayState.instance.modchartSprites.exists(killMe[0])) {
					coverMeInPiss = PlayState.instance.modchartSprites.get(killMe[0]);
				} else {
					coverMeInPiss = Reflect.getProperty(PlayState.instance, killMe[0]);
				}

				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
			}
			return Reflect.getProperty(PlayState.instance, variable);
		});
		Lua_helper.add_callback(lua, "setProperty", function(variable:String, value:Dynamic) {
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				setVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1], value);
				return true;
			}
			setVarInArray(getInstance(), variable, value);
			return true;
		});
		Lua_helper.add_callback(lua, "getPropertyFromGroup", function(obj:String, index:Int, variable:Dynamic) {
			if(Std.isOfType(Reflect.getProperty(PlayState.instance, obj), FlxTypedGroup)) {
				return Reflect.getProperty(Reflect.getProperty(PlayState.instance, obj).members[index], variable);
			}

			var leArray:Dynamic = Reflect.getProperty(PlayState.instance, obj)[index];
			if(leArray != null) {
				if(Type.typeof(variable) == ValueType.TInt) {
					return leArray[variable];
				}
				var killMe:Array<String> = variable.split('.');
				if(killMe.length > 1) {
					var coverMeInPiss:Dynamic = Reflect.getProperty(leArray, killMe[0]);
					for (i in 1...killMe.length-1) {
						coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
					}
					return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
				}
				return Reflect.getProperty(leArray, variable);
			}
			//luaTrace("Object #" + index + " from group: " + obj + " doesn't exist!");
			return null;
		});
		Lua_helper.add_callback(lua, "setPropertyFromGroup", function(obj:String, index:Int, variable:Dynamic, value:Dynamic) {
			if(Std.isOfType(Reflect.getProperty(PlayState.instance, obj), FlxTypedGroup)) {
				return Reflect.setProperty(Reflect.getProperty(PlayState.instance, obj).members[index], variable, value);
			}

			var leArray:Dynamic = Reflect.getProperty(PlayState.instance, obj)[index];
			if(leArray != null) {
				if(Type.typeof(variable) == ValueType.TInt) {
					return leArray[variable] = value;
				}
				var killMe:Array<String> = variable.split('.');
				if(killMe.length > 1) {
					var coverMeInPiss:Dynamic = Reflect.getProperty(leArray, killMe[0]);
					for (i in 1...killMe.length-1) {
						coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
					}
					return Reflect.setProperty(coverMeInPiss, killMe[killMe.length-1], value);
				}
				return Reflect.setProperty(leArray, variable, value);
			}
		});
		Lua_helper.add_callback(lua, "removeFromGroup", function(obj:String, index:Int, dontDestroy:Bool = false) {
			if(Std.isOfType(Reflect.getProperty(PlayState.instance, obj), FlxTypedGroup)) {
				var sex = Reflect.getProperty(PlayState.instance, obj).members[index];
				if(!dontDestroy)
					sex.kill();
				Reflect.getProperty(PlayState.instance, obj).remove(sex, true);
				if(!dontDestroy)
					sex.destroy();
				return;
			}
			Reflect.getProperty(PlayState.instance, obj).remove(Reflect.getProperty(PlayState.instance, obj)[index]);
		});

		Lua_helper.add_callback(lua, "getPropertyFromClass", function(classVar:String, variable:String) {
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = Reflect.getProperty(Type.resolveClass(classVar), killMe[0]);
				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
			}
			return Reflect.getProperty(Type.resolveClass(classVar), variable);
		});
		Lua_helper.add_callback(lua, "setPropertyFromClass", function(classVar:String, variable:String, value:Dynamic) {
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = Reflect.getProperty(Type.resolveClass(classVar), killMe[0]);
				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.setProperty(coverMeInPiss, killMe[killMe.length-1], value);
			}
			return Reflect.setProperty(Type.resolveClass(classVar), variable, value);
		});

		//shitass stuff for epic coders like me B)  *image of obama giving himself a medal*
		Lua_helper.add_callback(lua, "getObjectOrder", function(obj:String) {
			if(PlayState.instance.modchartSprites.exists(obj) && PlayState.instance.modchartSprites.get(obj).wasAdded) {
				return PlayState.instance.members.indexOf(PlayState.instance.modchartSprites.get(obj));
			}

			var leObj:FlxBasic = Reflect.getProperty(PlayState.instance, obj);
			if(leObj != null) {
				return PlayState.instance.members.indexOf(leObj);
			}
			//luaTrace("Object " + obj + " doesn't exist!");
			return -1;
		});
		Lua_helper.add_callback(lua, "setObjectOrder", function(obj:String, position:Int) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				var spr:ModchartSprite = PlayState.instance.modchartSprites.get(obj);
				if(spr.wasAdded) {
					PlayState.instance.remove(spr, true);
					PlayState.instance.insert(position, spr);
					return;
				}
			}

			var leObj:FlxBasic = Reflect.getProperty(PlayState.instance, obj);
			if(leObj != null) {
				PlayState.instance.remove(leObj, true);
				PlayState.instance.insert(position, leObj);
				return;
			}
			//luaTrace("Object " + obj + " doesn't exist!");
		});

		// gay ass tweens
		Lua_helper.add_callback(lua, "doTweenX", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String) {
			var penisExam:Dynamic = tweenShit(tag, vars);
			if(penisExam != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(penisExam, {x: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			} else {
				//luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenY", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String) {
			var penisExam:Dynamic = tweenShit(tag, vars);
			if(penisExam != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(penisExam, {y: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			} else {
				//luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenAngle", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String) {
			var penisExam:Dynamic = tweenShit(tag, vars);
			if(penisExam != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(penisExam, {angle: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			} else {
				//luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "getRandomFloat", function(min:Float, max:Float = 1, exclude:String = '') {
			var excludeArray:Array<String> = exclude.split(',');
			var toExclude:Array<Float> = [];
			for (i in 0...excludeArray.length)
			{
				toExclude.push(Std.parseFloat(excludeArray[i].trim()));
			}
			return FlxG.random.float(min, max, toExclude);
		});
		Lua_helper.add_callback(lua, "getRandomInt", function(min:Int, max:Int = FlxMath.MAX_VALUE_INT, exclude:String = '') {
			var excludeArray:Array<String> = exclude.split(',');
			var toExclude:Array<Int> = [];
			for (i in 0...excludeArray.length)
			{
				toExclude.push(Std.parseInt(excludeArray[i].trim()));
			}
			return FlxG.random.int(min, max, toExclude);
		});
		Lua_helper.add_callback(lua, "doTweenAlpha", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String) {
			var penisExam:Dynamic = tweenShit(tag, vars);
			if(penisExam != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(penisExam, {alpha: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			} else {
				//luaTrace('Couldnt find object: ' + vars);
			}
		});
		Lua_helper.add_callback(lua, "doTweenZoom", function(tag:String, vars:String, value:Dynamic, duration:Float, ease:String) {
			var penisExam:Dynamic = tweenShit(tag, vars);
			if(penisExam != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(penisExam, {zoom: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			} else {
				//luaTrace('Couldnt find object: ' + vars);
			}
		});

		
		Lua_helper.add_callback(lua, "doTweenColor", function(tag:String, vars:String, targetColor:String, duration:Float, ease:String) {
			var penisExam:Dynamic = tweenShit(tag, vars);
			if(penisExam != null) {
				var color:Int = Std.parseInt(targetColor);
				if(!targetColor.startsWith('0x')) color = Std.parseInt('0xff' + targetColor);

				PlayState.instance.modchartTweens.set(tag, FlxTween.color(penisExam, duration, penisExam.color, color, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.modchartTweens.remove(tag);
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
					}
				}));
			} else {
				//luaTrace('Couldnt find object: ' + vars);
			}
		});

		//Tween shit, but for strums
		Lua_helper.add_callback(lua, "noteTweenX", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String) {
			cancelTween(tag);
			if(note < 0) note = 0;
			var testicle:StrumNote = PlayState.instance.strumLineNotes.members[note % PlayState.instance.strumLineNotes.length];

			if(testicle != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(testicle, {x: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			}
		});
		Lua_helper.add_callback(lua, "noteTweenY", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String) {
			cancelTween(tag);
			if(note < 0) note = 0;
			var testicle:StrumNote = PlayState.instance.strumLineNotes.members[note % PlayState.instance.strumLineNotes.length];

			if(testicle != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(testicle, {y: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			}
		});
		Lua_helper.add_callback(lua, "noteTweenAngle", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String) {
			cancelTween(tag);
			if(note < 0) note = 0;
			var testicle:StrumNote = PlayState.instance.strumLineNotes.members[note % PlayState.instance.strumLineNotes.length];

			if(testicle != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(testicle, {angle: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			}
		});
		Lua_helper.add_callback(lua, "noteTweenAlpha", function(tag:String, note:Int, value:Dynamic, duration:Float, ease:String) {
			cancelTween(tag);
			if(note < 0) note = 0;
			var testicle:StrumNote = PlayState.instance.strumLineNotes.members[note % PlayState.instance.strumLineNotes.length];

			if(testicle != null) {
				PlayState.instance.modchartTweens.set(tag, FlxTween.tween(testicle, {alpha: value}, duration, {ease: getFlxEaseByString(ease),
					onComplete: function(twn:FlxTween) {
						PlayState.instance.callOnLuas('onTweenCompleted', [tag]);
						PlayState.instance.modchartTweens.remove(tag);
					}
				}));
			}
		});

		Lua_helper.add_callback(lua, "cancelTween", function(tag:String) {
			cancelTween(tag);
		});

		Lua_helper.add_callback(lua, "runTimer", function(tag:String, time:Float = 1, loops:Int = 1) {
			cancelTimer(tag);
			PlayState.instance.modchartTimers.set(tag, new FlxTimer().start(time, function(tmr:FlxTimer) {
				if(tmr.finished) {
					PlayState.instance.modchartTimers.remove(tag);
				}
				PlayState.instance.callOnLuas('onTimerCompleted', [tag, tmr.loops, tmr.loopsLeft]);
				//trace('Timer Completed: ' + tag);
			}, loops));
		});
		Lua_helper.add_callback(lua, "cancelTimer", function(tag:String) {
			cancelTimer(tag);
		});

		/*Lua_helper.add_callback(lua, "getPropertyAdvanced", function(varsStr:String) {
			var variables:Array<String> = varsStr.replace(' ', '').split(',');
			var leClass:Class<Dynamic> = Type.resolveClass(variables[0]);
			if(variables.length > 2) {
				var curProp:Dynamic = Reflect.getProperty(leClass, variables[1]);
				if(variables.length > 3) {
					for (i in 2...variables.length-1) {
						curProp = Reflect.getProperty(curProp, variables[i]);
					}
				}
				return Reflect.getProperty(curProp, variables[variables.length-1]);
			} else if(variables.length == 2) {
				return Reflect.getProperty(leClass, variables[variables.length-1]);
			}
			return null;
		});
		Lua_helper.add_callback(lua, "setPropertyAdvanced", function(varsStr:String, value:Dynamic) {
			var variables:Array<String> = varsStr.replace(' ', '').split(',');
			var leClass:Class<Dynamic> = Type.resolveClass(variables[0]);
			if(variables.length > 2) {
				var curProp:Dynamic = Reflect.getProperty(leClass, variables[1]);
				if(variables.length > 3) {
					for (i in 2...variables.length-1) {
						curProp = Reflect.getProperty(curProp, variables[i]);
					}
				}
				return Reflect.setProperty(curProp, variables[variables.length-1], value);
			} else if(variables.length == 2) {
				return Reflect.setProperty(leClass, variables[variables.length-1], value);
			}
		});*/
		
		//stupid bietch ass functions
		Lua_helper.add_callback(lua, "addScore", function(value:Int = 0) {
			PlayState.instance.songScore += value;
			PlayState.instance.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "addMisses", function(value:Int = 0) {
			PlayState.instance.songMisses += value;
			PlayState.instance.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "addHits", function(value:Int = 0) {
			PlayState.instance.songHits += value;
			PlayState.instance.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setScore", function(value:Int = 0) {
			PlayState.instance.songScore = value;
			PlayState.instance.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setMisses", function(value:Int = 0) {
			PlayState.instance.songMisses = value;
			PlayState.instance.RecalculateRating();
		});
		Lua_helper.add_callback(lua, "setHits", function(value:Int = 0) {
			PlayState.instance.songHits = value;
			PlayState.instance.RecalculateRating();
		});
		
		Lua_helper.add_callback(lua, "getColorFromHex", function(color:String) {
			if(!color.startsWith('0x')) color = '0xff' + color;
			return Std.parseInt(color);
		});
		Lua_helper.add_callback(lua, "keyJustPressed", function(name:String) {
			var key:Bool = false;
			switch(name) {
				case 'left': key = PlayState.instance.getControl('NOTE_LEFT_P');
				case 'down': key = PlayState.instance.getControl('NOTE_DOWN_P');
				case 'up': key = PlayState.instance.getControl('NOTE_UP_P');
				case 'right': key = PlayState.instance.getControl('NOTE_RIGHT_P');
				case 'accept': key = PlayState.instance.getControl('ACCEPT');
				case 'back': key = PlayState.instance.getControl('BACK');
				case 'pause': key = PlayState.instance.getControl('PAUSE');
				case 'reset': key = PlayState.instance.getControl('RESET');
				case 'space': key = PlayState.instance.getControl('NOTE_SPACE_P'); //Apenas para que a Chaos e Final Escape possam usar o botão custom
				case '0': key = FlxG.keys.justPressed.ZERO; // esses números eram do vs calculadora k
				case '1': key = FlxG.keys.justPressed.ONE;
				case '2': key = FlxG.keys.justPressed.TWO;
				case '3': key = FlxG.keys.justPressed.THREE;	
				case '4': key = FlxG.keys.justPressed.FOUR;	
				case '5': key = FlxG.keys.justPressed.FIVE;
				case '6': key = FlxG.keys.justPressed.SIX;
				case '7': key = FlxG.keys.justPressed.SEVEN;
				case '8': key = FlxG.keys.justPressed.EIGHT;
				case '9': key = FlxG.keys.justPressed.NINE;
			}
			return key;
		});
		Lua_helper.add_callback(lua, "setHealth", function(value:Float = 0) {
			PlayState.instance.health = value;
		});
		Lua_helper.add_callback(lua, "keyPressed", function(name:String) {
			var key:Bool = false;
			switch(name) {
				case 'left': key = PlayState.instance.getControl('NOTE_LEFT');
				case 'down': key = PlayState.instance.getControl('NOTE_DOWN');
				case 'up': key = PlayState.instance.getControl('NOTE_UP');
				case 'right': key = PlayState.instance.getControl('NOTE_RIGHT');
			}
			return key;
		});
		Lua_helper.add_callback(lua, "keyReleased", function(name:String) {
			var key:Bool = false;
			switch(name) {
				case 'left': key = PlayState.instance.getControl('NOTE_LEFT_R');
				case 'down': key = PlayState.instance.getControl('NOTE_DOWN_R');
				case 'up': key = PlayState.instance.getControl('NOTE_UP_R');
				case 'right': key = PlayState.instance.getControl('NOTE_RIGHT_R');
			}
			return key;
		});
		Lua_helper.add_callback(lua, "addCharacterToList", function(name:String, type:String) {
			var charType:Int = 0;
			switch(type.toLowerCase()) {
				case 'dad': charType = 1;
				case 'gf' | 'girlfriend': charType = 2;
			}
			PlayState.instance.addCharacterToList(name, charType);
		});
		Lua_helper.add_callback(lua, "precacheImage", function(name:String) {
			PlayState.instance.precacheList.set(name, 'image');
		});
		Lua_helper.add_callback(lua, "precacheSound", function(name:String) {
			PlayState.instance.precacheList.set(name, 'sound');
		});
		Lua_helper.add_callback(lua, "triggerEvent", function(name:String, arg1:Dynamic, arg2:Dynamic, arg3:Dynamic, arg4:Dynamic, arg5:Dynamic) {
			var value1:String = arg1;
			var value2:String = arg2;
			var value3:String = arg3;
			var value4:String = arg4;
			PlayState.instance.triggerEventNote(name, value1, value2, value3, value4);
			//trace('Triggered event: ' + name + ', ' + value1 + ', ' + value2);
		});

		Lua_helper.add_callback(lua, "startCountdown", function(variable:String) {
			PlayState.instance.startCountdown();
		});
		Lua_helper.add_callback(lua, "endSong", function() {
			PlayState.instance.KillNotes();
			PlayState.instance.endSong();
		});
		Lua_helper.add_callback(lua, "getSongPosition", function() {
			return Conductor.songPosition;
		});

		Lua_helper.add_callback(lua, "getCharacterX", function(type:String) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					return PlayState.instance.dadGroup.x;
				case 'gf' | 'girlfriend':
					return PlayState.instance.gfGroup.x;
				default:
					return PlayState.instance.boyfriendGroup.x;
			}
		});
		Lua_helper.add_callback(lua, "setCharacterX", function(type:String, value:Float) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					PlayState.instance.dadGroup.x = value;
				case 'gf' | 'girlfriend':
					PlayState.instance.gfGroup.x = value;
				default:
					PlayState.instance.boyfriendGroup.x = value;
			}
		});
		Lua_helper.add_callback(lua, "getCharacterY", function(type:String) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					return PlayState.instance.dadGroup.y;
				case 'gf' | 'girlfriend':
					return PlayState.instance.gfGroup.y;
				default:
					return PlayState.instance.boyfriendGroup.y;
			}
		});
		Lua_helper.add_callback(lua, "setCharacterY", function(type:String, value:Float) {
			switch(type.toLowerCase()) {
				case 'dad' | 'opponent':
					PlayState.instance.dadGroup.y = value;
				case 'gf' | 'girlfriend':
					PlayState.instance.gfGroup.y = value;
				default:
					PlayState.instance.boyfriendGroup.y = value;
			}
		});
		Lua_helper.add_callback(lua, "cameraSetTarget", function(target:String) {
			var isDad:Bool = false;
			if(target == 'dad') {
				isDad = true;
			}
			PlayState.instance.moveCamera(isDad);
		});
		Lua_helper.add_callback(lua, "cameraShake", function(camera:String, intensity:Float, duration:Float) {
			cameraFromString(camera).shake(intensity, duration);
		});
		Lua_helper.add_callback(lua, "setRatingPercent", function(value:Float) {
			PlayState.instance.ratingPercent = value;
		});
		Lua_helper.add_callback(lua, "setRatingString", function(value:String) {
			PlayState.instance.ratingString = value;
		});
		Lua_helper.add_callback(lua, "getMouseX", function(camera:String) {
			var cam:FlxCamera = cameraFromString(camera);
			return FlxG.mouse.getScreenPosition(cam).x;
		});
		Lua_helper.add_callback(lua, "getMouseY", function(camera:String) {
			var cam:FlxCamera = cameraFromString(camera);
			return FlxG.mouse.getScreenPosition(cam).y;
		});
		//Furtado da Psych 6.3 apenas para ser usado na Slaybells
		Lua_helper.add_callback(lua, "addOffset", function(obj:String, anim:String, x:Float, y:Float) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				PlayState.instance.modchartSprites.get(obj).animOffsets.set(anim, [x, y]);
				return true;
			}

			var char:Character = Reflect.getProperty(getInstance(), obj);
			if(char != null) {
				char.addOffset(anim, x, y);
				return true;
			}
			return false;
		});
		Lua_helper.add_callback(lua, "characterPlayAnim", function(character:String, anim:String, ?forced:Bool = false) {
			switch(character.toLowerCase()) {
				case 'dad':
					if(PlayState.instance.dad.animOffsets.exists(anim))
						PlayState.instance.dad.playAnim(anim, forced);
				case 'gf' | 'girlfriend':
					if(PlayState.instance.gf.animOffsets.exists(anim))
						PlayState.instance.gf.playAnim(anim, forced);
				default: 
					if(PlayState.instance.boyfriend.animOffsets.exists(anim))
						PlayState.instance.boyfriend.playAnim(anim, forced);
			}
		});
		Lua_helper.add_callback(lua, "cameraFade", function(camera:String, color:String, duration:Float,forced:Bool) {
			var colorNum:Int = Std.parseInt(color);
			if(!color.startsWith('0x')) colorNum = Std.parseInt('0xff' + color);
			cameraFromString(camera).fade(colorNum, duration,false,null,forced);
		});
		Lua_helper.add_callback(lua, "characterDance", function(character:String) {
			switch(character.toLowerCase()) {
				case 'dad': PlayState.instance.dad.dance();
				case 'gf' | 'girlfriend': PlayState.instance.gf.dance();
				default: PlayState.instance.boyfriend.dance();
			}
		});

		Lua_helper.add_callback(lua, "makeLuaSprite", function(tag:String, image:String, x:Float, y:Float) {
			if(image != 'nil' && image != '' || !tag.startsWith('exe')){ //Pelo menos alguma coisa está funcionando
				//Basicamente é só manter o 'exe' como váriavel das lyrics que tudo dará certo
			tag = tag.replace('.', '');
			resetSpriteTag(tag);
			var leSprite:ModchartSprite = new ModchartSprite(x, y);
			leSprite.moves = false; //Experimental btw (Considerando que é uma mudança global para performance, tenho medo do que possa acontecer...)
			leSprite.loadGraphic(Paths.image(image));
			leSprite.antialiasing = ClientPrefs.globalAntialiasing;
			PlayState.instance.modchartSprites.set(tag, leSprite);
			leSprite.active = true;
			}
		});

		Lua_helper.add_callback(lua, "makeLuaTiledSprite", function(tag:String, image:String, width:Float, height:Float, repeteEmX:Bool, repeteEmY:Bool) {
			tag = tag.replace('.', '');
			resetTiledSpriteTag(tag);
			var leSprite:ModchartTiledSprite = new ModchartTiledSprite(width, height, repeteEmX, repeteEmY);
			leSprite.loadGraphic(Paths.image(image));
			leSprite.moves = false;
			leSprite.antialiasing = ClientPrefs.globalAntialiasing;
			PlayState.instance.modchartTiledSprites.set(tag, leSprite);
			leSprite.active = true;
		});

		/*Lua_helper.add_callback(lua, "makeLuaSpriteNoAntialiasing", function(tag:String, image:String, x:Float, y:Float) {
			tag = tag.replace('.', '');
			resetSpriteTag(tag);
			var leSprite:ModchartSprite = new ModchartSprite(x, y);
			if(OpenFlAssets.exists(Paths.imagechecker(image))){
				leSprite.loadGraphic(Paths.image(image));
				} else if(image != 'nil' && image.length > 1 && image != 'nil'){
					FlxG.log.add('não achei ' + image + " em " + LoadingState.directoryreader + " então vou procurar em preload");
						leSprite.loadGraphic(Paths.image(image, 'preload'));
				}
			leSprite.antialiasing = false;
			PlayState.instance.modchartSprites.set(tag, leSprite);
			leSprite.active = true;
		});*/ // tecnicamente n precisa disso já que é só mudar o property antialising do sprite por lua através do setProperty('nomedosprite', false ou true), na época (2021) eu n sabia disso e usava isso aqui pros sprites pixel

		Lua_helper.add_callback(lua, "makeAnimatedLuaSprite", function(tag:String, image:String, x:Float, y:Float) { //Modificação usada única e exclusivamente em Pasta night... Maldito hypno...
			tag = tag.replace('.', '');
			resetSpriteTag(tag);

			var leSprite:ModchartSprite = new ModchartSprite(x, y);
			leSprite.frames = Paths.getSparrowAtlas(image);
			leSprite.antialiasing = ClientPrefs.globalAntialiasing;
			PlayState.instance.modchartSprites.set(tag, leSprite);
		});

		Lua_helper.add_callback(lua,"playVideo", function() {
			if (!GlobalVideo.get().playing)
				GlobalVideo.get().play();
		});

		Lua_helper.add_callback(lua,"pauseVideo", function() {
			if (!GlobalVideo.get().paused)
				GlobalVideo.get().pause();
		});

		Lua_helper.add_callback(lua,"resumeVideo", function() {
			if (GlobalVideo.get().paused)
				GlobalVideo.get().pause(); //Talvez eu deveria arrumar isso...
		});
		
		Lua_helper.add_callback(lua,"restartVideo", function() {
			GlobalVideo.get().restart();
		});

		Lua_helper.add_callback(lua, "makeGraphic", function(obj:String, width:Int, height:Int, color:String) {
			var colorNum:Int = Std.parseInt(color);
			if(!color.startsWith('0x')) colorNum = Std.parseInt('0xff' + color);

			if(PlayState.instance.modchartSprites.exists(obj)) {
				if (color == '000000')
					PlayState.instance.modchartSprites.get(obj).makeGraphic(width, height, FlxColor.BLACK);
				else
					PlayState.instance.modchartSprites.get(obj).makeGraphic(width, height, colorNum);
				//Sussy hack pro meu PC racista, feminista, taxista, violinista, cavalista, etc... etc... etc...
				//Podem cancelar ele no tinder.
				return;
			}

			var object:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(object != null) {
					object.makeGraphic(width, height, colorNum);
			}
		});
		Lua_helper.add_callback(lua, "addAnimationByPrefix", function(obj:String, name:String, prefix:String, framerate:Int = 24, loop:Bool = true) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				var cock:ModchartSprite = PlayState.instance.modchartSprites.get(obj);
				cock.animation.addByPrefix(name, prefix, framerate, loop);
				if(cock.animation.curAnim == null) {
					cock.animation.play(name, true);
				}
				return;
			}
			
			var cock:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(cock != null) {
				cock.animation.addByPrefix(name, prefix, framerate, loop);
				if(cock.animation.curAnim == null) {
					cock.animation.play(name, true);
				}
			}
		});
		Lua_helper.add_callback(lua, "addAnimationByIndices", function(obj:String, name:String, prefix:String, indices:String, framerate:Int = 24) {
			var strIndices:Array<String> = indices.trim().split(',');
			var die:Array<Int> = [];
			for (i in 0...strIndices.length) {
				die.push(Std.parseInt(strIndices[i]));
			}

			if(PlayState.instance.modchartSprites.exists(obj)) {
				var pussy:ModchartSprite = PlayState.instance.modchartSprites.get(obj);
				pussy.animation.addByIndices(name, prefix, die, '', framerate, false);
				if(pussy.animation.curAnim == null) {
					pussy.animation.play(name, true);
				}
				return;
			}
			
			var pussy:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(pussy != null) {
				pussy.animation.addByIndices(name, prefix, die, '', framerate, false);
				if(pussy.animation.curAnim == null) {
					pussy.animation.play(name, true);
				}
			}
		});
		Lua_helper.add_callback(lua, "objectPlayAnimation", function(obj:String, name:String, forced:Bool = false) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				PlayState.instance.modchartSprites.get(obj).animation.play(name, forced);
				return;
			}
			else if(PlayState.instance.modchartTiledSprites.exists(obj)) {
				PlayState.instance.modchartSprites.get(obj).animation.play(name, forced);
				return;
			}

			var spr:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(spr != null) {
				spr.animation.play(name, forced);
			}
		});

		Lua_helper.add_callback(lua, "playAnim", function(obj:String, name:String, forced:Bool = false, ?reverse:Bool = false, ?startFrame:Int = 0)
			{
				if(PlayState.instance.getLuaObject(obj, false) != null) {
					var luaObj:FlxSprite = PlayState.instance.getLuaObject(obj,false);
					if(luaObj.animation.getByName(name) != null)
					{
						luaObj.animation.play(name, forced, reverse, startFrame);
						if(Std.isOfType(luaObj, ModchartSprite))
						{
							//convert luaObj to ModchartSprite
							var obj:Dynamic = luaObj;
							var luaObj:ModchartSprite = obj;
	
							var daOffset = luaObj.animOffsets.get(name);
							if (luaObj.animOffsets.exists(name))
							{
								luaObj.offset.set(daOffset[0], daOffset[1]);
							}
						}
					}
					return true;
				}
	
				var spr:FlxSprite = Reflect.getProperty(getInstance(), obj);
				if(spr != null) {
					if(spr.animation.getByName(name) != null)
					{
						if(Std.isOfType(spr, Character))
						{
							//convert spr to Character
							var obj:Dynamic = spr;
							var spr:Character = obj;
							spr.playAnim(name, forced, reverse, startFrame);
						}
						else
							spr.animation.play(name, forced, reverse, startFrame);
					}
					return true;
				}
				return false;
			});
		
		Lua_helper.add_callback(lua, "setScrollFactor", function(obj:String, scrollX:Float, scrollY:Float) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				PlayState.instance.modchartSprites.get(obj).scrollFactor.set(scrollX, scrollY);
				return;
			}else if(PlayState.instance.modchartTiledSprites.exists(obj)){
				PlayState.instance.modchartTiledSprites.get(obj).scrollFactor.set(scrollX, scrollY);
				return;
			}

			var object:FlxObject = Reflect.getProperty(PlayState.instance, obj);
			if(object != null) {
				object.scrollFactor.set(scrollX, scrollY);
			}
		});
		Lua_helper.add_callback(lua, "addLuaSprite", function(tag:String, front:Bool = false) {
			if(PlayState.instance.modchartSprites.exists(tag)) {
				var shit:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
				if(!shit.wasAdded) {
					if(front) {
						PlayState.instance.add(shit);
					} else {
						var position:Int = PlayState.instance.members.indexOf(PlayState.instance.gfGroup);
						if(PlayState.instance.members.indexOf(PlayState.instance.boyfriendGroup) < position) {
							position = PlayState.instance.members.indexOf(PlayState.instance.boyfriendGroup);
						} else if(PlayState.instance.members.indexOf(PlayState.instance.dadGroup) < position) {
							position = PlayState.instance.members.indexOf(PlayState.instance.dadGroup);
						}
						PlayState.instance.insert(position, shit);
					}
					shit.wasAdded = true;
				}
			}else if(PlayState.instance.modchartTiledSprites.exists(tag)) {
				var shit:ModchartTiledSprite = PlayState.instance.modchartTiledSprites.get(tag);
				if(!shit.wasAdded) {
					if(front) {
						PlayState.instance.add(shit);
					} else {
						var position:Int = PlayState.instance.members.indexOf(PlayState.instance.gfGroup);
						if(PlayState.instance.members.indexOf(PlayState.instance.boyfriendGroup) < position) {
							position = PlayState.instance.members.indexOf(PlayState.instance.boyfriendGroup);
						} else if(PlayState.instance.members.indexOf(PlayState.instance.dadGroup) < position) {
							position = PlayState.instance.members.indexOf(PlayState.instance.dadGroup);
						}
						PlayState.instance.insert(position, shit);
					}
					shit.wasAdded = true;
				}
			}
		});
		Lua_helper.add_callback(lua, "setGraphicSize", function(obj:String, x:Int, y:Int = 0) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				var shit:ModchartSprite = PlayState.instance.modchartSprites.get(obj);
				shit.setGraphicSize(x, y);
				shit.updateHitbox();
				return;
			}

			var poop:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(poop != null) {
				poop.setGraphicSize(x, y);
				poop.updateHitbox();
				return;
			}
			//luaTrace('Couldnt find object: ' + obj);
		});
		Lua_helper.add_callback(lua, "scaleObject", function(obj:String, x:Float, y:Float) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				var shit:ModchartSprite = PlayState.instance.modchartSprites.get(obj);
				shit.scale.set(x, y);
				shit.updateHitbox();
				return;
			}

			var poop:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(poop != null) {
				poop.scale.set(x, y);
				poop.updateHitbox();
				return;
			}
			//luaTrace('Couldnt find object: ' + obj);
		});
		Lua_helper.add_callback(lua, "updateHitbox", function(obj:String) {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				var shit:ModchartSprite = PlayState.instance.modchartSprites.get(obj);
				shit.updateHitbox();
				return;
			}

			var poop:FlxSprite = Reflect.getProperty(PlayState.instance, obj);
			if(poop != null) {
				poop.updateHitbox();
				return;
			}
			//luaTrace('Couldnt find object: ' + obj);
		});
		Lua_helper.add_callback(lua, "removeLuaSprite", function(tag:String, destroy:Bool = true) {
			if(!PlayState.instance.modchartSprites.exists(tag) && !PlayState.instance.modchartTiledSprites.exists(tag)) {
				return;
			}
			
			if(!PlayState.instance.modchartTiledSprites.exists(tag)){
				var pee:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
				if(destroy) {
					pee.kill();
				}
	
				if(pee.wasAdded) {
					PlayState.instance.remove(pee, true);
					pee.wasAdded = false;
				}
	
				if(destroy) {
					pee.destroy();
					PlayState.instance.modchartSprites.remove(tag);
				}
			}else{
				var pee:ModchartTiledSprite = PlayState.instance.modchartTiledSprites.get(tag);
				if(destroy) {
					pee.kill();
				}
	
				if(pee.wasAdded) {
					PlayState.instance.remove(pee, true);
					pee.wasAdded = false;
				}
	
				if(destroy) {
					pee.destroy();
					PlayState.instance.modchartTiledSprites.remove(tag);
				}
			}
		});

		Lua_helper.add_callback(lua, "setObjectCamera", function(obj:String, camera:String = '') {
			if(PlayState.instance.modchartSprites.exists(obj)) {
				PlayState.instance.modchartSprites.get(obj).cameras = [cameraFromString(camera)];
				return true;
			}else if(PlayState.instance.modchartTexts.exists(obj)) {
				PlayState.instance.modchartTexts.get(obj).cameras = [cameraFromString(camera)];
				return true;
			}

			var object:FlxObject = Reflect.getProperty(PlayState.instance, obj);
			if(object != null) {
				object.cameras = [cameraFromString(camera)];
				return true;
			}
			//luaTrace("Object " + obj + " doesn't exist!");
			return false;
		});
		Lua_helper.add_callback(lua, "setBlendMode", function(obj:String, blend:String = '') {
			var real = PlayState.instance.getLuaObject(obj);
			if(real!=null) {
				real.blend = blendModeFromString(blend);
				return true;
			}

			var killMe:Array<String> = obj.split('.');
			var spr:FlxSprite = getObjectDirectly(killMe[0]);
			if(killMe.length > 1) {
				spr = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
			}

			if(spr != null) {
				spr.blend = blendModeFromString(blend);
				return true;
			}
			//luaTrace("setBlendMode: Object " + obj + " doesn't exist!", false, false);
			return false;
		});
		Lua_helper.add_callback(lua, "screenCenter", function(obj:String, pos:String = 'xy') {
			var spr:FlxSprite = PlayState.instance.getLuaObject(obj);

			if(spr==null){
				var killMe:Array<String> = obj.split('.');
				spr = getObjectDirectly(killMe[0]);
				if(killMe.length > 1) {
					spr = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
				}
			}

			if(spr != null)
			{
				switch(pos.trim().toLowerCase())
				{
					case 'x':
						spr.screenCenter(X);
						return;
					case 'y':
						spr.screenCenter(Y);
						return;
					default:
						spr.screenCenter(XY);
						return;
				}
			}
			//luaTrace("screenCenter: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
		});
		Lua_helper.add_callback(lua, "startDialogue", function(dialogueFile:String, music:String = null) {
			var path:String = Paths.json(Paths.formatToSongPath(PlayState.SONG.song) + '/' + dialogueFile);
			//luaTrace('Trying to load dialogue: ' + path);

			if(OpenFlAssets.exists(path)) {
				var shit:DialogueFile = DialogueBoxPsych.parseDialogue(path);
				if(shit.dialogue.length > 0) {
					PlayState.instance.startDialogue(shit, music);
					//luaTrace('Successfully loaded dialogue');
				} else {
					//luaTrace('Your dialogue file is badly formatted!');
				}
			} else {
				//luaTrace('Dialogue file not found');
				if(PlayState.instance.endingSong) {
					PlayState.instance.endSong();
				} else {
					PlayState.instance.startCountdown();
				}
			}
		});
		Lua_helper.add_callback(lua, "startVideo", function(videoFile:String) {
			#if VIDEOS_ALLOWED
			if(OpenFlAssets.exists("assets/videos/" + videoFile + ".webm")) 
			{
				PlayState.instance.startVideo(videoFile);
			} 
			else 
			{
				//luaTrace('Video file not found: ' + videoFile);
			}
			#else
			if(PlayState.instance.endingSong) 
			{
				PlayState.instance.endSong();
			} 
			else 
			{
				PlayState.instance.startCountdown();
			}
			#end
		});
		
		Lua_helper.add_callback(lua, "playMusic", function(sound:String, volume:Float = 1, loop:Bool = false) {
			FlxG.sound.playMusic(Paths.music(sound), volume, loop);
		});
		Lua_helper.add_callback(lua, "mudarRPCdetalhes", function(texto:String) {
			PlayState.instance.updateRPC(texto);
		});
		Lua_helper.add_callback(lua, "cyCut", function(texto:String) {
			PlayState.instance.cyCutscene(texto);
		});
		Lua_helper.add_callback(lua, "playSound", function(sound:String, volume:Float = 1, ?tag:String = null) {
			if(tag != null && tag.length > 0) {
				tag = tag.replace('.', '');
				if(PlayState.instance.modchartSounds.exists(tag)) {
					PlayState.instance.modchartSounds.get(tag).stop();
				}
				PlayState.instance.modchartSounds.set(tag, FlxG.sound.play(Paths.sound(sound), volume, false, function() {
					PlayState.instance.modchartSounds.remove(tag);
					PlayState.instance.callOnLuas('onSoundFinished', [tag]);
				}));
				return;
			}
			FlxG.sound.play(Paths.sound(sound), volume);
		});
		Lua_helper.add_callback(lua, "stopSound", function(tag:String) {
			if(tag != null && tag.length > 1 && PlayState.instance.modchartSounds.exists(tag)) {
				PlayState.instance.modchartSounds.get(tag).stop();
				PlayState.instance.modchartSounds.remove(tag);
			}
		});
		Lua_helper.add_callback(lua, "pauseSound", function(tag:String) {
			if(tag != null && tag.length > 1 && PlayState.instance.modchartSounds.exists(tag)) {
				PlayState.instance.modchartSounds.get(tag).pause();
			}
		});
		Lua_helper.add_callback(lua, "resumeSound", function(tag:String) {
			if(tag != null && tag.length > 1 && PlayState.instance.modchartSounds.exists(tag)) {
				PlayState.instance.modchartSounds.get(tag).play();
			}
		});
		Lua_helper.add_callback(lua, "soundFadeIn", function(tag:String, duration:Float, fromValue:Float = 0, toValue:Float = 1) {
			if(tag == null || tag.length < 1) {
				FlxG.sound.music.fadeIn(duration, fromValue, toValue);
			} else if(PlayState.instance.modchartSounds.exists(tag)) {
				PlayState.instance.modchartSounds.get(tag).fadeIn(duration, fromValue, toValue);
			}
			
		});
		Lua_helper.add_callback(lua, "soundFadeOut", function(tag:String, duration:Float, toValue:Float = 0) {
			if(tag == null || tag.length < 1) {
				FlxG.sound.music.fadeOut(duration, toValue);
			} else if(PlayState.instance.modchartSounds.exists(tag)) {
				PlayState.instance.modchartSounds.get(tag).fadeOut(duration, toValue);
			}
		});
		Lua_helper.add_callback(lua, "soundFadeCancel", function(tag:String) {
			if(tag == null || tag.length < 1) {
				if(FlxG.sound.music.fadeTween != null) {
					FlxG.sound.music.fadeTween.cancel();
				}
			} else if(PlayState.instance.modchartSounds.exists(tag)) {
				var theSound:FlxSound = PlayState.instance.modchartSounds.get(tag);
				if(theSound.fadeTween != null) {
					theSound.fadeTween.cancel();
					PlayState.instance.modchartSounds.remove(tag);
				}
			}
		});
		Lua_helper.add_callback(lua, "getSoundVolume", function(tag:String) {
			if(tag == null || tag.length < 1) {
				if(FlxG.sound.music != null) {
					return FlxG.sound.music.volume;
				}
			} else if(PlayState.instance.modchartSounds.exists(tag)) {
				return PlayState.instance.modchartSounds.get(tag).volume;
			}
			return 0;
		});
		Lua_helper.add_callback(lua, "cameraFlash", function(camera:String, color:String, duration:Float,forced:Bool) {
			var colorNum:Int = Std.parseInt(color);
			if(!color.startsWith('0x')) colorNum = Std.parseInt('0xff' + color);
			cameraFromString(camera).flash(colorNum, duration,null,forced);
		});
		Lua_helper.add_callback(lua, "setSoundVolume", function(tag:String, value:Float) {
			if(tag == null || tag.length < 1) {
				if(FlxG.sound.music != null) {
					FlxG.sound.music.volume = value;
				}
			} else if(PlayState.instance.modchartSounds.exists(tag)) {
				PlayState.instance.modchartSounds.get(tag).volume = value;
			}
		});
		Lua_helper.add_callback(lua, "getSoundTime", function(tag:String) {
			if(tag != null && tag.length > 0 && PlayState.instance.modchartSounds.exists(tag)) {
				return PlayState.instance.modchartSounds.get(tag).time;
			}
			return 0;
		});
		Lua_helper.add_callback(lua, "setSoundTime", function(tag:String, value:Float) {
			if(tag != null && tag.length > 0 && PlayState.instance.modchartSounds.exists(tag)) {
				var theSound:FlxSound = PlayState.instance.modchartSounds.get(tag);
				if(theSound != null) {
					var wasResumed:Bool = theSound.playing;
					theSound.pause();
					theSound.time = value;
					if(wasResumed) theSound.play();
				}
			}
		});

		Lua_helper.add_callback(lua, "debugPrint", function(text1:Dynamic = '', text2:Dynamic = '', text3:Dynamic = '', text4:Dynamic = '', text5:Dynamic = '') {
			if (text1 == null) text1 = '';
			if (text2 == null) text2 = '';
			if (text3 == null) text3 = '';
			if (text4 == null) text4 = '';
			if (text5 == null) text5 = '';
			//luaTrace('' + text1 + text2 + text3 + text4 + text5, true, false);
		});
		Lua_helper.add_callback(lua, "close", function() {
			closed = true;
			return closed;
		});

		Lua_helper.add_callback(lua, "startachieving", function(achieveID:String) {
			if(achieveID != null && achieveID.length > 0 && Achievements.getAchievementIndex(achieveID) != -1)
				return PlayState.instance.startachieving(achieveID);
			else
				FlxG.log.add('Não existe achievement com o nome de ' + achieveID);
		});

		//É... Aos poucos vou sendo cada vez mais obrigado a portar a arrumar a Final Escape...
		// LUA TEXTS
		Lua_helper.add_callback(lua, "makeLuaText", function(tag:String, text:String, width:Int, x:Float, y:Float) {
			tag = tag.replace('.', '');
			resetTextTag(tag);
			var leText:ModchartText = new ModchartText(x, y, text, width);
			PlayState.instance.modchartTexts.set(tag, leText);
		});

		Lua_helper.add_callback(lua, "setTextString", function(tag:String, text:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				obj.text = text;
				return true;
			}
			//luaTrace("setTextString: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextSize", function(tag:String, size:Int) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				obj.size = size;
				return true;
			}
			//luaTrace("setTextSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextWidth", function(tag:String, width:Float) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				obj.fieldWidth = width;
				return true;
			}
			//luaTrace("setTextWidth: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextBorder", function(tag:String, size:Int, color:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				var colorNum:Int = Std.parseInt(color);
				if(!color.startsWith('0x')) colorNum = Std.parseInt('0xff' + color);

				obj.borderSize = size;
				obj.borderColor = colorNum;
				return true;
			}
			//luaTrace("setTextBorder: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextColor", function(tag:String, color:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				var colorNum:Int = Std.parseInt(color);
				if(!color.startsWith('0x')) colorNum = Std.parseInt('0xff' + color);

				obj.color = colorNum;
				return true;
			}
			//luaTrace("setTextColor: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextFont", function(tag:String, newFont:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				obj.font = Paths.font(newFont);
				return true;
			}
			//luaTrace("setTextFont: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextItalic", function(tag:String, italic:Bool) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				obj.italic = italic;
				return true;
			}
			//luaTrace("setTextItalic: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextAlignment", function(tag:String, alignment:String = 'left') {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				obj.alignment = LEFT;
				switch(alignment.trim().toLowerCase())
				{
					case 'right':
						obj.alignment = RIGHT;
					case 'center':
						obj.alignment = CENTER;
				}
				return true;
			}
			//luaTrace("setTextAlignment: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});

		Lua_helper.add_callback(lua, "getTextString", function(tag:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null && obj.text != null)
			{
				return obj.text;
			}
			//luaTrace("getTextString: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return null;
		});
		Lua_helper.add_callback(lua, "getTextSize", function(tag:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				return obj.size;
			}
			//luaTrace("getTextSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return -1;
		});
		Lua_helper.add_callback(lua, "getTextFont", function(tag:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				return obj.font;
			}
			//luaTrace("getTextFont: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return null;
		});
		Lua_helper.add_callback(lua, "getTextWidth", function(tag:String) {
			var obj:FlxText = getTextObject(tag);
			if(obj != null)
			{
				return obj.fieldWidth;
			}
			//luaTrace("getTextWidth: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return 0;
		});

		Lua_helper.add_callback(lua, "addLuaText", function(tag:String) {
			if(PlayState.instance.modchartTexts.exists(tag)) {
				var shit:ModchartText = PlayState.instance.modchartTexts.get(tag);
				if(!shit.wasAdded) {
					getInstance().add(shit);
					shit.wasAdded = true;
					//trace('added a thing: ' + tag);
				}
			}
		});
		Lua_helper.add_callback(lua, "removeLuaText", function(tag:String, destroy:Bool = true) {
			if(!PlayState.instance.modchartTexts.exists(tag)) {
				return;
			}

			var pee:ModchartText = PlayState.instance.modchartTexts.get(tag);
			if(destroy) {
				pee.kill();
			}

			if(pee.wasAdded) {
				getInstance().remove(pee, true);
				pee.wasAdded = false;
			}

			if(destroy) {
				pee.destroy();
				PlayState.instance.modchartTexts.remove(tag);
			}
		});


		// DEPRECATED, DONT MESS WITH THESE SHITS, ITS JUST THERE FOR BACKWARD COMPATIBILITY
		Lua_helper.add_callback(lua, "luaSpriteMakeGraphic", function(tag:String, width:Int, height:Int, color:String) {
			//luaTrace("luaSpriteMakeGraphic is deprecated! Use makeGraphic instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				var colorNum:Int = Std.parseInt(color);
				if(!color.startsWith('0x')) colorNum = Std.parseInt('0xff' + color);

				PlayState.instance.modchartSprites.get(tag).makeGraphic(width, height, colorNum);
			}
		});
		Lua_helper.add_callback(lua, "luaSpriteAddAnimationByPrefix", function(tag:String, name:String, prefix:String, framerate:Int = 24, loop:Bool = true) {
			//luaTrace("luaSpriteAddAnimationByPrefix is deprecated! Use addAnimationByPrefix instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				var cock:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
				cock.animation.addByPrefix(name, prefix, framerate, loop);
				if(cock.animation.curAnim == null) {
					cock.animation.play(name, true);
				}
			}
		});
		Lua_helper.add_callback(lua, "luaSpriteAddAnimationByIndices", function(tag:String, name:String, prefix:String, indices:String, framerate:Int = 24) {
			//luaTrace("luaSpriteAddAnimationByIndices is deprecated! Use addAnimationByIndices instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				var strIndices:Array<String> = indices.trim().split(',');
				var die:Array<Int> = [];
				for (i in 0...strIndices.length) {
					die.push(Std.parseInt(strIndices[i]));
				}
				var pussy:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
				pussy.animation.addByIndices(name, prefix, die, '', framerate, false);
				if(pussy.animation.curAnim == null) {
					pussy.animation.play(name, true);
				}
			}
		});
		Lua_helper.add_callback(lua, "luaSpritePlayAnimation", function(tag:String, name:String, forced:Bool = false) {
			//luaTrace("luaSpritePlayAnimation is deprecated! Use objectPlayAnimation instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				PlayState.instance.modchartSprites.get(tag).animation.play(name, forced);
			}
		});
		/* por algum motivo essa função estava repetida duas vezes, mas acredito que a de cima funcione melhor
		Lua_helper.add_callback(lua, "setObjectCamera", function(obj:String, camera:String = '') {
			/*if(PlayState.instance.modchartSprites.exists(obj)) {
				PlayState.instance.modchartSprites.get(obj).cameras = [cameraFromString(camera)];
				return true;
			}
			else if(PlayState.instance.modchartTexts.exists(obj)) {
				PlayState.instance.modchartTexts.get(obj).cameras = [cameraFromString(camera)];
				return true;
			}
			var real = PlayState.instance.getLuaObject(obj);
			if(real!=null){
				real.cameras = [cameraFromString(camera)];
				return true;
			}

			var killMe:Array<String> = obj.split('.');
			var object:FlxSprite = getObjectDirectly(killMe[0]);
			if(killMe.length > 1) {
				object = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
			}

			if(object != null) {
				object.cameras = [cameraFromString(camera)];
				return true;
			}
			//luaTrace("setObjectCamera: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});*/
		
		Lua_helper.add_callback(lua, "setLuaSpriteCamera", function(tag:String, camera:String = '') {
			//luaTrace("setLuaSpriteCamera is deprecated! Use setObjectCamera instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				PlayState.instance.modchartSprites.get(tag).cameras = [cameraFromString(camera)];
				return true;
			}
			//luaTrace("Lua sprite with tag: " + tag + " doesn't exist!");
			return false;
		});
		Lua_helper.add_callback(lua, "setLuaSpriteScrollFactor", function(tag:String, scrollX:Float, scrollY:Float) {
			//luaTrace("setLuaSpriteScrollFactor is deprecated! Use setScrollFactor instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				PlayState.instance.modchartSprites.get(tag).scrollFactor.set(scrollX, scrollY);
			}
			else if(PlayState.instance.modchartTiledSprites.exists(tag)) {
				PlayState.instance.modchartTiledSprites.get(tag).scrollFactor.set(scrollX, scrollY);
			}
		});
		Lua_helper.add_callback(lua, "scaleLuaSprite", function(tag:String, x:Float, y:Float) {
			//luaTrace("scaleLuaSprite is deprecated! Use scaleObject instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				var shit:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
				shit.scale.set(x, y);
				shit.updateHitbox();
			}else if(PlayState.instance.modchartTiledSprites.exists(tag)) {
				var shit:ModchartTiledSprite = PlayState.instance.modchartTiledSprites.get(tag);
				shit.scale.set(x, y);
				shit.updateHitbox();
			}
		});
		Lua_helper.add_callback(lua, "getPropertyLuaSprite", function(tag:String, variable:String) {
			//luaTrace("getPropertyLuaSprite is deprecated! Use getProperty instead", false, true);
			if(PlayState.instance.modchartSprites.exists(tag)) {
				var killMe:Array<String> = variable.split('.');
				if(killMe.length > 1) {
					var coverMeInPiss:Dynamic = Reflect.getProperty(PlayState.instance.modchartSprites.get(tag), killMe[0]);
					for (i in 1...killMe.length-1) {
						coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
					}
					return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
				}
				return Reflect.getProperty(PlayState.instance.modchartSprites.get(tag), variable);
			}
			return null;
		});
		Lua_helper.add_callback(lua, "setPropertyTiledLuaSprite", function(variable:String, value:Dynamic) {
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = null;
				if(PlayState.instance.modchartTiledSprites.exists(killMe[0])) {
					coverMeInPiss = PlayState.instance.modchartTiledSprites.get(killMe[0]);
				} else {
					coverMeInPiss = Reflect.getProperty(PlayState.instance, killMe[0]);
				}

				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.setProperty(coverMeInPiss, killMe[killMe.length-1], value);
			}
			return Reflect.setProperty(PlayState.instance, variable, value);
		});
		
		Lua_helper.add_callback(lua, "getPropertyTiledLuaSprite", function(variable:String) {
			var killMe:Array<String> = variable.split('.');
			if(killMe.length > 1) {
				var coverMeInPiss:Dynamic = null;
				if(PlayState.instance.modchartTiledSprites.exists(killMe[0])) {
					coverMeInPiss = PlayState.instance.modchartTiledSprites.get(killMe[0]);
				} else {
					coverMeInPiss = Reflect.getProperty(PlayState.instance, killMe[0]);
				}

				for (i in 1...killMe.length-1) {
					coverMeInPiss = Reflect.getProperty(coverMeInPiss, killMe[i]);
				}
				return Reflect.getProperty(coverMeInPiss, killMe[killMe.length-1]);
			}
			return Reflect.getProperty(PlayState.instance, variable);
		});
		Lua_helper.add_callback(lua, "musicFadeIn", function(duration:Float, fromValue:Float = 0, toValue:Float = 1) {
			FlxG.sound.music.fadeIn(duration, fromValue, toValue);
			//luaTrace('musicFadeIn is deprecated! Use soundFadeIn instead.', false, true);

		});
		Lua_helper.add_callback(lua, "musicFadeOut", function(duration:Float, toValue:Float = 0) {
			FlxG.sound.music.fadeOut(duration, toValue);
			//luaTrace('musicFadeOut is deprecated! Use soundFadeOut instead.', false, true);
		});

		//Discord.DiscordClient.addLuaCallbacks(lua);

				//SHADER SHIT

		
		
				Lua_helper.add_callback(lua, "addChromaticAbberationEffect", function(camera:String,chromeOffset:Float = 0.005) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new ChromaticAberrationEffect(chromeOffset));
					}
				});
				
				Lua_helper.add_callback(lua, "addScanlineEffect", function(camera:String,lockAlpha:Bool=false) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new ScanlineEffect(lockAlpha));
					}
				});
				Lua_helper.add_callback(lua, "addGrainEffect", function(camera:String,grainSize:Float,lumAmount:Float,lockAlpha:Bool=false) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new GrainEffect(grainSize,lumAmount,lockAlpha));
					}
				});
				Lua_helper.add_callback(lua, "addTiltshiftEffect", function(camera:String,blurAmount:Float,center:Float) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new TiltshiftEffect(blurAmount,center));
					}
				});
				Lua_helper.add_callback(lua, "addVCREffect", function(camera:String,glitchFactor:Float = 0.0,distortion:Bool=true,perspectiveOn:Bool=true,vignetteMoving:Bool=true) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new VCRDistortionEffect(glitchFactor,distortion,perspectiveOn,vignetteMoving));
					}
				});
				Lua_helper.add_callback(lua, "addGlitchEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new GlitchEffect(waveSpeed,waveFrq,waveAmp));
					}
				});
				Lua_helper.add_callback(lua, "addPulseEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new PulseEffect(waveSpeed,waveFrq,waveAmp));
					}
				});
				Lua_helper.add_callback(lua, "addDistortionEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new DistortBGEffect(waveSpeed,waveFrq,waveAmp));
					}
				});
				Lua_helper.add_callback(lua, "addInvertEffect", function(camera:String,lockAlpha:Bool=false) {
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new InvertColorsEffect(lockAlpha));
					}
				});
				Lua_helper.add_callback(lua, "addGreyscaleEffect", function(camera:String) { //for dem funkies
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new GreyscaleEffect());
					}
				});
				Lua_helper.add_callback(lua, "addGrayscaleEffect", function(camera:String) { //for dem funkies
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new GreyscaleEffect());
					}
				});
				Lua_helper.add_callback(lua, "add3DEffect", function(camera:String,xrotation:Float=0,yrotation:Float=0,zrotation:Float=0,depth:Float=0) { //for dem funkies
					if(ClientPrefs.shaders) {
					addShaderToCamera(camera, new ThreeDEffect(xrotation,yrotation,zrotation,depth));
					}
				});
				Lua_helper.add_callback(lua, "addBloomEffect", function(camera:String,intensity:Float = 0.35,blurSize:Float=1.0) {
					if(ClientPrefs.shaders){
					addShaderToCamera(camera, new BloomEffect(blurSize/512.0,intensity));
					}
				});
				Lua_helper.add_callback(lua, "clearEffects", function(camera:String) {
					clearShaderFromCamera(camera);
				});

				//Coisas adicionadas exclusivamente para a Final Escape caso isso estrague o resto dos luas

				Lua_helper.add_callback(lua, "restartSong", function(?skipTransition:Bool = false) {
					PlayState.instance.persistentUpdate = false;
					PauseSubState.restartSong(skipTransition);
					return true;
				});

				Lua_helper.add_callback(lua, "setCamMove", function(valor:Bool) {
					PlayState.movecameraallowed = valor;
				});

				Lua_helper.add_callback(lua, "dueto", function(vaiounao:Bool) { //Funções criadas por pura preguiça
					if(!ClientPrefs.middleScroll){
						if(vaiounao)
							PlayState.instance.vaiDueto();
						else
							PlayState.instance.saiDueto();
					}
				});


				Lua_helper.add_callback(lua, "getCamMove", function() {
					return PlayState.movecameraallowed;
				});
		
				Lua_helper.add_callback(lua, "addAnimation", function(obj:String, name:String, frames:Array<Int>, framerate:Int = 24, loop:Bool = true) {
					if(PlayState.instance.getLuaObject(obj,false)!=null) {
						var cock:FlxSprite = PlayState.instance.getLuaObject(obj,false);
						cock.animation.add(name, frames, framerate, loop);
						if(cock.animation.curAnim == null) {
							cock.animation.play(name, true);
						}
						return;
					}
		
					var cock:FlxSprite = Reflect.getProperty(getInstance(), obj);
					if(cock != null) {
						cock.animation.add(name, frames, framerate, loop);
						if(cock.animation.curAnim == null) {
							cock.animation.play(name, true);
						}
					}
				});
		
				Lua_helper.add_callback(lua, "loadGraphic", function(variable:String, image:String, ?gridX:Int = 0, ?gridY:Int = 0) {
					var killMe:Array<String> = variable.split('.');
					var spr:FlxSprite = getObjectDirectly(killMe[0]);
					var animated = gridX != 0 || gridY != 0;
		
					if(killMe.length > 1) {
						spr = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
					}
		
					if(spr != null && image != null && image.length > 0)
					{
						//trace(image); //Eu até me preocuparia em fazer um sistema melhor pra isso mas na real... Isso só vai ser usado uma única vez então né?
						spr.loadGraphic(Paths.image(image), animated, gridX, gridY);
					}
				});
		
				Lua_helper.add_callback(lua, "exitSong", function(?skipTransition:Bool = false) {
					if(skipTransition)
					{
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
					}
		
					PlayState.cancelMusicFadeTween();
					CustomFadeTransition.nextCamera = PlayState.instance.camOther;
					if(FlxTransitionableState.skipNextTransIn)
						CustomFadeTransition.nextCamera = null;
		
					if(PlayState.modohistoria)
						MusicBeatState.switchState(new MenuPreHistoria());
					else
						MusicBeatState.switchState(new FreeplayState());
		
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.instance.transitioning = true;
					return true;
				});

				//Adicional Pasta-Night
				Lua_helper.add_callback(lua, "stringSplit", function(str:String, split:String) {
					return str.split(split);
				});
			
		
		call('onCreate', []);
		#end
	}

	function resetSpriteTag(tag:String) {
		if(!PlayState.instance.modchartSprites.exists(tag)) {
			return;
		}
		
		var pee:ModchartSprite = PlayState.instance.modchartSprites.get(tag);
		pee.kill();
		if(pee.wasAdded) {
			PlayState.instance.remove(pee, true);
		}
		pee.destroy();
		PlayState.instance.modchartSprites.remove(tag);
	}

	function resetTiledSpriteTag(tag:String) {
		if(!PlayState.instance.modchartSprites.exists(tag)) {
			return;
		}
		
		var pee:ModchartTiledSprite = PlayState.instance.modchartTiledSprites.get(tag);
		pee.kill();
		if(pee.wasAdded) {
			PlayState.instance.remove(pee, true);
		}
		pee.destroy();
		PlayState.instance.modchartTiledSprites.remove(tag);
	}

	function resetTextTag(tag:String) {
		if(!PlayState.instance.modchartTexts.exists(tag)) {
			return;
		}

		var pee:ModchartText = PlayState.instance.modchartTexts.get(tag);
		pee.kill();
		if(pee.wasAdded) {
			PlayState.instance.remove(pee, true);
		}
		pee.destroy();
		PlayState.instance.modchartTexts.remove(tag);
	}

	function cancelTween(tag:String) {
		if(PlayState.instance.modchartTweens.exists(tag)) {
			PlayState.instance.modchartTweens.get(tag).cancel();
			PlayState.instance.modchartTweens.get(tag).destroy();
			PlayState.instance.modchartTweens.remove(tag);
		}
	}

	function tweenShit(tag:String, vars:String) {
		cancelTween(tag);
		var variables:Array<String> = vars.split('.');
		var sexyProp:Dynamic = getObjectDirectly(variables[0]);
		if(variables.length > 1) {
			sexyProp = getVarInArray(getPropertyLoopThingWhatever(variables), variables[variables.length-1]);
		}
		return sexyProp;
	}

	function cancelTimer(tag:String) {
		if(PlayState.instance.modchartTimers.exists(tag)) {
			var theTimer:FlxTimer = PlayState.instance.modchartTimers.get(tag);
			theTimer.cancel();
			theTimer.destroy();
			PlayState.instance.modchartTimers.remove(tag);
		}
	}

	//Better optimized than using some getProperty shit or idk
	function getFlxEaseByString(?ease:String = '') {
		switch(ease.toLowerCase().trim()) {
			case 'backin': return FlxEase.backIn;
			case 'backinout': return FlxEase.backInOut;
			case 'backout': return FlxEase.backOut;
			case 'bouncein': return FlxEase.bounceIn;
			case 'bounceinout': return FlxEase.bounceInOut;
			case 'bounceout': return FlxEase.bounceOut;
			case 'circin': return FlxEase.circIn;
			case 'circinout': return FlxEase.circInOut;
			case 'circout': return FlxEase.circOut;
			case 'cubein': return FlxEase.cubeIn;
			case 'cubeinout': return FlxEase.cubeInOut;
			case 'cubeout': return FlxEase.cubeOut;
			case 'elasticin': return FlxEase.elasticIn;
			case 'elasticinout': return FlxEase.elasticInOut;
			case 'elasticout': return FlxEase.elasticOut;
			case 'expoin': return FlxEase.expoIn;
			case 'expoinout': return FlxEase.expoInOut;
			case 'expoout': return FlxEase.expoOut;
			case 'quadin': return FlxEase.quadIn;
			case 'quadinout': return FlxEase.quadInOut;
			case 'quadout': return FlxEase.quadOut;
			case 'quartin': return FlxEase.quartIn;
			case 'quartinout': return FlxEase.quartInOut;
			case 'quartout': return FlxEase.quartOut;
			case 'quintin': return FlxEase.quintIn;
			case 'quintinout': return FlxEase.quintInOut;
			case 'quintout': return FlxEase.quintOut;
			case 'sinein': return FlxEase.sineIn;
			case 'sineinout': return FlxEase.sineInOut;
			case 'sineout': return FlxEase.sineOut;
			case 'smoothstepin': return FlxEase.smoothStepIn;
			case 'smoothstepinout': return FlxEase.smoothStepInOut;
			case 'smoothstepout': return FlxEase.smoothStepInOut;
			case 'smootherstepin': return FlxEase.smootherStepIn;
			case 'smootherstepinout': return FlxEase.smootherStepInOut;
			case 'smootherstepout': return FlxEase.smootherStepOut;
		}
		return FlxEase.linear;
	}

	function blendModeFromString(blend:String):BlendMode {
		switch(blend.toLowerCase().trim()) {
			case 'add': return ADD;
			case 'alpha': return ALPHA;
			case 'darken': return DARKEN;
			case 'difference': return DIFFERENCE;
			case 'erase': return ERASE;
			case 'hardlight': return HARDLIGHT;
			case 'invert': return INVERT;
			case 'layer': return LAYER;
			case 'lighten': return LIGHTEN;
			case 'multiply': return MULTIPLY;
			case 'overlay': return OVERLAY;
			case 'screen': return SCREEN;
			case 'shader': return SHADER;
			case 'subtract': return SUBTRACT;
		}
		return NORMAL;
	}

	function cameraFromString(cam:String):FlxCamera {
		switch(cam.toLowerCase()) {
			case 'camHUD' | 'camhud' | 'hud': return PlayState.instance.camHUD;
			case 'camHUD2' |'camhud2' | 'hud2': return PlayState.instance.camHUD2;
			case 'camother' | 'other': return PlayState.instance.camOther;
			case 'camlegenda' | 'legenda': return PlayState.instance.camLegenda;
			case 'camorig' | 'orig': return FlxG.camera;
			case 'campasta' | 'pasta': return PastaNightSelect.selectCam;
			case 'gameMenu' : return MainMenuStateMobile.instance.camGame;
			case 'achMenu' : return MainMenuStateMobile.instance.camAchievement;
		}
		return PlayState.instance.camGame;
	}

	public static function getPropertyLoopThingWhatever(killMe:Array<String>, ?checkForTextsToo:Bool = true, ?getProperty:Bool=true):Dynamic
		{
			var coverMeInPiss:Dynamic = getObjectDirectly(killMe[0], checkForTextsToo);
			var end = killMe.length;
			if(getProperty)end=killMe.length-1;
	
			for (i in 1...end) {
				coverMeInPiss = getVarInArray(coverMeInPiss, killMe[i]);
			}
			return coverMeInPiss;
		}

	public static function getObjectDirectly(objectName:String, ?checkForTextsToo:Bool = true):Dynamic
	{
		var coverMeInPiss:Dynamic = PlayState.instance.getLuaObject(objectName, checkForTextsToo);
		if(coverMeInPiss==null)
			coverMeInPiss = getVarInArray(getInstance(), objectName);

		return coverMeInPiss;
	}

	public static function addShaderToCamera(cam:String,effect:ShaderEffect){//STOLE FROM ANDROMEDA
	  
	  
		if(ClientPrefs.shaders)
		  {
			  switch(cam.toLowerCase()) {
				  case 'camhud' | 'hud':
						  camHUDShaders.push(effect);
						  var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
						  for(i in camHUDShaders){
							newCamEffects.push(new ShaderFilter(i.shader));
						  }
						  PlayState.instance.camHUD.setFilters(newCamEffects);
				  case 'camother' | 'other':
						  camOtherShaders.push(effect);
						  var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
						  for(i in camOtherShaders){
							newCamEffects.push(new ShaderFilter(i.shader));
						  }
						  PlayState.instance.camOther.setFilters(newCamEffects);
				  case 'camgame' | 'game':
						  camGameShaders.push(effect);
						  var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
						  for(i in camGameShaders){
							newCamEffects.push(new ShaderFilter(i.shader));
						  }
						  PlayState.instance.camGame.setFilters(newCamEffects);
				  case 'campasta' | 'pasta':
							  camGameShaders.push(effect);
							  var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
							  for(i in camGameShaders){
								newCamEffects.push(new ShaderFilter(i.shader));
							  }
							  PastaNightSelect.selectCam.setFilters(newCamEffects);
				  default:
						  camOtherShaders.push(effect);
						  var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
						  for(i in camOtherShaders){
						  newCamEffects.push(new ShaderFilter(i.shader));
						  }
						  //PlayState.instance.camOther.setFilters(newCamEffects);
						  FlxG.camera.setFilters(newCamEffects);
				  
				  
					  
					  
			  }
		  }
		
		
		
		
	}
  
	public static function removeShaderFromCamera(cam:String,effect:ShaderEffect){
		
		
		  switch(cam.toLowerCase()) {
			  case 'camhud' | 'hud': 
	  camHUDShaders.remove(effect);
	  var newCamEffects:Array<BitmapFilter>=[];
	  for(i in camHUDShaders){
		newCamEffects.push(new ShaderFilter(i.shader));
	  }
	  PlayState.instance.camHUD.setFilters(newCamEffects);
			  case 'camother' | 'other': 
					  camOtherShaders.remove(effect);
					  var newCamEffects:Array<BitmapFilter>=[];
					  for(i in camOtherShaders){
						newCamEffects.push(new ShaderFilter(i.shader));
					  }
					  PlayState.instance.camOther.setFilters(newCamEffects);
					  case 'campasta' | 'pasta': 
						  camOtherShaders.remove(effect);
						  var newCamEffects:Array<BitmapFilter>=[];
						  for(i in camOtherShaders){
							newCamEffects.push(new ShaderFilter(i.shader));
						  }
						  PastaNightSelect.selectCam.setFilters(newCamEffects);
			  default: 
				  camGameShaders.remove(effect);
				  var newCamEffects:Array<BitmapFilter>=[];
				  for(i in camGameShaders){
					newCamEffects.push(new ShaderFilter(i.shader));
				  }
				  PlayState.instance.camGame.setFilters(newCamEffects);
		  }
		  
		
	}
	  
	  
	  
	public static function clearShaderFromCamera(cam:String){
		
		
		  switch(cam.toLowerCase()) {
			  case 'camhud' | 'hud': 
				  camHUDShaders = [];
				  var newCamEffects:Array<BitmapFilter>=[];
				  PlayState.instance.camHUD.setFilters(newCamEffects);
			  case 'camother' | 'other': 
				  camOtherShaders = [];
				  var newCamEffects:Array<BitmapFilter>=[];
				  PlayState.instance.camOther.setFilters(newCamEffects);
			  default: 
				  camGameShaders = [];
				  var newCamEffects:Array<BitmapFilter>=[];
				  PlayState.instance.camGame.setFilters(newCamEffects);
		  }
		  
		
	}
  
	public static function setVarInArray(instance:Dynamic, variable:String, value:Dynamic):Any
		{
			var shit:Array<String> = variable.split('[');
			if(shit.length > 1)
			{
				var blah:Dynamic = null;
				if(PlayState.instance.variables.exists(shit[0]))
				{
					var retVal:Dynamic = PlayState.instance.variables.get(shit[0]);
					if(retVal != null)
						blah = retVal;
				}
				else
					blah = Reflect.getProperty(instance, shit[0]);
	
				for (i in 1...shit.length)
				{
					var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
					if(i >= shit.length-1) //Last array
						blah[leNum] = value;
					else //Anything else
						blah = blah[leNum];
				}
				return blah;
			}
			/*if(Std.isOfType(instance, Map))
				instance.set(variable,value);
			else*/
				
			if(PlayState.instance.variables.exists(variable))
			{
				PlayState.instance.variables.set(variable, value);
				return true;
			}
	
			Reflect.setProperty(instance, variable, value);
			return true;
		}

	public static inline function getInstance()
		{
			return PlayState.instance.isDead ? GameOverSubstate.instance : PlayState.instance;
		}

	public function luaTrace(text:String, ignoreCheck:Bool = false, deprecated:Bool = false, color:FlxColor = FlxColor.WHITE) {
		#if LUA_ALLOWED
		if(ignoreCheck || getBool('luaDebugMode')) {
			if(deprecated && !getBool('luaDeprecatedWarnings')) {
				return;
			}
			//PlayState.instance.addTextToDebug(text, color); //Trem chato que só a mizera...
			//trace(text); é... whut?
		}
		#end
	}

	inline static function getTextObject(name:String):FlxText
	{
		return PlayState.instance.modchartTexts.exists(name) ? PlayState.instance.modchartTexts.get(name) : Reflect.getProperty(PlayState.instance, name);
	}

	inline static function getTiledSpriteObject(name:String):FlxTiledSprite
		{
			return PlayState.instance.modchartTiledSprites.exists(name) ? PlayState.instance.modchartTiledSprites.get(name) : Reflect.getProperty(PlayState.instance, name);
		}

	public static function getVarInArray(instance:Dynamic, variable:String):Any
		{
			var shit:Array<String> = variable.split('[');
			if(shit.length > 1)
			{
				var blah:Dynamic = null;
				if(PlayState.instance.variables.exists(shit[0]))
				{
					var retVal:Dynamic = PlayState.instance.variables.get(shit[0]);
					if(retVal != null)
						blah = retVal;
				}
				else
					blah = Reflect.getProperty(instance, shit[0]);
	
				for (i in 1...shit.length)
				{
					var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
					blah = blah[leNum];
				}
				return blah;
			}
	
			if(PlayState.instance.variables.exists(variable))
			{
				var retVal:Dynamic = PlayState.instance.variables.get(variable);
				if(retVal != null)
					return retVal;
			}
	
			return Reflect.getProperty(instance, variable);
		}
	
	var lastCalledFunction:String = '';
	public function call(func:String, args:Array<Dynamic>):Dynamic {
		#if LUA_ALLOWED
		if(closed) return Function_Continue;

		lastCalledFunction = func;
		try {
			if(lua == null) return Function_Continue;

			Lua.getglobal(lua, func);
			var type:Int = Lua.type(lua, -1);

			if (type != Lua.LUA_TFUNCTION) {
				if (type > Lua.LUA_TNIL)
					trace("ERROR (" + func + "): attempt to call a " + typeToString(type) + " value");

				Lua.pop(lua, 1);
				return Function_Continue;
			}

			for (arg in args) Convert.toLua(lua, arg);
			var status:Int = Lua.pcall(lua, args.length, 1, 0);

			// Checks if it's not successful, then show a error.
			if (status != Lua.LUA_OK) {
				var error:String = getErrorMessage(status);
				trace("ERROR (" + func + "): " + error);
				return Function_Continue;
			}

			// If successful, pass and then return the result.
			var result:Dynamic = cast Convert.fromLua(lua, -1);
			if (result == null) result = Function_Continue;

			Lua.pop(lua, 1);
			return result;
		}
		catch (e:Dynamic) {
			trace(e);
		}
		#end
		return Function_Continue;
	}

	function typeToString(type:Int):String {
		#if LUA_ALLOWED
		switch(type) {
			case Lua.LUA_TBOOLEAN: return "boolean";
			case Lua.LUA_TNUMBER: return "number";
			case Lua.LUA_TSTRING: return "string";
			case Lua.LUA_TTABLE: return "table";
			case Lua.LUA_TFUNCTION: return "function";
		}
		if (type <= Lua.LUA_TNIL) return "nil";
		#end
		return "unknown";
	}

	function getErrorMessage(status:Int):String {
		#if LUA_ALLOWED
		var v:String = Lua.tostring(lua, -1);
		Lua.pop(lua, 1);

		if (v != null) v = v.trim();
		if (v == null || v == "") {
			switch(status) {
				case Lua.LUA_ERRRUN: return "Runtime Error";
				case Lua.LUA_ERRMEM: return "Memory Allocation Error";
				case Lua.LUA_ERRERR: return "Critical Error";
			}
			return "Unknown Error";
		}

		return v;
		#end
		return null;
	}

	#if LUA_ALLOWED
	function resultIsAllowed(leLua:State, leResult:Null<Int>) { //Makes it ignore warnings
		switch(Lua.type(leLua, leResult)) {
			case Lua.LUA_TNIL | Lua.LUA_TBOOLEAN | Lua.LUA_TNUMBER | Lua.LUA_TSTRING | Lua.LUA_TTABLE:
				return true;
		}
		return false;
	}
	#end

	public function set(variable:String, data:Dynamic) {
		#if LUA_ALLOWED
		if(lua == null) {
			return;
		}

		Convert.toLua(lua, data);
		Lua.setglobal(lua, variable);
		#end
	}

	#if LUA_ALLOWED
	public function getBool(variable:String) {
		var result:String = null;
		Lua.getglobal(lua, variable);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);

		if(result == null) {
			return false;
		}

		// YES! FINALLY IT WORKS
		//trace('variable: ' + variable + ', ' + result);
		return (result == 'true');
	}
	#end

	public function stop() {
		#if LUA_ALLOWED
		if(lua == null) {
			return;
		}

		if(accessedProps != null) {
			accessedProps.clear();
		}
		PlayState.instance.removeLua(this);
		Lua.close(lua);
		lua = null;
		#end
	}
}

class ModchartText extends FlxText
{
	public var wasAdded:Bool = false;
	public function new(x:Float, y:Float, text:String, width:Float)
	{
		super(x, y, width, text, 16);
		setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		cameras = [PlayState.instance.camHUD];
		scrollFactor.set();
		borderSize = 2;
	}
}


class ModchartSprite extends FlxSprite
{
	public var wasAdded:Bool = false;
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();
	//public var isInFront:Bool = false;

	public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);
		antialiasing = ClientPrefs.globalAntialiasing;
	}
}

class ModchartTiledSprite extends FlxTiledSprite
{
	public var wasAdded:Bool = false;
	//public var isInFront:Bool = false;
}

class DebugLuaText extends FlxText
{
	private var disableTime:Float = 6;
	public var parentGroup:FlxTypedGroup<DebugLuaText>; 
	public function new(text:String, parentGroup:FlxTypedGroup<DebugLuaText>) {
		this.parentGroup = parentGroup;
		super(10, 10, 0, text, 16);
		setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scrollFactor.set();
		borderSize = 1;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		disableTime -= elapsed;
		if(disableTime <= 0) {
			kill();
			parentGroup.remove(this);
			destroy();
		}
		else if(disableTime < 1) alpha = disableTime;
	}
}
