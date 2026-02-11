package;

// Isso eu acho util estar unificado. Não vou mexer.

import flixel.FlxG;
import flixel.math.FlxMath;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var gfSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

class Section
{
	public var sectionNotes:Array<Dynamic> = [];

	public var lengthInSteps:Int = 16;
	public var gfSection:Bool = false;
	public var typeOfSection:Int = 0;
	public var mustHitSection:Bool = true;

	/**
	 *	Copies the first section into the second section!
	 */
	public static var COPYCAT:Int = 0;

	public function new(lengthInSteps:Int = 16)
	{
		this.lengthInSteps = lengthInSteps;
	}
}

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
	@:optional var stepCrochet:Float;
}

class Conductor
{
	public static var bpm:Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var songPosition:Float;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new() {}

	public static function getBPMFromSeconds(time:Float)
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: bpm,
			stepCrochet: stepCrochet
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (time >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		return lastChange;
	}

	/* Adaptado do código original do FNF */
	public static function update(?songPos:Float):Void
	{
		var currentTime:Float = (FlxG.sound.music != null) ? FlxG.sound.music.time : 0.0;
		var currentLength:Float = (FlxG.sound.music != null) ? FlxG.sound.music.length : 0.0;

		if (songPos == null)
		{
			songPos = currentTime;
		}

		// If the song is playing, limit the song position to the length of the song or beginning of the song.
		if (FlxG.sound.music != null)
		{
			songPosition = FlxMath.bound(songPos, 0, currentLength);
		}
		else
		{
			songPosition = songPos;
		}

		// Get the BPM change event for the current song position
		var currentBPMEvent:BPMChangeEvent = getBPMFromSeconds(songPosition);

		if (currentBPMEvent == null && FlxG.sound.music != null)
		{
			trace('WARNING: Conductor BPM map is empty or invalid.');
		}
		else if (currentBPMEvent != null && songPosition > 0.0)
		{
			// Calculate current position based on BPM event
			var stepCrochet:Float = currentBPMEvent.stepCrochet;
			var timeSinceEvent:Float = songPosition - currentBPMEvent.songTime;
			
			// roundDecimal prevents representing 8 as 7.9999999
			var currentStepTime:Float = FlxMath.roundDecimal(
				currentBPMEvent.stepTime + (timeSinceEvent / stepCrochet), 6);
			
			lastSongPos = songPosition;
		}
		else if (songPosition >= 0.0)
		{
			// Assume a constant BPM
			var stepCrochet:Float = stepCrochet;
			var currentStepTime:Float = FlxMath.roundDecimal((songPosition / stepCrochet), 4);
			lastSongPos = songPosition;
		}
	}

	public static function getBPMFromStep(step:Float)
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: bpm,
			stepCrochet: stepCrochet
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.bpmChangeMap[i].stepTime <= step)
				lastChange = Conductor.bpmChangeMap[i];
		}

		return lastChange;
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM,
					stepCrochet: ((60 / curBPM) * 1000) / 4
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		#if debug
		trace("new BPM map BUDDY " + bpmChangeMap);
		#end
	}

	public static function stepToSeconds(step:Float)
	{
		var lastChange = getBPMFromStep(step);
		return step * lastChange.stepCrochet; // TODO: make less shit and take BPM into account PROPERLY
	}

	public static function getCrotchetAtTime(time:Float)
	{
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepCrochet * 4;
	}

	public static function beatToSeconds(beat:Float)
	{
		var step = beat * 4;
		var lastChange = getBPMFromStep(step);
		return lastChange.songTime
			+
			((step - lastChange.stepTime) / (lastChange.bpm / 60) / 4) * 1000; // step * (lastChange.stepCrochet*4); // TODO: make less shit and take BPM into account PROPERLY
	}

	public static function getStep(time:Float)
	{
		var lastChange = getBPMFromSeconds(time);
		return lastChange.stepTime + (time - lastChange.songTime) / lastChange.stepCrochet;
	}

	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;
	var videonombre:String;
	var legendaOffset:Float;
	var legendaSpacing:Float;

	var player1:String;
	var player2:String;
	var player3:String;
	var stage:String;

	var arrowSkin:String;
	var splashSkin:String;
	var validScore:Bool;
	var isRing:Bool;
	var startinvisibru:Bool;
	var canfollowpermitido:Bool;
}

class Song
{
	public var song:String;
	public var videonombre:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var startinvisibru:Bool = false;
	public var arrowSkin:String;
	public var splashSkin:String;
	public var isRing:Bool = false;
	public var speed:Float = 1;
	public var stage:String;
	public var canfollowpermitido:Bool = false;
	public var legendaOffset:Float;
	public var legendaSpacing:Float = 64;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var player3:String = 'gf';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = null;

		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);

		if (rawJson == null)
		{ // Isso aqui só foi feito pra engine poder reconhecer as lyrics que o konan for colocar sem precisar serem compiladas
			// Não sabia que o assets não conseguia fazer isso, mas até que faz sentido
			#if (desktop && debug)
			rawJson = sys.io.File.getContent(Paths.json(formattedFolder + '/' + formattedSong)).trim();
			#else
			rawJson = Assets.getText(Paths.json(formattedFolder + '/' + formattedSong)).trim();
			#end
		}

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		var songJson:SwagSong = parseJSONshit(rawJson);
		if (jsonInput != 'events')
			StageData.loadDirectory(songJson);
		return songJson;
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
