package ajustes;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.lists.FlxGamepadButtonList;
import flixel.input.gamepad.FlxGamepad;
#if rpc
import Discord.DiscordClient;
#end
import Input.Controls;
import flash.text.TextField;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class KeysSubstate extends MusicBeatState {
	private static var curSelected:Int = -1;
	private static var curAlt:Bool = false;
	private static var gamepad:FlxGamepad;

	private var defaultKey:String = Linguagem.LangUtil.getString("key_reset", "key");
	private var bindLength:Int = 0;

	var optionShit:Array<Dynamic> = [
		[Linguagem.LangUtil.getString("key_note", "key")],
		[Linguagem.LangUtil.getString("key_left", "key"), 'note_left'],
		[Linguagem.LangUtil.getString("key_down", "key"), 'note_down'],
		[Linguagem.LangUtil.getString("key_up", "key"), 'note_up'],
		[Linguagem.LangUtil.getString("key_right", "key"), 'note_right'],
		[Linguagem.LangUtil.getString("key_dodge", "key"), 'note_space'],
		[''],
		['UI'],
		[Linguagem.LangUtil.getString("key_left", "key"), 'ui_left'],
		[Linguagem.LangUtil.getString("key_down", "key"), 'ui_down'],
		[Linguagem.LangUtil.getString("key_up", "key"), 'ui_up'],
		[Linguagem.LangUtil.getString("key_right", "key"), 'ui_right'],
		[''],
		[Linguagem.LangUtil.getString("key_reset", "key"), 'reset'],
		[Linguagem.LangUtil.getString("key_accept", "key"), 'accept'],
		[Linguagem.LangUtil.getString("key_return", "key"), 'back'],
		[Linguagem.LangUtil.getString("key_pause", "key"), 'pause'],
		[''],
		[Linguagem.LangUtil.getString("key_volume", "key")],
		[Linguagem.LangUtil.getString("key_mute", "key"), 'volume_mute'],
		[Linguagem.LangUtil.getString("key_volup", "key"), 'volume_up'],
		[Linguagem.LangUtil.getString("key_voldown", "key"), 'volume_down'],
		['']#if debug ,
		['DEBUG'],
		['Tecla 1', 'debug_1'],
		['Tecla 2', 'debug_2']
		#end
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpInputs:Array<AttachedSprite> = [];
	private var grpInputsAlt:Array<AttachedSprite> = [];
	var rebindingKey:Bool = false;
	var nextAccept:Int = 5;

	public function new() {
		super();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('escolhendo-branco'));
		bg.color = 0xffffffff; //arrumem a cor a vosso gosto
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		optionShit.push(['']);
		optionShit.push([defaultKey]);

		for (i in 0...optionShit.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optionShit[i][0] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:Alphabet = new Alphabet(0, (10 * i), optionShit[i][0], (!isCentered || isDefaultKey), false, 0, 0, 'padrao');
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
				optionText.yAdd = -55;
			} else {
				optionText.forceX = 200;
			}
			optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText, i);
				bindLength++;
				if(curSelected < 0) curSelected = i;
			}
		}
		changeSelection();
	}

	private var gamepadModel:String = "Keyboard"; //Provavelmente não a melhor escolha, mas lesgo.

	private function setGamepadModel(gamepad:FlxGamepad):Void
	{
		switch(gamepad.detectedModel){
			case PS4:
				gamepadModel = "PS4";
			case SWITCH_PRO:
				gamepadModel = "Switch";
			default:
				gamepadModel = "Xinput"; //Aparentemente os controles do Steam e do Xbox seguem o mesmo padrão. (Infelizmente não tenho um steam deck pra testar).
		}
	}

	private function isGamepadConnected():Bool
	{
		if (FlxG.gamepads.lastActive != null){
			gamepad = FlxG.gamepads.lastActive;
			setGamepadModel(gamepad);
			return true;
		}
		return false;
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	var keyboardMode:Bool = true;
	override function update(elapsed:Float) {
		if(!rebindingKey) {
			if (isGamepadConnected() && FlxG.gamepads.anyButton() && keyboardMode){
				keyboardMode = false;
				reloadKeys();
			}else if (FlxG.keys.pressed.ANY && !keyboardMode){
				gamepadModel = "Keyboard";
				keyboardMode = true;
				reloadKeys();
			}
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK #if mobile || FlxG.android.justReleased.BACK #end) { //haha sistema anti burrice
				ClientPrefs.reloadControls();
				/*
				grpOptions.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				}); */
				MusicBeatState.switchState(new ajustes.AjustesState());
				ClientPrefs.salvarControles();
				GlobalSoundManager.play(cancelMenu);
			}

			if(controls.ACCEPT || FlxG.keys.justPressed.ENTER && nextAccept <= 0) {
				if(optionShit[curSelected][0] == defaultKey) {
					ClientPrefs.keyBinds = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					GlobalSoundManager.play(confirmMenu);
				} else if(!unselectableCheck(curSelected)) {
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt) {
						grpInputsAlt[getInputTextNum()].alpha = 0;
					} else {
						grpInputs[getInputTextNum()].alpha = 0;
					}
					GlobalSoundManager.play(scrollMenu);
				}
			}
		} else {
			var keyPressed:Int;
			if (keyboardMode) keyPressed = FlxG.keys.firstJustPressed();
			else 			  keyPressed = gamepad.firstJustPressedID();
			trace(keyPressed);
			if (keyPressed > -1) {
				if (keyboardMode)
					changeBindsKeyboard(keyPressed);
				else
					changeBindsGamepad(keyPressed);
			}
			
			bindingTime += elapsed;
			if(bindingTime > 5) {
				if (curAlt) {
					grpInputsAlt[curSelected].alpha = 1;
				} else {
					grpInputs[curSelected].alpha = 1;
				}
				GlobalSoundManager.play(scrollMenu);
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	private function changeBindsKeyboard(newBind:Int):Void
	{
		var keysArray:Array<FlxKey> = ClientPrefs.keyBinds.get(optionShit[curSelected][1]);
		keysArray[curAlt ? 1 : 0] = newBind;
		
		var opposite:Int = (curAlt ? 0 : 1);
		if(keysArray[opposite] == keysArray[1 - opposite]) {
			keysArray[opposite] = NONE;
		}
		ClientPrefs.keyBinds.set(optionShit[curSelected][1], keysArray);
		
		reloadKeys();
		GlobalSoundManager.play(confirmMenu);
		rebindingKey = false;
	}

	private function changeBindsGamepad(newBind:Int):Void
	{
		var keysArray:Array<FlxGamepadInputID> = ClientPrefs.keyBindsGamepad.get(optionShit[curSelected][1]);
		keysArray[curAlt ? 1 : 0] = newBind;
		
		var opposite:Int = (curAlt ? 0 : 1);
		if(keysArray[opposite] == keysArray[1 - opposite]) {
			keysArray[opposite] = NONE;
		}
		ClientPrefs.keyBindsGamepad.set(optionShit[curSelected][1], keysArray);
		
		reloadKeys();
		GlobalSoundManager.play(confirmMenu);
		rebindingKey = false;
	}

	function getInputTextNum() {
		var num:Int = 0;
		for (i in 0...curSelected) {
			if(optionShit[i].length > 1) {
				num++;
			}
		}
		return num;
	}

	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optionShit.length - 1;
			if (curSelected >= optionShit.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
								break;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
								break;
							}
						}
					}
				}
			}
		}
		GlobalSoundManager.play(scrollMenu);
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.6;
				if(!curAlt) {
					grpInputs[i].alpha = 1;
				}
				break;
			}
		}
		for (i in 0...grpInputsAlt.length) {
			if(grpInputsAlt[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputsAlt[i].alpha = 0.6;
				if(curAlt) {
					grpInputsAlt[i].alpha = 1;
				}
				break;
			}
		}
		GlobalSoundManager.play(scrollMenu);
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optionShit[num][0] == defaultKey) {
			return checkDefaultKey;
		}
		return optionShit[num].length < 2 && optionShit[num][0] != defaultKey;
	}

	private function formatKey(inputData:Dynamic):String
		{
			if (keyboardMode) return Input.InputFormatter.getKeyName(inputData);
			else 			  return Input.InputFormatter.getKeyNameGamepad(inputData);
		}
	
	private function addBindTexts(optionText:Alphabet, num:Int) { //Preguiça de mudar o nome da função.
		var keys:Array<Dynamic>;
		if (keyboardMode) keys = ClientPrefs.keyBinds.get(optionShit[num][1]);
		else 			  keys = ClientPrefs.keyBindsGamepad.get(optionShit[num][1]);
		var text1 = new AttachedSprite('input/$gamepadModel/${formatKey(keys[0])}', null, "preload");
		text1.xAdd = 450;
		text1.yAdd = -25;
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedSprite('input/$gamepadModel/${formatKey(keys[1])}', null, "preload");
		text2.xAdd = 650;
		text2.yAdd = -25;
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedSprite = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while(grpInputsAlt.length > 0) {
			var item:AttachedSprite = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i], i);
			}
		}


		var bullShit:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
							}
						}
					}
				}
			}
		}
	}
} 