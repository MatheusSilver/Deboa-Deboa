package;

#if desktop
///import GameJolt;
///import GameJolt.GameJoltAPI;

#end
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
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	#if mobile
	var initialState:Class<FlxState> = TitleState; //Must do: Pensar em uma forma de iniciar o vídeo através do titlestate
	#elseif desktop
	var initialState:Class<FlxState> = PreTitleState; // The FlxState the game starts with.
	#end
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = ClientPrefs.fullscreen; // Whether to start the game in fullscreen on desktop targets
	//Quando tu for começar o jooj, verifica se isso aqui não tá crashando não fiz o teste disso quando fullscreen não foi setado ainda
	public static var fpsVar:FPS;
	#if desktop
	//public static var gjToastManager:GJToastManager;
	#end


	public static var instance:Main;


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

		public static function dumpCache()
		{
			if(ClientPrefs.imagesPersist){ //Pode ser que o manito queira ter um cache infinito
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
			Assets.cache.clear();
			Assets.cache.clear("songs");
			Assets.cache.clear("shared");
			Assets.cache.clear("preload");
			if(LoadingState.directory != 'shared' && LoadingState.directory != "preload" && LoadingState.directory != null){
			Assets.cache.clear(LoadingState.directory);
			}
		}

		}

		public static var webmHandler:WebmHandler;

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		#if desktop
		/*gjToastManager = new GJToastManager();
		addChild(gjToastManager);*/
		#end

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		/*
		#if !debug
		initialState = PreTitleState;
		#end
		top 10 codes que tu faz no passado, esquece e depois se arrepende (Mobile Issue :skull:)
		*/ 
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		//Use Flixel 4.11.0 - haxelib install flixel 4.11.0 e flixel-addons 2.11.0
		// muito obrigado, tenha um ótimo dia 😎

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if(fpsVar != null) {
			fpsVar.visible = false;
		}
		
		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}

	public function getFPS():Float{
		return fpsVar.currentFPS;	
	}
}