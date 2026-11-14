package;

import Song.SwagSong;
import SongAssetCollector.PreloadRequest;
import SongAssetScanner.LuaScanResult;
import cpp.vm.Gc;
import flixel.FlxG;
import haxe.Json;
import haxe.Timer;
import lime.graphics.Image;
import lime.graphics.PixelFormat;
import lime.media.AudioBuffer;
import lime.system.ThreadPool;
import lime.utils.Assets as LimeAssets;
import lime.utils.Bytes;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import sys.thread.Mutex;

private enum JobKind
{
	ReadScript;
	ReadCharacter;
	ReadEvents;
	DecodeImage;
	DecodeSound;
}

private class PreloadJob
{
	public var owner:SongPreloader;
	public var kind:JobKind;
	public var key:String;
	public var filePath:String;
	public var xmlFilePath:String = null;
	public var gpu:Bool = true;
	public var address:String = null;
	public var streamed:Bool = false;
	public var bytes:Bytes = null;

	public var scan:LuaScanResult = null;
	public var characterImage:String = null;
	public var characterIcon:String = null;
	public var notes:Array<Array<Dynamic>> = null;
	public var image:Image = null;
	public var xml:Xml = null;
	public var buffer:AudioBuffer = null;
	public var error:String = null;

	public function new(owner:SongPreloader, kind:JobKind, key:String, filePath:String)
	{
		this.owner = owner;
		this.kind = kind;
		this.key = key;
		this.filePath = filePath;
	}

	public function discard():Void
	{
		if (buffer != null)
			buffer.dispose();
		buffer = null;
		bytes = null;
		image = null;
		xml = null;
	}
}

class SongPreloader
{
	public static var current(default, null):SongPreloader = null;

	static inline var FRAME_BUDGET:Float = 0.006;
	static inline var TIMEOUT:Float = 20;
	static inline var THREADS:Int = #if mobile 2 #else 3 #end;
	static inline var MAX_OUTSTANDING:Int = THREADS;
	static inline var GC_GROWTH_LIMIT:Float = 64 * 1024 * 1024;

	static var pool:ThreadPool = null;
	static var limeLock:Mutex = new Mutex();

	public var song(default, null):SwagSong;
	public var isDone(default, null):Bool = false;
	public var preloadedKeys(default, null):Map<String, Bool> = [];

	var collector:SongAssetCollector;
	var waiting:Array<PreloadJob> = [];
	var finished:Array<PreloadJob> = [];
	var inFlight:Int = 0;
	var cancelled:Bool = false;
	var draining:Bool = false;
	var doneCallbacks:Array<Void->Void> = [];
	var waitDeadline:Float = 0;
	var memAfterCollect:Float = Gc.memInfo64(Gc.MEM_INFO_CURRENT);

	public static function start(song:SwagSong):Void
	{
		if (song == null || (current != null && current.song == song))
			return;
		if (Std.isOfType(FlxG.state, PlayState))
			return;
		if (current != null)
			current.cancel();
		current = new SongPreloader(song);
	}

	public static function whenReady(callback:Void->Void, timeout:Float = TIMEOUT):Void
	{
		var preloader:SongPreloader = current;
		if (preloader == null || preloader.isDone)
		{
			callback();
			return;
		}

		preloader.doneCallbacks = [callback];
		preloader.waitDeadline = Timer.stamp() + timeout;
	}

	public static function keysFor(song:SwagSong):Null<Map<String, Bool>>
	{
		return (current != null && current.song == song) ? current.preloadedKeys : null;
	}

	public static function release():Void
	{
		if (current == null)
			return;
		current.doneCallbacks = [];
		current.cancel();
		current = null;
	}

	function new(song:SwagSong)
	{
		this.song = song;
		if (pool == null)
			createPool();

		var stageFile:StageData.StageFile = StageData.getStageFile(song.stage);
		var isPixelStage:Bool = stageFile != null && stageFile.isPixelStage;
		Paths.setCurrentLevel(stageFile != null && stageFile.directory != null && stageFile.directory.length > 0 ? stageFile.directory : 'shared');

		var songLower:String = song.song.toLowerCase();
		collector = new SongAssetCollector({
			song: song.song,
			player1: song.player1,
			player2: song.player2,
			player3: song.player3,
			stage: song.stage,
			arrowSkin: song.arrowSkin,
			splashSkin: song.splashSkin,
			needsVoices: song.needsVoices,
			isPixelStage: isPixelStage,
			noteSplashes: ClientPrefs.noteSplashes,
			legendas: ClientPrefs.legendas,
			camFollowScript: ClientPrefs.camZooms && !song.canfollowpermitido,
			legendPath: 'letras/' + songLower + '/' + ClientPrefs.lingua + '/',
			eventFiles: [songLower == 'cross-console-clash' ? 'events' + CoolUtil.difficultyStuff[PlayState.storyDifficulty][1] : 'events', 'palavroes', 'letras']
		});
		collector.addSong();
		collector.addNotes([for (section in song.notes) for (note in section.sectionNotes) (note : Array<Dynamic>)]);

		for (asset in PlayState.fixedPrecache())
		{
			switch (asset.type)
			{
				case 'image': collector.addImage(asset.key, null, false, true);
				case 'sound': collector.addSound(asset.key);
				case 'music': collector.addMusic(asset.key);
			}
		}
		for (key in PlayState.countdownImages(isPixelStage))
			collector.addImage(key, null, false, true);
		for (image in PlayState.haxeStageImages(song.stage, ClientPrefs.gore, ClientPrefs.lowQuality, ClientPrefs.shaders).concat(PlayState.startScreenImages(song.song)))
			collector.addImage(image.key, image.library, image.atlas, true);

		FlxG.signals.postUpdate.add(pump);
		pump();
	}

