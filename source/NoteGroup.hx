package;

import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;

@:access(flixel.FlxCamera)
class NoteGroup extends FlxTypedGroup<Note>
{
	var tails:Array<Note> = [];

	override public function draw():Void
	{
		var oldDefaultCameras = FlxCamera._defaultCameras;
		if (cameras != null)
			FlxCamera._defaultCameras = cameras;

		for (note in members)
			if (note != null && note.exists && note.visible && note.isSustainNote)
				tails.push(note);
		tails.sort(byStrumTime);
		for (note in tails)
			note.draw();
		tails.resize(0);

		for (note in members)
			if (note != null && note.exists && note.visible && !note.isSustainNote)
				note.draw();

		FlxCamera._defaultCameras = oldDefaultCameras;
	}

	override public function forEachAlive(Function:Note->Void, Recurse:Bool = false):Void
	{
		for (note in members.copy())
			if (note != null && note.exists && note.alive)
				Function(note);
	}

	static function byStrumTime(a:Note, b:Note):Int
	{
		return a.strumTime < b.strumTime ? -1 : (a.strumTime > b.strumTime ? 1 : 0);
	}
}
