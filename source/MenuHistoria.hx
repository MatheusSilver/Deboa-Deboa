package;

import LoadingState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
#if desktop
import Discord.DiscordClient;
#end

class MenuHistoria extends MusicBeatSubstate
{

	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	
	var subindo:Bool = true;
	var canceltweens:Bool = false;
    var musicas:Array<Dynamic> = [];
	var nombres:Array<Dynamic> = [];
	public static var dapreselected:String = '';
	public static var curSelected:Int = 0; //Publico pra corrigir um pequeno bugzinho de continuidade.
	var apertavel:Bool = false;
	var textoSpriteTweens:FlxTween;

	var naopodevoltar:Bool = false;

	//transition stuff
	var pastbgSprite:FlxSprite;
	
	//stuff to show
	var bgSprite:FlxSprite;
	var perfilSprite:FlxSprite;
	var textoSprite:FlxSprite;

	override function create()
	{

        var leWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
        for (j in 0...leWeek.songs.length) {
            musicas.push(leWeek.songs[j][0]);
			nombres.push(leWeek.songs[j][3]);
        }

		FlxG.mouse.visible = false;
		if(curSelected >= WeekData.weeksList.length) curSelected = 0;
		persistentUpdate = persistentDraw = true;

		pastbgSprite = new FlxSprite(0, 0);
		pastbgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		bgSprite = new FlxSprite(0, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		textoSprite = new FlxSprite().loadGraphic(Paths.image('nota_invisivel', 'preload'));
		textoSprite.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('nota_invisivel', 'preload'));
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
		//FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));

		add(bgSprite);
		add(pastbgSprite);
		add(perfilSprite);
		add(textoSprite);

		changeSong();

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		if(curSelected >= musicas.length) curSelected = 0;

		super.create();
	}

	var instPlaying:Int = -1;
	var executando:Bool = false;
	private static var vocals:FlxSound = null;
	
	override function update(elapsed:Float)
	{

		#if desktop
		if(!selectedWeek){
		DiscordClient.changePresence("Escolhendo uma musica em: ", dapreselected, null);
		}
		#end

		if(textoSpriteTweens != null)
			textoSpriteTweens.active = true;

		if (!movedBack && !selectedWeek)
		{

			if (controls.UI_LEFT_P && apertavel && musicas.length > 1) //MALUCO EU SOU MUITO BURRO...
				//Consegui cometer o mesmo erro duas vezes seguidas...
			{
				changeSong(-1, true);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_RIGHT_P && apertavel && musicas.length > 1)
			{
				changeSong(1, false);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.BACK && !movedBack && !selectedWeek && apertavel && !naopodevoltar)
				{
						FlxTween.tween(perfilSprite, {alpha: 0}, 1.0, {ease: FlxEase.expoInOut});
						FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut, 
						onComplete: function(twn:FlxTween) {
							close();
						}});
					movedBack = true;
					curSelected = 0;
				}
		
				else if(FlxG.keys.justPressed.SPACE)
				{
					if(instPlaying != curSelected)
					{
						#if PRELOAD_ALL
						FreeplayState.destroyFreeplayVocals();
						FlxG.sound.music.volume = 0;
						Paths.currentModDirectory = musicas[curSelected].folder;
						var poop:String = Highscore.formatSong(musicas[curSelected].toLowerCase(), 2);
						PlayState.SONG = Song.loadFromJson(poop, musicas[curSelected].toLowerCase());
						if (PlayState.SONG.needsVoices)
							vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
						else
							vocals = new FlxSound();
		
						FlxG.sound.list.add(vocals);
						FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
						vocals.play();
						vocals.persist = true;
						vocals.looped = true;
						vocals.volume = 0.7;
						instPlaying = curSelected;
						#end
					}
				}

			if (controls.ACCEPT && apertavel)
			{
				selectSong(true);
			} 	
			#if debug
			else if (FlxG.keys.justPressed.SEVEN && nombres[curSelected].toLowerCase() != 'controle' && nombres[curSelected] != 'Cross Console Clash' && nombres[curSelected] != 'Noite da Rapaziada'){
				selectSong(false);
			}
			#end
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectSong(toPlay:Bool)
	{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				stopspamming = true;
			}

