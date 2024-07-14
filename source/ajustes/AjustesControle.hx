package ajustes;

import flixel.input.gamepad.FlxGamepadInputID;
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

class AjustesControle extends MusicBeatState {
	private static var curSelected:Int = -1;
	private static var curAlt:Bool = false;

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
	private var grpInputs:Array<AttachedText> = [];
	private var grpInputsAlt:Array<AttachedText> = [];
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
			optionText.yMult = 60;
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

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		if(!rebindingKey) {
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
					ClientPrefs.keyBindsGamepad = ClientPrefs.defaultKeysGamepad.copy();
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
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
			var keyPressed:Int = gamepad.firstJustPressedRawID();
			if (keyPressed > -1) {
				var keysArray:Array<FlxGamepadInputID> = ClientPrefs.keyBindsGamepad.get(optionShit[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if(keysArray[opposite] == keysArray[1 - opposite]) {
					keysArray[opposite] = NONE;
				}
				ClientPrefs.keyBindsGamepad.set(optionShit[curSelected][1], keysArray);

				reloadKeys();
				GlobalSoundManager.play(confirmMenu);
				rebindingKey = false;
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

	private function addBindTexts(optionText:Alphabet, num:Int) {
		var keys:Array<Dynamic> = ClientPrefs.keyBindsGamepad.get(optionShit[num][1]);
		var text1 = new AttachedText(Input.InputFormatter.getKeyNameGamepad(keys[0]), 400, -55);
		text1.setPosition(optionText.x + 400, optionText.y - 55);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);

		var text2 = new AttachedText(Input.InputFormatter.getKeyNameGamepad(keys[1]), 650, -55);
		text2.setPosition(optionText.x + 650, optionText.y - 55);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedText = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while(grpInputsAlt.length > 0) {
			var item:AttachedText = grpInputsAlt[0];
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