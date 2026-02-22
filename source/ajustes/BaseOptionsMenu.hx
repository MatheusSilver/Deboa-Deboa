package ajustes;

import BSLTouchUtils;
import BSLTouchUtils.BSLSwipeUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import gamejolt.*;

using StringTools;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

#if rpc
import Discord.DiscordClient;
#end

class BaseOptionsMenu extends MusicBeatState
{
	private static var curSelected:Int = 0;
	static var unselectableOptions:Array<String> = [
		'visuals_cap',
		'subt_cap',
		'global_sounds_cap',
		'acessibilidade_cap',
		'gameplay_cap',
		'hitsound_sounds_cap'
	];
	static var noCheckbox:Array<String> = [
		'fps_max',
		'note_delay',
		'opacity',
		'game_volume',
		'hitsound_volume',
		'hitsound_type',
		'hitsound_test',
		'colorblindness_filter',
		#if desktop
		'cursor_size'
		#end
	];

	static var options:Array<String> = [
		'visuals_cap',
		'low_quality',
		'shaders',
		'aliasing',
		'fullscreen',
		'hide_hud',
		'hide_time',
		#if desktop
		'auto_pause',
		#end
		'fps_visible',
		if(Main.is_GPU_allowed ) 'gpu',
		#if !html5
		'fps_max', //Apparently 120FPS isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		#end
		'gameplay_cap',
		'downscroll',
		'middlescroll',
		'reset',
		//'Ghost Tapping', //Isso é deveras é perigoso em algumas músicas
		'note_delay',
		'splash',
		'focus',
		'cam_effects',
		'subt_cap',
		'subtitles',
		'opacity',
		'acessibilidade_cap',
		'flashing',
		'gore',
		'animspeed',
		'colorblindness_filter',
		#if !FLX_NO_MOUSE
		'cursor_size',
		#end
		'global_sounds_cap',
		'game_volume',
		'hitsound_sounds_cap',
		'hitsound',
		'hitsound_volume',
		'hitsound_type',
		'hitsound_test'
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxArray:Array<CheckboxThingie> = [];
	private var checkboxNumber:Array<Int> = [];
	private var grpTexts:FlxTypedGroup<AttachedText>;
	private var textNumber:Array<Int> = [];
	var bg:FlxSprite; 

	private var showCharacter:Character = null;
	private var descText:FlxText;

	public function new()
	{

		super();

		bg = new FlxSprite().loadGraphic(Paths.image('escolhendo-branco'));
		bg.color = 0xfffc4f4f; //arrumem a cor a vosso gosto
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		// avoids lagspikes while scrolling through menus!
		showCharacter = new Character(840, 170, 'bf', true);
		// showCharacter = new Character(840, 170, 'optionsmenu/sunkyajustes', true);
		// Alguma coisa me diz que não era para ser o sunky aqui...
		showCharacter.setGraphicSize(Std.int(showCharacter.width * 0.8));
		showCharacter.updateHitbox();
		showCharacter.dance();
		add(showCharacter);
		showCharacter.visible = false;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var isCentered:Bool = unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, Linguagem.LangUtil.getString("opt_name_"+options[i], "option_name"), false, false, 0.05, 1, 'alfabetovio'); // esse true no final é pro texto ser branco
			optionText.isMenuItem = true;
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.forceX = optionText.x;
			} else {
				optionText.x += 300;
				optionText.forceX = 300;
			}
			optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				var useCheckbox:Bool = true;
				for (j in 0...noCheckbox.length) {
					if(options[i] == noCheckbox[j]) {
						useCheckbox = false;
						break;
					}
				}