			selectedWeek = true;
			
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(musicas[curSelected]);
			FreeplayState.infoextended = nombres[curSelected]; //O cara esqueceu como funciona o sistema que ele mesmo fez...É um genio simplesmente... ;-;
			var poop:String = Highscore.formatSong(songLowercase, 2);
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
				poop = songLowercase;
				trace('Couldnt find file');
			}
			trace(poop);

			if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + WeekData.weeksLoaded.get(dapreselected).weekBackground + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'))) {
				pastbgSprite.loadGraphic(Paths.image("scrolling/scroll-" + WeekData.weeksLoaded.get(dapreselected).weekBackground + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
			} else {
				FlxG.log.warn('Não foi possível achar ' + Paths.image("scrolling/scroll-" + WeekData.weeksLoaded.get(dapreselected).weekBackground + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
				pastbgSprite.loadGraphic('assets/images/menuDesat.png');
			}
			pastbgSprite.setGraphicSize(FlxG.width);
			pastbgSprite.screenCenter(XY);

			FreeplayState.justread = musicas[curSelected];
			PlayState.isStoryMode = false;
			PlayState.modohistoria = true;
			if(nombres[curSelected].toLowerCase() != 'controle' && nombres[curSelected] != 'Cross Console Clash' && nombres[curSelected] != 'Noite da Rapaziada'){
			MenuPreHistoria.bigmenu.alpha = 0;
			bgSprite.alpha = 0;
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);

			PlayState.storyDifficulty = 2;
			FlxTween.tween(perfilSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
			FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut, 
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(pastbgSprite, {alpha: 0}, 1.0,{ease: FlxEase.linear});
			}});

			// Nesse eu não vou mexer, tô com medo de ferrar alguma coisa.
			if(toPlay){
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				openSubState(new LoadingsState());
				LoadingState.loadAndSwitchState(new PlayState());
			});
			} else{
				MusicBeatState.switchState(new editors.ChartingState());
			}

			FlxG.sound.music.volume = 0;
			} else if (nombres[curSelected].toLowerCase() == 'controle'){
				new FlxTimer().start(0.3, function(tmr:FlxTimer) {
					openSubState(new ControlSongSubstate());
				});
			} else if (nombres[curSelected].toLowerCase() == 'noite da rapaziada'){
				FlxG.sound.music.volume = 0;
				naopodevoltar=true;
				apertavel=false;
				new FlxTimer().start(0.3, function(tmr:FlxTimer) {
					MusicBeatState.switchState(new PastaNightSelect());
				});
			} else if (nombres[curSelected].toLowerCase() == 'cross console clash'){
				#if desktop
				DiscordClient.changePresence("Escolhendo um lado em", "Cross Console Clash", null);
				#end
				naopodevoltar=true;
				apertavel=false;
				new FlxTimer().start(0.3, function(tmr:FlxTimer) {
					if(textoSpriteTweens != null){
						textoSpriteTweens.active = false;
						textoSpriteTweens.cancel();
					}
					FlxTween.tween(perfilSprite, {y: -perfilSprite.height}, 0.5, {ease: FlxEase.expoInOut});
					FlxTween.tween(textoSprite, {y: FlxG.height}, 0.5, {ease: FlxEase.expoInOut});
					openSubState(new ConsoleClashSubState(musicas[curSelected]));
				});
			}
					
			FreeplayState.destroyFreeplayVocals();
		}

		function tweenpracima(){
			textoSpriteTweens = FlxTween.tween(textoSprite, {y: perfilSprite.height + perfilSprite.y + 5}, 3, {ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {
				if(!canceltweens)
					tweenprabaixo();
			}});
		}

		function tweenprabaixo(){
			textoSpriteTweens = FlxTween.tween(textoSprite, {y: FlxG.height - textoSprite.height - 5}, 3, {ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {
				if(!canceltweens)
					tweenpracima();
			}});
		}

		function entrada(){
			var escolhaWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
			var pasta:String = escolhaWeek.weekBackground;
			FlxTween.tween(perfilSprite, {y: -FlxG.height}, 0.1, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'))) { //anti crashing moment 
						perfilSprite.loadGraphic(Paths.image("scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')); 
						perfilSprite.updateHitbox();
						perfilSprite.screenCenter(X);
					} else {
						FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
					}
					FlxTween.tween(perfilSprite, {y: 25}, 0.4, {ease: FlxEase.expoInOut,
						onComplete: function(twn:FlxTween) {
									if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload'))) { //anti crashing moment 
										textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload')); 
										textoSprite.updateHitbox();
										textoSprite.screenCenter(X);
									} else {
										FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + pasta + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)");
									}
									tweenpracima();
						}});	
				}
			});	
		}

	public function changeSong(change:Int = 0, side:Bool = false):Void
	{
		apertavel = false;
		curSelected += change;

		if (curSelected < 0)
			curSelected = musicas.length - 1;
		if (curSelected >= musicas.length)
			curSelected = 0;

		var leWeek:WeekData = WeekData.weeksLoaded.get(dapreselected);
		WeekData.setDirectoryFromWeek(leWeek);

		bgSprite.visible = true;
		pastbgSprite.visible = true;
		perfilSprite.visible = true;
		textoSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
			if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'))) {
				bgSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
			} else {
				FlxG.log.warn('Não foi possível achar ' + Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
				bgSprite.loadGraphic('assets/images/menuDesat.png');
			}
			if (!selectedWeek){
				bgSprite.setGraphicSize(FlxG.width);
				pastbgSprite.setGraphicSize(FlxG.width);
			}

			bgSprite.screenCenter(XY);
			bgSprite.setGraphicSize(FlxG.width, FlxG.height);
			pastbgSprite.screenCenter(XY);

			var curtimer:Float = 0.3;
			FlxTween.tween(bgSprite, {alpha: 1}, curtimer * 2, {ease: FlxEase.expoInOut});
			FlxTween.tween(pastbgSprite, {alpha: 0}, curtimer * 2, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'))) {
						pastbgSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
					} else {
						FlxG.log.warn('Não foi possível achar ' + Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
						pastbgSprite.loadGraphic('assets/images/menuDesat.png');
					}
					new FlxTimer().start(0.15, function(tmr:FlxTimer) {
					apertavel = true;
					});
					pastbgSprite.alpha = 1;
				}
			});
			if (!side && executando){
			FlxTween.tween(textoSprite, {x: 0 - textoSprite.width}, curtimer, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload'))) { //anti crashing moment 
						textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload')); 
						textoSprite.updateHitbox();
					} else {
						FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)");
					}
					textoSprite.x = FlxG.width + textoSprite.width;
					FlxTween.tween(textoSprite, {x: ((FlxG.width - textoSprite.width) / 2)}, curtimer, {ease: FlxEase.expoInOut});
				}
			});
			FlxTween.tween(perfilSprite, {x: 0 - perfilSprite.width}, curtimer, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'))) { //anti crashing moment 
						perfilSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')); 
						perfilSprite.updateHitbox();
					} else {
						FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
					}
					perfilSprite.x = FlxG.width + perfilSprite.width;
					FlxTween.tween(perfilSprite, {x: (FlxG.width - perfilSprite.width) / 2}, curtimer, {ease: FlxEase.expoInOut});
				}
			});
			} else if (executando) {
				FlxTween.tween(textoSprite, {x: FlxG.width + textoSprite.width}, curtimer, {ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween) {
						if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload'))) { //anti crashing moment 
							textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload')); 
							textoSprite.updateHitbox();
						} else {
							FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)");
						}
						textoSprite.x = 0 - textoSprite.width;
						FlxTween.tween(textoSprite, {x: ((FlxG.width - textoSprite.width) / 2)}, curtimer, {ease: FlxEase.expoInOut});
					}
				});
				FlxTween.tween(perfilSprite, {x: FlxG.width + perfilSprite.width}, curtimer, {ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween) {
						if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'))) { //anti crashing moment 
							perfilSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')); 
							perfilSprite.updateHitbox();
						} else {
							FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
						}
						perfilSprite.x = 0 - perfilSprite.width;
						FlxTween.tween(perfilSprite, {x: ((FlxG.width - perfilSprite.width) / 2)}, curtimer, {ease: FlxEase.expoInOut});
					}
				});	
			}
			new FlxTimer().start(curtimer * 2 + 0.01, function(tmr:FlxTimer) {
				if (!executando){
					executando = true;
					textoSprite.y = FlxG.height + textoSprite.height;
					textoSprite.screenCenter(X);
					perfilSprite.screenCenter(X);
					perfilSprite.y = -FlxG.height;
					entrada();
					}
				});
	}
}