	function pump():Void
	{
		var budgetEnd:Float = Timer.stamp() + FRAME_BUDGET;
		do
		{
			var job:PreloadJob = finished.shift();
			if (job == null)
				break;
			try
			{
				finalize(job);
			}
			catch (e:Dynamic)
			{
				trace('SongPreloader: erro ao registrar ${job.key} ($e)');
			}
		}
		while (Timer.stamp() < budgetEnd);

		if (!draining && doneCallbacks.length > 0 && Timer.stamp() >= waitDeadline)
		{
			trace('SongPreloader: entrando na música sem esperar o resto do preload');
			draining = true;
			waiting = [];
		}

		if (!draining)
		{
			for (request in collector.takePending())
				resolve(request);
			feedWorkers();
		}

		if (Gc.memInfo64(Gc.MEM_INFO_CURRENT) - memAfterCollect > GC_GROWTH_LIMIT)
		{
			Gc.run(false);
			memAfterCollect = Gc.memInfo64(Gc.MEM_INFO_CURRENT);
		}

		if (inFlight == 0 && waiting.length == 0 && finished.length == 0 && (draining || !collector.hasPending()))
			finish();
	}

	function resolve(request:PreloadRequest):Void
	{
		switch (request)
		{
			case Script(id):
				queueRead(ReadScript, id, Paths.getPreloadPath(id));
			case CharacterJson(name):
				queueRead(ReadCharacter, name, Paths.getPreloadPath('characters/$name.json'));
			case EventFile(file):
				queueRead(ReadEvents, file, Paths.json(collector.songFolder + '/' + file));
			case ImageFile(key, library, atlas, gpu):
				queueImage(key, library, atlas, gpu);
			case Icon(healthIcon):
				queueImage(HealthIcon.getIconPath(healthIcon), 'shared', false, true);
			case SoundFile(key):
				queueSound(key, Paths.getSoundAddress(key, 'sounds', key));
			case MusicFile(key):
				queueSound(key, Paths.getSoundAddress(key, 'music', key));
			case SongAudio(file):
				var songKey:String = Paths.songAudioKey(song.song, file);
				queueSound(songKey, Paths.getSoundAddress(songKey, 'songs', songKey), true);
		}
	}

	function queueRead(kind:JobKind, key:String, assetId:String):Void
	{
		if (OpenFlAssets.exists(assetId))
			waiting.unshift(new PreloadJob(this, kind, key, LimeAssets.getPath(assetId)));
	}

	function queueImage(key:String, library:Null<String>, atlas:Bool, gpu:Bool):Void
	{
		if (Paths.currentTrackedAssets.exists(key))
		{
			preloadedKeys.set(key, true);
			return;
		}
		var file:String = library == 'locales' ? ClientPrefs.lingua + '/images/' + key : 'images/' + key;
		var id:String = Paths.getPath('$file.png', IMAGE, library);
		if (!OpenFlAssets.exists(id, IMAGE))
			return;

		var job:PreloadJob = new PreloadJob(this, DecodeImage, key, LimeAssets.getPath(id));
		job.gpu = gpu;
		if (atlas)
		{
			var xmlId:String = Paths.getPath('$file.xml', TEXT, library);
			if (OpenFlAssets.exists(xmlId))
				job.xmlFilePath = LimeAssets.getPath(xmlId);
		}
		waiting.push(job);
	}

	function queueSound(key:String, address:String, streamed:Bool = false):Void
	{
		if (Paths.isAudioLoaded(key))
		{
			preloadedKeys.set(key, true);
			return;
		}
		if (!OpenFlAssets.exists(address, SOUND))
			return;

		var job:PreloadJob = new PreloadJob(this, DecodeSound, key, LimeAssets.getPath(address));
		job.address = address;
		job.streamed = streamed;
		waiting.push(job);
	}

