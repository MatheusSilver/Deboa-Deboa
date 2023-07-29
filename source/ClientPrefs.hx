package;

import flixel.FlxG;
import flixel.util.FlxSave;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import PlayerSettings;
import TitleState;

class ClientPrefs
{
	// Novamente um state feito pelo Silver no mesmo port da hatsune miku
	public static var shaders:Null<Bool> = #if windows true #else false #end;
	public static var downScroll:Null<Bool> = false;
	public static var pibby:Null<Bool> = false;
	public static var middleScroll:Null<Bool> = false;
	public static var showFPS:Null<Bool> = true;
	public static var flashing:Null<Bool> = true;
	public static var legendas:Null<Bool> = true;
	public static var loadingexperimental:Null<Bool> = true;
	public static var legendasporcima:Null<Bool> = true;
	public static var pausarauto:Null<Bool> = true;
	public static var globalAntialiasing:Null<Bool> = true;
	public static var lowQuality:Null<Bool> = false;
	public static var noteSplashes:Null<Bool> = true;
	public static var framerate:Null<Int> = 60;
	public static var gore:Null<Bool> = false;
	public static var cursing:Null<Bool> = true;
	public static var camZooms:Null<Bool> = true;
	public static var hideHud:Null<Bool> = false;
	public static var hitSounds:Null<Bool> = false;
	public static var fullscreen:Null<Bool> = false;
	public static var hitSoundType:Null<Int> = 0;
	public static var osusom:Null<Float> = 0.5;
	public static var efeitosVolume:Null<Float> = 0.8;
	public static var noteOffset:Null<Int> = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var ghostTapping:Null<Bool> = true;
	public static var hideTime:Null<Bool> = false;
	public static var firstTime:Null<Bool> = true;
	public static var buttonsMode:Array<Dynamic> = [];
	public static var buttons:Array<Dynamic> = [];

	// Controls
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		// Key Bind, Name for ControlsSubState
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_space' => [SPACE],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE],
		'volume_mute' => [ZERO, NONE],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS],
		'debug_1' => [SEVEN, NONE],
		'debug_2' => [EIGHT, NONE]
	];

	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
		// trace(defaultKeys);
	}

	private static var importantMap:Map<String, Array<String>> = ["flixelSound" => ["volume"]];

	/** Quick Function to Fix Save Files for Flixel 5
		@BeastlyGabi
	**/
	inline public static function getSavePath(folder:String = 'TeamSilver'):String
	{
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	public static function init()
	{
		FlxG.save.bind('modboa', getSavePath());

		// https://github.com/ShadowMario/FNF-PsychEngine/pull/11633
		for (field in Type.getClassFields(ClientPrefs))
		{
			if (Type.typeof(Reflect.field(ClientPrefs, field)) != TFunction)
			{
				if (!importantMap.get("flixelSound").contains(field))
				{
					var defaultValue:Dynamic = Reflect.field(ClientPrefs, field);
					var flxProp:Dynamic = Reflect.field(FlxG.save.data, field);
					Reflect.setField(ClientPrefs, field, (flxProp != null ? flxProp : defaultValue));
				}
			}
		}

		for (flixelS in importantMap.get("flixelSound"))
		{
			var flxProp:Dynamic = Reflect.field(FlxG.save.data, flixelS);

			if (flxProp != null)
				Reflect.setField(FlxG.sound, flixelS, flxProp);
		}

		Highscore.load();
		PlayerSettings.init();
        carregarControles();
	}

	public static function save()
	{
		// ensure that we're saving (hopefully)
		if (FlxG.save.data == null)
			FlxG.save.bind('modboa', getSavePath());

		for (field in Type.getClassFields(ClientPrefs))
		{
			if (Type.typeof(Reflect.field(ClientPrefs, field)) != TFunction)
				Reflect.setField(FlxG.save.data, field, Reflect.field(ClientPrefs, field));
		}

		for (flixel in importantMap.get("flixelSound"))
			Reflect.setField(FlxG.save.data, flixel, Reflect.field(FlxG.sound, flixel));

		FlxG.save.flush();
	}

    // Fiz duas funções de save, pq na X02Engine, quando eu salvava com o save normal, ele substituia as bools
    public static function salvarControles() {

        var save:FlxSave = new FlxSave();
		save.bind('controls_v2', CoolUtil.getSavePath());
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");

    }

    public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

    public static function carregarControles() {
        var save:FlxSave = new FlxSave();
		save.bind('controls_v2', CoolUtil.getSavePath());
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
    }

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
