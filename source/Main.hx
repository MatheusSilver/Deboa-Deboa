package;

import openfl.filters.ColorMatrixFilter;
import openfl.filters.BitmapFilter;
#if mobile
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import openfl.events.UncaughtErrorEvent;
import sys.io.Process;
#end
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
#if rpc
import Discord.DiscordClient;
#end

class Main extends Sprite
{

	#if desktop
	//public static var gjToastManager:GJToastManager;
	#end

	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, 
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		// startFullscreen: ClientPrefs.fullscreen // if the game should start at fullscreen mode
		startFullscreen: false // if the game should start at fullscreen mode
		//Isso não funciona aqui.
	};

	public static var fpsVar:FPS;
	public static var tongue:FireTongueEx;
	// You can pretty much ignore everything from here on - your code should go in your states.

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	public static var mouse_allowed:Bool = false;
	#if mobile
	private static var using_touch:Bool = true;
	#end
	public static function mouseVisibility(visible:Bool):Void
	{
		#if desktop
		FlxG.mouse.visible = visible;
		#else
		using_touch = visible;
		#end
	}

	public static function getMouseVisibility():Bool
	{
		#if desktop
		return FlxG.mouse.visible;
		#else
		return using_touch;
		#end
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	#if mobile
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		path = "crash/" + "FE_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/Yoshubs/Forever-Engine";

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		var crashDialoguePath:String = "FE-CrashDialog";

		#if windows
		crashDialoguePath += ".exe";
		#end

		if (Assets.exists(crashDialoguePath))
		{
			Sys.println("Found crash dialog: " + crashDialoguePath);
			new Process(crashDialoguePath, [path]);
		}
		else
		{
			Sys.println("No crash dialog found! Making a simple alert instead...");
			Application.current.window.alert(errMsg, "Error!");
		}

		Sys.exit(1);
	}
	#end

	private function setupGame():Void
	{
		Lib.application.window.height = 720;
		Lib.application.window.width = 1280;
		var stageWidth:Int = Lib.application.window.width;
		var stageHeight:Int = Lib.application.window.height;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}
	
		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));


		fpsVar = new FPS(5, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}

		tongue = new FireTongueEx();
		tongue.initialize({locale: ClientPrefs.lingua});


		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if rpc
		if (!DiscordClient.isInitialized) {
			DiscordClient.initialize();
			Application.current.window.onClose.add(function() {
			DiscordClient.shutdown();
			});
		}
		#end

		var shaderarray:Array<BitmapFilter> = [new ColorMatrixFilter(ClientPrefs.shaderMatrix)];
		if(ClientPrefs.shaderMatrix.length != 0) {
			FlxG.game.setFilters(shaderarray); // Resumindo: Se tu quer enxergar as cores certinhas, tu vai ter lag no jogo k
		}
		FlxG.fullscreen = ClientPrefs.fullscreen; //Lá em cima as clientprefs ainda não haviam sido carregadas  
		FlxG.fixedTimestep = true;
	}
}