				if(useCheckbox) {
					var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, false);
					checkbox.sprTracker = optionText;
					checkboxArray.push(checkbox);
					checkboxNumber.push(i);
					add(checkbox);
				} else {
					var valueText:AttachedText = new AttachedText('0', optionText.width + 80);
					valueText.sprTracker = optionText;
					grpTexts.add(valueText);
					textNumber.push(i);
				}
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		for (i in 0...options.length) {
			if(!unselectableCheck(i)) {
				curSelected = i;
				break;
			}
		}
		BSLSwipeUtils.max_y = Std.int(FlxG.width/6);//indo do topo até o fim da tela, o mano só passa em no máximo 6 opções.
		BSLSwipeUtils.mouseScrollMultiplier=1;
		BSLSwipeUtils.reset_manual=false;
		changeSelection();
		#if mobileC
		addVirtualPad(LEFT_RIGHT, NONE);
		#end
		reloadValues();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		var accepted = controls.ACCEPT;

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}
		if (Main.getMouseVisibility()){		
			BSLSwipeUtils.swipeVertical();
			for (option in grpOptions.members)
			{
				if (BSLTouchUtils.solto(option) && option.targetY == 0 && !BSLSwipeUtils.is_swipping)
					accepted = true;
				else if (BSLTouchUtils.solto(option) && !BSLSwipeUtils.is_swipping)
					changeSelection(Std.int(option.targetY));
			}
			if (Math.abs(change_swipe) <= Math.abs(BSLSwipeUtils.scrollY) && BSLSwipeUtils.scrollY != 0)
				change_swipe = -BSLSwipeUtils.scrollY;
			else if(change_swipe != 0)
				changeSelection();
		}

		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end) {	
			GlobalSoundManager.changeVolumes(); //Feito unica e exclusivamente pra salvar os novos volumes.
			ClientPrefs.save();
			MusicBeatState.switchState(new ajustes.AjustesState());
			GlobalSoundManager.play(cancelMenu);
		}

		var usesCheckbox = true;
		for (i in 0...noCheckbox.length) {
			if(options[curSelected] == noCheckbox[i]) {
				usesCheckbox = false;
				break;
			}
		}

		if(usesCheckbox) {
			if(accepted && nextAccept <= 0) {
				switch(options[curSelected]) {
					case 'fps_visible':
						ClientPrefs.showFPS = !ClientPrefs.showFPS;
						if(Main.fpsVar != null)
							Main.fpsVar.visible = ClientPrefs.showFPS;

					case 'low_quality':
						ClientPrefs.lowQuality = !ClientPrefs.lowQuality;

					case 'gore':
						ClientPrefs.gore = !ClientPrefs.gore;
				
					case 'shaders':
						ClientPrefs.shaders = !ClientPrefs.shaders;
					case 'aliasing':
						ClientPrefs.globalAntialiasing = !ClientPrefs.globalAntialiasing;
						showCharacter.antialiasing = ClientPrefs.globalAntialiasing;
						for (item in grpOptions) {
							item.antialiasing = ClientPrefs.globalAntialiasing;
						}
						for (i in 0...checkboxArray.length) {
							var spr:CheckboxThingie = checkboxArray[i];
							if(spr != null) {
								spr.antialiasing = ClientPrefs.globalAntialiasing;
							}
						}
						bg.antialiasing = ClientPrefs.globalAntialiasing;

					case 'splash':
						ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;

					case 'focus':
						ClientPrefs.focus = !ClientPrefs.focus;

					case 'flashing':
						ClientPrefs.flashing = !ClientPrefs.flashing;

					case 'animspeed':
						ClientPrefs.reducedAnimations = !ClientPrefs.reducedAnimations;

					case 'hitsound':
						ClientPrefs.hitSounds = !ClientPrefs.hitSounds;

					case 'fullscreen': //Isso é bem inutil no mobile btw, só faz deixar as marquinhas dos botões do lado
						openfl.Lib.application.window.maximized = false;

						ClientPrefs.fullscreen = !ClientPrefs.fullscreen;
						FlxG.fullscreen = ClientPrefs.fullscreen;
					
					case 'subtitles':
						ClientPrefs.legendas = !ClientPrefs.legendas;	

					case 'Swearing':
						ClientPrefs.cursing = !ClientPrefs.cursing;

					case 'gpu':
						ClientPrefs.loadingexperimental = !ClientPrefs.loadingexperimental;

					#if desktop
					case 'auto_pause':
							ClientPrefs.pausarauto = !ClientPrefs.pausarauto ;
#end

					case 'downscroll':
						ClientPrefs.downScroll = !ClientPrefs.downScroll;

					case 'middlescroll':
						ClientPrefs.middleScroll = !ClientPrefs.middleScroll;

					case 'reset':
						ClientPrefs.canReset = !ClientPrefs.canReset;

					case 'Ghost Tapping':
						ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;

					case 'cam_effects':
						ClientPrefs.camZooms = !ClientPrefs.camZooms;

					case 'hide_hud':
						ClientPrefs.hideHud = !ClientPrefs.hideHud;
					
					case 'hide_time':
						ClientPrefs.hideTime = !ClientPrefs.hideTime;
				}
				GlobalSoundManager.play(scrollMenu);
				reloadValues();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				final addTen:Int = controls.UI_LEFT ? -10 : 10;
				final addOne:Int = controls.UI_LEFT ? -1 : 1;
				if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
				switch(options[curSelected]) {
					case 'fps_max':
						ClientPrefs.framerate += addTen;
						if(ClientPrefs.framerate < 60) ClientPrefs.framerate = 60;
						else if(ClientPrefs.framerate > 240) ClientPrefs.framerate = 240;

						if(ClientPrefs.framerate > FlxG.drawFramerate) {
							FlxG.updateFramerate = ClientPrefs.framerate;
							FlxG.drawFramerate = ClientPrefs.framerate;
						} else {
							FlxG.drawFramerate = ClientPrefs.framerate;
							FlxG.updateFramerate = ClientPrefs.framerate;
						}
					case 'note_delay':
						var mult:Int = 1;
						if(holdTime > 1.5) { //Double speed after 1.5 seconds holding
							mult = 2;
						}
						ClientPrefs.noteOffset += addOne * mult;
						if(ClientPrefs.noteOffset < 0) ClientPrefs.noteOffset = 0;
						else if(ClientPrefs.noteOffset > 500) ClientPrefs.noteOffset = 500;
					case 'hitsound_volume':
						if (ClientPrefs.hitSounds){
						ClientPrefs.osusom = CoolUtil.stableOneDigitSum(ClientPrefs.osusom, addOne);
						if(ClientPrefs.osusom < 0.1) {ClientPrefs.osusom = 0.1;}
						else if(ClientPrefs.osusom > 1.0) {ClientPrefs.osusom = 1.0;}
						else{
							var hitsound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('osu/' + ClientPrefs.hitSoundType, 'shared'));
							hitsound.volume = ClientPrefs.osusom;
							hitsound.play();
						}
					}
					case 'game_volume':
						ClientPrefs.efeitosVolume = CoolUtil.stableOneDigitSum(ClientPrefs.efeitosVolume, addOne);
						if(ClientPrefs.efeitosVolume < 0.05) {ClientPrefs.efeitosVolume = 0; }
						else if(ClientPrefs.efeitosVolume > 0.95) {ClientPrefs.efeitosVolume = 1.0; }
						else{
							var teste:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Metronome_Tick', 'shared')); 
							//Podem trocar isso quando quiserem,
							//o próprio nome da variável já diz o pq eu escolhi um som random
							teste.volume = ClientPrefs.efeitosVolume;
							teste.play();
						}
					case 'hitsound_type':
						if (ClientPrefs.hitSounds){
							ClientPrefs.hitSoundType += addOne;
							if(ClientPrefs.hitSoundType <= 1) {ClientPrefs.hitSoundType = 1;}
							else if(ClientPrefs.hitSoundType >= 13) {ClientPrefs.hitSoundType = 13;}
							else {
								var hitsound:FlxSound = new FlxSound().loadEmbedded(Paths.sound(('osu/' + ClientPrefs.hitSoundType), 'shared'));
								hitsound.volume = ClientPrefs.osusom;
								hitsound.play();
							}
						}
					case 'opacity':
						if (ClientPrefs.legendas){
							ClientPrefs.opacidadeLegendas = (ClientPrefs.opacidadeLegendas*10 + addOne)/10;
							if(ClientPrefs.opacidadeLegendas>0.95){ClientPrefs.opacidadeLegendas = 1;}else if(ClientPrefs.opacidadeLegendas<0.15){ClientPrefs.opacidadeLegendas=0.1;}
						}
					case 'colorblindness_filter':
						ClientPrefs.curFilter += addOne;

						if (ClientPrefs.curFilter >= Shaders.ColorblindData.matrizes.length)
							ClientPrefs.curFilter = Shaders.ColorblindData.matrizes.length - 1;

						if (ClientPrefs.curFilter < 0)
							ClientPrefs.curFilter = 0;

						Main.changeFilter(ClientPrefs.curFilter);
					#if desktop
					case 'cursor_size':
						ClientPrefs.cursor_size = CoolUtil.stableOneDigitSum(ClientPrefs.cursor_size, addOne);
						if (ClientPrefs.cursor_size < 0.5) ClientPrefs.cursor_size = 0.5;
						if (ClientPrefs.cursor_size > 2) ClientPrefs.cursor_size = 2;
						FlxG.mouse.load(ClientPrefs.cursor_size);
					#end
 				}
				reloadValues();

				if(holdTime <= 0 && options[curSelected] != "hitsound_type" && options[curSelected] != "hitsound_volume") GlobalSoundManager.play(scrollMenu);
				holdTime += elapsed;
			} else if (controls.ACCEPT && options[curSelected] == 'hitsound_test' && ClientPrefs.hitSounds){
				var hitsound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('osu/' + ClientPrefs.hitSoundType, 'shared'));
				hitsound.volume = ClientPrefs.osusom;
				hitsound.play();
			}else {
				holdTime = 0;
			}
		}

		if(showCharacter != null && showCharacter.animation.curAnim.finished) {
			showCharacter.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	private var change_swipe:Int = 0;
	
	function changeSelection(change:Int = 0)
	{
		if (change_swipe != 0){
			change = Std.int(Math.abs(change_swipe)/change_swipe);
			change_swipe -= change;
		}

		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = options.length - 1;
			if (curSelected >= options.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		descText.text = Linguagem.LangUtil.getString("opt_desc_"+options[curSelected], "option_desc", "\n");

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}

				for (j in 0...checkboxArray.length) {
					var tracker:FlxSprite = checkboxArray[j].sprTracker;
					if(tracker == item) {
						checkboxArray[j].alpha = item.alpha;
						break;
					}
				}
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				text.alpha = 0.6;
				if(textNumber[i] == curSelected) {
					text.alpha = 1;
				}
			}
		}

		showCharacter.visible = (options[curSelected] == 'aliasing');
		GlobalSoundManager.play(scrollMenu);
	}

	function reloadValues() {
		for (i in 0...checkboxArray.length) {
			var checkbox:CheckboxThingie = checkboxArray[i];
			if(checkbox != null) {
				var daValue:Bool = false;
				switch(options[checkboxNumber[i]]) {
					case 'fps_visible':
						daValue = ClientPrefs.showFPS;
					case 'shaders':
						daValue = ClientPrefs.shaders;
					case 'low_quality':
						daValue = ClientPrefs.lowQuality;
					case 'gore':
						daValue = ClientPrefs.gore;
					case 'aliasing':
						daValue = ClientPrefs.globalAntialiasing;
					case 'cam_effects':
						daValue = ClientPrefs.camZooms;
					case 'splash':
						daValue = ClientPrefs.noteSplashes;
					case 'focus':
						daValue = ClientPrefs.focus;
					case 'flashing':
						daValue = ClientPrefs.flashing;
					case 'animspeed':
						daValue = ClientPrefs.reducedAnimations;
					case 'subtitles':
						daValue = ClientPrefs.legendas;
					case 'gpu':
						daValue = ClientPrefs.loadingexperimental;
					case 'downscroll':
						daValue = ClientPrefs.downScroll;
					case 'middlescroll':
						daValue = ClientPrefs.middleScroll;
					case 'reset':
						daValue = ClientPrefs.canReset;
					case 'Ghost Tapping':
						daValue = ClientPrefs.ghostTapping;
					case 'Swearing':
						daValue = ClientPrefs.cursing;
					case 'hitsound':
						daValue = ClientPrefs.hitSounds;
					case 'fullscreen':
						daValue = ClientPrefs.fullscreen;
						#if desktop
					case 'auto_pause':
						daValue = ClientPrefs.pausarauto;
						#end
					case 'Zooms da Camera':
						daValue = ClientPrefs.camZooms;
					case 'hide_hud':
						daValue = ClientPrefs.hideHud;
					case 'hide_time':
						daValue = ClientPrefs.hideTime;
				}
				checkbox.daValue = daValue;
			}
		}
		for (i in 0...grpTexts.members.length) {
			var text:AttachedText = grpTexts.members[i];
			if(text != null) {
				var daText:String = '';
				switch(options[textNumber[i]]) {
					case 'fps_max':
						daText = '' + ClientPrefs.framerate;
					case 'note_delay':
						daText = ClientPrefs.noteOffset + 'ms';
					case 'game_volume':
						daText = Std.string(ClientPrefs.efeitosVolume);
					case 'hitsound_volume':
						daText = Std.string(ClientPrefs.osusom);
					case 'hitsound_type':
						daText = Linguagem.LangUtil.getString("opt_desc_soundType_ID", "option_desc", "\n")+ " " + Std.string(ClientPrefs.hitSoundType);
					case 'hitsound_test':
						daText = '';
					case 'opacity':
						daText = Std.string(ClientPrefs.opacidadeLegendas);
					case 'colorblindness_filter':
						daText = getFilterType(ClientPrefs.curFilter);
					case 'cursor_size':
						daText = Std.string(ClientPrefs.cursor_size);
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
		}
	}

	public function getFilterType(filter:Int):String {
		switch(filter) {
			case 1: return "Deuteranopia";
			case 2: return "Tritanopia";
			case 3: return "Protanopia";
			default: return Linguagem.LangUtil.getString("common_text_filter", "data");
		}
	}

	private function unselectableCheck(num:Int):Bool {
		for (i in 0...unselectableOptions.length) {
			if(options[num] == unselectableOptions[i]) {
				return true;
			}
		}
		return options[num] == null || options[num].length < 1;
	}
}