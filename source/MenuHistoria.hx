package;

import LoadingState;
import flixel.system.FlxSound;
import flixel.input.mouse.FlxMouseButton;
import flixel.ui.FlxButton;
import flixel.tweens.FlxEase;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class MenuHistoria extends MusicBeatState
{

	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	
	var subindo:Bool = true;
    var musicas:Array<Dynamic> = [];
	var nombres:Array<Dynamic> = [];
	public static var dapreselected:String = '';
	private static var curSelected:Int = 0;
	var apertavel:Bool = false;

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
		textoSprite = new FlxSprite(0, FlxG.height - 125);
		textoSprite.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(0, 0);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
		

		add(bgSprite);
		add(pastbgSprite);
		add(perfilSprite);
		add(textoSprite);

		changeSong();

		#if mobileC
		addVirtualPad(RIGHT_LEFT, A_B);
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
		DiscordClient.changePresence("Escolhendo uma musica em: " + dapreselected, null);
		#end

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_LEFT_P && apertavel) //MALUCO EU SOU MUITO BURRO...
				//Consegui cometer o mesmo erro duas vezes seguidas...
			{
				changeSong(-1, false);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_RIGHT_P && apertavel)
			{
				changeSong(1, true);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new MenuPreHistoria());
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

			if (controls.ACCEPT)
			{
				selectSong();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MenuPreHistoria());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectSong()
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

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;

			FreeplayState.justread = musicas[curSelected];

			bgSprite.alpha = 0;
			PlayState.modohistoria = true;
			FlxG.log.warn(musicas[curSelected]);
			FlxTween.tween(perfilSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
			FlxTween.tween(bgSprite, {alpha: 0}, 1.0, {ease: FlxEase.expoInOut});
			FlxTween.tween(textoSprite, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut, 
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(pastbgSprite, {alpha: 0}, 1.0,{ease: FlxEase.linear});
			}});
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				openSubState(new LoadingsState());
				LoadingState.loadAndSwitchState(new PlayState());
			});

			FlxG.sound.music.volume = 0;
					
			FreeplayState.destroyFreeplayVocals();
		}

		function tweenpracima(){
			FlxTween.tween(textoSprite, {y: perfilSprite.height + perfilSprite.y + 5}, 5, {ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {
				tweenprabaixo();
			}});
		}

		function tweenprabaixo(){
			FlxTween.tween(textoSprite, {y: FlxG.height - textoSprite.height - 5}, 5, {ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {
				tweenpracima();
			}});
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
			if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'))) {
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
			pastbgSprite.screenCenter(XY);
			perfilSprite.updateHitbox();
			perfilSprite.y = 25;

			var curtimer:Float = 0.3;
			FlxTween.tween(bgSprite, {alpha: 1}, curtimer * 2, {ease: FlxEase.expoInOut});
			FlxTween.tween(pastbgSprite, {alpha: 0}, curtimer * 2, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'))) {
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
			if (!side){
			FlxTween.tween(textoSprite, {x: 0 - textoSprite.width}, curtimer, {ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween) {
					if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload'))) { //anti crashing moment 
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
					if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'))) { //anti crashing moment 
						perfilSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')); 
						perfilSprite.updateHitbox();
					} else {
						FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
					}
					perfilSprite.x = FlxG.width + perfilSprite.width;
					FlxTween.tween(perfilSprite, {x: (FlxG.width - perfilSprite.width) / 2}, curtimer, {ease: FlxEase.expoInOut});
				}
			});

			//
			} else{
				FlxTween.tween(textoSprite, {x: FlxG.width + textoSprite.width}, curtimer, {ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween) {
						if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload'))) { //anti crashing moment 
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
						if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'))) { //anti crashing moment 
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
					textoSprite.y = 10 * FlxG.height;
					tweenpracima();
					}
				});
	}
}