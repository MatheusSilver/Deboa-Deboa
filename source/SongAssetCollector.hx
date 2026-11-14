package;

import SongAssetScanner.LuaScanResult;

using StringTools;

enum PreloadRequest
{
	Script(id:String);
	CharacterJson(name:String);
	EventFile(file:String);
	ImageFile(key:String, library:Null<String>, atlas:Bool, gpu:Bool);
	Icon(healthIcon:String);
	SoundFile(key:String);
	MusicFile(key:String);
	SongAudio(file:String);
}

typedef SongAssetOptions =
{
	var song:String;
	var player1:String;
	var player2:String;
	var player3:String;
	var stage:String;
	var arrowSkin:String;
	var splashSkin:String;
	var needsVoices:Bool;
	var isPixelStage:Bool;
	var noteSplashes:Bool;
	var legendas:Bool;
	var camFollowScript:Bool;
	var legendPath:String;
	var eventFiles:Array<String>;
}

class SongAssetCollector
{
	public var songFolder(default, null):String;

	var options:SongAssetOptions;
	var arrowSkin:String;
	var pending:Array<PreloadRequest> = [];
	var seen:Map<String, Bool> = [];

	public function new(options:SongAssetOptions)
	{
		this.options = options;
		songFolder = options.song.toLowerCase().replace(' ', '-');
		arrowSkin = isEmpty(options.arrowSkin) ? 'NOTE_assets' : options.arrowSkin;
	}

	public function hasPending():Bool
	{
		return pending.length > 0;
	}

	public function takePending():Array<PreloadRequest>
	{
		var taken:Array<PreloadRequest> = pending;
		pending = [];
		return taken;
	}

	public function addSong():Void
	{
		addCharacter(options.player1);
		addCharacter(options.player2);
		addCharacter(isEmpty(options.player3) ? 'gf' : options.player3);
		if (!isEmpty(options.stage))
			addScript('stages/${options.stage}.lua');
		addScript('data/$songFolder/master.lua');
		if (options.camFollowScript)
			addScript('custom_scripts/camFollowGlobal.lua');
		for (file in options.eventFiles)
			add('events:' + file, EventFile(file));

		add('audio:Inst', SongAudio('Inst'));
		if (options.needsVoices)
			add('audio:Voices', SongAudio('Voices'));

		addNoteSkin(arrowSkin);
		if (options.noteSplashes)
			addImage('splashes/' + (isEmpty(options.splashSkin) ? 'noteSplashes' : options.splashSkin), null, true, true);
	}

	public function addNotes(notes:Array<Array<Dynamic>>):Void
	{
		for (note in notes)
		{
			if (note == null || note.length < 3 || !(Std.isOfType(note[1], Int) || Std.isOfType(note[1], Float)))
				continue;
			if (note[1] < 0)
				addEvent(note);
			else if (note.length > 3 && isText(note[3]))
				addNoteType(note[3]);
		}
	}

	public function addImage(key:String, library:Null<String>, atlas:Bool, gpu:Bool):Void
	{
		if (!isEmpty(key))
			add('img:' + key, ImageFile(key, library, atlas, gpu));
	}

	public function addSound(key:String):Void
	{
		if (!isEmpty(key))
			add('snd:' + key, SoundFile(key));
	}

	public function addMusic(key:String):Void
	{
		if (!isEmpty(key))
			add('music:' + key, MusicFile(key));
	}

	public function onScriptScanned(result:LuaScanResult):Void
	{
		for (image in result.images)
			addImage(image.key, image.library, image.atlas, image.gpu);
		for (sound in result.sounds)
			addSound(sound);
		for (name in result.characters)
			addCharacter(name);
		for (script in result.songScripts)
			addScript('data/$songFolder/$script');
		for (script in result.globalScripts)
			addScript(script);
	}

	public function onCharacterRead(name:String, image:Null<String>, healthIcon:Null<String>):Void
	{
		if (!isEmpty(image))
			addImage(image, 'shared', true, true);
		if (!isEmpty(healthIcon))
			add('icon:' + healthIcon, Icon(healthIcon));
	}

	public static function notesFromSongJson(text:String):Array<Array<Dynamic>>
	{
		text = text.trim();
		while (text.length > 0 && !text.endsWith('}'))
			text = text.substr(0, text.length - 1);
		var notes:Array<Array<Dynamic>> = [];
		var song:Dynamic = haxe.Json.parse(text).song;
		if (song == null || song.notes == null)
			return notes;
		for (section in (song.notes : Array<Dynamic>))
			if (section != null && section.sectionNotes != null)
				for (note in (section.sectionNotes : Array<Dynamic>))
					notes.push(note);
		return notes;
	}

	function addEvent(note:Array<Dynamic>):Void
	{
		if (!isText(note[2]))
			return;
		var name:String = note[2];
		addScript('custom_events/$name.lua');
		switch (name)
		{
			case 'Change Character':
				if (note.length > 4 && isText(note[4]))
					addCharacter(note[4]);
			case 'noteskinchangeBF' | 'noteskinchangeOPPT':
				if (note.length > 3 && isText(note[3]))
					addNoteSkin(note[3]);
			case 'Adicionar Imagens' | 'Adicionar Imagens diferenciado' | 'Adicionar Imagens diferenciadasso':
				if (options.legendas)
					for (i in 3...7)
						if (i < note.length && isText(note[i]))
							addImage(options.legendPath + note[i], null, false, true);
		}
	}

	function addNoteType(type:String):Void
	{
		addScript('custom_notetypes/$type.lua');
		if (type == 'Hurt Note')
			addNoteSkin(arrowSkin, 'HURT');
	}

	function addNoteSkin(skin:String, prefix:String = ''):Void
	{
		var slash:Int = skin.lastIndexOf('/');
		var file:String = skin.substr(0, slash + 1) + prefix + skin.substr(slash + 1);
		if (options.isPixelStage || skin.endsWith('zoom'))
		{
			addImage('pixelUI/' + file, null, false, true);
			addImage('pixelUI/' + file + 'ENDS', null, false, true);
		}
		else
			addImage(file, null, true, true);
	}

	function addCharacter(name:String):Void
	{
		if (!isEmpty(name) && add('json:' + name, CharacterJson(name)))
			addScript('characters/$name.lua');
	}

	function addScript(id:String):Void
	{
		add('lua:' + id, Script(id));
	}

	function add(id:String, request:PreloadRequest):Bool
	{
		if (seen.exists(id))
			return false;
		seen.set(id, true);
		pending.push(request);
		return true;
	}

	static inline function isEmpty(value:String):Bool
	{
		return value == null || value.length == 0;
	}

	static inline function isText(value:Dynamic):Bool
	{
		return Std.isOfType(value, String) && (value : String).length > 0;
	}
}