	function feedWorkers():Void
	{
		while (waiting.length > 0 && inFlight + finished.length < MAX_OUTSTANDING)
		{
			inFlight++;
			pool.queue(waiting.shift());
		}
	}

	function finalize(job:PreloadJob):Void
	{
		if (job.error != null)
		{
			trace('SongPreloader: ${job.key} ignorado (${job.error})');
			return;
		}
		switch (job.kind)
		{
			case ReadScript:
				collector.onScriptScanned(job.scan);
			case ReadCharacter:
				collector.onCharacterRead(job.key, job.characterImage, job.characterIcon);
			case ReadEvents:
				collector.addNotes(job.notes);
			case DecodeImage:
				Paths.registerDecodedImage(job.key, job.image, job.gpu);
				preloadedKeys.set(job.key, true);
				if (job.xml != null)
					Paths.registerSparrowFrames(job.key, job.xml);
			case DecodeSound:
				if (job.streamed)
					Paths.registerStreamedSound(job.key, job.address, job.bytes);
				else
					Paths.registerDecodedSound(job.key, job.address, job.buffer);
				preloadedKeys.set(job.key, true);
		}
	}

	function finish():Void
	{
		isDone = true;
		FlxG.signals.postUpdate.remove(pump);
		var callbacks:Array<Void->Void> = doneCallbacks;
		doneCallbacks = [];
		for (callback in callbacks)
			callback();
	}

	function cancel():Void
	{
		cancelled = true;
		FlxG.signals.postUpdate.remove(pump);
		for (job in finished)
			job.discard();
		finished = [];
		waiting = [];
		var callbacks:Array<Void->Void> = doneCallbacks;
		doneCallbacks = [];
		for (callback in callbacks)
			callback();
	}

	static function createPool():Void
	{
		pool = new ThreadPool(0, THREADS);
		pool.doWork.add(doWork);
		pool.onComplete.add(onJobDone);
		pool.onError.add(onJobDone);
	}

	static function doWork(state:Dynamic):Void
	{
		var job:PreloadJob = state;
		if (job.owner.cancelled)
		{
			pool.sendError(job);
			return;
		}
		try
		{
			var bytes:Bytes = readFile(job.filePath);
			if (bytes == null)
				throw 'arquivo não encontrado: ${job.filePath}';
			switch (job.kind)
			{
				case ReadScript:
					job.scan = SongAssetScanner.scanLua(bytes.toString());
				case ReadCharacter:
					var json:Dynamic = Json.parse(bytes.toString());
					job.characterImage = json.image;
					job.characterIcon = json.healthicon;
				case ReadEvents:
					job.notes = SongAssetCollector.notesFromSongJson(bytes.toString());
				case DecodeImage:
					limeCall(function()
					{
						job.image = Image.fromBytes(bytes);
						#if sys
						if (job.image != null)
						{
							job.image.format = BGRA32;
							job.image.premultiplied = true;
						}
						#end
					});
					if (job.image == null)
						throw 'imagem inválida: ${job.filePath}';
					if (job.xmlFilePath != null)
					{
						try
						{
							var xmlBytes:Bytes = readFile(job.xmlFilePath);
							if (xmlBytes != null)
								job.xml = Xml.parse(xmlBytes.toString());
						}
						catch (e:Dynamic) {}
					}
				case DecodeSound:
					if (job.streamed)
						job.bytes = bytes;
					else
					{
						limeCall(function() job.buffer = AudioBuffer.fromBytes(bytes));
						if (job.buffer == null)
							throw 'som inválido: ${job.filePath}';
					}
			}
			pool.sendComplete(job);
		}
		catch (e:Dynamic)
		{
			job.error = Std.string(e);
			pool.sendError(job);
		}
	}

	static function readFile(path:String):Null<Bytes>
	{
		#if android
		var bytes:Null<Bytes> = null;
		limeCall(function() bytes = Bytes.fromFile(path));
		return bytes;
		#else
		return sys.FileSystem.exists(path) ? sys.io.File.getBytes(path) : null;
		#end
	}

	static function limeCall(call:Void->Void):Void
	{
		limeLock.acquire();
		Gc.enable(false);
		Gc.safePoint();
		try
		{
			call();
		}
		catch (e:Dynamic)
		{
			Gc.enable(true);
			limeLock.release();
			throw e;
		}
		Gc.enable(true);
		limeLock.release();
	}

	static function onJobDone(state:Dynamic):Void
	{
		var job:PreloadJob = state;
		var owner:SongPreloader = job.owner;
		owner.inFlight--;
		if (owner.cancelled)
		{
			job.discard();
			return;
		}
		owner.finished.push(job);
	}
}
