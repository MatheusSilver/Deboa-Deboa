package;

import lime.system.System;
import webm.WebmPlayer;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: FALSE, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};
	public static var fpsVar:FPS;
	public static var memoryCounter:MemoryCounter;


	public static var instance:Main;
	
	public static var path:String = System.applicationStorageDirectory;


	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		instance = this;

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

		public static function dumpCache() // THIS MOD WASTES 1-2 FUCKING G I G A B Y T E S OF MEMORY SO OF COURSE I COPIED KADE'S CODE FOR FUCKS SAKE
		{
			@:privateAccess
			for (key in FlxG.bitmap._cache.keys())
			{
				var obj = FlxG.bitmap._cache.get(key);
				if (obj != null)
				{
					Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
				}
			}
			Paths.localTrackedAssets = [];
			Paths.currentTrackedAssets = [];
			Assets.cache.clear("songs");
			Assets.cache.clear("shared");
			Assets.cache.clear("preload");
			// */
		}

		public static var webmHandler:WebmHandler;

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		#if !debug
		initialState = TitleState;
		#end
		
		ClientPrefs.startControls();	

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));
		
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}


		memoryCounter = new MemoryCounter(10, 3, 0xffffff);
		addChild(memoryCounter);
		if(memoryCounter != null) {
			memoryCounter.visible = ClientPrefs.showFPS;
		
		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if desktop
		FlxG.stage.application.window.onClose.add(function()
		{
			DiscordClient.shutdown();
		});
		#end
	}
	}

	public function getFPS():Float{
		return fpsVar.currentFPS;	
	}
}