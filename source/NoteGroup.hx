package;

import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;

@:access(flixel.FlxCamera)
class NoteGroup extends FlxTypedGroup<Note>
{
	override public function draw():Void
	{
		var oldDefaultCameras = FlxCamera._defaultCameras;
		if (cameras != null)
			FlxCamera._defaultCameras = cameras;

		drawNotes(true);
		drawNotes(false);

		FlxCamera._defaultCameras = oldDefaultCameras;
	}

	override public function forEachAlive(Function:Note->Void, Recurse:Bool = false):Void
	{
		for (note in members.copy())
			if (note != null && note.exists && note.alive)
				Function(note);
	}

	function drawNotes(sustains:Bool):Void
	{
		for (note in members)
			if (note != null && note.exists && note.visible && note.isSustainNote == sustains)
				note.draw();
	}
}
