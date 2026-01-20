package;

import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef StageFile =
{
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
}

class StageData
{
	public static var forceNextDirectory:String = null;

	public static function loadDirectory(SONG:Song.SwagSong)
	{
		var stage:String = SONG.stage != null ? SONG.stage : 'confronting'; // Seguindo a lógica que a CY também é a padrão no PlayState.

		var stageFile:StageFile = getStageFile(stage);
		if (stageFile == null)
			forceNextDirectory = '';
		else
			forceNextDirectory = stageFile.directory;
	}

	public static function getStageFile(stage:String):StageFile
	{
		var rawJson:String = null;
		var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

		if (Assets.exists(path))
			rawJson = Assets.getText(path);
		else
			return null;
		
		return cast Json.parse(rawJson);
	}
}