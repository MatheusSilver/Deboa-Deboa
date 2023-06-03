package;

import LoadingState.LoadingsState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import MusicBeatSubstate;
import PlayState;
#if rpc
import Discord.DiscordClient;
#end
import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;

class PastaNightSelect extends MusicBeatState {
    public static var selectCam:FlxCamera;
    var characters:Array<String> = ['MX', 'LordX', 'Hypno'];
    var characterSprites:Array<Array<FlxSprite>> = [];
    var selectorArrow:FlxSprite;
    var displacementList:Array<Int> = [-4,2,0];
	var crt:ShaderFilter;
	var paracomessapohameno:Bool = false;


	override public function create()
	{
		super.create();

		#if rpc
		DiscordClient.changePresence("Escolhendo um personagem em", "Noite da Rapaziada", null);
		#end

		FlxG.sound.playMusic(Paths.music('PastaNightSelect', 'preload'), 1, true);
		
		selector = -1;
		selectCam = new FlxCamera(0, 0, 768, 672);
		FlxG.cameras.reset(selectCam);
		
		crt = new ShaderFilter(new CRTEffectShader()); //Just Testing
		selectCam.setFilters([crt]);
		selectCam.x += (FlxG.width / 2 - selectCam.width / 2);
		selectCam.y += (FlxG.height / 2 - selectCam.height / 2);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var blackBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(blackBG);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pasta/PastaSelect_BG', 'preload'));
        bg.setGraphicSize(Std.int(bg.width * 3));
		bg.setPosition(selectCam.width / 2 - bg.width / 2, selectCam.height / 2 - bg.height / 2);
        add(bg);
        // bg.cameras = [selectCam];

		new FlxTimer().start(1.0, function(tmr:FlxTimer) {
			paracomessapohameno = true;
		});

		for (i in 0...characters.length) {
			characterSprites[i] = [];
            for (j in 0...3) {
				var charSprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pasta/PastaSelect_${characters[i]}_0${j+1}', 'preload'));
                if (j == 1)
                   charSprite.visible = false; 
				charSprite.setGraphicSize(Std.int(charSprite.width * 3));
				charSprite.setPosition(bg.x + bg.width / 2 - charSprite.width / 2, bg.y + bg.height / 2 - charSprite.height / 2);
				charSprite.x += (i - 1) * (3 * 45) + 3;
				charSprite.x = Std.int(charSprite.x);
				charSprite.y = (176 * 3) - charSprite.height + (displacementList[i]*3);
				add(charSprite);
				characterSprites[i].push(charSprite);
            }
        }

		selectorArrow = new FlxSprite().loadGraphic(Paths.image('pasta/PastaSelect_Arrow', 'preload'));
		selectorArrow.setGraphicSize(Std.int(selectorArrow.width * 3));
        add(selectorArrow);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		updateSelection(0);
    }

    public static var selector:Int = -1;
    public var oldSelector:Int = 0;
	public var totalElapsed:Float = 0;
    override public function update(elapsed:Float) {
		totalElapsed += elapsed;
		if (crt != null)
			crt.shader.data.time.value = [totalElapsed];
		
        if (controls.UI_LEFT_P)
			updateSelection(selector - 1);
        if (controls.UI_RIGHT_P)
			updateSelection(selector + 1);
		
        if (controls.ACCEPT) {
			var crossDifficulty:Int = selector + 5;
			FreeplayState.infoextended = 'Noite da Rapaziada';
			persistentUpdate = false;
			PlayState.isStoryMode = false;
            canSelect = false;
			characterSprites[selector][0].visible = false;
			characterSprites[selector][2].visible = false;
			characterSprites[selector][1].visible = true;
            new FlxTimer().start(0.5, function(tmr:FlxTimer){
				characterSprites[selector][1].visible = false;
				characterSprites[selector][0].visible = true;

				var songLowercase:String = Paths.formatToSongPath('pasta-night');
				var poop:String = Highscore.formatSong(songLowercase, crossDifficulty);
				if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					poop = songLowercase;
					trace('Couldnt find file');
				}
				trace(poop);
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.storyDifficulty = crossDifficulty;
	
				FlxG.camera.flash(FlxColor.RED, 1.0);
				selectCam = new FlxCamera(0, 0, 1280, 720);
				FlxG.cameras.reset(selectCam);
				openSubState(new LoadingsState());
				new FlxTimer().start(1.5, function(tmr:FlxTimer) {
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.stop();
					FlxG.sound.music = null;
				});
	
				FlxG.sound.music.volume = 0;
						
				FreeplayState.destroyFreeplayVocals();
            });
        }

        super.update(elapsed);
    }

    var canSelect:Bool = true;

    function updateSelection(selection:Int) {
		if (selection != selector && canSelect)
		{
			selector = selection;
			if (selector > characters.length - 1)
				selector = 0;
			else if (selector < 0)
				selector = characters.length - 1;
			// selection
			for (i in 0...characters.length)
				characterSprites[i][2].visible = true;
			characterSprites[selector][2].visible = false;

			selectorArrow.setPosition(characterSprites[selector][0].x+characterSprites[selector][0].width/2-selectorArrow.width/2,124*3);
		}
		
    }
}