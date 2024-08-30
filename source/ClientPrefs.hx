package;

import Utils.InputDevices;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.FlxG;
import flixel.util.FlxSave;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Input.PlayerSettings;
import TitleState;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;

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
	public static var hitSoundType:Null<Int> = 1;
	public static var osusom:Null<Float> = 0.5;
	public static var efeitosVolume:Null<Float> = 0.8;
	public static var noteOffset:Null<Int> = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var ghostTapping:Null<Bool> = true;
	public static var hideTime:Null<Bool> = false;
	public static var firstTime:Null<Bool> = true;
	public static var buttonsMode:Array<Dynamic> = [];
	public static var buttons:Array<Dynamic> = [];
	public static var achievementsMap:Map<String, Bool> = [];
	public static var likesMap:Map<String, String> = [];
	public static var currentModifiers:Array<Int> = []; // valeu dav
	public static var opacidadeLegendas:Float = 1;
	public static var focus:Null<Bool> = false;
	public static var lingua:Null<String> = "pt-BR";
	public static var shaderMatrix:Array<Float> = [];
	public static var curFilter:Null<Int> = 0; // isso é feio mas funciona :D
	public static var curMultiplayerNoteSkin = 0;
	public static var palavroes:Null<Bool> = true;
	public static var canReset:Null<Bool> = true; // fiz isso pois meu dedo gordo clica sem querer querendo no R toda vez que eu aperto D ou F no teclado :D
	public static var gamepadDisplay:InputDevices = AUTO;

	public static var firstBoot:Null<Bool> = true;

	// Pop ups
	public static var multiplayerPopUp:Null<Bool> = false;
	public static var freeplayPopUp:Null<Bool> = false;
	public static var modifiersPopUp:Null<Bool> = false; 

	public static var keyBinds:Map<String, Array<FlxKey>> = new Map<String, Array<FlxKey>>();
	public static var keyBindsGamepad:Map<String, Array<FlxGamepadInputID>> = new Map<String, Array<FlxGamepadInputID>>();

	private static var importantMap:Map<String, Array<String>> = ["flixelSound" => ["volume"]];

	public static function init()
	{
		FlxG.save.bind('modboa', Utils.CoolUtil.getSavePath());

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
		
		carregarControles();
		PlayerSettings.init();
		Highscore.load();
	}
	public static function save()
	{
		// ensure that we're saving (hopefully)
		if (FlxG.save.data == null)
			FlxG.save.bind('modboa', Utils.CoolUtil.getSavePath());

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
		save.bind('controlesmodboa', Utils.CoolUtil.getSavePath());
		save.data.customControls = keyBinds;
		save.data.customControlsGamepad = keyBindsGamepad;
		save.flush();
		FlxG.log.add("Settings saved!");

    }

    public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(Input.KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

    public static function carregarControles() {
		var save:FlxSave = new FlxSave();
		save.bind('controlesmodboa', Utils.CoolUtil.getSavePath());
	
		var defaultKeyboardControls:Map<String, Array<FlxKey>> = Input.DefaultInputs.defaultKeys;
		for (control => keys in defaultKeyboardControls) {
			keyBinds.set(control, keys);
		}
	
		if (save != null && save.data.customControls != null) {
			var customKeyboardControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in customKeyboardControls) {
				keyBinds.set(control, keys);
			}
		}
	
		var defaultGamepadControls:Map<String, Array<FlxGamepadInputID>> = Input.DefaultInputs.defaultKeysGamepad;
		for (control => keys in defaultGamepadControls) {
			keyBindsGamepad.set(control, keys);
		}
	
		if (save != null && save.data.customControlsGamepad != null) {
			var customGamepadControls:Map<String, Array<FlxGamepadInputID>> = save.data.customControlsGamepad;
			for (control => keys in customGamepadControls) {
				keyBindsGamepad.set(control, keys);
			}
		}
	
		reloadControls();
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
