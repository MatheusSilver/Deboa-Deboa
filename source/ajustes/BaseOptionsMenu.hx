package ajustes;

import Controls;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;

using StringTools;
#if rpc
import Discord.DiscordClient;
#end

class BaseOptionsMenu extends MusicBeatState
{

	private static var curSelected:Int = 0;
	static var unselectableOptions:Array<String> = [
		'VISUAL',
		'SOM GLOBAL',
		'GAMEPLAY',
		'SONS EXTRAS'
	];
	static var noCheckbox:Array<String> = [
		'FPS',
		'Delay da Nota',
		'Volume ',
		'Volume',
		'Tipo',
		'Teste o HitSound'
	];

	static var options:Array<String> = [
		'VISUAL',
		'Baixa Qualidade',
		'Shaders', //Infelizmente, shaders não funcionam no android. (Na verdade funcionam sim, mas é muito dificil de portar. É um conhecimento escasso. Somente os porters mais antigos sabem como deixar eles funcionais.)
		//Vai que o Sirox e seu celular da NASA joguem esse mod, por via das duvidas, os shaders ficam desativados por padrão em mobile
		'Anti-Aliasing',
		'FullScreen',
		'Esconder HUD',
		'Esconder tempo',
		'Auto pause',
		'Violencia',
		'Luzes Piscantes',
		'FPS visível',
		'Carregar rápido',
		#if !html5
		'FPS', //Apparently 120FPS isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		#end
		'GAMEPLAY',
		//'Antimash',
		'Downscroll',
		'Middlescroll',
		//'Ghost Tapping', //Isso é deveras é perigoso em algumas músicas
		'Delay da Nota',
		'Note Splashes',
		'Legendas',
		'Efeitos de Camera',
		'SOM GLOBAL',
		'Volume ',
		'SONS EXTRAS',
		'Hitsounds',
		'Volume',
		'Tipo',
		'Teste o HitSound'
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
		showCharacter = new Character(840, 170, 'optionsmenu/sunkyajustes', true);
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
			var optionText:Alphabet = new Alphabet(0, 70 * i, options[i], false, false, 0.05, 1, 'alfabetovio'); // esse true no final é pro texto ser branco
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
		changeSelection();
		#if mobileC
		addVirtualPad(FULL, A_B);
		#end
		reloadValues();
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('newmenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {			
			ClientPrefs.saveSettings();
			MusicBeatState.switchState(new ajustes.AjustesState());
			GlobalSoundManager.play('cancelMenu');
		}

		var usesCheckbox = true;
		for (i in 0...noCheckbox.length) {
			if(options[curSelected] == noCheckbox[i]) {
				usesCheckbox = false;
				break;
			}
		}

		if(usesCheckbox) {
			if(controls.ACCEPT && nextAccept <= 0) {
				switch(options[curSelected]) {
					case 'FPS visível':
						ClientPrefs.showFPS = !ClientPrefs.showFPS;
						if(Main.fpsVar != null)
							Main.fpsVar.visible = ClientPrefs.showFPS;

					case 'Baixa Qualidade':
						ClientPrefs.lowQuality = !ClientPrefs.lowQuality;
					
					case 'Shaders':
						ClientPrefs.shaders = !ClientPrefs.shaders;

					case 'Anti-Aliasing':
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

					case 'Antimash':
						ClientPrefs.resolution = !ClientPrefs.resolution;

					case 'Note Splashes':
						ClientPrefs.noteSplashes = !ClientPrefs.noteSplashes;

					case 'Luzes Piscantes':
						ClientPrefs.flashing = !ClientPrefs.flashing;

					case 'Hitsounds':
						ClientPrefs.hitSounds = !ClientPrefs.hitSounds;

					case 'FullScreen': //Isso é bem inutil no mobile btw, só faz deixar as marquinhas dos botões do lado
						openfl.Lib.application.window.maximized = false;

						ClientPrefs.fullscreen = !ClientPrefs.fullscreen;
						FlxG.fullscreen = ClientPrefs.fullscreen;
					
					case 'Legendas':
						ClientPrefs.legendas = !ClientPrefs.legendas;	

					case 'Violencia':
						ClientPrefs.gore = !ClientPrefs.gore;

					case 'Swearing':
						ClientPrefs.cursing = !ClientPrefs.cursing;

					case 'Carregar rápido':
						ClientPrefs.loadingexperimental = !ClientPrefs.loadingexperimental;

					case 'Auto pause':
							ClientPrefs.pausarauto = !ClientPrefs.pausarauto ;

					case 'Downscroll':
						ClientPrefs.downScroll = !ClientPrefs.downScroll;

					case 'Middlescroll':
						ClientPrefs.middleScroll = !ClientPrefs.middleScroll;

					case 'Ghost Tapping':
						ClientPrefs.ghostTapping = !ClientPrefs.ghostTapping;

					case 'Efeitos de Camera':
						ClientPrefs.camZooms = !ClientPrefs.camZooms;

					case 'Esconder HUD':
						ClientPrefs.hideHud = !ClientPrefs.hideHud;
					
					case 'Esconder tempo':
						ClientPrefs.hideTime = !ClientPrefs.hideTime;
				}
				GlobalSoundManager.play('scrollMenu');
				reloadValues();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var add:Int = controls.UI_LEFT ? -1 : 1;
				var addo:Float = controls.UI_LEFT ? -0.1 : 0.1;
				if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
				switch(options[curSelected]) {
					case 'FPS':
						ClientPrefs.framerate += add*10;
						if(ClientPrefs.framerate < 60) ClientPrefs.framerate = 60;
						else if(ClientPrefs.framerate > 240) ClientPrefs.framerate = 240;

						if(ClientPrefs.framerate > FlxG.drawFramerate) {
							FlxG.updateFramerate = ClientPrefs.framerate;
							FlxG.drawFramerate = ClientPrefs.framerate;
						} else {
							FlxG.drawFramerate = ClientPrefs.framerate;
							FlxG.updateFramerate = ClientPrefs.framerate;
						}
					case 'Delay da Nota':
						var mult:Int = 1;
						if(holdTime > 1.5) { //Double speed after 1.5 seconds holding
							mult = 2;
						}
						ClientPrefs.noteOffset += add * mult;
						if(ClientPrefs.noteOffset < 0) ClientPrefs.noteOffset = 0;
						else if(ClientPrefs.noteOffset > 500) ClientPrefs.noteOffset = 500;
					case 'Volume':
						if (ClientPrefs.hitSounds){
						ClientPrefs.osusom += addo;
						if(ClientPrefs.osusom < 0.1) ClientPrefs.osusom = 0.1;
						else if(ClientPrefs.osusom > 1.0) ClientPrefs.osusom = 1.0; 
						var hitsound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('osu/' + ClientPrefs.hitSoundType, 'shared'));
						hitsound.volume = ClientPrefs.osusom;
						hitsound.play();
					}
					case 'Volume ':
						ClientPrefs.efeitosVolume += addo;
						if(ClientPrefs.efeitosVolume < 0.05) ClientPrefs.efeitosVolume = 0;
						else if(ClientPrefs.efeitosVolume > 0.95) ClientPrefs.efeitosVolume = 1.0; 
						var teste:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Metronome_Tick', 'shared')); 
						//Podem trocar isso quando quiserem,
						//o próprio nome da variável já diz o pq eu escolhi um som random
						teste.volume = ClientPrefs.efeitosVolume;
						teste.play();
					case 'Tipo':
						if (ClientPrefs.hitSounds){
						ClientPrefs.hitSoundType += add;
						if(ClientPrefs.hitSoundType < 1) ClientPrefs.hitSoundType = 1;
						else if(ClientPrefs.hitSoundType > 4) ClientPrefs.hitSoundType = 4; //A ordem importa k
						var hitsound:FlxSound = new FlxSound().loadEmbedded(Paths.sound(('osu/' + ClientPrefs.hitSoundType), 'shared'));
						hitsound.volume = ClientPrefs.osusom;
						hitsound.play();
						}
				}
				reloadValues();

				if(holdTime <= 0) GlobalSoundManager.play('scrollMenu');
				holdTime += elapsed;
			} else if (controls.ACCEPT && options[curSelected] == 'Teste o HitSound' && ClientPrefs.hitSounds){
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
	
	function changeSelection(change:Int = 0)
	{
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = options.length - 1;
			if (curSelected >= options.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var daText:String = '';
		switch(options[curSelected]) {
			case 'Antimash':
				daText = "Caso tu for muito nutella mesmo,\naquele cara que spamma pq\nnão sabe jogar, ative isso.";
			case 'Gore':
				daText = "Desative isso para não visualizar\nos elementos com gore nas músicas.";
			case 'FPS':
				daText = "Determina o entre áspas limite do seu FPS.";
			case 'Delay da Nota':
				daText = "Troca o quão cedo uma nota aparece.\n(feitos para fones com delay.)";
			case 'Volume ':
				daText = 'Altera o Volume dos efeitos sonoros do jogo inteiro.';
			case 'FPS visível':
				daText = "Se desmarcado, desativa os contadores do jogo,\ntais como o contador de FPS e de memória.";
			case 'Shaders':
				daText = "Permite o uso de efeitos especiais de tela no jogo.\n(Desmarcar aumenta a performance.)";
			case 'Baixa Qualidade':
				daText = "Se marcado, retira elementos do cenário.\n(Desative isso caso a música que esteja jogando, trave demais.)";
			case 'Anti-Aliasing':
				daText = "Se desmarcado, desativa o anti-aliasing do jogo \n(Aumenta MUITO a performance)";
			case 'Carregar rápido':
				daText = "Se marcado, a engine passará a usar\n um sistema alternativo para carregar os assets \n talvez mais rápido que o original dependendo da sua máquina.";	
			case 'Downscroll':
				daText = "Se marcado, as notas ficaram estilo Guitar Hero.\n(Irão pra baixo)";
			case 'Hitsounds':
				daText = "Um som é tocado quando você acerta uma nota.";
			case 'FullScreen':
				daText = "Bom... Deixa o game em tela cheia uai";
			case 'Teste o HitSound':
				daText = "Aperte Enter para testar o volume e o som do Hitsound escolhido. \n A opção de hitsound precisa estar ativa para funcionar.";
			case 'Tipo':
				daText = "Escolha o seu som de osu favorito quando acertar uma nota entre os 4 disponíveis \n Os Hitsounds precisam estar ativos para mudar esta opção.";
			case 'Volume':
				daText = "Altere aqui o volume do som da Hitsound.\n(Esquerda para abaixar, direita para aumentar.) \n Os Hitsounds precisam estar ativos para mudar esta opção.";
			case 'Middlescroll':
				daText = "Se marcado, a nota do oponente irá sumir e a sua ficará no meio.";
			case 'Ghost Tapping':
				daText = "Se marcado, você não errará por apertar teclas aleatóriamente.\n(Não funciona caso errar uma nota da música.)";
			case 'Swearing':
				daText = "If unchecked, your mom won't be angry at you.";
			case 'Violencia':
				daText = "Se desmarcado, você não verá gore, sangue, visceras, coisas ruins.\n(Desativa isso caso for sensível demais.\nP.S: Principalmente pro mod do EXE.)";
			case 'Auto pause':
				daText = "Se desmarcado, não irá pausar automaticamente\nse você sair da janela do jogo enquanto\nestá em uma música.";
			case 'Note Splashes':
				daText = "Se desmarcado, quando acertar uma nota Sick!, as notas irão soltar uma animaçãozinha.\n(Caso estiver travando, desative isso também.)";
			case 'Luzes Piscantes':
				daText = "Desmarque caso for sensível com tela tremendo, luzes piscantes e etc...\n(Todos mods de agora tem isso.)";
			case 'Legendas':
				daText = "Se ativado, você irá ver as legendas nas músicas.";	
			case 'Efeitos de Camera':
				daText = "Se marcado, a camera irá acompanhar as notas da música \n também irá permitir outros efeitos de zoom acompanhados da batida da musica";
			case 'Esconder HUD':
				daText = "Se marcado, tira muitas coisas da tela.";
			case 'Esconder tempo':
				daText = "Se marcado, a barrinha com o tempo da música, sumirá.";
		}
		descText.text = daText;

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

		showCharacter.visible = (options[curSelected] == 'Anti-Aliasing');
		GlobalSoundManager.play('scrollMenu');
	}

	function reloadValues() {
		for (i in 0...checkboxArray.length) {
			var checkbox:CheckboxThingie = checkboxArray[i];
			if(checkbox != null) {
				var daValue:Bool = false;
				switch(options[checkboxNumber[i]]) {
					case 'FPS visível':
						daValue = ClientPrefs.showFPS;
					case 'Shaders':
						daValue = ClientPrefs.shaders;
					case 'Baixa Qualidade':
						daValue = ClientPrefs.lowQuality;
					case 'Anti-Aliasing':
						daValue = ClientPrefs.globalAntialiasing;
					case 'Efeitos de Camera':
						daValue = ClientPrefs.camZooms;
					case 'Note Splashes':
						daValue = ClientPrefs.noteSplashes;
					case 'Luzes Piscantes':
						daValue = ClientPrefs.flashing;
					case 'Legendas':
						daValue = ClientPrefs.legendas;
					case 'Carregar rápido':
						daValue = ClientPrefs.loadingexperimental;
					case 'Downscroll':
						daValue = ClientPrefs.downScroll;
					case 'Middlescroll':
						daValue = ClientPrefs.middleScroll;
					case 'Ghost Tapping':
						daValue = ClientPrefs.ghostTapping;
					case 'Swearing':
						daValue = ClientPrefs.cursing;
					case 'Hitsounds':
						daValue = ClientPrefs.hitSounds;
					case 'FullScreen':
						daValue = ClientPrefs.fullscreen;
					case 'Violencia':
						daValue = ClientPrefs.gore;
					case 'Auto pause':
						daValue = ClientPrefs.pausarauto;
					case 'Zooms da Camera':
						daValue = ClientPrefs.camZooms;
					case 'Esconder HUD':
						daValue = ClientPrefs.hideHud;
					case 'Esconder tempo':
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
					case 'FPS':
						daText = '' + ClientPrefs.framerate;
					case 'Delay da Nota':
						daText = ClientPrefs.noteOffset + 'ms';
					case 'Volume ':
						daText = Std.string(ClientPrefs.efeitosVolume);
					case 'Volume':
						daText = Std.string(ClientPrefs.osusom);
					case 'Tipo':
						daText = 'Som ' + Std.string(ClientPrefs.hitSoundType+1);
					case 'Teste o HitSound':
						daText = '';
				}
				var lastTracker:FlxSprite = text.sprTracker;
				text.sprTracker = null;
				text.changeText(daText);
				text.sprTracker = lastTracker;
			}
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