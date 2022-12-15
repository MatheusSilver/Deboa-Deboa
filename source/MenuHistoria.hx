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

    var musicas:Array<Dynamic> = [];
    var nombres:Array<Dynamic> = [];
	private static var curSelected:Int = 0;
	var apertavel = false;

	var bgSprite:FlxSprite;
	var perfilSprite:FlxSprite;
	var textoSprite:FlxSprite;
	var bigmenu:FlxSprite;

	override function create()
	{
        var leWeek:WeekData = WeekData.weeksLoaded.get(FreeplayState.dapreselected);
        for (j in 0...leWeek.songs.length) {
            musicas.push(leWeek.songs[j][0]);
        }

		FlxG.mouse.visible = false;
		if(curSelected >= WeekData.weeksList.length) curSelected = 0;
		persistentUpdate = persistentDraw = true;

		bgSprite = new FlxSprite(0, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		textoSprite = new FlxSprite(0, FlxG.height - 125);
		textoSprite.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(0, 0);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
		

		add(bgSprite);
		add(perfilSprite);
		add(textoSprite);

		changeWeek();

		#if mobileC
		addVirtualPad(RIGHT_LEFT, A_B);
		#end

		if(curSelected >= musicas.length) curSelected = 0;

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	
	override function update(elapsed:Float)
	{
		#if desktop
		DiscordClient.changePresence("Escolhendo uma musica em: " + FreeplayState.dapreselected, null);
		#end

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				if (textoSprite.y == perfilSprite.y + 45)
					FlxTween.angle(textoSprite, textoSprite.y, FlxG.height - 100, 7, {ease: FlxEase.quartInOut});
				if (textoSprite.y == FlxG.height - 100)
					FlxTween.angle(textoSprite, textoSprite.y, perfilSprite.y + 45, 7, {ease: FlxEase.quartInOut});
			}, 0); //yay yay ping pong que legal ihuuuuuuuuu

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
    
            else if (FlxG.keys.justPressed.SPACE)
            {
                persistentUpdate = false;
                var songLowercase:String = Paths.formatToSongPath(musicas[curSelected]);
                FreeplayState.infoextended = musicas[curSelected].display;
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
    
                FlxG.camera.flash(FlxColor.WHITE, 1.5);
                openSubState(new LoadingsState());
                new FlxTimer().start(2.0, function(tmr:FlxTimer) {
                    LoadingState.loadAndSwitchState(new PlayState());
                });
				/*
				
				*/
    
                FlxG.sound.music.volume = 0;
                        
                FreeplayState.destroyFreeplayVocals();
            }

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_LEFT_P || apertavel)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_RIGHT_P || apertavel)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuStateMobile());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

			//	grpWeekText.members[curSelected].startFlashing();
			//	if(grpWeekCharacters.members[1].character != '') grpWeekCharacters.members[1].animation.play('confirm');
				stopspamming = true;
			}

			selectedWeek = true;

			var botaoselect = WeekData.weeksList[curSelected];
			FreeplayState.dapreselected = botaoselect;
			
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
			MusicBeatState.switchState(new MenuHistoria());
			});
		}

	public function changeWeek(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = musicas.length - 1;
		if (curSelected >= musicas.length)
			curSelected = 0;

		var leWeek:WeekData = WeekData.weeksLoaded.get(FreeplayState.dapreselected);
		WeekData.setDirectoryFromWeek(leWeek);

		bgSprite.visible = true;
		perfilSprite.visible = true;
		textoSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
			if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'))) {
				bgSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
			} else {
				FlxG.log.warn('Não foi possível achar ' + Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (back)", 'preload'));
				bgSprite.loadGraphic('assets/images/menuDesat.png');
			}
			if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload'))) { //anti crashing moment 
				perfilSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)", 'preload')); 
			} else {
				FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (scroll)");
			}
			if(OpenFlAssets.exists(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload'))) { //anti crashing moment 
				textoSprite.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)", 'preload')); 
			} else {
				FlxG.log.warn('Não foi possível achar ' + "scrolling/scroll-" + assetName + "/scroll-" + musicas[curSelected].toLowerCase() + " (txt)");
			}
			bgSprite.setGraphicSize(FlxG.width);
			bgSprite.screenCenter(XY);
			perfilSprite.updateHitbox();
			perfilSprite.screenCenter(X);
			perfilSprite.y = 75;
			textoSprite.screenCenter(X);


	}
}