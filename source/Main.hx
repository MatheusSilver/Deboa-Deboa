package;

import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepad.FlxGamepadModel;
import gamejolt.InviteBackEnd;
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
import gamejolt.InviteBackEnd;
#if rpc
import Discord.DiscordClient;
#end
import Linguagem.FireTongueEx;

using StringTools;

class Main extends Sprite
{
	#if mobile
	public static var path = lime.system.System.applicationStorageDirectory;
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
		// Isso não funciona aqui.
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
	private static var touch_allowed:Bool = true;
	#end

	public static function mouseVisibility(visible:Bool):Void
	{
		#if desktop
		FlxG.mouse.visible = visible;
		#else
		touch_allowed = visible;
		#end
	}

	public static function getMouseVisibility():Bool
	{
		#if desktop
		return FlxG.mouse.visible;
		#else
		return touch_allowed;
		#end
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		stage.application.onExit.add(function(exitCode)
		{
			if (!gamejolt.GJClient.logged)
				return;
			gamejolt.GJClient.updateStatus(false);
		});

		setupGame();
	}

	#if mobile
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "crash/" + "PsychEngine_" + dateNow + ".txt";

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

		errMsg += "\nErro: "
			+ e.error
			+ "\nSó sabo que nada sebo.";

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Erro!");
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

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));


		fpsVar = new FPS(5, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if (fpsVar != null)
		{
			fpsVar.visible = ClientPrefs.showFPS;
		}

		tongue = new FireTongueEx();
		tongue.initialize({locale: ClientPrefs.lingua});

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if rpc
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.window.onClose.add(function()
			{
				DiscordClient.shutdown();
			});
		}
		#end

		var shaderarray:Array<BitmapFilter> = [new ColorMatrixFilter(ClientPrefs.shaderMatrix)];
		if (ClientPrefs.shaderMatrix.length != 0)
		{
			FlxG.game.setFilters(shaderarray); // Resumindo: Se tu quer enxergar as cores certinhas, tu vai ter lag no jogo k
		}
		FlxG.fullscreen = ClientPrefs.fullscreen; // Lá em cima as clientprefs ainda não haviam sido carregadas
		FlxG.updateFramerate = ClientPrefs.framerate;
		FlxG.drawFramerate = ClientPrefs.framerate;
		FlxG.fixedTimestep = false; // Agora eu fiquei na dúvida entre deixar isso falso, ou deixar isso como verdadeiro.
		// Eu mandei lá no Discord, uma gravação onde o FPS Cap é 240 e ele fica SUPER lagado. Só consegui resolver isso deixando o timestep como falso.
	}
}
