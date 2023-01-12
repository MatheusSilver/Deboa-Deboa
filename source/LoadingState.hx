package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class LoadingsState extends MusicBeatSubstate
{
	var loadingidentifier:Array<String> = [
	'cycles', 
	'execution', 
	'soulless', 
	'sunshine', 
	'defender', 
	'illegal-download'
]; //usado apenas para os grupinhos

	public var instantAlpha:Bool = false;
	var art = new FlxSprite();
	var loadingbar = new FlxSprite();
	var modboalogo = new FlxSprite();
	var isgroup:Bool = false;
	var position:Int = 0;
	var loadBar:FlxSprite;
	override function create()
	{

		//Silver explicações pt2
		//Basicamente é só tu enfiar a tela de loading na pasta loadings dentro de preload/images
		//O NOME DO ARQUIVO DEVE SER O MESMO QUE O NOME DO JSON DA MUSICA 
		//Para grupos de músicas que usem a mesma tela de loading, veja o exemplo de como foi feita a do lordx
		modboalogo.loadGraphic(Paths.image('loading/loading-logo',  'preload'));
		loadingbar.loadGraphic(Paths.image('loading/carregando',  'preload'));
		loadingbar.x=343;
		//loadingbar.y=0;
		modboalogo.y=720;
		//modboalogo.x=0;		
		loadingbar.setGraphicSize(Std.int(FlxG.width * 1));
		loadingbar.updateHitbox();
		loadingbar.antialiasing = ClientPrefs.globalAntialiasing;
		modboalogo.setGraphicSize(Std.int(FlxG.width * 1));
		modboalogo.updateHitbox();
		modboalogo.antialiasing = ClientPrefs.globalAntialiasing;

		if (loadingidentifier.contains(Std.string(FreeplayState.justread).toLowerCase())){
			isgroup = true;
			position = loadingidentifier.lastIndexOf((Std.string(FreeplayState.justread).toLowerCase())) + 1;
		}

		art.alpha = 0;
		#if !debug
		if(OpenFlAssets.exists(Paths.image('loading/' + (isgroup ? ((position % 2 != 0) ? (loadingidentifier[position - 1] + '-' + loadingidentifier[position]) : loadingidentifier[position - 1] + '-' + loadingidentifier[position - 2]) : Std.string(FreeplayState.justread).toLowerCase()), 'preload'))) { //Você já olhou pra alguem e pensou... O que passa, na cabeça dela? 
			art.loadGraphic(Paths.image('loading/' + (isgroup ? ((position % 2 != 0) ? (loadingidentifier[position - 1] + '-' + loadingidentifier[position]) : loadingidentifier[position - 1] + '-' + loadingidentifier[position - 2]) : Std.string(FreeplayState.justread).toLowerCase()), 'preload')); //Fiz isso pensando nos modders que talvez modarão esse mod, mas isso não é o ideal...
		} else {
			art.loadGraphic('assets/images/menuBG.png'); 
		}
		#else
		art.loadGraphic(Paths.image('loading/' + (isgroup ? ((position % 2 != 0) ? (loadingidentifier[position - 1] + '-' + loadingidentifier[position]) : loadingidentifier[position - 2] + '-' + loadingidentifier[position - 1]) : Std.string(FreeplayState.justread).toLowerCase()), 'preload')); //Fiz isso pensando nos modders que talvez modarão esse mod, mas isso não é o ideal...
		#end
		//assim eu consigo ter um pequeno feedback se a loading screen não existe ou se só tá escrita errada mesmo.

		FlxTween.tween(art, {alpha: 1}, 0.5,{ease: FlxEase.linear});
		FlxTween.tween(loadingbar, {x: 0}, 0.6,{ease: FlxEase.quartInOut, startDelay: 0.4});
		FlxTween.tween(modboalogo, {y: 0}, 0.65,{ease: FlxEase.quartInOut, startDelay: 0.5});
		
		art.setGraphicSize(Std.int(FlxG.width * 1.2));
		art.updateHitbox();
		art.screenCenter(XY);
		art.antialiasing = ClientPrefs.globalAntialiasing;
		art.scrollFactor.set();
		art.screenCenter();

		add(art); //Haha isso não é um NFT
		add(modboalogo);
		add(loadingbar);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		art.setGraphicSize(Std.int(FlxG.width * 1.0));
		art.updateHitbox();
		art.screenCenter(XY);
		
		if(LoadingState.callbacks != null) {
			LoadingState.targetShit = FlxMath.remapToRange(LoadingState.callbacks.numRemaining / LoadingState.callbacks.length, 1, 0, 0, 1);
			loadBar.scale.x += 0.5 * (LoadingState.targetShit - loadBar.scale.x);
		}
	}
}
class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;

	public static var directory:String = 'shared';

	var target:FlxState;
	var stopMusic = false;
	var actualdirectory:String;
	public static var directoryreader:String;
	public static var callbacks:MultiCallback;
	public static var targetShit:Float = 0;
	
	function new(target:FlxState, stopMusic:Bool, actualdirectory:String)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
		this.actualdirectory = actualdirectory;
	}
	
	override function create()
	{

		initSongsManifest().onComplete
		(
			function (lib)
			{
				callbacks = new MultiCallback(onLoad);
				var introComplete = callbacks.add("introComplete");
				if (PlayState.SONG != null) {
				checkLoadSong(getSongPath());
				if (PlayState.SONG.needsVoices)
					checkLoadSong(getVocalPath());
			}
				checkLibrary("shared");
				if(actualdirectory != null && actualdirectory.length > 0 && actualdirectory != 'shared') {
					checkLibrary(actualdirectory);
				}
				
				var fadeTime = 1.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
			}
		);
		super.create();
	}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}
	
	function checkLibrary(library:String) {
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;
			
			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		FlxG.switchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false, ?waitForLoad:Bool = true)
	{
		var waitTime = 0.0;
		if (waitForLoad)
		{
			FlxG.sound.music.fadeOut(1, 0);
			waitTime = 1.6;
		}

		FlxTransitionableState.skipNextTransIn = true;
		new FlxTimer().start(waitTime, function(tmr:FlxTimer) {

			FlxG.switchState(getNextState(target, stopMusic));
		});	
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
		{
			var actualdirectory:String = 'shared';
			var weekDir:String = StageData.forceNextDirectory;
			StageData.forceNextDirectory = null;
	
			if(weekDir != null && weekDir.length > 0 && weekDir != '') actualdirectory = weekDir;
	
			Paths.setCurrentLevel(actualdirectory);
			trace('Setting asset folder to ' + actualdirectory);
			directoryreader = actualdirectory;

			#if NO_PRELOAD_ALL
			var loaded:Bool = false;
			if (PlayState.SONG != null) {
				loaded = isSoundLoaded(getSongPath()) && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath())) && isLibraryLoaded("shared") && isLibraryLoaded(actualdirectory);
			}
			
			if (!loaded)
				return new LoadingState(target, stopMusic, actualdirectory);
			#end
			if (stopMusic && FlxG.sound.music != null)
				FlxG.sound.music.stop();
			directory = actualdirectory; //Tenho minhas duvidas se isso aqui tá realmente funfando...
			return target;
		}
	
	#if NO_PRELOAD_ALL
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	#end
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}