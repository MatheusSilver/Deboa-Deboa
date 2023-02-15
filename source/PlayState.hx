package;

import openfl.display.BitmapData;
import SonicHUDCCC; //tive que trocar o nome pra não conflitar com o outro sonic hud usado na prey, YCR e talvez na nova confronting
#if desktop
import sys.io.Process; // medo
#end
#if sys
import Sys;
#if desktop
import sys.FileSystem;
#end
import sys.io.File;
#end
import lime.system.System;
import openfl.Lib;
import webm.WebmPlayer;
import flixel.addons.display.FlxTiledSprite;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Shaders;

import flixel.graphics.FlxGraphic;

#if mobileC
import ui.Mobilecontrols;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public var precacheList:Map<String, String> = new Map<String, String>(); 

	var scrollModifierChecker:Bool; //Usado apenas para flipar a pontinha da nota caso a música mude de downscroll para upscroll no meio do caminho. - Vulgo Pasta Night

	public static var cccVidaCounter:Int = 2;

	var hitsound:FlxSound;
	var sonicPulo:FlxSound;
	var sonicAviso:FlxSound;
	var sonicDash:FlxSound;

	public static var modohistoria:Bool = false;

	var blackFuck:FlxSprite;

	var stageData:StageFile;

	

	//CCC Stuff
	public static var sonicHUDCCC:SonicHUDCCC;
	var invencibilidade:Bool = false;
	var cccMiss:Bool = false;
	var luigienter:Bool = false;

	//veri scari
	var fakertransform:FlxSprite;
	var daJumpscare:FlxSprite = new FlxSprite(0, 0);
	var daP3Static:FlxSprite = new FlxSprite(0, 0);
	var bgSkychasing:FlxSprite;
	var daNoteStatic:FlxSprite = new FlxSprite(0, 0);


	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;
	public static var majinstrums:Bool = false;
	public static var desesperada:Bool = false;
	public static var resetforcado = false; //Provavelmente vai ser usado no futuro em:
	//"Eu digo quando acaba", na real

	var vignetteEspecial:FlxSprite; //usado exclusivamente na simp into the chifres

	var infinitesimbol:FlxSprite; //detalhe gigachad

	// - coldsteels spins
	var SpinAmount:Float = 0;
	var IsNoteSpinning:Bool = false;
	var isPlayersSpinning:Bool = false;
	public var superZoomShit:Bool = false;
	public var supersuperZoomShit:Bool = false;

	var tempogravador:FlxText;

	var secondsTotal:Int;

	public static var ratingStuff:Array<Dynamic> = [
		['Horrível!', 0.2], //From 0% to 19%
		['Merda', 0.4], //From 20% to 39%
		['Ruim', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Bom', 0.7], //69%
		['Ótimo', 0.8], //From 70% to 79%
		['Excelente', 0.9], //From 80% to 89%
		['Foda!', 1], //From 90% to 99%
		['Perfeito!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	var floaty:Float = 0;
	#if (haxe >= "4.0.0")
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	#else
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map();
	#end
	public static var shader_chromatic_abberation:ChromaticAberrationEffect;
	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end

	var monitor:FlxSprite;

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;
	#if (haxe >= "4.0.0")
	public var variables:Map<String, Dynamic> = new Map();
	#else
	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	#end
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var noteKillOffset:Float = 300;

	// - flying shit
	var flyTarg:Character;
	var flyState:String = '';
	
	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public var shaderUpdates:Array<Float->Void> = [];

	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public static var nomehistorico:String;

	public var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<Dynamic> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;
	private static var resetSpriteCache:Bool = false;

	var tailscircle:String = '';
	var floaty2:Float = 0;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>; //Usado exclusivamente na Pasta Night e talvez na Slaybells
	public var thirdplayerStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	var topBar:FlxSprite;
	var bottomBar:FlxSprite;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	private var startingSong:Bool = false;
	private var updateTime:Bool = false;
	public static var practiceMode:Bool = false;
	public static var usedPractice:Bool = false;
	public static var changedDifficulty:Bool = false;
	public static var cpuControlled:Bool = false;

	var botplaySine:Float = 0;
	var botplayTxt:FlxText;

	var startCircle:FlxSprite;
	var startText:FlxSprite;

	// - dad 2 things (namely needlemouse)
	public var dad2:Character;
	public var dad2Group:FlxSpriteGroup; // going to use this for needle/sarah (avery)

	//trems da pasta night
	var barmesafront:BGSprite;
	var bracosmx:FlxSprite;
	var blocomx:BGSprite;
	var bracoshypno:FlxSprite;



	// needlemouse shit
	var conkCreet:BGSprite;
	var needleBuildings:BGSprite;
	var needleMoutains:BGSprite;
	var needleSky:BGSprite;
	var needleRuins:BGSprite;
	var needleFg:FlxSprite;
	var vcr:ShaderFilter;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camCCC:FlxCamera;
	public var camHUD2:FlxCamera; // jumpscares, ect..
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var camLegenda:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyCityLights:FlxTypedGroup<BGSprite>;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:FlxSprite;
	var blammedLightsBlackTween:FlxTween;
	var phillyCityLightsEvent:FlxTypedGroup<BGSprite>;
	var phillyCityLightsEventTween:FlxTween;
	var trainSound:FlxSound;

	public static var webmHandler:WebmHandler;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var bgGhouls:BGSprite;

	public static var isRing:Bool = false;

	var textoajustefino:String = '';

	var meses:Array<String> = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var ghostMisses:Int = 0;
	public var scoreTxt:FlxText;
	public var judgementCounter:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;
	var judgementCounterTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;
	public static var letrinhas:FlxSprite;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public var inCutscene:Bool = false;
	var songLength:Float = 0;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var pauseSound:FlxSound;

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end	

	public var luaArray:Array<FunkinLua> = [];
	//Achievement shit
	var keysPressed:Array<Bool> = [false, false, false, false];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	//Coisas
	var jumpscareSound:FlxSound;
	var jumpscareAuxiliar:FlxSound;

	// Lua shit
	public static var instance:PlayState;
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	//Sonic P2 Stage
	var p2Ground:BGSprite;
	public var p2greenhill:BGSprite; //isso é uma ação desesperada...
	var p2Sky:BGSprite;

	// - ring counter bullshit
	var ringCounter:FlxSprite;
	var counterNum:FlxText;
	var bfIsLeft:Bool = false;

	//exe p3 trens
	var balling:FlxSprite = new FlxSprite(0, 0);
	var p3staticbg:FlxSprite;

	// starved shit
	var warning:FlxSprite = new FlxSprite();
	var stardustBgPixel:FlxTiledSprite;
	var stardustFloorPixel:FlxTiledSprite;
	var stardustFurnace:FlxSprite;
	var endingIndicator:FlxSprite;
	var theendbg:BGSprite;
	var furnaceTheEnd:BGSprite;
	var hungryManJackTime:Int = 0;
	public var healthbarval:Float = 1; // I'm fucking stupid but ok it works
	var desvioPrey:Bool = false; //Tá associado com o evento 2400 e serve pra permitir que o player aperte espaço em um momento bem específico
	var desviou:Bool = false; //Serve como sensor para o resto da música pra saber se o player apertou na hora certa.
	public static var canuseevents:Bool = true;
	public static var canRegen:Bool = true;
	public static var loadingImage:String;
	
	var cNum:Int = 0;


	var memuse:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100; // :sunglasses: :trollface:

	// Texto de aviso caso o PC/celular esteja sobrecarregando.

	var sobrecarga:FlxText;
	var canoff:Bool = canon;
	var canon:Bool;

	/* Semelhante ao do OBS Studio:
	 		Imagem de exemplo no chat #x02-room 
			 https://cdn.discordapp.com/attachments/1050918953960091658/1075471038718160986/maxresdefault.png
	*/

	public var sonicHUDSongs:Array<String> = [
		"prey",
		'round-a-bout',
	];

	public var ringsNumbers:Array<SonicNumber>=[];
	public var minNumber:SonicNumber;
	public var sonicHUD:FlxSpriteGroup;
	public var scoreNumbers:Array<SonicNumber>=[];
	public var missNumbers:Array<SonicNumber>=[];
	public var vidaNumbers:Array<SonicNumber>=[];
	public var secondNumberA:SonicNumber;
	public var secondNumberB:SonicNumber;
	public var millisecondNumberA:SonicNumber;
	public var millisecondNumberB:SonicNumber;

	var hudStyle:String = 'sonic2';
	public var sonicHUDStyles:Map<String, String> = [
		"round-a-bout" => 'sonic3',
		"prey" => "soniccd",
		"you-cant-run" => "sonic2", // because its green hill zone so it should be sonic1
		// "songName" => "styleName",

		// styles are sonic2 and sonic3
		// defaults to sonic2 if its in sonicHUDSongs but not in here
	];
	//loading stuff
	var art = new FlxSprite();
	var loadingbar = new FlxSprite();
	var modboalogo = new FlxSprite();
	public static var veioNormal:Bool;

	override public function create()
	{

		Main.dumpCache();
		Achievements.loadAchievements();
		
		//Precache geral

		if(SONG.song.toLowerCase() == 'defender' && SONG.song.toLowerCase() == 'illegal-download') {
		precacheList.set('loading/' + curSong, 'image');
		} else {
		precacheList.set('loading/defender-illegal-download', 'image');
		}
		precacheList.set('loading/loading-logo', 'image');
		precacheList.set('loading/carregando', 'image');
		precacheList.set('vaitomarnocu', 'image');
		precacheList.set('pause/botplayativado', 'image');
		precacheList.set('pause/botplaydesativado', 'image');
		precacheList.set('pause/praticarativado', 'image');
		precacheList.set('pause/praticardesativado', 'image');
		precacheList.set('pause/pause (linhas)', 'image');
		precacheList.set('pause/pause (sonicexe)', 'image');
		precacheList.set('pause/pause (continuar)', 'image');
		precacheList.set('pause/pause (restart)', 'image');
		precacheList.set('pause/pause (voltar)', 'image');
		precacheList.set('unpause', 'sound');
		precacheList.set('PauseEnter', 'sound');
		precacheList.set('pausescrollmenu', 'sound');
		precacheList.set('breakfast', 'music');

	
		
		//FlxG.sound.cache(Paths.inst(PlayState.SONG.song));
		//if (SONG.needsVoices){
		//	FlxG.sound.cache(Paths.voices(PlayState.SONG.song));
		//}

		


		isRing = SONG.isRing; //Top 10 otimizações mais sodas do Mundo talvez do Brasil

		cccVidaCounter = 2; //meida...
        canRegen = true;
		resetforcado = false;
        canuseevents = true; //Apenas para ter certeza de que a música não vai vir bugada da Prey

		

		blackFuck = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		add(blackFuck);
		blackFuck.alpha = 0;
		FlxG.mouse.visible = false;
	
				
		instance = this;

		nomehistorico = FreeplayState.infoextended;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();


		removedVideo = false;

		practiceMode = false;
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camCCC = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camLegenda = new FlxCamera();
		camHUD2 = new FlxCamera();
		camHUD2.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;
		camCCC.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		camLegenda.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camCCC);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOther);
		FlxG.cameras.add(camHUD2);
		FlxG.cameras.add(camLegenda);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		sonicHUD = new FlxSpriteGroup();
		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		modboalogo.loadGraphic(Paths.image('loading/loading-logo',  'preload'));
		modboalogo.cameras=[camHUD];
		loadingbar.loadGraphic(Paths.image('loading/carregando',  'preload'));
		loadingbar.x=0;

		loadingbar.cameras=[camHUD];
		//loadingbar.y=0;
		modboalogo.y=0;
		//modboalogo.x=0;		
		loadingbar.setGraphicSize(Std.int(FlxG.width * 1));
		loadingbar.updateHitbox();
		loadingbar.antialiasing = ClientPrefs.globalAntialiasing;
		loadingbar.cameras = [camHUD2];
		modboalogo.setGraphicSize(Std.int(FlxG.width * 1));
		modboalogo.updateHitbox();
		modboalogo.cameras = [camHUD2];
		art.cameras=[camHUD];
		modboalogo.antialiasing = ClientPrefs.globalAntialiasing;
		art.loadGraphic(Paths.image(loadingImage, 'preload'));
		art.cameras = [camHUD2];
		art.setGraphicSize(Std.int(FlxG.width * 1.0));
		art.updateHitbox();
		art.screenCenter(XY);
		art.antialiasing = ClientPrefs.globalAntialiasing;
		art.alpha=1;

		#if desktop
		storyDifficultyText = '' + CoolUtil.difficultyStuff[storyDifficulty][0];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (modohistoria)
		{
			detailsText = MenuHistoria.dapreselected;
		}
		else
		{
			detailsText = FreeplayState.weekNombre;
		}

		// String for when the game is paused
		detailsPausedText = "Pausado - " + detailsText;
		#end

		topBar = new FlxSprite(0, -170).makeGraphic(1280, 170, FlxColor.BLACK);
		bottomBar = new FlxSprite(0, 720).makeGraphic(1280, 170, FlxColor.BLACK);

		startCircle = new FlxSprite();
		startText = new FlxSprite();

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);
		curStage = PlayState.SONG.stage;
		trace('stage is: ' + curStage);
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				default:
					curStage = 'stage';
			}
		}

		stageData = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100]
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		dad2Group = new FlxSpriteGroup(DAD_X, DAD_Y); // should load right on top of dad? hopefully lmao (avery)
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{

			case 'too-slow':
					{
						var bg:FlxSprite = new FlxSprite(-297 - 230, -246).loadGraphic(Paths.image('PolishedP1/FLOOR1'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1.3, 1);
						bg.active = false;
						add(bg);

						jumpscareSound = new FlxSound().loadEmbedded(Paths.sound('jumpscare'));
						jumpscareAuxiliar = new FlxSound().loadEmbedded(Paths.sound('datOneSound'));

					} 
			case 'fakerStage':
				var daStatic:FlxSprite = new FlxSprite(0, 0);
	
				daStatic.frames = Paths.getSparrowAtlas('daSTAT', 'preload');
				add(daStatic);
				remove(daStatic);
				fakertransform = new FlxSprite(100 - 10000, 100 - 10000);
				fakertransform.frames = Paths.getSparrowAtlas('Faker_Transformation');
				fakertransform.animation.addByPrefix('1', 'TransformationRIGHT instance 1');
				fakertransform.animation.addByPrefix('2', 'TransformationLEFT instance 1');
				fakertransform.animation.addByPrefix('3', 'TransformationUP instance 1');
				fakertransform.animation.addByPrefix('4', 'TransformationDOWN instance 1');
				fakertransform.animation.play('1', true);
				fakertransform.alpha = 0;
				add(fakertransform);
				remove(fakertransform);
			case 'void':
				var whiteFuck:FlxSprite; //Talvez eu arrange outra serventia pra isso.
				whiteFuck = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
				add(whiteFuck);
			case 'P2Stage':
				p2Sky = new BGSprite('cenarios/Glitch', -200, -200, 0.6, 0.6);
				p2Sky.scale.x = 0.8;
				p2Sky.scale.y = 0.8;
				add(p2Sky);

				p2Ground = new BGSprite('cenarios/ground', -425, -100, 1.1, 1.1);
				p2Ground.scale.x = 1;
				p2Ground.scale.y = 1;
				add(p2Ground);
				

				p2greenhill = new BGSprite('cenarios/GreenHill', 180, 350, 1, 0.9);
				p2greenhill.setGraphicSize(Std.int(p2greenhill.width * 6)); //yeah yeah, matematics
				p2greenhill.scale.x = 8;
				p2greenhill.visible = false;
				p2greenhill.antialiasing = true;
				add(p2greenhill);

				case 'P3Stage': // i fixed the bgs and shit!!! - razencro part 1 - bg's finalizados sílvio parte 2
				{		
					var sSKY:FlxSprite = new FlxSprite(-621.1, -395.65).loadGraphic(Paths.image('cenarios/Glitch'));
					sSKY.antialiasing = true;
					sSKY.scrollFactor.set(0.9, 1);
					sSKY.active = false;
					sSKY.scale.x = 1.2;
					sSKY.scale.y = 1.2;
					add(sSKY);

					p3staticbg = new FlxSprite(0, 0);
					p3staticbg.frames = Paths.getSparrowAtlas('effects/estatica', 'shared');
					p3staticbg.animation.addByPrefix('P3Static', 'TitleMenuSSBG instance 1', 24, true);
					p3staticbg.animation.play('P3Static');
					p3staticbg.screenCenter();
					p3staticbg.scale.x = 4.5;
					p3staticbg.scale.y = 4.5;
					p3staticbg.visible = false;
					add(p3staticbg);

					var bg:FlxSprite = new FlxSprite(-630.4, -266).loadGraphic(Paths.image('cenarios/ground'));
					bg.antialiasing = true;
					bg.scrollFactor.set(1.1, 1);
					bg.active = false;
					bg.scale.x = 1.2;
					bg.scale.y = 1.2;
					add(bg);
				}


			case 'needle':

				defaultCamZoom = 0.6;

				needleSky = new BGSprite('cenarios/needlemouse/sky', -725, -200, 0.7, 0.9);
				// needleSky.setGraphicSize(Std.int(needleSky.width * 0.9));
				add(needleSky);

				needleMoutains = new BGSprite('cenarios/needlemouse/mountains', -700, -175, 0.8, 0.9);
				needleMoutains.setGraphicSize(Std.int(needleMoutains.width * 1.1));
				add(needleMoutains);

				needleRuins = new BGSprite('cenarios/needlemouse/ruins', -775, -310, 1, 0.9);
				needleRuins.setGraphicSize(Std.int(needleRuins.width * 1.4));
				add(needleRuins);

				needleBuildings = new BGSprite('cenarios/needlemouse/buildings', -1000, -100, 1, 0.9);
				// needleBuildings.setGraphicSize(Std.int(needleBuildings.width * 0.85));
				add(needleBuildings);

				conkCreet = new BGSprite('cenarios/needlemouse/CONK_CREET', -775, -310, 1, 0.9);
				conkCreet.setGraphicSize(Std.int(conkCreet.width * 1.4));
				add(conkCreet);

				

				needleFg = new FlxSprite(-690, -80).loadGraphic(Paths.image("cenarios/needlemouse/fg"));
				needleFg.setGraphicSize(Std.int(needleFg.width * 1.1));
				needleFg.scrollFactor.set(1, 0.9);

				tempogravador = new FlxText(50, 0, 0, "", 48);
				tempogravador.text = '';
				tempogravador.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				tempogravador.updateHitbox();
				tempogravador.cameras = [camHUD];
				tempogravador.screenCenter(XY);
				tempogravador.x += 125;
				tempogravador.y += 175;
                tempogravador.visible = ClientPrefs.shaders;
				tempogravador.antialiasing = false;
				add(tempogravador);
				

				if(ClientPrefs.shaders) {
					vcr = new ShaderFilter(new VCRDistortionShader());
					vcr.shader.data.iTime.value = [0];
					vcr.shader.data.vignetteOn.value = [true];
					vcr.shader.data.perspectiveOn.value = [true];
					vcr.shader.data.distortionOn.value = [true];
					vcr.shader.data.scanlinesOn.value = [true];
					vcr.shader.data.vignetteMoving.value = [true];
					vcr.shader.data.glitchModifier.value = [0];
					vcr.shader.data.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];

					camGame.setFilters([vcr]);
					camHUD.setFilters([vcr]);				
				}

			case 'chasing':

			var contadordevida:FlxSprite;
			var greenhill:FlxSprite;

			monitor = new FlxSprite(-108, -100, Paths.image('cenarios/chasing/monitor'));
			monitor.antialiasing = ClientPrefs.globalAntialiasing;
			monitor.scale.y = 0.85;
			monitor.scrollFactor.set(1, 1);
			monitor.updateHitbox();

			contadordevida = new FlxSprite(56, 805, Paths.image('cenarios/chasing/HedgehogLives'));
			contadordevida.antialiasing = ClientPrefs.globalAntialiasing;
			contadordevida.scale.y = 0.9;
			contadordevida.scale.x = 0.9;
			contadordevida.scrollFactor.set(1, 1);
			contadordevida.updateHitbox();

			greenhill = new FlxSprite(4, -100, Paths.image('cenarios/chasing/GreenHill'));
			greenhill.antialiasing = ClientPrefs.globalAntialiasing;
			greenhill.scale.x = 1;
			greenhill.scale.y = 0.99;
			greenhill.scrollFactor.set(1, 1);
			greenhill.updateHitbox();

			add(greenhill);
			add(contadordevida);
			add(monitor);

			bgSkychasing = new FlxSprite(-50, -75, Paths.image('cenarios/chasing/BGSky'));
			bgSkychasing.antialiasing = ClientPrefs.globalAntialiasing;
			bgSkychasing.scale.x = 1;
			bgSkychasing.scale.y = 1;
			bgSkychasing.scrollFactor.set(1, 1);
			bgSkychasing.updateHitbox();
			bgSkychasing.visible = false;
			add(bgSkychasing);

			case 'starved-pixel':
				defaultCamZoom = 0.6;
				isPixelStage = true;

				theendbg = new BGSprite('cenarios/starved/Prey End', 0, 0, 1, 1); //Tecnicamente ele está atrás de todo mundo
				theendbg.scale.x = 1.3; //Não acho que vou precisar me preocupar com o visible dele
				theendbg.scale.y = 1.3;
				theendbg.visible = false;
				add(theendbg);

				furnaceTheEnd = new BGSprite('cenarios/starved/Furnace', 226, 526, 1, 1, ['Furnace Idle']);
				furnaceTheEnd.scale.x = 1.5;
				furnaceTheEnd.scale.y = 1.5; //Já você é um outro caso.
				furnaceTheEnd.visible = false;


				stardustBgPixel = new FlxTiledSprite(Paths.image('cenarios/starved/stardustBg2'), 4608, 2832, true, true);
				stardustBgPixel.scrollFactor.set(0.4, 0.4);


				stardustFloorPixel = new FlxTiledSprite(Paths.image('cenarios/starved/stardustFloor1'), 4608, 2832, true, true);

				stardustBgPixel.visible = false;
				stardustFloorPixel.visible = false;

				stardustFurnace = new FlxSprite(-500, 1450);
				stardustFurnace.frames = Paths.getSparrowAtlas('characters/prey/Furnace_sheet', 'shared');
				stardustFurnace.animation.addByPrefix('idle', 'Furnace idle', 24, true);
				stardustFurnace.animation.play('idle');
				stardustFurnace.scale.x = 6;
				stardustFurnace.scale.y = 6;
				stardustFurnace.antialiasing = false;

				stardustBgPixel.screenCenter();
				stardustFloorPixel.screenCenter();
				stardustFloorPixel.y -=410;
				stardustFloorPixel.x -= 250;
				stardustFurnace.x -= 250;
				stardustFurnace.y -=410;

				stardustBgPixel.y -=410;
				stardustBgPixel.x -= 250; //Mais fácil

				add(stardustBgPixel);
				add(stardustFurnace);

				warning.frames = Paths.getSparrowAtlas("slash_warning_sheet"); //Apenas placeholder
				warning.animation.addByPrefix('warn', 'slash warning');
				warning.setGraphicSize(Std.int(warning.width * 2.5));
				warning.visible = false;
				warning.screenCenter();
				warning.cameras = [camHUD];
				add(warning);
				
				sonicDash = new FlxSound().loadEmbedded(Paths.sound('SonicDash', 'week-prey'));
				sonicPulo = new FlxSound().loadEmbedded(Paths.sound('SonicJump', 'week-prey'));
				sonicPulo.volume = 0.6;
				sonicDash.volume = 0.6; //carregamento pra rodar uma única vez... Omega massa...
				//Qual foi... O fleetway tem uma spritesheet inteira (Que ninguem vê) só pra atirar um laserzin

				sonicAviso = new FlxSound().loadEmbedded(Paths.sound('AvisoSom', 'week-prey'));
				sonicAviso.volume = 0.6;

				endingIndicator = new FlxSprite(Paths.image('good_ending')); //Só pra garantir que ele fique na frente da tela preta na hora do super sonico
				endingIndicator.alpha = 0;
				endingIndicator.cameras = [camHUD2];
				endingIndicator.updateHitbox();
				endingIndicator.screenCenter();
				add(endingIndicator);

			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);

				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}

			case 'spooky': //Week 2
				if(!ClientPrefs.lowQuality) {
					halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
				} else {
					halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
				}
				add(halloweenBG);

				halloweenWhite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				halloweenWhite.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				halloweenWhite.alpha = 0;
				halloweenWhite.blend = ADD;

				//PRECACHE SOUNDS
				CoolUtil.precacheSound('thunder_1');
				CoolUtil.precacheSound('thunder_2');

			case 'philly': //Week 3
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
					add(bg);
				}

				var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<BGSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:BGSprite = new BGSprite('philly/win' + i, city.x, city.y, 0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					phillyCityLights.add(light);
				}

				if(!ClientPrefs.lowQuality) {
					var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
					add(streetBehind);
				}

				phillyTrain = new BGSprite('philly/train', 2000, 360);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				CoolUtil.precacheSound('train_passes');
				FlxG.sound.list.add(trainSound);

				var street:BGSprite = new BGSprite('philly/street', -40, 50);
				add(street);

			case 'limo': //Week 4
				var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
				add(skyBG);

				if(!ClientPrefs.lowQuality) {
					limoMetalPole = new BGSprite('gore/metalPole', -500, 220, 0.4, 0.4);
					add(limoMetalPole);

					bgLimo = new BGSprite('limo/bgLimo', -150, 480, 0.4, 0.4, ['background limo pink'], true);
					add(bgLimo);

					limoCorpse = new BGSprite('gore/noooooo', -500, limoMetalPole.y - 130, 0.4, 0.4, ['Henchmen on rail'], true);
					add(limoCorpse);

					limoCorpseTwo = new BGSprite('gore/noooooo', -500, limoMetalPole.y, 0.4, 0.4, ['henchmen death'], true);
					add(limoCorpseTwo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					limoLight = new BGSprite('gore/coldHeartKiller', limoMetalPole.x - 180, limoMetalPole.y - 80, 0.4, 0.4);
					add(limoLight);

					grpLimoParticles = new FlxTypedGroup<BGSprite>();
					add(grpLimoParticles);

					//PRECACHE BLOOD
					var particle:BGSprite = new BGSprite('gore/stupidBlood', -400, -400, 0.4, 0.4, ['blood'], false);
					particle.alpha = 0.01;
					grpLimoParticles.add(particle);
					resetLimoKill();

					//PRECACHE SOUND
					CoolUtil.precacheSound('dancerdeath');
				}

				limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);

				fastCar = new BGSprite('limo/fastCarLol', -300, 160);
				fastCar.active = true;
				limoKillingState = 0;

			case 'mall': //Week 5 - Cocoa, Eggnog
				var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				if(!ClientPrefs.lowQuality) {
					upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);
				}

				var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
				add(tree);

				bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
				bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
				add(fgSnow);

				santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
				add(santa);
				CoolUtil.precacheSound('Lights_Shut_off');

			case 'mallEvil': //Week 5 - Winter Horrorland
				var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
				add(evilTree);

				var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
				add(evilSnow);

			case 'school': //Week 6 - Senpai, Roses
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var bgSky:BGSprite = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
				add(bgSky);
				bgSky.antialiasing = false;

				var repositionShit = -200;

				var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
				add(bgSchool);
				bgSchool.antialiasing = false;

				var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
				add(bgStreet);
				bgStreet.antialiasing = false;

				var widShit = Std.int(bgSky.width * 6);
				if(!ClientPrefs.lowQuality) {
					var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					fgTrees.updateHitbox();
					add(fgTrees);
					fgTrees.antialiasing = false;
				}

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgTrees.antialiasing = false;

				if(!ClientPrefs.lowQuality) {
					var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
					treeLeaves.setGraphicSize(widShit);
					treeLeaves.updateHitbox();
					add(treeLeaves);
					treeLeaves.antialiasing = false;
				}

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));

				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();

				if(!ClientPrefs.lowQuality) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

			case 'schoolEvil': //Week 6 - Thorns
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var posX = 400;
				var posY = 200;
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', posX, posY, 0.8, 0.9, ['background 2'], true);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);

					bgGhouls = new BGSprite('weeb/bgGhouls', -100, 190, 0.9, 0.9, ['BG freaks glitch instance'], false);
					bgGhouls.setGraphicSize(Std.int(bgGhouls.width * daPixelZoom));
					bgGhouls.updateHitbox();
					bgGhouls.visible = false;
					bgGhouls.antialiasing = false;
					add(bgGhouls);
				} else {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool_low', posX, posY, 0.8, 0.9);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);
				}
		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		if(ClientPrefs.noteSplashes){
			precacheList.set('splashes/'+SONG.splashSkin, 'image');
		}

		if (ClientPrefs.hitSounds){
			hitsound = new FlxSound().loadEmbedded(Paths.sound('osu/' + ClientPrefs.hitSoundType, 'shared'));
			hitsound.volume = ClientPrefs.osusom; //I FORGOOOOOOOOOOOOOOOOOOOOOOOOOOOOOR
		}

		pauseSound = new FlxSound().loadEmbedded(Paths.sound('PauseEnter'));
		pauseSound.volume = 0.6;
		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		
		if (curStage == 'needle'){
			add(dad2Group);
		}

		add(gfGroup);
		add(dadGroup);
		add(boyfriendGroup);
		
		if(curStage == 'spooky') {
			add(halloweenWhite);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

        var doPush:Bool = false;

		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		luaFile = Paths.getPreloadPath(luaFile);
		if(OpenFlAssets.exists(luaFile)) {
			doPush = true;
		}

		if(curStage == 'philly') {
			phillyCityLightsEvent = new FlxTypedGroup<BGSprite>();
			for (i in 0...5)
			{
				var light:BGSprite = new BGSprite('philly/win' + i, -10, 0, 0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				phillyCityLightsEvent.add(light);
			}
		}
		
		if(doPush) 
			luaArray.push(new FunkinLua(Asset2File.getPath(luaFile)));

		blammedLightsBlack = new FlxSprite(BF_X - FlxG.width*2, BF_Y - FlxG.height*2);
		blammedLightsBlack.makeGraphic(Std.int(FlxG.width * 5), Std.int(FlxG.height * 5), FlxColor.BLACK);
		var position:Int = members.indexOf(boyfriendGroup);
		insert(position - 1, blammedLightsBlack);
		
		if(curStage == 'philly') insert(members.indexOf(blammedLightsBlack) + 1, phillyCityLightsEvent);
		blammedLightsBlack.alpha = 0.0;

		var gfVersion:String = SONG.player3;
		if(gfVersion == null || gfVersion.length < 1) {
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				default:
					gfVersion = 'gf';
			}
			SONG.player3 = gfVersion; //Fix for the Chart Editor
		}

		gf = new Character(0, 0, gfVersion);
		startCharacterPos(gf);
		gf.scrollFactor.set(0.95, 0.95);
		gfGroup.add(gf);
		startCharacterLua(gf.curCharacter);

		if (curStage == 'too-slow')
			{
				gf.scrollFactor.set(1.37, 1);
			}
		if (curStage == 'needle')
			{
				dad2 = new Character(0, 0, 'sarah1');
				startCharacterPos(dad2, true);
				dad2Group.add(dad2);
			}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);

		flyTarg = dad;

		scrollModifierChecker = ClientPrefs.downScroll;

		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		if (nomehistorico.toLowerCase() == 'profundezas'){
			var logoBl2:FlxSprite;
			logoBl2 = new FlxSprite(0, 0);
			
			logoBl2.frames = Paths.getSparrowAtlas('cenarios/depths/waves');
			logoBl2.antialiasing = ClientPrefs.globalAntialiasing;
			logoBl2.scale.set(5, 3);
			logoBl2.alpha = 0.06;
			logoBl2.cameras = [camHUD2];
			logoBl2.animation.addByPrefix('muitomedo', 'idle', 13);
			logoBl2.animation.play('muitomedo');
			logoBl2.updateHitbox();
			vignetteEspecial = new FlxSprite(0, 0).loadGraphic(Paths.image('vignette'));
			vignetteEspecial.cameras = [camHUD2];
			vignetteEspecial.setGraphicSize(FlxG.width, FlxG.height);
			vignetteEspecial.alpha = 0.3;
			// Caso o lowquality esteja ativado, o filtro não vai aparecer, consumindo pouca ram 
			// Mas e se não desativar?
			// Eu tenho autorização de colocar minha otimização aqui?
			if(!ClientPrefs.lowQuality) 
			{
			add(logoBl2);
			}
			add(vignetteEspecial);

		}
		
		var camPos:FlxPoint = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);
		camPos.x += gf.cameraPosition[0];
		camPos.y += gf.cameraPosition[1];

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			gf.visible = false;
		}

		switch(curStage)
		{
			case 'too-slow':
				boyfriend.y += 25;
				dad.y += 200;
				dad.x += 200;
				dad.scale.x = 1.1;
				dad.scale.y = 1.1;
				dad.scrollFactor.set(1.37, 1);
				boyfriend.scrollFactor.set(1.37, 1);
			case 'starved-pixel':
				add(stardustFloorPixel);
				add(furnaceTheEnd); //Perigoso... Pra dizer o mínimo
				
				dad.x -= 1050; //Garantindo que o fornalha comece lá atrás
			case 'needle':
				add(needleFg);
				dad2.alpha = 0;

				dad.x -= 120;
				dad.y += 265;
				boyfriend.x += 275;
				boyfriend.y += 280;
				gf.x += 1000;
				gf.y += 350;
				dad2.x -= 150;
				dad2.y += 25;

				flyTarg = dad2; // fucking smart genious and intellegent
				flyState = 'sHover';

				boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.9));
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);
			
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 20, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = !ClientPrefs.hideTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 45;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = !ClientPrefs.hideTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);
		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
		'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		if(SONG.song.toLowerCase()=='clickbait'){
			timeBar.createFilledBar(0x63C9C9C9, 0xFFFF0000);
			timeBar.numDivisions = 2000; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		}else{
			timeBar.numDivisions = 400;
			timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		}

		timeBar.alpha = 0;
		timeBar.visible = !ClientPrefs.hideTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();
		thirdplayerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);		
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys()) {
			var luaToLoad:String = 'custom_notetypes/' + notetype + '.lua';
		    luaToLoad = Paths.getPreloadPath(luaToLoad);			
			if(OpenFlAssets.exists(luaToLoad)) {
				luaArray.push(new FunkinLua(Asset2File.getPath(luaToLoad)));
			}
		}
		for (event in eventPushedMap.keys()) {
			var luaToLoad:String = 'custom_events/' + event + '.lua';
		    luaToLoad = Paths.getPreloadPath(luaToLoad);			
			if(OpenFlAssets.exists(luaToLoad)) {
				luaArray.push(new FunkinLua(Asset2File.getPath(luaToLoad)));
			}
		}	
		#end		
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		
		if (curSong.toLowerCase() == 'faker')
		{
			fakertransform.setPosition(dad.getGraphicMidpoint().x - 400, dad.getGraphicMidpoint().y - 400);
		}

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		if((!ClientPrefs.camZooms || SONG.canfollowpermitido || OpenFlAssets.exists(Paths.getPreloadPath('custom_scripts/camFollowGlobal.lua')))&& curSong.toLowerCase()!='pasta-night')
			moveCameraSection(0);

		var textodesobrecarga:String = "Seu uso de memória está muito alto! As opções de performance serão ativadas.";
		var systemtotalmemory:Float = Math.round(System.totalMemory);
		var memoriavisi:Float;

		//Infelizmente eu não sei como fazer isso com cálculos, sinceramente.
		// systemtotalmemory / 2 + 200;
		// ???????????
		switch(systemtotalmemory) 
		{
			case 500:
				memoriavisi = 200;

			case 1000:
				memoriavisi = 800;

			case 2000: 
				memoriavisi = 1600;

			case 6000:
				memoriavisi = 4000;

			case 8000:
				memoriavisi = 5000;

			case 12000:
				memoriavisi = 8000;
			
			case 16000:
				memoriavisi = 12000;

			default:
				memoriavisi = "1234";
		}

		var gtasan:FlxSprite(0, 0).loadGraphic(Paths.image("vaitomarnocu"));
		gtasan.setGraphicSize(Std.int(FlxG.width, FlxG.height));
		gtasan.alpha = 0;
		add(gtasan);

		var sobrecarga:FlxText = new FlxText(-200 - 578 + 753, FlxG.height - 40, FlxG.width, textodesobrecarga, 18);
		if(!memoriavisi > systemtotalmemory) 
		{
		sobrecarga.alpha = 0;
		} else {
		sobrecarga.alpha = 1;
		canon = true;

				if(canon) 
				{
					ClientPrefs.lowQuality = true;
					ClientPrefs.globalAntialiasing = false;
					ClientPrefs.shaders = false;
					gtasan.alpha = 1;
					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						gtasan.alpha = 0;
					});

				} else if (canoff) {
					ClientPrefs.lowQuality = false;
					ClientPrefs.globalAntialiasing = true;
					ClientPrefs.shaders = true;
				}
		}
		sobrecarga.setFormat(Paths.font("letravio.ttf"), 18, FlxColor.WHITE, RIGHT);
		sobrecarga.scrollFactor.set();
		add(sobrecarga);

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'healthbarval', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.visible = !ClientPrefs.hideHud;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.visible = !ClientPrefs.hideHud;
		add(iconP2);
		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.scrollFactor.set();
		judgementCounter.screenCenter(Y);
		if(!ClientPrefs.hideHud) {add(judgementCounter);}

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		if(curSong.toLowerCase() != 'cross-console-clash')
			{
				add(botplayTxt);
			}
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		if (isRing)
			{
				ringCounter = new FlxSprite(1133, 610).loadGraphic(Paths.image('cenarios/Counter'));
				add(ringCounter);
				ringCounter.cameras = [camHUD];
	
				var strumArray = [0, 1, 3, 4];
	
				counterNum = new FlxText(1207, 606, 0, '0', 10, false);
				counterNum.setFormat('EurostileTBla', 60, FlxColor.fromRGB(255, 204, 51), FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(204, 102, 0));
				counterNum.setBorderStyle(OUTLINE, FlxColor.fromRGB(204, 102, 0), 3, 1);
				add(counterNum);
				counterNum.cameras = [camHUD];
	
				if (ClientPrefs.downScroll)
				{
					ringCounter.y = 50;
					counterNum.y = 56;
				}
			}

		if (isPixelStage || nomehistorico.toLowerCase() == 'voltas-e-revoltas' || curSong == 'you-cant-run'){

		if(sonicHUDStyles.exists(SONG.song.toLowerCase()))hudStyle = sonicHUDStyles.get(SONG.song.toLowerCase());
		var hudFolder = hudStyle;
		if(hudStyle == 'soniccd')hudFolder = 'sonic1';
		if(curSong == 'round-a-bout')
			{
			hudStyle = 'sonic3';
			hudFolder = 'sonic3';
			}

		var scoreLabel:FlxSprite = new FlxSprite(15, 25).loadGraphic(Paths.image("sonicUI/" + hudFolder + "/score"));
		scoreLabel.setGraphicSize(Std.int(scoreLabel.width * 3));
		scoreLabel.updateHitbox();
		scoreLabel.x = 15;
		scoreLabel.antialiasing = false;
		scoreLabel.scrollFactor.set();
		sonicHUD.add(scoreLabel);

		var timeLabel:FlxSprite = new FlxSprite(15, 70).loadGraphic(Paths.image("sonicUI/" + hudFolder + "/time"));
		timeLabel.setGraphicSize(Std.int(timeLabel.width * 3));
		timeLabel.updateHitbox();
		timeLabel.x = 15;
		timeLabel.antialiasing = false;
		timeLabel.scrollFactor.set();

		sonicHUD.add(timeLabel);

		var missLabel:FlxSprite = new FlxSprite(15, 160).loadGraphic(Paths.image("sonicUI/" + hudFolder + "/misses"));
		missLabel.setGraphicSize(Std.int(missLabel.width * 3));
		missLabel.y = 115;
		missLabel.updateHitbox();
		missLabel.x = 15;
		missLabel.antialiasing = false;
		missLabel.scrollFactor.set();
		sonicHUD.add(missLabel);

		// score numbers
		if(hudFolder=='sonic3'){
			for(i in 0...7){
				var number = new SonicNumber(0, 0, 0);
				number.folder = hudFolder;
				number.setGraphicSize(Std.int(number.width*3));
				number.updateHitbox();
				number.x = scoreLabel.x + scoreLabel.width + ((9 * i) * 3);
				number.y = scoreLabel.y;
				scoreNumbers.push(number);
				sonicHUD.add(number);
			}
		}else{
			for(i in 0...7){
				var number = new SonicNumber(0, 0, 0);
				number.folder = hudFolder;
				number.setGraphicSize(Std.int(number.width*3));
				number.updateHitbox();
				number.x = scoreLabel.x + scoreLabel.width + ((9 * i) * 3);
				number.y = scoreLabel.y;
				scoreNumbers.push(number);
				sonicHUD.add(number);
			}
		}

		// miss numbers
		for(i in 0...4){
			var number = new SonicNumber(0, 0, 0);
			number.folder = hudFolder;
			number.setGraphicSize(Std.int(number.width*3));
			number.updateHitbox();
			number.x = missLabel.x + missLabel.width + (6*3) + ((9 * i) * 3);
			number.y = missLabel.y;
			missNumbers.push(number);
			sonicHUD.add(number);
		}


		// time numbers
		minNumber = new SonicNumber(0, 0, 0);
		minNumber.folder = hudFolder;
		minNumber.setGraphicSize(Std.int(minNumber.width*3));
		minNumber.updateHitbox();
		minNumber.x = timeLabel.x + timeLabel.width;
		minNumber.y = timeLabel.y;
		if(curSong != 'round-a-bout'){
		sonicHUD.add(minNumber);
		}

		// vida numbers
		for(i in 0...3){
			var number = new SonicNumber(0, 0, 0);
			number.folder = hudFolder;
			number.setGraphicSize(Std.int(number.width*3));
			number.updateHitbox();
			number.x = timeLabel.x + timeLabel.width + (6*3) + ((9 * i) * 3);
			number.y = timeLabel.y;
			vidaNumbers.push(number);
			if (curSong == 'round-a-bout'){sonicHUD.add(number);}
		}

		var percentagesimbol:FlxText;
		percentagesimbol = new FlxText(minNumber.width, 0, 0, "", 44);
		percentagesimbol.text = '%';
		percentagesimbol.setFormat(Paths.font("vcr.ttf"), 44, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		percentagesimbol.updateHitbox();
		percentagesimbol.x = minNumber.x + minNumber.width * 3;
		percentagesimbol.y = minNumber.y - 5;
		percentagesimbol.antialiasing = false;
		percentagesimbol.scrollFactor.set();
		if (curSong == 'round-a-bout'){
			sonicHUD.add(percentagesimbol);
		}


		var timeColon:FlxSprite = new FlxSprite(0, 0);
		if(curSong.toLowerCase()=='prey'){ //Silvio bulo pt2 - Isso é pra corrigir um bug em needlemouse e YCR, possivelmente CY tambem
		timeColon.loadGraphic(Paths.image("sonicUI/" + hudFolder + "/quote2"));
		}else{
			timeColon.loadGraphic(Paths.image("sonicUI/" + hudFolder + "/colon"));
		}
		timeColon.setGraphicSize(Std.int(timeColon.width * 3));
		timeColon.updateHitbox();
		timeColon.x = 170;
		timeColon.y = timeLabel.y;
		timeColon.antialiasing = false;
		timeColon.scrollFactor.set();
		if (curSong == 'prey' || curSong == 'you-cant-run'){
			sonicHUD.add(timeColon);
		}


		secondNumberA = new SonicNumber(0, 0, 0);
		secondNumberA.folder = hudFolder;
		secondNumberA.setGraphicSize(Std.int(secondNumberA.width*3));
		secondNumberA.updateHitbox();
		secondNumberA.x = 186;
		secondNumberA.y = timeLabel.y;
		if (curSong == 'prey' || curSong == 'you-cant-run'){
			sonicHUD.add(secondNumberA);
		}


		secondNumberB = new SonicNumber(0, 0, 0);
		secondNumberB.folder = hudFolder;
		secondNumberB.setGraphicSize(Std.int(secondNumberB.width*3));
		secondNumberB.updateHitbox();
		secondNumberB.x = 213;
		secondNumberB.y = timeLabel.y;
		if (curSong == 'prey' || curSong == 'you-cant-run'){
			sonicHUD.add(secondNumberB);
		}


		var timeQuote:FlxSprite = new FlxSprite(0, 0);
		if(hudFolder=='sonic1'){
			timeQuote.loadGraphic(Paths.image("sonicUI/" + hudFolder + "/quote"));
			timeQuote.setGraphicSize(Std.int(timeQuote.width * 3));
			timeQuote.updateHitbox();
			timeQuote.x = secondNumberB.x + secondNumberB.width;
			timeQuote.y = timeLabel.y;
			timeQuote.antialiasing = false;
			timeQuote.scrollFactor.set();
			sonicHUD.add(timeQuote);

			millisecondNumberA = new SonicNumber(0, 0, 0);
			millisecondNumberA.folder = hudFolder;
			millisecondNumberA.setGraphicSize(Std.int(millisecondNumberA.width*3));
			millisecondNumberA.updateHitbox();
			millisecondNumberA.x = timeQuote.x + timeQuote.width + (2*3);
			millisecondNumberA.y = timeLabel.y;
			sonicHUD.add(millisecondNumberA);

			millisecondNumberB = new SonicNumber(0, 0, 0);
			millisecondNumberB.folder = hudFolder;
			millisecondNumberB.setGraphicSize(Std.int(millisecondNumberB.width*3));
			millisecondNumberB.updateHitbox();
			millisecondNumberB.x = millisecondNumberA.x + millisecondNumberA.width + 3;
			millisecondNumberB.y = timeLabel.y;
			sonicHUD.add(millisecondNumberB);
		}

		switch(hudFolder){
			case 'sonic2':
				minNumber.x = timeLabel.x + timeLabel.width + (4*3);
				timeColon.x = minNumber.x + minNumber.width + (2*3);
				secondNumberA.x = timeColon.x + timeColon.width + (4*3);
				secondNumberB.x = secondNumberA.x + secondNumberA.width + 3;
			case 'sonic3':
				minNumber.x =  timeLabel.x + timeLabel.width + (4*3);
			default:

		}

		if(!ClientPrefs.downScroll && curSong != 'round-a-bout'){
			for(member in sonicHUD.members){
				member.y = FlxG.height-member.height-member.y;
			}
		}

		if(curSong == 'prey' || curSong == 'you-cant-run' && isPixelStage || nomehistorico.toLowerCase() == 'voltas-e-revoltas'){
			scoreTxt.visible=false;
			timeBar.visible=false;
			if (curSong == 'round-a-bout'){
			timeTxt.x = FlxG.width - timeTxt.width + 75;
			}
			if (hudFolder != 'sonic3'){
			timeTxt.visible=false;
			} else {
				healthBar.visible=false;
				healthBarBG.visible=false;
				iconP1.visible=false;
				iconP2.visible=false;
			}
			timeBarBG.visible=false;
			judgementCounter.visible = false;
			add(sonicHUD);
		}


	}

		if(curSong.toLowerCase()!='cross-console-clash'){
			strumLineNotes.cameras = [camHUD];
			grpNoteSplashes.cameras = [camHUD];
			notes.cameras = [camHUD];		
			botplayTxt.cameras = [camHUD];
		} else{
			strumLineNotes.cameras = [camHUD2];
			grpNoteSplashes.cameras = [camHUD2];
			notes.cameras = [camHUD2];		
			botplayTxt.cameras = [camHUD2];	
		}

		healthBar.cameras = [camHUD];
		blackFuck.cameras = [camHUD2];
		healthBarBG.cameras = [camHUD];
		sobrecarga.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		judgementCounter.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		topBar.cameras = [camOther];
		bottomBar.cameras = [camOther];
		startCircle.cameras = [camHUD2];
		startText.cameras = [camHUD2];
		sonicHUD.cameras = [camHUD];

		#if mobileC
			mcontrols = new Mobilecontrols();
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPadNOTES(mcontrols._virtualPad, FULL, NONE);
					if(curSong.toLowerCase('triple-trouble') || curSong.toLowerCase('chaos') || nomehistorico.toLowerCase('gran finale') || curSong.toLowerCase('prey') || curSong.toLowerCase('pasta-night')){
						controls.setVirtualPadNOTES(mcontrols._virtualPad, FULL, A);
						}
				case HITBOX:
					controls.setHitBoxNOTES(mcontrols._hitbox);
					if(curSong.toLowerCase('triple-trouble') || curSong.toLowerCase('chaos') || nomehistorico.toLowerCase('gran finale') || curSong.toLowerCase('prey') || curSong.toLowerCase('pasta-night')){
					controls.setSpecialHitBoxNOTES(mcontrols._hitbox);
					}
				default:
			}
			trackedinputsNOTES = controls.trackedinputsNOTES;
			controls.trackedinputsNOTES = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];

			mcontrols.visible = false;

			add(mcontrols);
		#end		
		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		updateTime = true;

		var luaFile:String = 'data/' + Paths.formatToSongPath(SONG.song) + '/master.lua';
	    luaFile = Paths.getPreloadPath(luaFile);
	
		if(OpenFlAssets.exists(luaFile)) 
			luaArray.push(new FunkinLua(Asset2File.getPath(luaFile)));	

		if(ClientPrefs.camZooms && !SONG.canfollowpermitido && curSong.toLowerCase()!='pasta-night')
		{
		var luaFile2 = 'custom_scripts/camFollowGlobal.lua';
		luaFile2 = Paths.getPreloadPath(luaFile2);
		if(OpenFlAssets.exists(luaFile2)) {
			luaArray.push(new FunkinLua(Asset2File.getPath(luaFile2)));	
			}
		}
		
		var daSong:String = Paths.formatToSongPath(curSong).toLowerCase();
		if (isStoryMode && !seenCutscene)
			{
				switch (daSong)
				{
					default:
						startCountdown();
				}
				seenCutscene = true;
			}else{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);

				case 'cross-console-clash':
					if (curSong.toLowerCase()=='cross-console-clash')
						{
							camHUD.alpha = 0;
							sonicHUDCCC = new SonicHUDCCC();
							add(sonicHUDCCC);
							sonicHUDCCC.cameras = [camCCC];
							botplayTxt.setFormat(Paths.font("smb1.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
							botplayTxt.cameras=[camCCC];
							add(botplayTxt);
							if(ClientPrefs.downScroll)
								{
									botplayTxt.y=90-SonicHUDCCC.ringsText.y;
								}
							else
								{
									botplayTxt.y=SonicHUDCCC.ringsText.y-75;
								}
							canRegen = false;

							opponentStrums.forEach(function(tomove:FlxSprite)
								{
									tomove.x += 160 * 0.7;
								});
							playerStrums.forEach(function(tomove:FlxSprite)
								{
									tomove.x -= 160 * 0.7;
								});

								if(storyDifficulty == 4){
									for (i in 0...playerStrums.length) {
										playerStrums.members[i].x -= 80;
									}
									for (i in 0...opponentStrums.length) {
										opponentStrums.members[i].x += 80;
									}
								}
						}
						startCountdown();

					case 'soulless':
						camGame.alpha = 0;
						camHUD.alpha = 0;
						startCountdown();
	
					case 'too-slow' | 'you-cant-run' | 'triple-trouble' | 'endless' | 'execution' | 'cycles' | 'prey' | 'faker' | 'black-sun' | 'round-a-bout':
	
					if (curSong.toLowerCase()=='triple-trouble'){
						camHUD.alpha = 0;
					}
					startCountdown();
					blackFuck.alpha = 1;
					startCircle.loadGraphic(Paths.image('StartScreen/Circle-'+ daSong));
					startCircle.x += 900;
					add(startCircle);
					startText.loadGraphic(Paths.image('StartScreen/Text-' + daSong));
					startText.x -= 1200;
					add(startText);

					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle, {x: 0}, 0.5);
						FlxTween.tween(startText, {x: 0}, 0.5);
					});

					new FlxTimer().start(1.9, function(tmr:FlxTimer)
					{
						FlxTween.tween(blackFuck, {alpha: 0}, 1);
						FlxTween.tween(startCircle, {alpha: 0}, 1, {
							onComplete: function(twn:FlxTween)
							{
								remove(startCircle);
								startCircle.destroy();
							}
						});
						FlxTween.tween(startText, {alpha: 0}, 1, {
							onComplete: function(twn:FlxTween)
							{
								remove(startText);
								startText.destroy();
							}
						});
					});
				case 'control': //Outro super omega foda e complexo code de musica.
					camHUD.alpha = 0;
					camHUD.angle = 0;
					camGame.angle = 0;
					startCountdown();

				case 'milk':
					startCountdown();
					add(blackFuck);
					startCircle.loadGraphic(Paths.image('StartScreen/Sunky'));
					startCircle.scale.x = 0;
					startCircle.x += 50;
					add(startCircle);
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						FlxTween.tween(startCircle.scale, {x: 1}, 0.2, {ease: FlxEase.elasticOut});
						FlxG.sound.play(Paths.sound('flatBONK'));
					});

					new FlxTimer().start(1.9, function(tmr:FlxTimer)
					{
						FlxTween.tween(blackFuck, {alpha: 0}, 1);
						FlxTween.tween(startCircle, {alpha: 0}, 1, {
							onComplete: function(twn:FlxTween)
							{
								remove(startCircle);
								startCircle.destroy();
							}
						});
					});

				case 'personel':
					camGame.alpha = 0;
					startCountdown();

				case 'sunshine':
					
				var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cenarios/saturn/ready'));
				var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cenarios/saturn/set'));
				var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cenarios/saturn/go'));

				ready.scale.x = 0.5; // i despise all coding.
				set.scale.x = 0.5;
				go.scale.x = 0.7;
				ready.scale.y = 0.5;
				set.scale.y = 0.5;
				go.scale.y = 0.7;
				ready.screenCenter();
				set.screenCenter();
				go.screenCenter();
				ready.cameras = [camHUD];
				set.cameras = [camHUD];
				go.cameras = [camHUD];
				var amongus:Int = 0;


				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					switch (amongus)
					{
						case 0:
							startCountdown();
							add(ready);
							FlxTween.tween(ready.scale, {x: .9, y: .9}, Conductor.crochet / 500);
							FlxG.sound.play(Paths.sound('intro1'));
						case 1:
							ready.visible = false;
							add(set);
							FlxTween.tween(set.scale, {x: .9, y: .9}, Conductor.crochet / 500);
							FlxG.sound.play(Paths.sound('intro2'));
						case 2:
							set.visible = false;
							add(go);
							FlxTween.tween(go.scale, {x: 1.1, y: 1.1}, Conductor.crochet / 500);
							FlxG.sound.play(Paths.sound('intro3'));
						case 3:
							go.visible = false;
							canPause = true;
					}
					amongus += 1;
					if (amongus < 5)
						tmr.reset(Conductor.crochet / 700);
				});
					default:
						startCountdown();
				}
	
				switch (curSong)
				{
					case 'sunshine':
					default:
						startCountdown();
				}
			}
			RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
	//	precacheList.set('missnote1', 'sound');
	//	precacheList.set('missnote2', 'sound');
	//	precacheList.set('missnote3', 'sound');

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end
		
		
		callOnLuas('onCreatePost', []);

		setOnLuas('camPosDadX', dad.getMidpoint().x + 150 + dad.cameraPosition[0]);
		setOnLuas('camPosDadY', dad.getMidpoint().y - 100 + dad.cameraPosition[1]);

		setOnLuas('camPosBFX', boyfriend.getMidpoint().x - 100 - boyfriend.cameraPosition[0]);
		setOnLuas('camPosBFY', boyfriend.getMidpoint().y - 100 + boyfriend.cameraPosition[1]);


		super.create();

		cacheCountdown();
		cachePopUpScore();
		//trace("Iniciando precache no PlayState.");

		

		//trace('executando precachelist');

		for (key => type in precacheList)
			{
				
				switch(type)
				{
					case 'image':				
						Paths.image(key);
					case 'sound':
						CoolUtil.precacheSound(key);
					case 'music':
						FlxG.sound.cache(Paths.music(key));
				}
			}
			if(veioNormal)
				{
					add(art); //Haha isso não é um NFT
					add(modboalogo);
					add(loadingbar);
					veioNormal=false;
				}
			art.loadGraphic(Paths.image(loadingImage, 'preload'));
			trace(loadingImage);

			FlxTween.tween(art, {alpha: 0}, 0.85,{ease: FlxEase.linear, startDelay: 0.05});
			FlxTween.tween(loadingbar, {x: 343}, 0.45,{ease: FlxEase.quartInOut, startDelay: 0.05});
			FlxTween.tween(modboalogo, {y: 720}, 0.65,{ease: FlxEase.quartInOut, startDelay: 0.10});
		//	trace("Precache finalizado");
	}

	private function cachePopUpScore()
		{
			var pixelShitPart1:String = '';
			var pixelShitPart2:String = '';
			if (isPixelStage)
			{
				pixelShitPart1 = 'pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			precacheList.set(pixelShitPart1 + "sick" + pixelShitPart2, 'image');
			precacheList.set(pixelShitPart1 + "good" + pixelShitPart2, 'image');
			precacheList.set(pixelShitPart1 + "bad" + pixelShitPart2, 'image');
			precacheList.set(pixelShitPart1 + "shit" + pixelShitPart2, 'image');
			//precacheList.set(pixelShitPart1 + "combo" + pixelShitPart2, 'image');
			for (i in 0...10) {
				precacheList.set(pixelShitPart1 + 'num' + i + pixelShitPart2, 'image');
			}
		}

	function cacheCountdown()
		{
			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', 'set', 'go']);
			introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);
	
			var introAlts:Array<String> = introAssets.get('default');
			if (isPixelStage) introAlts = introAssets.get('pixel');
			
			for (asset in introAlts)
				precacheList.set(asset,'image');
			
			precacheList.set('intro3' + introSoundsSuffix, 'sound');
			precacheList.set('intro2' + introSoundsSuffix, 'sound');
			precacheList.set('intro1' + introSoundsSuffix, 'sound');
			precacheList.set('introGo' + introSoundsSuffix, 'sound');
		}

	public var vidSound:FlxSound;
	public var videoFrames:Int = 0;
	public var videoSprite:FlxSprite;

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors()
		{
			if (!bfIsLeft)
				healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
					FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			else
				healthBar.createFilledBar(FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]),
					FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
			healthBar.updateBar();
		}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					newBoyfriend.alreadyLoaded = false;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					newDad.alreadyLoaded = false;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(!gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					newGf.alreadyLoaded = false;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
		{
			#if LUA_ALLOWED
			var luaFile:String = 'characters/' + name + '.lua';
			luaFile = Paths.getPreloadPath(luaFile);
	
			if(OpenFlAssets.exists(luaFile))
				luaArray.push(new FunkinLua(Asset2File.getPath(luaFile))); //Ajustes para mobile
			
			#end
		}
	
		public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
			if(modchartSprites.exists(tag)) return modchartSprites.get(tag);
			if(text && modchartTexts.exists(tag)) return modchartTexts.get(tag);
			if(variables.exists(tag)) return variables.get(tag);
			return null;
		}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(OpenFlAssets.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(OpenFlAssets.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				if(endingSong) {
					endSong();
				} else {
					startCountdown();
				}
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
		if(endingSong) {
			endSong();
		} else {
			startCountdown();
			}
		}

	var dialogueCount:Int = 0;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{	
		// TO DO: Make this more flexible, maybe?
		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			var doof:DialogueBoxPsych = new DialogueBoxPsych(dialogueFile, song);
			doof.scrollFactor.set();
			if(endingSong) {
				doof.finishThing = endSong;
			} else {
				doof.finishThing = startCountdown;
			}
			doof.nextDialogueThing = startNextDialogue;
			doof.skipDialogueThing = skipDialogue;
			doof.cameras = [camHUD];
			add(doof);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	public function focusOut() {
		if (paused)
			return;
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}
	public function focusIn() 
	{ 
		// nada 
	}

	public function backgroundVideo(source:String, xPos:Float = 0, yPos:Float = 0, tamanho:String = 'cheio', chromakey:Float = 0, layering:Float = 0)
		{
		
		if (nomehistorico.toLowerCase() == 'rastro' && curStep > 100){ //Top 10 codes mais feios dos animes
			isPixelStage = false;
			bgSkychasing.visible = true;
			removeStatics();
			generateStaticArrows(0);
			generateStaticArrows(1);
			triggerEventNote('noteskinchangeOPPT', 'NOTE_assets', '');
			triggerEventNote('noteskinchangeBF', 'NOTE_assets', 'blood');
		}
		
		if(!OpenFlAssets.exists(source)){
			if(GlobalVideo.get() != null){
				GlobalVideo.get().stop();

			FlxG.stage.window.onFocusOut.remove(focusOut);
			FlxG.stage.window.onFocusIn.remove(focusIn);
			//remove(videoSprite);
			videoSprite.visible = false;
			useVideo = false;
			}else{
				FlxG.log.add('O nome do vídeo está errado!!!');
			}
		}else{
		useVideo = true;

		var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
		//WebmPlayer.SKIP_STEP_LIMIT = 90;
		var str1:String = "WEBM SHIT";
		webmHandler = new WebmHandler();
		webmHandler.source(ourSource);
		webmHandler.makePlayer();
		webmHandler.webm.name = str1;

		GlobalVideo.setWebm(webmHandler);

		GlobalVideo.get().source(source);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();

		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		}
		else
		{
			GlobalVideo.get().play();
		}

		var data = webmHandler.webm.bitmapData;

		videoSprite = new FlxSprite().loadGraphic(data);

		videoSprite.visible = true;
		videoSprite.alpha = 1;
		if (chromakey == 1){
			videoSprite.shader = new GreenScreenShader();
		}

		if (tamanho != "cheio"){
			videoSprite.scale.x = Std.parseFloat(tamanho);
			videoSprite.scale.y = Std.parseFloat(tamanho);
		} else {
			videoSprite.setGraphicSize(FlxG.width, FlxG.height); //Revisar isso amanhã tambem
		}

		trace('poggers');

		if(layering == 1) { //Layering = 1 significa que o video ficará abaixo dos bonecos mas acima do cenário
			videoSprite.cameras = [camGame];
			videoSprite.x = xPos + 0.001;
			videoSprite.y = yPos + 0.001;
			remove(gf);
			remove(boyfriend);
			remove(dad);
			add(videoSprite);
			add(gf);
			add(boyfriend);
			add(dad);
		} else { //Significa que o vídeo ficará acima de literalmente tudo.
			videoSprite.cameras = [camHUD2];
			videoSprite.x = xPos + 0.001;
			videoSprite.y = yPos + 0.001;
			add(videoSprite);
		}

		if (!songStarted)
			webmHandler.pause();
		else
			webmHandler.resume();
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countDownSprites:Array<FlxSprite> = [];

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		#if mobileC
		mcontrols.visible = true;
		#end

		

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			generateStaticArrows(0);
			generateStaticArrows(1);
			if(nomehistorico.toLowerCase() == 'noite da rapaziada'){
				generateStaticArrows(2);
			}
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}
			for (i in 0...thirdplayerStrums.length) {
				setOnLuas('defaultthirplayerStrumX' + i, thirdplayerStrums.members[i].x);
				setOnLuas('defaultthirdplayerStrumY' + i, thirdplayerStrums.members[i].y);
				if(ClientPrefs.middleScroll) thirdplayerStrums.members[i].visible = false; //Ainda pensando sobre isso...
			}

			if(curSong == 'prey' || curSong == 'you-cant-run'){
				if(isPixelStage){
				healthBar.x += 150;
				scoreTxt.x += 150;
				iconP1.x += 150;
				iconP2.x += 150;
				healthBarBG.x += 150;
				}
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			if(nomehistorico.toLowerCase() == 'controle'){
				setOnLuas('gifPermitido', ControlSongSubstate.gifPermitido);
			}


			var swagCounter:Int = 0;

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (tmr.loopsLeft % gfSpeed == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing"))
				{
					gf.dance();
				}
				if(tmr.loopsLeft % 2 == 0) {
					if (boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing'))
					{
						boyfriend.dance();
					}
					if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
					{
						dad.dance();
					}
				}
				else if(dad.danceIdle && dad.animation.curAnim != null && !dad.stunned && !dad.curCharacter.startsWith('gf') && !dad.animation.curAnim.name.startsWith("sing"))
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);
				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);
	
					bottomBoppers.dance(true);
					santa.dance(true);
				}
				if(curSong.toLowerCase()=='prey'){
					furnaceTheEnd.dance(true);
				}
				if (curSong.toLowerCase() != 'sunshine'){

				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						var ready:FlxSprite; 
						if(Assets.exists(Paths.imagechecker(introAlts[0]))){
						ready = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						} else {
							ready = new FlxSprite().loadGraphic(Paths.image(introAlts[0], 'preload'));
						}
						ready.scrollFactor.set();
						ready.updateHitbox();

						if (PlayState.isPixelStage)
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

						ready.screenCenter();
						ready.antialiasing = antialias;
						add(ready);
						countDownSprites.push(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(ready);
								remove(ready);
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						var set:FlxSprite;
						if(Assets.exists(Paths.imagechecker(introAlts[1]))){
							set = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
							} else {
								set = new FlxSprite().loadGraphic(Paths.image(introAlts[1], 'preload'));
							}
						set.scrollFactor.set();

						if (PlayState.isPixelStage)
							set.setGraphicSize(Std.int(set.width * daPixelZoom));

						set.screenCenter();
						set.antialiasing = antialias;
						add(set);
						countDownSprites.push(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(set);
								remove(set);
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						var go:FlxSprite; //bruh + meme = breme

						if(Assets.exists(Paths.imagechecker(introAlts[1]))){
							go = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
							} else {
								go = new FlxSprite().loadGraphic(Paths.image(introAlts[2], 'preload'));
							} //Matando chasing, sunshine, green-hills e mais qualquer outra música numa tacada só.
						go.scrollFactor.set();

						if (PlayState.isPixelStage)
							go.setGraphicSize(Std.int(go.width * daPixelZoom));

						go.updateHitbox();

						go.screenCenter();
						go.antialiasing = antialias;
						add(go);
						countDownSprites.push(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								countDownSprites.remove(go);
								remove(go);
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
					case 4:
				}
			} //solução preguiçosa, fodasi

				notes.forEachAlive(function(note:Note) {
					note.copyAlpha = false;
					note.alpha = 1 * note.multAlpha;
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				if (generatedMusic)
				{
					notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
				}

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;

		if (useVideo)
			GlobalVideo.get().resume();

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = finishSong;
		vocals.play();

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		
		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		
		curSong = songData.song;

		if (SONG.needsVoices) {
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		} else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;


		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		if(curSong.toLowerCase()=='cross-console-clash'){
			file = Paths.json(songName + '/events' + CoolUtil.difficultyStuff[storyDifficulty][1]);
		}
		if (OpenFlAssets.exists(file)) {
			var eventsData:Array<SwagSection>;
			if(curSong.toLowerCase()=='cross-console-clash'){
				eventsData = Song.loadFromJson('events' + CoolUtil.difficultyStuff[storyDifficulty][1], songName).notes;
			} else{
				eventsData = Song.loadFromJson('events', songName).notes;
			}
			for (section in eventsData)
			{
				for (songNotes in section.sectionNotes)
				{
					if(songNotes[1] < 0) {
						eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4], songNotes[5]]);
						eventPushed(songNotes);
					}
				}
			}
		}

		var fileletras:String = Paths.json(songName + '/letras');
		if (OpenFlAssets.exists(fileletras)) {
			var eventsDataletras:Array<SwagSection>;
				eventsDataletras = Song.loadFromJson('letras', songName).notes;
			for (section in eventsDataletras)
			{
				for (songNotes in section.sectionNotes)
				{
					if(songNotes[1] < 0) {
						eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4], songNotes[5]]);
						eventPushed(songNotes);
					}
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				if(songNotes[1] > -1) { //Real notes
					var daStrumTime:Float = songNotes[0];
					var lol = 4;

					if (isRing)
						lol = 5;
					var daNoteData:Int = Std.int(songNotes[1] % lol);

					var gottaHitNote:Bool = section.mustHitSection;

					var lol2 = 3;

					if (isRing)
						lol2 = 4;
					if (songNotes[1] > lol2)
					{
						gottaHitNote = !section.mustHitSection;
					}

					if (songNotes[1] > lol2)
						{
							gottaHitNote = !section.mustHitSection;
						}
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.mustPress = gottaHitNote;
					swagNote.sustainLength = songNotes[2];
					swagNote.noteType = songNotes[3];
					if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
					
					
					if (section.gfSection){
						//	trace("got gf section");
						if (songNotes[3] == null || songNotes[3] == ''|| songNotes[3].length ==0){
							swagNote.noteType = 'GF Sing';
						//	trace("got gf notes");
						}
					}
					
					swagNote.scrollFactor.set();

					var susLength:Float = swagNote.sustainLength;

					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);

					var floorSus:Int = Math.floor(susLength);
					if(floorSus > 0) {
						for (susNote in 0...floorSus+1)
						{
							oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

							var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(SONG.speed, 2)), daNoteData, oldNote, true);
							sustainNote.mustPress = gottaHitNote;
							sustainNote.noteType = swagNote.noteType;
							sustainNote.scrollFactor.set();
							unspawnNotes.push(sustainNote);

							if (sustainNote.mustPress)
							{
								sustainNote.x += FlxG.width / 2; // general offset
							}
						}
					}

					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else {}

					if(!noteTypeMap.exists(swagNote.noteType)) {
						noteTypeMap.set(swagNote.noteType, true);
					}
				} else { //Event Notes
					eventNotes.push([songNotes[0], songNotes[1], songNotes[2], songNotes[3], songNotes[4], songNotes[5]]);
					eventPushed(songNotes);
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:Array<Dynamic>) {
		switch(event[2]) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event[3].toLowerCase()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(event[3]);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event[4];
				addCharacterToList(newCharacter, charType);

			case 'Adicionar Imagens':
				if(ClientPrefs.legendas){
					//trace('executando cache de lyrics');
				if(OpenFlAssets.exists(Paths.imagechecker(event[3]))){
					precacheList.set(event[3], 'image');
				}
				if(OpenFlAssets.exists(Paths.imagechecker(event[4]))){
					precacheList.set(event[4], 'image');
				}
				if(OpenFlAssets.exists(Paths.imagechecker(event[5]))){
					precacheList.set(event[5], 'image');
				}
				}
		}

		if(!eventPushedMap.exists(event[2])) {
			eventPushedMap.set(event[2], true);
		}
	}

	function eventNoteEarlyTrigger(event:Array<Dynamic>):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event[2]]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event[2]) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		var earlyTime1:Float = eventNoteEarlyTrigger(Obj1);
		var earlyTime2:Float = eventNoteEarlyTrigger(Obj2);
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0] - earlyTime1, Obj2[0] - earlyTime2);
	}

	private function generateStaticArrows(player:Int):Void
		{
			var keyCount:Int = 4;
			if (isRing){
				keyCount = 5;
			}
			for (i in 0...keyCount)
			{
				var skin:String = "NOTE_assets";
				if (isRing){
					skin = 'RING_assets';
				}

				if(storyDifficulty == 3){
				if(curSong.toLowerCase()=='cross-console-clash' && player == 0){skin='arrows-mario';}

				if(curSong.toLowerCase()=='cross-console-clash' && player == 1){skin='arrows-sonic';}
				}
				else if(storyDifficulty == 4){
					if(curSong.toLowerCase()=='cross-console-clash' && player == 1){skin='arrows-mario';}
	
					if(curSong.toLowerCase()=='cross-console-clash' && player == 0){skin='arrows-sonic';}
				}

				//Endless
				if(curSong.toLowerCase()=='endless' && curStep >= 500){skin='Majin_Notes';}

				//FIQUEI FUCKING 2 HORAS TENTANDO CONSERTAR ISSO...
				//O problema? eu tinha trocado o nome da textura da strum depois de ela ter carregado a textura padrão...
				//Sílvio == bulo...

				//Chasing
				if(curSong.toLowerCase()=='chasing' && curStep <= 25){skin='arrows-sonic';}
				if(curSong.toLowerCase()=='chasing' && curStep >= 25){skin='NOTE_assets';}

				//Prey
				if(curSong.toLowerCase()=='prey' && player == 0 && (curStep <= 500 || (curStep <= 1100 && curStep >= 1000))){skin='NOTE-FURNACEBLU_assets';}
				else if(curSong.toLowerCase()=='prey' && curStep >= 500 && curStep <= 1400 && player == 0){skin='NOTE-FURNACE_assets';}
				else if (curSong.toLowerCase()=='prey' && curStep >= 1500 && player == 0){skin='NOTE-STARVI_assets';}
				
				if (curSong.toLowerCase()=='prey' && curStep >= 3000 && player == 1){skin='NOTE-supa_assets';} //Pessoa olhando de fora: Wow, ele realmente pensou numa forma de carregar as strums ao mesmo tempo


				if (curSong.toLowerCase()=='prey' && curStep >= 4480){skin='NOTE_assets';} //Estou fazendo isso na pura preguiça, espero que dê certo
				//Como eu queria que fossem as setas vermelhas...

				//Realidade: Sem querer querendo o code pra troca de strum saiu sozinho...

				var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player, skin);
				babyArrow.downScroll = ClientPrefs.downScroll;
				if (!isStoryMode)
				{
					babyArrow.y -= 10;
					babyArrow.alpha = 0;
					if (curSong == 'you-cant-run' || curSong.toLowerCase()=='prey' || curSong.toLowerCase()=='endless') //Casos especiais são tão legais...
					{
						babyArrow.alpha = 1;
						babyArrow.y = babyArrow.y + 10;
				} else if(!SONG.startinvisibru || player == 1){
						FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
					}else{
						FlxTween.tween(babyArrow, {y: babyArrow.y + 10}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

					}
				}
	
				if (player == 1)
				{
					playerStrums.add(babyArrow);
				}
				else if (player == 0)
				{
					opponentStrums.add(babyArrow);
				} else if (player == 2 && curSong.toLowerCase() == 'pasta-night'){
					thirdplayerStrums.add(babyArrow);
				}
	
				strumLineNotes.add(babyArrow);
				babyArrow.postAddedToGroup();
			}
			//Fixes para players de middlescroll em musicas que as strums mudam e/ou tem três setas.
		}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = false;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (i in 0...chars.length) {
				if(chars[i].colorTween != null) {
					chars[i].colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
					
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = true;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = true;
			
			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (i in 0...chars.length) {
				if(chars[i].colorTween != null) {
					chars[i].colorTween.active = true;
				}
			}
			
			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	public var canPause:Bool = true;
	var limoSpeed:Float = 0;

	public static var useVideo = false;

	public static var removedVideo = false;

	var starvedSpeed:Float = 15;

	override public function update(elapsed:Float)
	{
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/

			floaty += 0.03;


		if (useVideo && GlobalVideo.get() != null)
			{
				if (GlobalVideo.get().ended && !removedVideo)
				{
					videoSprite.visible = false;
				//	remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
					useVideo = false;
				}
			}

		switch (flyState)
		{
			case 'hover' | 'hovering':
				flyTarg.y += Math.sin(floaty) * 1.5;
			case 'fly' | 'flying':
				flyTarg.y += Math.sin(floaty) * 1.5;
				flyTarg.x += Math.cos(floaty) * 1.5;
			case 'sHover' | 'sHovering':
				flyTarg.y += Math.sin(floaty2) * 0.5;
		}
		callOnLuas('onUpdate', [elapsed]);

		var targetHP:Float = health;

		if (bfIsLeft)
			targetHP = 2 - health;

		healthbarval = targetHP;

		if (isRing){
			counterNum.text = Std.string(cNum);
		}
		floaty2 += 0.01;
		var targetSpeed:Float = 15;

		if(desvioPrey && controls.NOTE_SPACE_P){
			desvioPrey = false;
			desviou = true;
			warning.visible = false;
		}
		switch (hungryManJackTime) //A velocidade do cenário e da chart é governada por essa parte aqui
		//Caso queira, você pode adicionar mais variações de targetSpeed que essas mudanças serão aplicadas a todos os outros elementos.
		{
			case 1:
				targetSpeed = 40; //Usada na parte da entrada do starved
			case 2:
				targetSpeed = 50; //Usada na hora do super sonico
			default:
				targetSpeed = 25; //Padrão usada no começo da música
		}
		starvedSpeed = FlxMath.lerp(starvedSpeed, targetSpeed, 0.3*(elapsed/(1/60)));
		if (targetSpeed - starvedSpeed < 0.2)
			{
				starvedSpeed = targetSpeed;
			}
		if (curStage == 'starved-pixel')
		{
			stardustBgPixel.scrollX -= (starvedSpeed * stardustBgPixel.scrollFactor.x) * (elapsed/(1/120));
			stardustFloorPixel.scrollX -= starvedSpeed * (elapsed/(1/120));
		}

		switch (curStage)
		{
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 130) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		if (nomehistorico.toLowerCase() == 'voltas-e-revoltas'){
			
			var leDate = Date.now();

			tempogravador.text = (leDate.getHours() <= 12 ? leDate.getHours() : leDate.getHours() - 12) + ":" + (leDate.getMinutes() < 10 ? "0" + Std.string(leDate.getMinutes()) : Std.string(leDate.getMinutes())) + ':' +
			(leDate.getSeconds() < 10 ? "0" + Std.string(leDate.getSeconds()) : Std.string(leDate.getSeconds())) + '\n' + (leDate.getHours() <= 12 ? "AM" : "PM") + "\n"
			+ Std.string(leDate.getDate()) + " " + meses[leDate.getMonth()];
		if(leDate.getHours() == 3 && ClientPrefs.shaders && !Achievements.isAchievementUnlocked('madrugada') && songStarted){
			startachieving('madrugada');
		}
		}
		//Maluco... Quando eu olho pra isso aqui de novo fico tipo:
			//Essa foi realmente uma das primeiras coisas que fiz no modboa? k
			//Fun fact: Sim foi realmente a primeira coisa que fiz no modboa no dia 29/10/2022
			//Data de reflexão sobre o assunto 07/02/2023 dia que os achievements foram programados

		if (SONG.song.toLowerCase() == 'personel' && IsNoteSpinning)
			{
				var thisX:Float = Math.sin(SpinAmount * (SpinAmount / 2)) * 100;
				var thisY:Float = Math.sin(SpinAmount * (SpinAmount)) * 100;
				for (str in playerStrums)
				{
					str.angle = str.angle + SpinAmount; //Porque eu quero e posso...
					SpinAmount = SpinAmount + 0.005;
				}
				for (str in opponentStrums)
				{
					str.angle = str.angle + SpinAmount;
					SpinAmount = SpinAmount + 0.005;
				}
			}
			if (SONG.song.toLowerCase() == 'personel' && isPlayersSpinning)
			{
				dad.angle = dad.angle + SpinAmount;
				SpinAmount = SpinAmount + 0.00003;
				boyfriend.angle = boyfriend.angle + SpinAmount;
				SpinAmount = SpinAmount + 0.00003;
			}

		if(ratingString == '?') {
			scoreTxt.text = 'Pontos: ' + songScore + ' | Precisão: ' + ratingString;
			judgementCounter.text = 'Sicks: 0 \nGoods: 0\nBads: 0\nShits: 0\nErros: 0' + '\n' + ''; //Isso me incomoda muito nos prints que voces mandam...
		} else {
			judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nErros: ${songMisses}' + '\n' + '';
			scoreTxt.text = 'Pontos: ' + songScore + ' | Precisão: ' + ratingString + ' (' + Math.floor(ratingPercent * 100) + '%)';
		}

		if(cpuControlled) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}
		botplayTxt.visible = cpuControlled;

		if (FlxG.keys.justPressed.ENTER #if android || FlxG.android.justReleased.BACK #end && startedCountdown && canPause)
			{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

					// no more gitaroo man easter egg :D
					if(FlxG.sound.music != null) {
						FlxG.sound.music.pause();
						vocals.pause();
					}
					PauseSubState.transCamera = camOther;
					pauseSound.play();
					openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
				#if desktop
				DiscordClient.changePresence(detailsPausedText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
			}
		}


		if (FlxG.keys.justPressed.SEVEN && !endingSong && !inCutscene)
		{
			majinstrums = false;
			canRegen = true;
			canuseevents = true;
			desesperada = false;
			persistentUpdate = false;
			paused = true;
			cancelFadeTween();
			CustomFadeTransition.nextCamera = camOther;
			MusicBeatState.switchState(new ChartingState());


			if (useVideo)
				{
					GlobalVideo.get().stop();
					videoSprite.visible = false;
				//	remove(videoSprite);
					#if sys
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					#end
					removedVideo = true;
				}

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		if (dad.curCharacter == "tailsdoll-cartoon") // Do you really wanna see sonic.exe fly? Me neither.
			{
				if (tailscircle == 'hovering' || tailscircle == 'circling')
					dad.y += Math.sin(floaty) * 1.3;
				if (tailscircle == 'circling')
					dad.x += Math.cos(floaty) * 1.3; // math B)
			}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else if(healthBar.percent < 80)
			iconP2.animation.curAnim.curFrame = 0;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					if (!majinstrums){
						songPercent = (curTime / songLength);
					}

					if (!majinstrums){
						secondsTotal = Math.floor((songLength - curTime) / 1000);
					}

					if(secondsTotal < 0){ secondsTotal = 0;}

					if(!majinstrums){
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
					}
					
					if (isPixelStage || curSong == 'round-a-bout' || curSong == 'you-cant-run'){
					var minutesRemaining:Int = Math.floor(secondsTotal / 60);
					var secondsRemaining:String = '' + secondsTotal % 60;

					if (secondsRemaining.length < 2)
						secondsRemaining = '0' + secondsRemaining; // Dunno how to make it display a zero first in Haxe lol

					timeTxt.text = minutesRemaining + ':' + secondsRemaining;

					var curMS:Float = Math.floor(curTime);
					var curSex:Int = Math.floor(curMS / 1000);
					if (curSex < 0)
						curSex = 0;

		    	var curMins = Math.floor(curSex / 60);
					curMS%=1000;
		    	curSex%=60;

				if (curSong == 'prey' || curSong == 'you-cant-run'){
					minNumber.number = curMins;
				}
				var sepSex = Std.string(curSex).split("");
					if(curSex<10){
						secondNumberA.number = 0;
						secondNumberB.number = curSex;
					}else{
						secondNumberA.number = Std.parseInt(sepSex[0]);
						secondNumberB.number = Std.parseInt(sepSex[1]);
					}
					if(millisecondNumberA!=null && millisecondNumberB!=null){
						curMS = Math.round(curMS/10);
						if(curMS<10){
							millisecondNumberA.number = 0;
							millisecondNumberB.number = Math.floor(curMS);
						}else{
							var sepMSex = Std.string(curMS).split("");
							millisecondNumberA.number = Std.parseInt(sepMSex[0]);
							millisecondNumberB.number = Std.parseInt(sepMSex[1]);
						}
					}
				}
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (sonicHUDStyles.exists(SONG.song.toLowerCase())){
			updateSonicScore();
			updateSonicMisses();
			updateSonicVida();
		}

		// RESET = Quick Game Over Screen
		if (controls.RESET && !inCutscene && !endingSong)
		{
			resetforcado = true;
			majinstrums = false;
			canRegen = true;
			canuseevents = true;
			desesperada = false;
			health = 0;
			//trace("RESET = True");
		}
		if(cccVidaCounter < 0){
			health = 0;
		}
		doDeathCheck();

		var roundedSpeed:Float = FlxMath.roundDecimal(SONG.speed, 2);
		if (unspawnNotes[0] != null)
		{
			var time:Float = 1500;
			if(roundedSpeed < 1) time /= roundedSpeed;
			if(unspawnNotes[0].multSpeed < 1) time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if(!cpuControlled) {
				keyShit();
			} else if(boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}

			if(startedCountdown)
			{

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if(!daNote.mustPress && daNote.noteType != 'player3') 
					strumGroup = opponentStrums;
				
				if (daNote.noteType == 'player3' && !daNote.mustPress)
					strumGroup = thirdplayerStrums;

				
				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) //Downscroll
				{
					//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * SONG.speed);
					daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * SONG.speed * daNote.multSpeed);
				}
				else //Upscroll
				{
					//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * SONG.speed);
					daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * SONG.speed * daNote.multSpeed);
				}

				var angleDir = strumDirection * Math.PI / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if(daNote.copyAlpha)
					daNote.alpha = strumAlpha;

				if(daNote.copyX)
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

				if(daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;


					if (daNote.animation.curAnim.name.endsWith('end')&&scrollModifierChecker !=strumScroll) {
						daNote.flipY = strumScroll;
					}

					if (daNote.animation.curAnim.name.endsWith('end')&& !PlayState.isPixelStage && stageData.isPixelStage)
					{
						daNote.scale.y = 1;
						daNote.y -= 400;
					}
					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if(strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * SONG.speed + (46 * (SONG.speed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * SONG.speed;
							if(isPixelStage) {
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							} else {
								daNote.y -= 19;
							}
						}
						daNote.y += (Note.swagWidth / 2) - (60.5 * (SONG.speed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (SONG.speed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
					{
						opponentNoteHit(daNote);
					}

					if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
						if(daNote.isSustainNote) {
							if(daNote.canBeHit) {
								goodNoteHit(daNote);
							}
						} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
							goodNoteHit(daNote);
						}
					}

					var center:Float = strumY + Note.swagWidth / 2;
					if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
						(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						if (strumScroll)
						{
							if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
						else
						{
							if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}

					// Kill extremely late notes and cause misses
					if (Conductor.songPosition > noteKillOffset + daNote.strumTime-200) //Um pouco mais preciso
					{
						if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
							noteMiss(daNote);
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}else{
					notes.forEachAlive(function(daNote:Note)
					{
						daNote.canBeHit = false;
						daNote.wasGoodHit = false;
					});
				}
		}
		checkEventNote();

		if (!inCutscene) {
			if(!cpuControlled) {
				keyShit();
			} else if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
				boyfriend.dance();
			}
		}
		
		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				FlxG.sound.music.pause();
				vocals.pause();
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if(daNote.strumTime + 800 < Conductor.songPosition) {
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length) {
					var daNote:Note = unspawnNotes[0];
					if(daNote.strumTime + 800 >= Conductor.songPosition) {
						break;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
					daNote.destroy();
				}

				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();

				vocals.time = Conductor.songPosition;
				vocals.play();
			}
		} //talvez isso seja útil...
		#end
		
		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', PlayState.cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck() {
		if (health <= 0 && !practiceMode && !isDead)
		{
			// ja entendi como funciona bruh
			if(curSong.toLowerCase()=='chaos' && cpuControlled)
				{
					startachieving("chaos_bot");
				}
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));
				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, nomehistorico + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var early:Float = eventNoteEarlyTrigger(eventNotes[0]);
			var leStrumTime:Float = eventNotes[0][0];
			if(Conductor.songPosition < leStrumTime - early) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0][3] != null)
				value1 = eventNotes[0][3];

			var value2:String = '';
			if(eventNotes[0][4] != null)
				value2 = eventNotes[0][4];

			var value3:String = '';
			if(eventNotes[0][5] != null)
				value3 = eventNotes[0][5];

			var value4:String = '';
			if(eventNotes[0][6] != null)
				value4 = eventNotes[0][6];

			if (canuseevents){
			triggerEventNote(eventNotes[0][2], value1, value2, value3, value4);
			}
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String, ?value3:String, ?value4:String) {
		switch(eventName) {
			/*case 'Adicionar Imagem':
				if (!ClientPrefs.Legendas)
				{
					
				}
				else
				{

				}
				*/
			case 'Socorro':
				lime.app.Application.current.window.title=value1;
			case 'Toggle Ghost Trail':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.5, 0.5); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
			case 'Character Fly':
				flyState = '';
				FlxTween.tween(dad, {x: DAD_X, y: DAD_Y}, 0.2, {
					onComplete: function(lol:FlxTween)
					{
						dad.setPosition(DAD_X, DAD_Y);
						flyState = value1;
					}
				});
			case 'strum swap2': //	OMAGA 2???????? DOS MESMOS CRIADORES DO WHATSAPP 2??? OOOOOOOOOOOMAGAAAAAWD (Silvio momentos antes de coringar colocando eventos na Triple-Trouble)
				if(value2 != 'true'){ //Só pra corrigir um bugzinho na Prey
				if (!ClientPrefs.middleScroll && value1 != 'true'){
				playerStrums.forEach(function(spr:FlxSprite)
				{
					spr.x += 645;
					
				});
				opponentStrums.forEach(function(spr:FlxSprite)
				{
					spr.x -= 645;
				});
			} else if (!ClientPrefs.middleScroll){ //Essa parte é exclusiva da Prey, a de cima é usada na triple-trouble
				FlxTween.tween(strumLineNotes.members[0], {x: 645 + (strumLineNotes.members[0].x)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[1], {x: 645 + (strumLineNotes.members[1].x)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[2], {x: 645 + (strumLineNotes.members[2].x)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[3], {x: 645 + (strumLineNotes.members[3].x)}, 1, {ease: FlxEase.quadInOut});

				FlxTween.tween(strumLineNotes.members[4], {x: (strumLineNotes.members[4].x) - 645}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[5], {x: (strumLineNotes.members[5].x) - 645}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[6], {x: (strumLineNotes.members[6].x) - 645}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[7], {x: (strumLineNotes.members[7].x) - 645}, 1, {ease: FlxEase.quadInOut});
			}
			}
			bfIsLeft = false;

			iconP2.changeIcon(dad.healthIcon);
			iconP1.changeIcon(boyfriend.healthIcon);
			reloadHealthBarColors();
				case 'strum swap1':
					if (!ClientPrefs.middleScroll && value1 != 'true'){
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x -= 645;
					});
					opponentStrums.forEach(function(spr:FlxSprite)
					{
						spr.x += 645;
					});
				} else if (!ClientPrefs.middleScroll){ //Essa parte é exclusiva da Prey, a de cima é usada na triple-trouble
					FlxTween.tween(strumLineNotes.members[0], {x: 645 + (strumLineNotes.members[0].x)}, 1, {ease: FlxEase.quadInOut});
					FlxTween.tween(strumLineNotes.members[1], {x: 645 + (strumLineNotes.members[1].x)}, 1, {ease: FlxEase.quadInOut});
					FlxTween.tween(strumLineNotes.members[2], {x: 645 + (strumLineNotes.members[2].x)}, 1, {ease: FlxEase.quadInOut});
					FlxTween.tween(strumLineNotes.members[3], {x: 645 + (strumLineNotes.members[3].x)}, 1, {ease: FlxEase.quadInOut});
	
					FlxTween.tween(strumLineNotes.members[4], {x: (strumLineNotes.members[4].x) - 645}, 1, {ease: FlxEase.quadInOut});
					FlxTween.tween(strumLineNotes.members[5], {x: (strumLineNotes.members[5].x) - 645}, 1, {ease: FlxEase.quadInOut});
					FlxTween.tween(strumLineNotes.members[6], {x: (strumLineNotes.members[6].x) - 645}, 1, {ease: FlxEase.quadInOut});
					FlxTween.tween(strumLineNotes.members[7], {x: (strumLineNotes.members[7].x) - 645}, 1, {ease: FlxEase.quadInOut});
				} //Eu estou do seu lado middlescrollzero / nexxy / Naffy rlx
				bfIsLeft = true;
				iconP1.changeIcon(dad.healthIcon);
				iconP2.changeIcon(boyfriend.healthIcon);
					reloadHealthBarColors();
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value)) value = 1;
				gfSpeed = value;

			case 'Blammed Lights':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				if(lightId > 0 && curLightEvent != lightId) {
					if(lightId > 5) lightId = FlxG.random.int(1, 5, [curLightEvent]);

					var color:Int = 0xffffffff;
					switch(lightId) {
						case 1: //Blue
							color = 0xff31a2fd;
						case 2: //Green
							color = 0xff31fd8c;
						case 3: //Pink
							color = 0xfff794f7;
						case 4: //Red
							color = 0xfff96d63;
						case 5: //Orange
							color = 0xfffba633;
					}
					curLightEvent = lightId;

					if(blammedLightsBlack.alpha == 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 1}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});

						var chars:Array<Character> = [boyfriend, gf, dad];
						for (i in 0...chars.length) {
							if(chars[i].colorTween != null) {
								chars[i].colorTween.cancel();
							}
							chars[i].colorTween = FlxTween.color(chars[i], 1, FlxColor.WHITE, color, {onComplete: function(twn:FlxTween) {
								chars[i].colorTween = null;
							}, ease: FlxEase.quadInOut});
						}
					} else {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = null;
						blammedLightsBlack.alpha = 1;

						var chars:Array<Character> = [boyfriend, gf, dad];
						for (i in 0...chars.length) {
							if(chars[i].colorTween != null) {
								chars[i].colorTween.cancel();
							}
							chars[i].colorTween = null;
						}
						dad.color = color;
						boyfriend.color = color;
						gf.color = color;
					}
					
					if(curStage == 'philly') {
						if(phillyCityLightsEvent != null) {
							phillyCityLightsEvent.forEach(function(spr:BGSprite) {
								spr.visible = false;
							});
							phillyCityLightsEvent.members[lightId - 1].visible = true;
							phillyCityLightsEvent.members[lightId - 1].alpha = 1;
						}
					}
				} else {
					if(blammedLightsBlack.alpha != 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 0}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});
					}

					if(curStage == 'philly') {
						phillyCityLights.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});
						phillyCityLightsEvent.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});

						var memb:FlxSprite = phillyCityLightsEvent.members[curLightEvent - 1];
						if(memb != null) {
							memb.visible = true;
							memb.alpha = 1;
							if(phillyCityLightsEventTween != null)
								phillyCityLightsEventTween.cancel();

							phillyCityLightsEventTween = FlxTween.tween(memb, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) {
								phillyCityLightsEventTween = null;
							}, ease: FlxEase.quadInOut});
						}
					}

					var chars:Array<Character> = [boyfriend, gf, dad];
					for (i in 0...chars.length) {
						if(chars[i].colorTween != null) {
							chars[i].colorTween.cancel();
						}
						chars[i].colorTween = FlxTween.color(chars[i], 1, chars[i].color, FlxColor.WHITE, {onComplete: function(twn:FlxTween) {
							chars[i].colorTween = null;
						}, ease: FlxEase.quadInOut});
					}

					curLight = 0;
					curLightEvent = 0;
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Spin':
				spirospreidi();

			case 'estatica brow':
				doStaticSign(1, false);

			case 'StaticMiss':
				staticHitMiss();

			case '"--------------': //vignetteEspecial
			var duracao:Float = Std.parseFloat(value2);
			if (value1 == 'true'){
				vignetteEspecial.alpha = 0.7;
			} else{
				FlxTween.tween(vignetteEspecial, {alpha: 0.3}, duracao);
			}

			case 'events':
				FlxTween.tween(blackFuck, {alpha: 1}, 1.5);	
				FlxTween.num(defaultCamZoom, 10, 1, {ease: FlxEase.cubeOut}, function (v:Float) {
					defaultCamZoom = v;
				}); //rápido e prático : D

			case 'lifetween':	
				FlxTween.num(healthbarval, Std.parseFloat(value1), 0.5, {ease: FlxEase.cubeOut}, function (v:Float) {
					healthbarval = v;
				});

			case 'invocar 3rdstrum':
				if(!ClientPrefs.middleScroll){
				var microArray:Array<String> = value1.split(',');
				var charType:Int = 0;
				var ordem:Array<Int> = [];
				for (i in 0...microArray.length){ //Basicamente aqui vai ser setado a ordem das notas, 
					//tipo, se o primeiro grupo de strums é o dad, o segundo é o player e talz...
				switch(microArray[i].toLowerCase()) {
					case 'gf' | 'girlfriend':
						charType = 8;
					case 'dad' | 'opponent':
						charType = 0;
					case 'bf' | 'boyfriend':
						charType = 4;
					default:
						charType = 4;
				}
				ordem.push(charType);
				}
				trace(ordem);

				//Note for future self:
				/*
				De 0 a 3 são as notas do dad, de 4 a 7 são as notas do BF, e de 8 a 11, são as notas do outro mano.
				sempre que precisar invocar 3 linhas de notas, utilize este evento, mas lembre-se de ativar no json da musica o thirdstrum = true
				caso contrario esse evento provavelmente irá crashar o jooj.
				SE ME CHAMAR DE MANIACO DOS TWEENS... :KNIFE:
				-- Sílvio
				*/
				FlxTween.tween(strumLineNotes.members[ordem[0]], {x: 15}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[0]+1], {x: 15 + (strumLineNotes.members[1].width * 1)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[0]+2], {x: 15 + (strumLineNotes.members[1].width * 2)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[0]+3], {x: 15 + (strumLineNotes.members[1].width * 3)}, 1, {ease: FlxEase.quadInOut});

				FlxTween.tween(strumLineNotes.members[ordem[1]], {x: ((FlxG.width / 2)) - (strumLineNotes.members[1].width * 2)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[1]+1], {x: ((FlxG.width / 2)) - (strumLineNotes.members[1].width * 1)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[1]+2], {x: ((FlxG.width / 2)) + (strumLineNotes.members[1].width * 0)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[1]+3], {x: ((FlxG.width / 2)) + (strumLineNotes.members[1].width * 1)}, 1, {ease: FlxEase.quadInOut});

				FlxTween.tween(strumLineNotes.members[ordem[2]], {x: ((FlxG.width - 15)) - (strumLineNotes.members[1].width * 4)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[2]+1], {x: ((FlxG.width - 15)) - (strumLineNotes.members[1].width * 3)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[2]+2], {x: ((FlxG.width - 15)) - (strumLineNotes.members[1].width * 2)}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(strumLineNotes.members[ordem[2]+3], {x: ((FlxG.width - 15)) - (strumLineNotes.members[1].width * 1)}, 1, {ease: FlxEase.quadInOut});
				opponentStrums.forEach(function(tofade:FlxSprite)
					{
						tofade.alpha = 0.4;
					});
				thirdplayerStrums.forEach(function(tofade:FlxSprite)
				{
					tofade.alpha = 0.4;
				});
			
				//Ah sim, utilizando esse evento, você poderá modificar a ordem das setas.
				}

			case 'Must Press Swap': //Transição mais estilosa usada exclusivamente em CCC
				var k:Float = 0; //-565 ou 565
				if(value1 == 'true'){k = 565 - 85;}
				FlxTween.tween(playerStrums.members[0], {x: playerStrums.members[0].x - k}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(playerStrums.members[1], {x: playerStrums.members[1].x - k}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(playerStrums.members[2], {x: playerStrums.members[2].x - k}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(playerStrums.members[3], {x: playerStrums.members[3].x - k}, 1, {ease: FlxEase.quadInOut});

				FlxTween.tween(opponentStrums.members[0], {x: opponentStrums.members[0].x + k}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(opponentStrums.members[1], {x: opponentStrums.members[1].x + k}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(opponentStrums.members[2], {x: opponentStrums.members[2].x + k}, 1, {ease: FlxEase.quadInOut});
				FlxTween.tween(opponentStrums.members[3], {x: opponentStrums.members[3].x + k}, 1, {ease: FlxEase.quadInOut});

			case 'eventos-tooslow':
				var supertimerchaos:Float = Std.parseFloat(value1);
					switch (supertimerchaos)
					{
						//Isso estava feio então unifiquei todos em um só, afinal, isso não é mais baseado em curstep
						case 27:
							doStaticSign(0);
						case 180:
							doJumpscare();
						case 921:
							doSimpleJump();
						case 765:
							FlxG.camera.flash(FlxColor.RED, 4);
						case 1305:
							cinematicBars(true);
							FlxTween.tween(camHUD, {alpha: 0}, 0.3);
							dad.playAnim('iamgod', true);
							dad.nonanimated = true;
						case 1362:
							FlxG.camera.shake(0.002, 0.6);
							camHUD.camera.shake(0.002, 0.6);
						case 1432:
							cinematicBars(false);
							FlxTween.tween(camHUD, {alpha: 1}, 0.3);
							dad.nonanimated = false;
					}		

			case 'eventos-personel':
				var supertimerchaos:Float = Std.parseFloat(value1);
				if (SONG.song.toLowerCase()=='personel')
					{
						switch (supertimerchaos)
						{
							case 1:
								dad.nonanimated = true;
							case 32:
								dad.nonanimated = false;
								camGame.alpha = 1;
							case 288:
								defaultCamZoom = 1.2;
								FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.3);
							case 416:
								defaultCamZoom = 1.6;
								FlxTween.tween(FlxG.camera, {zoom: 1.6}, 0.3);
							case 543:
								defaultCamZoom = 1.0;
								FlxTween.tween(FlxG.camera, {zoom: 1.0}, 0.3);
							case 799:
								defaultCamZoom = 0.9;
								FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.3);
							case 1069:
								for (str in playerStrums)
								{
									str.angle = str.angle + 35;
								}
								for (str in opponentStrums)
								{
									str.angle = str.angle + 35;
								}
							case 1199:
								IsNoteSpinning = true;
								FlxTween.tween(FlxG.camera, {zoom: 1.6}, 0.3);
								defaultCamZoom = 1.6;
							case 1263:
								IsNoteSpinning = false;
							case 1311:
								IsNoteSpinning = true;
								isPlayersSpinning = true;
								FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.3);
								defaultCamZoom = 1.2;
							case 1401:
								IsNoteSpinning = false;
								FlxTween.tween(FlxG.camera, {zoom: 1.8}, 0.3);
								defaultCamZoom = 1.8;
							case 1403:
								defaultCamZoom = 0.9;
								FlxTween.tween(FlxG.camera, {zoom: 0.9}, 21.2);
								isPlayersSpinning = false;
								dad.angle = 0;
								boyfriend.angle = 0;
								for (str in playerStrums)
								{
									FlxTween.tween(str, {angle: 0}, 0.5, {ease: FlxEase.circOut});
								}
								for (str in opponentStrums)
								{
									FlxTween.tween(str, {angle: 0}, 0.5, {ease: FlxEase.circOut});
								}
							case 1695:
								superZoomShit = true;
							case 1872:
								superZoomShit = false;
								supersuperZoomShit = true;
							case 1888:
								superZoomShit = true;
								supersuperZoomShit = false;
							case 1936:
								supersuperZoomShit = true;
								superZoomShit = false;
							case 1975:
								superZoomShit = false;
								supersuperZoomShit = false;
						}
					}
			case 'eventos-needle':
				var tempo:Float = Std.parseFloat(value1);
						switch (tempo)
						{

							case 760: //ok

								FlxTween.num(defaultCamZoom, 0.8, 0.5, {ease: FlxEase.cubeOut}, function (v:Float) {
									defaultCamZoom = v;
								});
								FlxTween.tween(blackFuck, {alpha: 0.5}, 1, {ease: FlxEase.quadInOut});

							case 765: //ok
							var char:Character = gf;
							char.idleSuffix = 'scared';
							char.recalculateDanceIdle();
							FlxTween.tween(dad2, {alpha: 0.7}, 0.5, {ease: FlxEase.quadInOut});
							// funnyLargeTween();

							case 775: //ok
								FlxTween.num(defaultCamZoom, 0.6, 0.5, {ease: FlxEase.cubeOut}, function (v:Float) {
									defaultCamZoom = v;
								});
								FlxTween.tween(blackFuck, {alpha: 0.0}, 1, {ease: FlxEase.quadInOut});		
							case 780:
								var char:Character = gf; //isso provavelmente deve ser menos bugado
								char.idleSuffix = ''; //e menos bagunçado que a solução anterior...
								char.recalculateDanceIdle(); // EU ESPERO...
								FlxTween.tween(dad2, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});							
						}
			case 'eventos-tripletrouble': //Que o inferno comece...
				var supertimer:Float = Std.parseFloat(value1);
				switch (supertimer)
				{
					//Nota adicional a fazer com lua,
					//Reaproveitar o lua da YCR, e codar o vignette red pra fazer tween nas partes do beast
					//Não é muito dificil, é só usar um get property que verifica se o p3staticbg está visivel ou não k
					
				case 1:
					doP3Static(); // cool static
					FlxTween.tween(FlxG.camera, {zoom: 1.2}, 2, {ease: FlxEase.cubeOut});
					FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.cubeOut}); //Só pra garantir que ninguem vai ver que o oponente está com as notas bugadas no começo
					defaultCamZoom = 1.1;
					if(!ClientPrefs.middleScroll){
					opponentStrums.members[0].x = opponentStrums.members[0].x + 28; //Silvio burro parte 2
					opponentStrums.members[1].x = opponentStrums.members[1].x + 28;
					opponentStrums.members[2].alpha = 0;
					opponentStrums.members[3].x = opponentStrums.members[3].x - 28*3;
					opponentStrums.members[4].x = opponentStrums.members[4].x - 28*3;
				}
				case 144:
					doP3JumpTAILS();
				case 1024, 1088, 1216, 1280, 2305, 2810, 3199, 4096:
					doP3Static(); //Esse trem serve como transição e pode ser substituido por TrioStatic usado em Slaybells
						
				case 1040: // Entrada beast, use o code de change character normal aqui.
					startachieving('tails_free');
					FlxTween.tween(FlxG.camera, {zoom: 0.9}, 2, {ease: FlxEase.cubeOut});
					defaultCamZoom = 0.9;

					p3staticbg.visible = true;

				case 1296: // Entrada do knuckles omaga, use strum swap 1 aqui junto com os eventos de troca de boneco.

					FlxTween.tween(FlxG.camera, {zoom: 1.1}, 2, {ease: FlxEase.cubeOut});
					defaultCamZoom = 1.1;

					p3staticbg.visible = false;

					doP3JumpKNUCKLES();

				case 2320:
					FlxTween.tween(FlxG.camera, {zoom: 0.9}, 2, {ease: FlxEase.cubeOut});
					defaultCamZoom = 0.9;

					p3staticbg.visible = true;
					startachieving('knuckles_free');

				case 2823: //Entrada do eggman, pra reverter o efeito das notas, use o evento strum swap 2
					doP3JumpEGGMAN();

					FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.cubeOut});
					defaultCamZoom = 1;
					p3staticbg.visible = false;

				case 2887, 3015, 4039:
					dad.playAnim('laugh', true);
					dad.nonanimated = true;
				case 2895, 3023, 4048:
					dad.nonanimated = false;

				case 4111: //Final, vá de acordo com a ordem no chat do discord pra trocar os bonecos.
					p3staticbg.visible = true;
					FlxTween.tween(playerStrums.members[2], {alpha: 0}, 1, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[0], {x: playerStrums.members[0].x + 160 * 0.7 / 4}, 1, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[1], {x: playerStrums.members[1].x + 160 * 0.7 / 4}, 1, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[3], {x: playerStrums.members[3].x - 160 * 3 * 0.7 / 4}, 1, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[4], {x: playerStrums.members[4].x - 160 * 3 * 0.7 / 4}, 1, {ease: FlxEase.cubeOut}); //Bem vindo a turma de matemática avançada omega kek
					//OH nooooo tweensssssssss nooooooooooooooooooooooooooo
					startachieving('eggman_free');

				case 4120:
					if(cNum >= 63 && !cpuControlled && !usedPractice) //Estou sendo legal e estou deixando você perder um anel
						startachieving('rings');
				}

			case 'eventos-prey':
				var supertimer:Float = Std.parseFloat(value1);
						switch (supertimer)
							{
						case 1:
							boyfriend.alpha = 0;
							
							camHUD.alpha = 0;
							FlxTween.tween(boyfriend, {alpha: 1}, 6);	
							triggerEventNote('noteskinchangeOPPT', 'NOTE-FURNACEBLU_assets', '');
							triggerEventNote('Change Character', 'dad', 'Furnace'); //Ele já foi carregado mesmo então tá safe
							#if desktop
							storyDifficultyText = 'Neutro';
							#end
							dad.x -= 1000;
						case 128:
							FlxG.camera.flash(FlxColor.BLACK, 4);
							FlxG.camera.zoom = 2;
							camZooming = false;
							stardustBgPixel.visible = true;
							stardustFloorPixel.visible = true;
							cinematicBars(true);

						case 246:
							FlxTween.tween(dad, {x: 580 - 250*2}, 1, {ease: FlxEase.cubeInOut});
							FlxTween.tween(camHUD, {alpha: 1}, 1.2,{ease: FlxEase.cubeInOut});
							cinematicBars(false);
						case 511:
							stardustFloorPixel.loadGraphic(Paths.image('cenarios/starved/stardustFloor2'));
							FlxG.camera.flash(FlxColor.WHITE, 3);
							removeStatics();
							generateStaticArrows(0);
							generateStaticArrows(1);
							triggerEventNote('noteskinchangeOPPT', 'NOTE-FURNACE_assets', ''); //must do Arrumar esse sprite.

						case 1024:
							FlxG.camera.flash(FlxColor.WHITE, 3);
							removeStatics();
							generateStaticArrows(0);
							generateStaticArrows(1);
							triggerEventNote('noteskinchangeOPPT', 'NOTE-FURNACEBLU_assets', ''); //must do Arrumar esse sprite.
							triggerEventNote('Change Character', 'dad', 'Furnace'); //Ele já foi carregado mesmo então tá safe
							FlxTween.tween(sonicHUD, {alpha: 0}, 0.5,{ease: FlxEase.cubeInOut}); //sÓ pq fica estranho com a cinematics
							
						case 1280:
							stardustFloorPixel.loadGraphic(Paths.image('cenarios/starved/stardustFloor3'));
							FlxG.camera.flash(FlxColor.WHITE, 3);
							removeStatics();
							generateStaticArrows(0);
							generateStaticArrows(1);
							triggerEventNote('noteskinchangeOPPT', 'NOTE-FURNACE_assets', ''); //must do Arrumar esse sprite.
							triggerEventNote('Change Character', 'dad', 'Furnace-rgb'); //Ele já foi carregado mesmo então tá safe
							FlxTween.tween(sonicHUD, {alpha: 1}, 0.5,{ease: FlxEase.cubeInOut});

						case 1530:
							FlxTween.tween(camHUD, {alpha: 0}, 4,{ease: FlxEase.cubeInOut}); //Dar tempo das notas sairem da tela
						case 1542: 
								dad.alpha = 0; //Esse evento deve ser colocado exatamente 100 tempos a frente do change character ao total o eggman aparecerá errado na tela por 0.01 segundo... ESPERO QUE NINGUEM PERCEBA
						case 1505:
							FlxTween.tween(dad, {x: -1500}, 5, {ease: FlxEase.cubeInOut});
							FlxTween.angle(dad, 0, -180, 5, {ease: FlxEase.cubeInOut});
						case 1545:
								cinematicBars(true);
								dad.x -= 1000;
								dad.y += 225;
								dad.y -= 410; //Por que tá repetido?/
								//Simples, PREGUIÇA!
								dad.alpha = 1;
								removeStatics();
								generateStaticArrows(0);
								generateStaticArrows(1);
								triggerEventNote('noteskinchangeOPPT', 'NOTE-STARVI_assets', ''); //must do Arrumar esse sprite.
						case 1547: //Just settings tbh
							health = 1;
							SONG.speed = 3.3; //A musica começa mais lenta, e nessa parte, ela fica com a velocidade .2 menor do que a chart normal
							boyfriend.animation.finishCallback = function(slash:String)
							{
								hungryManJackTime = 1;
								if (dad.animation.curAnim.name == "first dialogue")
								{
									boyfriend.specialAnim = false;
								}
							}
							//dad.playAnim("dialogue", true);
							dad.specialAnim = true;
							dad.animation.finishCallback = function(slash:String)
							{
								if (dad.animation.curAnim.name == "dialogue")
								{
									hungryManJackTime = 1;
									cinematicBars(false);
									dad.specialAnim = false;
								}
							}
						case 1570:
							FlxTween.tween(dad, {x: 1300}, 2.5,{ease: FlxEase.cubeInOut});
						case 1780:
							//Play sonic pulim
							sonicPulo.play();
							stardustFloorPixel.loadGraphic(Paths.image('cenarios/starved/stardustFloor1')); //AGORA SIM TU VAI PODER VER O OLHO DELE
							FlxG.camera.flash(FlxColor.RED, 1);
							cinematicBars(false); //I FORGOR
							FlxTween.tween(camHUD, {alpha: 1}, 1.0);
						case 1781:
							sonicDash.play();

						case 2400: //Aqui é a preparação para o ataque do fornalha
							sonicAviso.play();
							warning.visible = true;
							warning.animation.play("warn");

							desvioPrey = true;			
						
						case 2410: //Só pra não falar que eu fui maldoso
							desvioPrey = false;
							warning.visible = false;
							remove(warning);

						case 2432:
							if(desviou){
							triggerEventNote('Change Character', 'bf', 'bf-Sonic-Peelout-sus'); //Note for future self - Esse cara vai precisar de um pré cache especial só pra ele.
							}else{
								startachieving('prey_bot'); //YOU NOOOOOOOOB NEM COM BOTPLAY CONSEGUE SEU RUIM LIXO, GUSTAVO FREIRE DE QUEIROZ
								//Não conheço nenhum gustavo freire de queiroz btw, mas caso esse seja teu nome então...
								//Continuo não ligando pra isso Sr. Gustavo, agora pare de perder seu tempo lendo comentários no code dos outros
							}
							FlxTween.tween(stardustFurnace, {x: 3000}, 10, {onComplete: function(yes:FlxTween)
								{
									if(desviou)
										triggerEventNote('Change Character', 'bf', 'bf-Sonic-Peelout');
								}});
						case 3328:
							FlxTween.tween(camHUD, {alpha: 0}, 1,{ease: FlxEase.cubeInOut});
							FlxTween.tween(dad, {x: -300}, 4,{ease: FlxEase.cubeInOut});
							cinematicBars(true);
						case 3335:
							boyfriend.playAnim("dialogue peel");
							boyfriend.specialAnim = true;
						case 3367:
							blackFuck.alpha = 1;
						case 3378: //Top 10 mecanicas que parecem difíceis de fazer, mas que já estavam prontas o tempo todo.
							if (!desviou){
									canuseevents = false;
									FlxG.sound.music.pause();
									vocals.pause();
									Conductor.songPosition = 383050; //Isso equivale a 383.05 segundos 
									notes.forEachAlive(function(daNote:Note)
									{
										if(daNote.strumTime + 800 < Conductor.songPosition) {
											daNote.active = false;
											daNote.visible = false;
					
											daNote.kill();
											notes.remove(daNote, true);
											daNote.destroy();
										}
									});
									for (i in 0...unspawnNotes.length) {
										var daNote:Note = unspawnNotes[0];
										if(daNote.strumTime + 800 >= Conductor.songPosition) {
											break;
										}
					
										daNote.active = false;
										daNote.visible = false;
					
										daNote.kill();
										unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
										daNote.destroy();
									}
					
									FlxG.sound.music.time = Conductor.songPosition;
									FlxG.sound.music.play();
					
									vocals.time = Conductor.songPosition;
									vocals.play();
							}
						case 3364:
							var gotcha:FlxSprite = new FlxSprite(boyfriend.x + 1000, boyfriend.y + 405).loadGraphic(Paths.image('furnace_gotcha'));
							gotcha.setGraphicSize(Std.int(gotcha.width * 5));
							gotcha.antialiasing = false;
							gotcha.flipX = false;
							add(gotcha);
							FlxTween.tween(gotcha, {x: boyfriend.x + 500}, 0.3, {onComplete: function(yes:FlxTween)
							{
								FlxG.camera.flash(FlxColor.RED, 1);
								remove(gotcha);
							}});

							case 3420:
								health = 1;
								removeStatics();
								generateStaticArrows(0);
								generateStaticArrows(1);
								triggerEventNote('noteskinchangeBF', 'NOTE-supa_assets', ''); //must do Arrumar esse sprite.
								FlxG.camera.flash(FlxColor.YELLOW, 2);

								opponentStrums.forEach(function(tofade:FlxSprite)
									{
										tofade.alpha = 0;
									});
	
							case 3400:
								#if desktop
								storyDifficultyText = 'Good ending?'; //detalhe que achei soda
								#end
								endingTweens('good_ending');
								stardustFloorPixel.loadGraphic(Paths.image('cenarios/starved/stardustFloor4')); //AGORA SIM TU VAI PODER VER O OLHO DELE
								stardustBgPixel.loadGraphic(Paths.image('cenarios/starved/stardustBg')); //AGORA SIM TU VAI PODER VER O OLHO DELE

							case 3425:
								hungryManJackTime = 2;
								startachieving('prey_survive');
								cinematicBars(false);
								gf.x -= 1000;
								gf.y += 150;
								gf.y -= 410; 
								boyfriend.y += 450;
								dad.x -= 1000;
								dad.y += 50;
								FlxTween.tween(dad, {x: 580 - 450}, 3,{ease: FlxEase.cubeInOut});
								FlxTween.tween(gf, {x: 580 - 375}, 3,{ease: FlxEase.cubeInOut});
								SONG.speed = 4.0;
								FlxTween.tween(blackFuck, {alpha: 0}, 1,{ease: FlxEase.cubeInOut});
								FlxTween.tween(camHUD, {alpha: 1}, 1,{ease: FlxEase.cubeInOut});

								//A partir daqui é baseado no port do konan
								//Até o The End

								//The end

							case 4480:
								FlxG.camera.flash(FlxColor.RED, 5);
								blackFuck.alpha = 1;
								opponentStrums.forEach(function(tofade:FlxSprite)
									{
										tofade.alpha = 1;
									});

							case 4498:
								FlxTween.tween(sonicHUD, {alpha: 0}, 0.5,{ease: FlxEase.cubeInOut}); //sÓ pq fica estranho com a cinematics
								timeBar.visible=true;
								judgementCounter.visible=true;
								scoreTxt.visible=true;
								timeBar.createFilledBar(0xFF000000, 0xFFFF0000);
								timeTxt.visible=true;
								SONG.speed = 2.8; //Talvez isso seja muito lento, mas  a idéia é essa mesma k
								timeBarBG.visible=true;
								canRegen = false;
								isPixelStage = false;
								camHUD.alpha = 1; //Só pra garantir
								if(desviou){
								#if desktop
								storyDifficultyText = 'True Ending'; //detalhe que achei soda
								#end
								endingTweens('true_ending');
								} else {
								#if desktop
								storyDifficultyText = 'Bad ending'; //detalhe que achei soda
								#end
								endingTweens('bad_ending');
								}
								cinematicBars(false);
								removeStatics();
								generateStaticArrows(0);
								generateStaticArrows(1);
								triggerEventNote('noteskinchangeOPPT', 'NOTE_assets', '');
								triggerEventNote('noteskinchangeBF', 'NOTE_assets', 'blood');
								stardustBgPixel.visible = false;
								stardustFloorPixel.visible = false;
								theendbg.visible = true;
								furnaceTheEnd.visible = true;
								boyfriend.x = 998 -208;
								boyfriend.y = 302;
								dad.x = 1308 -195;
								dad.y = 175;
								health = 0.05;

								case 4505:
									FlxG.camera.flash(FlxColor.WHITE, 1);
									blackFuck.alpha = 0;

								case 4750:
									cpuControlled = true;
									botplayTxt.text = '';
									//Pensar em algo pra deixar bon appetit marcante

								case 4768:
									FlxTween.tween(camHUD, {alpha: 0}, 1,{ease: FlxEase.cubeInOut});

								case 4782:
									cpuControlled = false;
									botplayTxt.text = 'BOTPLAY';
						

							
							} //Me tornei aquilo que eu mais temia... Uma pessoa tão exagerada quanto a Nashira... NOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

						

			case 'Entrada Pixel':
				var indicador:Float = Std.parseFloat(value1);
				if(indicador == 1){
					scoreTxt.visible=false;
					timeBar.visible=false;
					timeTxt.visible=false;
					timeBarBG.visible=false;
					judgementCounter.visible = false;
					triggerEventNote('noteskinchangeBF', '', 'noteSplashesPixelSonic');
					p2greenhill.visible = true;
					add(sonicHUD);
					isPixelStage = true;
					removeStatics();
					generateStaticArrows(0);
					generateStaticArrows(1);
					desesperada = true;
				} else {
					scoreTxt.visible=true;
					timeBar.visible=true;
					timeTxt.visible=true;
					timeBarBG.visible=true;
					p2greenhill.visible = false;
					judgementCounter.visible = true;
					remove(sonicHUD);
					isPixelStage = false;
					triggerEventNote('noteskinchangeBF', '', 'blood');
					removeStatics();
					generateStaticArrows(0);
					generateStaticArrows(1);
					desesperada = false;
				}

			case 'CamZoomTween':
				var quantidade:Float = Std.parseFloat(value1);
				var duracao:Float = Std.parseFloat(value2);
				FlxTween.tween(FlxG.camera, {zoom: quantidade}, duracao, {ease: FlxEase.linear});

			case 'TelaPreta':
				if(value1 == 'true'){
					FlxTween.tween(blackFuck, {alpha: 1}, 0.3);
				} else {
					FlxTween.tween(blackFuck, {alpha: 0}, 0.3);
				}

			case 'CharacterAlphaTween':

				var charType:Int = 0;
				var opa_Cidade:Array<String> = value2.split(','); //Basicamente, o modelo é "alpha","duracao do tween"
				if (nomehistorico.toLowerCase() == 'vazio'){//solução rapida e facil
					FlxTween.tween(camGame, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]), {ease: FlxEase.quadInOut});
				}else{
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

					switch(charType) {
						case 2:
							FlxTween.tween(gf, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]), {ease: FlxEase.quadInOut});
						case 1:
						FlxTween.tween(dad, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]), {ease: FlxEase.quadInOut});
						case 0:
							FlxTween.tween(boyfriend, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]), {ease: FlxEase.quadInOut});
					}
				}

			case 'notestween':
				var charType:Int = 0;
				var opa_Cidade:Array<String> = value2.split(','); //Qual foi man? achaste mesmo que eu iria recodar o mesmo sistema de tweens duas vezes?
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 2: //Tenho minhas duvidas se isso aqui será usado, mas né? Tá ai.
						thirdplayerStrums.forEach(function(tofade:FlxSprite)
							{
								FlxTween.tween(tofade, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]));
							});
					case 1:
						opponentStrums.forEach(function(tofade:FlxSprite)
							{
								tofade.visible = true;
								FlxTween.tween(tofade, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]));
							});
					case 0:
						playerStrums.forEach(function(tofade:FlxSprite)
							{
								FlxTween.tween(tofade, {alpha: Std.parseFloat(opa_Cidade[0])}, Std.parseFloat(opa_Cidade[1]));
							});
				}

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;
		
						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				char.playAnim(value1, true);
				char.specialAnim = true;

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}
				char.idleSuffix = value2;
				char.recalculateDanceIdle();

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = Std.parseFloat(split[0].trim());
					var intensity:Float = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}

			case 'hudfade':
				var opacidade:Float = Std.parseFloat(value1);
				var timer:Float = Std.parseFloat(value2);
				FlxTween.tween(camHUD, {alpha: opacidade}, timer,{ease: FlxEase.cubeInOut});

			case 'comecarvideo': //TO DO: sistema de preload de videos... Vai que algum maluco queira lançar o filme do jureg aqui...
				var posAvancado:Array<String> = value2.split(',');
				backgroundVideo('assets/videos/' + value1 + '.webm', Std.parseFloat(posAvancado[0] + 0.1), Std.parseFloat(posAvancado[1] + 0.1), posAvancado[2], Std.parseFloat(posAvancado[3]), Std.parseFloat(posAvancado[4]));

			case 'tempo infinito':
				
					majinstrums = true;
					infinitesimbol = new FlxSprite().loadGraphic(Paths.image('simbolo_infinito'));
					infinitesimbol.y = timeBarBG.y - 40;
					infinitesimbol.setGraphicSize(Std.int(timeTxt.height * 1.7));
					infinitesimbol.cameras = [camHUD];
					infinitesimbol.angle = 0; //I FORGOR :skull:
					infinitesimbol.screenCenter(X);
					infinitesimbol.centerOrigin(); //apenas para garantir que o eixo de spin fique no centro do simbolo infinito
					removeStatics();
					generateStaticArrows(0);
					generateStaticArrows(1);
					FlxTween.num(timeBar.max, 20, 2.0, {ease: FlxEase.cubeOut}, function (v:Float) {
						remove(timeBar);
						timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
						'songPercent', 0, v);
						timeBar.numDivisions = 400;
						timeBar.scrollFactor.set();
						timeBar.createFilledBar(0xFF7700FF, 0xFFFFFFFF);
						timeBar.cameras = [camHUD];
						add(timeBar);
						});
						FlxTween.num(secondsTotal, 6039, 2.0, {ease: FlxEase.linear}, function (v2:Float) {
							timeTxt.text = FlxStringUtil.formatTime(v2, false);
							});
							new FlxTimer().start(2.03, function(tmr:FlxTimer) {
								timeTxt.visible = false;
								songPercent = 0;
								add(infinitesimbol);
							});

			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							boyfriend.visible = false;
							boyfriend = boyfriendMap.get(value2);
							if(!boyfriend.alreadyLoaded) {
								boyfriend.alpha = 1;
								boyfriend.alreadyLoaded = true;
							}
							boyfriend.visible = true;
							if (!bfIsLeft) iconP1.changeIcon(boyfriend.healthIcon) else iconP1.changeIcon(dad.healthIcon);
						}

						setOnLuas('camPosBFX', boyfriend.getMidpoint().x - 100 - boyfriend.cameraPosition[0]);
						setOnLuas('camPosBFY', boyfriend.getMidpoint().y - 100 + boyfriend.cameraPosition[1]);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							dad.visible = false;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf) {
									gf.visible = true;
								}
							} else {
								gf.visible = false;
							}
							if(!dad.alreadyLoaded) {
								dad.alpha = 1;
								dad.alreadyLoaded = true;
							}
							dad.visible = true;
							if (!bfIsLeft) iconP2.changeIcon(dad.healthIcon) else iconP2.changeIcon(boyfriend.healthIcon);
						}

						setOnLuas('camPosDadX', dad.getMidpoint().x + 150 + dad.cameraPosition[0]);
						setOnLuas('camPosDadY', dad.getMidpoint().y - 100 + dad.cameraPosition[1]);

					case 2:
						if(gf.curCharacter != value2) {
							if(!gfMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							gf.visible = false;
							gf = gfMap.get(value2);
							if(!gf.alreadyLoaded) {
								gf.alpha = 1;
								gf.alreadyLoaded = true;
							}
						}
				}
				reloadHealthBarColors();
			
			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			
			if (SONG.notes[id].gfSection){
				callOnLuas('onMoveCamera', ['gf']);
			}else{
				callOnLuas('onMoveCamera', ['dad']);
			}
		}
		else
		{
			moveCamera(false);
			if (SONG.notes[id].gfSection){
				callOnLuas('onMoveCamera', ['gf']);
			}else{
				callOnLuas('onMoveCamera', ['boyfriend']);
			}
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool) {
		if(isDad || curSong.toLowerCase()=='control') {
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0];
			camFollow.y += dad.cameraPosition[1];
			tweenCamIn();
		} else {
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0];
			camFollow.y += boyfriend.cameraPosition[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1) {
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween) {
						cameraTwn = null;
					}
				});
			}
		}
		
		
		if(nomehistorico != 'Gran Finale'){
		if (SONG.notes[Std.int(curStep / 16)].gfSection){
			
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0];
			camFollow.y += gf.cameraPosition[1];
			tweenCamIn();
		}
		}
		
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function finishSong():Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
			finishCallback();
		});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					if(canRegen){
						health -= 0.0475;
					}
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					if(canRegen){
					health -= 0.0475;
					}
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}
		#if mobileC
		mcontrols.visible = false;
		#end
		canoff = true; //Usado naquelas configs muito das loucas
		majinstrums = false;
		canRegen = true;
		canuseevents = true;
		desesperada = false;
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				videoSprite.visible = false;
			//	remove(videoSprite);
			}

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['toastie', 'besties', 'personel_clear', 
			'control_fc', 'bye_bye_fc', 'natal', 
			'sidekick', 'toofest_fc', 'perfect', 'fake_full_combo']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end

		var ret:Dynamic = callOnLuas('onEndSong', []);

		if(ret != FunkinLua.Function_Stop && !transitioning) {
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					cancelFadeTween();
					CustomFadeTransition.nextCamera = camOther;
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}

					// if ()
					if(!usedPractice) {
						MenuHistoria.weekCompleted.set(WeekData.weeksList[storyWeek], true);
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						FlxG.save.flush();
					}
					usedPractice = false;
					changedDifficulty = false;
					cpuControlled = false;
				}
				else
				{
					var difficulty:String = '' + CoolUtil.difficultyStuff[storyDifficulty][1];

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelFadeTween();
							//resetSpriteCache = true;
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else {
				var achieveID:Int = Achievements.getAchievementIndex('pibby');
				
				if (curSong != 'green-hills' || Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])){
					trace('WENT BACK TO FREEPLAY??');
					cancelFadeTween();
					CustomFadeTransition.nextCamera = camOther;
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}

				FlxTween.tween(blackFuck, {alpha: 1}, 0.3, {
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween)
				{
					if(modohistoria){
						MusicBeatState.switchState(new MenuPreHistoria());
						lime.app.Application.current.window.title='FNF: ModBoa EXE';
						modohistoria = false;
					} else {
						MusicBeatState.switchState(new FreeplayState());
						lime.app.Application.current.window.title='FNF: ModBoa EXE';
					}
				
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				}
			});	
			
		} else if (curSong == 'green-hills' && !Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])){
				ClientPrefs.pibby = true;
				#if desktop
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						System.exit(0);
					});
					lime.app.Application.current.window.alert("Projeto ModBoa parou de funcionar permanentemente!", "Glitch Fatal!");
				#end
				ClientPrefs.saveSettings();
				//if (FlxG.keys.justPressed.ENTER){

				//}


			}
				usedPractice = false;
				changedDifficulty = false;
				cpuControlled = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camLegenda); //Só pra garantir que isso fique em cima de tudo e todos
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	function updateSonicScore(){
		var seperatedScore:Array<String> = Std.string(songScore).split("");
		if(seperatedScore.length<scoreNumbers.length){
			for(idx in seperatedScore.length...scoreNumbers.length){
				if(hudStyle == 'chaotix' || hudStyle == 'sonic2' || hudStyle == 'soniccd' || hudStyle == 'sonic3'){
					seperatedScore.unshift('');
				}else{
					seperatedScore.unshift('0');
				}
			}
		}
		if(seperatedScore.length>scoreNumbers.length)
			seperatedScore.resize(scoreNumbers.length);

		for(idx in 0...seperatedScore.length){
			if(seperatedScore[idx]!='' || idx==scoreNumbers.length-1){
				var val = Std.parseInt(seperatedScore[idx]);
				if(Math.isNaN(val))val=0;
				scoreNumbers[idx].number = val;
				scoreNumbers[idx].visible=true;
			}else
				scoreNumbers[idx].visible=false;

		}
	}

	function updateSonicMisses(){
		var seperatedScore:Array<String> = Std.string(songMisses).split("");
		if(seperatedScore.length<missNumbers.length){
			for(idx in seperatedScore.length...missNumbers.length){
				if(hudStyle == 'chaotix' || hudStyle == 'sonic2' || hudStyle == 'soniccd' || hudStyle == 'sonic3'){
					seperatedScore.unshift('');
				}else{
					seperatedScore.unshift('0');
				}
			}
		}
		if(seperatedScore.length>missNumbers.length)
			seperatedScore.resize(missNumbers.length);

		for(idx in 0...seperatedScore.length){
			if(seperatedScore[idx]!='' || idx==missNumbers.length-1){
				var val = Std.parseInt(seperatedScore[idx]);
				if(Math.isNaN(val))val=0;
				missNumbers[idx].number = val;
				missNumbers[idx].visible=true;
			}else
				missNumbers[idx].visible=false;

		}
	}

	function updateSonicVida(){
		var seperatedScore:Array<String> = Std.string(Std.int(health * 50)).split(""); //Quando você entender o motivo de ser 50 e não 100... Meu amigo... tu vai curtir muito.
		if(seperatedScore.length<vidaNumbers.length){
			if(hudStyle == 'chaotix' || hudStyle == 'sonic2' || hudStyle == 'soniccd' || hudStyle == 'sonic3'){
				seperatedScore.unshift('');
			}else{
				seperatedScore.unshift('0');
			}
		}
		if(seperatedScore.length>vidaNumbers.length)
			seperatedScore.resize(vidaNumbers.length);

		for(idx in 0...seperatedScore.length){
			if(seperatedScore[idx]!='' || idx==vidaNumbers.length-1){
				var val = Std.parseInt(seperatedScore[idx]);
				if(Math.isNaN(val))val=0;
				vidaNumbers[idx].number = val;
				vidaNumbers[idx].visible=true;
			}else
				vidaNumbers[idx].visible=false;

		}
	}

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + 8); 

		vocals.volume = 1;
		if(!SONG.needsVoices){
			//lxG.sound.volume = 1;
		}

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 300;
		//Basicamente um sistema mais justo baseado em pontuação.

		var daRating:String = "sick";

		if(note.noteType != 'player3'){

			if (ClientPrefs.hitSounds) hitsound.play(true); //true seguida que ele vai ser forçado a reiniciar toda vez que você acertar uma nota.

		if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'shit';
			score = 75;
			//75 = 25% de 300
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.5)
		{
			daRating = 'bad';
			score = 150;
			//150 = 50% de 300
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			score = 225;
			//225 = 75% de 300
			goods++;
		}

		if(daRating == 'sick' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
			sicks++;
		}

		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			songHits++;
			RecalculateRating();
			if(scoreTxtTween != null && judgementCounterTween != null) {
				judgementCounterTween.cancel();
				scoreTxtTween.cancel();
			}
			scoreTxt.scale.x = 1.1;
			scoreTxt.scale.y = 1.1;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
				});
			judgementCounter.scale.x = 1.1;
			judgementCounter.scale.y = 1.1;
			judgementCounterTween = FlxTween.tween(judgementCounter.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					judgementCounterTween = null;
				}
			});
		}

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if(Assets.exists(Paths.imagechecker(pixelShitPart1 + daRating + pixelShitPart2))) {
		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		} else {
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, 'preload'));
		}
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = !ClientPrefs.hideHud;

		add(rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
		}

		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(rating, {alpha: 0}, 0.2,  {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var space = controls.NOTE_SPACE;
		var left = controls.NOTE_LEFT;

		var upP = controls.NOTE_UP_P;
		var rightP = controls.NOTE_RIGHT_P;
		var downP = controls.NOTE_DOWN_P;
		var spaceP = controls.NOTE_SPACE_P;
		var leftP = controls.NOTE_LEFT_P;

		var upR = controls.NOTE_UP_R;
		var rightR = controls.NOTE_RIGHT_R;
		var downR = controls.NOTE_DOWN_R;
		var spaceR = controls.NOTE_SPACE_R;
		var leftR = controls.NOTE_LEFT_R;

		var controlArray:Array<Bool>;
		var controlReleaseArray:Array<Bool>;
		var controlHoldArray:Array<Bool>;
		if (isRing){
		controlArray = [leftP, downP, spaceP, upP, rightP];
		controlReleaseArray = [leftR, downR, spaceR, upR, rightR];
		controlHoldArray = [left, down, space, up, right];
		} else{
			controlArray = [leftP, downP, upP, rightP];
			controlReleaseArray = [leftR, downR, upR, rightR];
			controlHoldArray = [left, down, up, right];
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (!boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					goodNoteHit(daNote);
				}
			});

			if ((controlHoldArray.contains(true) || controlArray.contains(true)) && !endingSong) {
				var canMiss:Bool = false;
				if (controlArray.contains(true)) {
					for (i in 0...controlArray.length) {
						// heavily based on my own code LOL if it aint broke dont fix it
						var pressNotes:Array<Note> = [];
						var notesDatas:Array<Int> = [];
						var notesStopped:Bool = false;

						var sortedNotesList:Array<Note> = [];
						notes.forEachAlive(function(daNote:Note)
						{
							if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate 
							&& !daNote.wasGoodHit && daNote.noteData == i) {
								sortedNotesList.push(daNote);
								notesDatas.push(daNote.noteData);

								// para jogadores nutellas que gostam de spammar.
								// caso quiserem um mod barra pesada:
								// REMOVAM IMEDIATAMENTE!
								// isso é o antimash no clientprefs da resolução
								// que eu não usei
								//canMiss = ClientPrefs.resolution;
							}
						});
						sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

						if (sortedNotesList.length > 0) {
							for (epicNote in sortedNotesList)
							{
								for (doubleNote in pressNotes) {
									if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 10) {
										doubleNote.kill();
										notes.remove(doubleNote, true);
										doubleNote.destroy();
									} else
										notesStopped = true;
								}
									
								// eee jack detection before was not super good
								if (controlArray[epicNote.noteData] && !notesStopped) {
									goodNoteHit(epicNote);
									pressNotes.push(epicNote);
								}

							}
						}
						else if (canMiss) 
							ghostMiss(controlArray[i], i, true);

						// I dunno what you need this for but here you go
						//									- Shubs

						// Shubs, this is for the "Just the Two of Us" achievement lol
						//									- Shadow Mario
						if (!keysPressed[i] && controlArray[i]) 
							keysPressed[i] = true;
					}
				}
			} else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing')
			&& !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.dance();
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if(controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm') {
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			if(controlReleaseArray[spr.ID]) {
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
		});
	}

	function ghostMiss(statement:Bool = false, direction:Int = 0, ?ghostMiss:Bool = false) {
		if (statement) {
			//noteMissPress(direction, ghostMiss);
			//callOnLuas('noteMissPress', [direction]);
		}
	} //Aparentemente essa função dobrava o erro caso tu apertasse uma nota quando não era pra apertar mesmo com ghost tapping ligado
	//Suponha que tu aperte pra direita, e a nota esteja na esquerda e você esteja com ghost tapping ligado
	//Nessa situação, ele vai contar que tu deixou a nota passar e ainda apertou errado.

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 10) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});

		if (curSong.toLowerCase()=='cross-console-clash' && !invencibilidade && daNote.noteType != 'CCC Regen'){ //Top 10 mecanicas mais fodas dos animes que não sei dizer se é uma recriação ou se é eu inventando moda
			cccVidaCounter--;
			invencibilidade = true;

			if(boyfriend.curCharacter.startsWith('mario')){
				if(cccVidaCounter == 1){
				FlxG.sound.play(Paths.sound('Damage'));
				triggerEventNote('Change Character', 'bf', 'mario-ccc');
				} else if (cccVidaCounter == 0){
					FlxG.sound.play(Paths.sound('power_down'));
					triggerEventNote('Change Character', 'bf', 'mario-ccc-small');
				}
			}else if(boyfriend.curCharacter.startsWith('sonic')){
				FlxG.sound.play(Paths.sound('ring_loss'), 0.5);
			}

			if(curSong.toLowerCase()=='cross-console-clash'){
				sonicHUDCCC.updateScoreText();
			}

			cccMiss=true;
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					invencibilidade = false;
					cccMiss=false;
					boyfriend.visible=true;
				});
		}

		if(canRegen){
		health -= daNote.missHealth; //For testing purposes
		}//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		RecalculateRating();

		var animToPlay:String = '';
		if (isRing && (boyfriend.animation.getByName('singLEFTmiss') != null && boyfriend.animation.getByName('singDOWNmiss') != null && boyfriend.animation.getByName('singUPmiss') != null && boyfriend.animation.getByName('singRIGHTmiss') != null)){
			switch (Math.abs(daNote.noteData) % 5)
			{
				case 0:
					animToPlay = 'singLEFTmiss';
				case 1:
					animToPlay = 'singDOWNmiss';
				case 2:
					animToPlay = 'none';
				case 3:
					animToPlay = 'singUPmiss';
				case 4:
					animToPlay = 'singRIGHTmiss';
			}
		}
		else{
			if(boyfriend.animation.getByName('singLEFTmiss') != null && boyfriend.animation.getByName('singDOWNmiss') != null && boyfriend.animation.getByName('singUPmiss') != null && boyfriend.animation.getByName('singRIGHTmiss') != null){ //Eu até faria um code mais limpo mas né? Se o cara não tem animação de erro pra esquerda, provavelmente não terá pras outras
			switch (Math.abs(daNote.noteData) % 4)
			{
				case 0:
					animToPlay = 'singLEFTmiss';
				case 1:
					animToPlay = 'singDOWNmiss';
				case 2:
					animToPlay = 'singUPmiss';
				case 3:
					animToPlay = 'singRIGHTmiss';
			}
			} else{
				animToPlay = 'none';
			}
		}

		if(daNote.noteType == 'GF Sing' || daNote.noteType == 'player3' && animToPlay != 'none') {
			gf.playAnim(animToPlay, true);
		} else {
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';
			if(animToPlay != 'none'){
			boyfriend.playAnim(animToPlay + daAlt, true);
			}
		}
		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	/*
	function noteMissPress(direction:Int = 1, ?ghostMiss:Bool = false):Void //You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			if (canRegen){
			health -= 0.04;
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				if(ghostMiss){ 
				ghostMisses++;
				songMisses++;
				}
			}
			RecalculateRating();

			//FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			if(boyfriend.animation.getByName('singLEFTmiss') != null && boyfriend.animation.getByName('singDOWNmiss') != null && boyfriend.animation.getByName('singUPmiss') != null && boyfriend.animation.getByName('singRIGHTmiss') != null){ //Eu até faria um code mais limpo mas né? Se o cara não tem animação de erro pra esquerda, provavelmente não terá pras outras
			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
			}
			vocals.volume = 0;
		}
	}*/

	function opponentNoteHit(note:Note):Void
		{
			if (Paths.formatToSongPath(SONG.song) != 'tutorial')
				camZooming = true;

			if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
				dad.playAnim('hey', true);
				dad.specialAnim = true;
				dad.heyTimer = 0.6;
			} else if(!note.noAnimation) {
				var altAnim:String = "";

				if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (SONG.notes[Math.floor(curStep / 16)].altAnim || note.noteType == 'Alt Animation') {
						altAnim = '-alt';
					}
				}

				var animToPlay:String = '';
				if (PlayState.isRing){
					switch (Std.int(Math.abs(note.noteData)))
					{
						case 0:
							animToPlay = 'singLEFT';
						case 1:
							animToPlay = 'singDOWN';
						case 2:
							//fica feliz e dá pulinho, ihaaaaaaaa
						case 3:
							animToPlay = 'singUP';
						case 4:
							animToPlay = 'singRIGHT';
					}
				}else{
					switch (Std.int(Math.abs(note.noteData)))
					{
						case 0:
							animToPlay = 'singLEFT';
						case 1:
							animToPlay = 'singDOWN';
						case 2:
							animToPlay = 'singUP';
						case 3:
							animToPlay = 'singRIGHT';
					}
				}
				if(note.noteType == 'GF Sing' || note.noteType == 'player3') {
					gf.playAnim(animToPlay + altAnim, true);
					gf.holdTimer = 0;
				} else if (curStage == 'needle')
				{
					dad.playAnim(animToPlay + altAnim, true);
					dad2.playAnim(animToPlay + altAnim, true);

					dad.holdTimer = 0;
					dad2.holdTimer = 0;
				} else {
					dad.playAnim(animToPlay + altAnim, true);
					dad.holdTimer = 0;
				}
			}

			if (SONG.needsVoices)
				vocals.volume = 1;
	
			var time:Float = 0.15;
			if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
				time += 0.15;
			}
			if (isRing){
				StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 5, time);
			} else if (note.noteData < 8 && note.noteType != 'player3'){
				StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
			} else {
				StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time, true);
			}
				note.hitByOpponent = true;

				if (note.noteType != 'player3')
					callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);
				
				if (note.noteType == 'player3') //Usado exclusivamente na Pasta-Night, mas codado de forma geral que possa ser usada em literalmente qualquer música
					callOnLuas('thirdplayerNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), 'player3', note.isSustainNote]);
	
			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote && note.noteType != 'player3') {
					spawnNoteSplashOnNote(note);
				}

				switch(note.noteType) {
					case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}

					}
				
				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			switch(note.noteType) {
				case 'CCC Regen': //Feito segundo a concept de TomokiAo (pelo menos parcialmente k)
					if(curSong.toLowerCase()=='cross-console-clash' && cccVidaCounter < 2){
						invencibilidade = true;
						cccMiss=true;
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
							{
								invencibilidade = false;
								cccMiss=false;
								boyfriend.visible=true;
							}); 
							//Tecnicamente isso não existe nem no mod original e nem no SMW original
							//Assim que tu pega um mushroom se tu tomar dano 0.1 sec depois tu perde ele
							//Mas resolvi facilitar um pouquinho.
						if(boyfriend.curCharacter.startsWith('mario')){
							if(cccVidaCounter == 1){
							triggerEventNote('Change Character', 'bf', 'mario-fire');
							} else if (cccVidaCounter == 0){
								triggerEventNote('Change Character', 'bf', 'mario-ccc');
							}
						FlxG.sound.play(Paths.sound('powerup'), 0.5, false);
						}else if(boyfriend.curCharacter.startsWith('sonic')){
						FlxG.sound.play(Paths.sound('Ring'));	
						}
					cccVidaCounter++;
					}
				}

			if (!note.isSustainNote && ((isRing && note.noteData != 2) || !isRing))
			{
				popUpScore(note);
				combo += 1;
				if(combo > 9999) combo = 9999;

				if(curSong.toLowerCase()=='cross-console-clash'){
					sonicHUDCCC.updateScoreText();
				}
			}
			if (isRing && note.noteData == 2)
				{
					cNum += 1;
					FlxG.sound.play(Paths.sound('Ring'));
				}
			if(canRegen){
			health += note.hitHealth;
			}

			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';
	
				var animToPlay:String = '';
			if (PlayState.isRing){
				switch (Std.int(Math.abs(note.noteData)))
				{
					case 0:
						animToPlay = 'singLEFT';
					case 1:
						animToPlay = 'singDOWN';
					case 2:
						animToPlay = 'none';
					case 3:
						animToPlay = 'singUP';
					case 4:
						animToPlay = 'singRIGHT';
				}
			}else{
				switch (Std.int(Math.abs(note.noteData)))
				{
					case 0:
						animToPlay = 'singLEFT';
					case 1:
						animToPlay = 'singDOWN';
					case 2:
						animToPlay = 'singUP';
					case 3:
						animToPlay = 'singRIGHT';
				}
			}

				if(note.noteType == 'GF Sing' || note.noteType == 'player3') {
					gf.playAnim(animToPlay + daAlt, true);
					gf.holdTimer = 0;
				} else if (animToPlay != 'none') {
					boyfriend.playAnim(animToPlay + daAlt, true);
					boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
	
					if(gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled || note.noteType == 'player3') {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}				
			if (isRing){
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 5, time);
			}else if (note.noteType != 'player3' && note.noteData < 8){
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
			} else {
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time, true);
			}
			} else {
				playerStrums.forEach(function(spr:StrumNote)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.playAnim('confirm', true);
					}
				});
			}
			note.wasGoodHit = true;
			vocals.volume = 1;
			if(!SONG.needsVoices){
				//FlxG.sound.volume = 1;
			}

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}


	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {	
		
		var skin:String = PlayState.SONG.splashSkin;
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		if (curStep < 0){
			splash.alpha = 0;
		} else {
			splash.alpha = 1;
		}
		if(majinstrums){
			splash.color = 0xFF5500B6;
		}
		if (nomehistorico.toLowerCase() == 'caos' && curStep > 1007){
			splash.color = 0xFFEEFF00;
		}
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
			gf.specialAnim = true;
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.danced = false; //Sets head to the correct position once the animation ends
		gf.playAnim('hairFall');
		gf.specialAnim = true;
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}
		if(gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}	
		function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];
		super.destroy();
	}

	public function cancelFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;

	override function stepHit()
	{
			
			super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);

		if(curSong.toLowerCase()=='cross-console-clash' && cccMiss)
		if (curStep % 2 == 0){
			boyfriend.visible = false;
		} else{
			boyfriend.visible = true;
		}

		//EVENTOS LASTSTEP
		if(curSong.toLowerCase()=='endless' && curStep == 1289 && !cpuControlled)
			startachieving("fisk");

		if (curSong.toLowerCase() == 'prey' && curStep > 4490 && canuseevents == false)
			canuseevents = true;


		if (curSong == 'faker')
			{
				switch (curStep)
				{ //Le saida fácil para um problema fácil, só que deveras chato de resolver.
					case 787, 795, 902, 800, 811, 819, 823, 827, 832, 835, 839, 847:
						doStaticSign(0, false);
					case 768:
						FlxTween.tween(camHUD, {alpha: 0}, 1);
					case 801: // 800
						add(fakertransform);
						fakertransform.setPosition(dad.getGraphicMidpoint().x - 460, dad.getGraphicMidpoint().y - 700);
						fakertransform.x += 20;
						fakertransform.y += 128;
						fakertransform.alpha = 1;
						dad.visible = false;
						fakertransform.animation.play('1');
					case 824: // 824
						fakertransform.setPosition(dad.getGraphicMidpoint().x - 460, dad.getGraphicMidpoint().y - 700);
						fakertransform.x += -19;
						fakertransform.y += 138;
						fakertransform.animation.play('2');
					case 836: // 836
						fakertransform.setPosition(dad.getGraphicMidpoint().x - 460, dad.getGraphicMidpoint().y - 700);
						fakertransform.x += 76;
						fakertransform.y -= 110;
						fakertransform.animation.play('3');
					case 848: // 848
						fakertransform.setPosition(dad.getGraphicMidpoint().x - 460, dad.getGraphicMidpoint().y - 700);
						fakertransform.x += -110;
						fakertransform.y += 318;
						fakertransform.animation.play('4');
					case 881:
						add(blackFuck);
						blackFuck.alpha = 1;
						blackFuck.visible = true;
				}
				if (curStep > 858 && curStep < 884)
					doStaticSign(0, false); // Honestly quite incredible
			}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			#if debug
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			#end
			return;
		}

		if(cccVidaCounter == 0 && boyfriend.curCharacter.startsWith('sonic') && curSong.toLowerCase()=='cross-console-clash'){
			if (curBeat % 2 == 0){
				SonicHUDCCC.ringsText.color = FlxColor.RED;
			} else{
				SonicHUDCCC.ringsText.color = FlxColor.YELLOW;
			}
		} else if (boyfriend.curCharacter.startsWith('sonic') && curSong.toLowerCase()=='cross-console-clash'){
			SonicHUDCCC.ringsText.color = FlxColor.YELLOW;
		}

		if (curBeat == 162 && curSong.toLowerCase() == 'cross-console-clash' && !luigienter)
			{
				luigienter=true;
				triggerEventNote('Change Character', 'gf', 'luigi-ccc'); //Ele roda a 24 FPS por segundo, se a animação dura 0.5 sec então basta com que o luigi tenha 12 frames repetidos e ninguem vai notar a diferença
				//Hopefully ;-;
				gf.x += 200;
				gf.y -=200;
				gf.playAnim("jump", true);
				gf.specialAnim = true;
				FlxTween.tween(gf, {x: GF_X}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(gf, {y: GF_Y}, 0.3, {ease: FlxEase.sineIn, onComplete: function(tween:FlxTween){
				gf.specialAnim = false;
				}});
			}

		
		if (curBeat % 2 == 0 && superZoomShit)
			{
				FlxG.camera.zoom += 0.06;
				camHUD.zoom += 0.08;
			}
	
			if (curBeat % 1 == 0 && supersuperZoomShit)
			{
				FlxG.camera.zoom += 0.06;
				camHUD.zoom += 0.08;
			}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			if((!ClientPrefs.camZooms || SONG.canfollowpermitido || !OpenFlAssets.exists(Paths.getPreloadPath('custom_scripts/camFollowGlobal.lua')))&&curSong.toLowerCase()!='pasta-night') //Apenas pra garantir que nenhum engraçadinho apague isso e fale: Aaaaaaaaa Mas sílvio... A camera tá bugada...
				moveCameraSection(Std.int(curStep / 16));

			//Apenas para evitar conflito entre os dois e pra talvez consertar um uso excessivo de memória com isso.
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing"))
		{
			gf.dance();
		}

		if(curBeat % 2 == 0) {
			if (boyfriend.animation.curAnim.name != null && !boyfriend.animation.curAnim.name.startsWith("sing"))
			{
				boyfriend.dance();
			}
			if (dad.animation.curAnim.name != null && !dad.animation.curAnim.name.startsWith("sing") && !dad.stunned)
			{
				dad.dance();
			}
		} else if(dad.danceIdle && dad.animation.curAnim.name != null && !dad.curCharacter.startsWith('gf') && !dad.animation.curAnim.name.startsWith("sing") && !dad.stunned) {
			dad.dance();
		}

		switch (curStage)
		{
			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);

			case 'starved-pixel':
					furnaceTheEnd.dance(true); //Tu não tá pensando que eu vou meter um furnance parado né?

			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:BGSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat);
		callOnLuas('onBeatHit', []);
	}

	function doP3Static()
		{
			#if debug
			trace('p3static XDXDXD');
			#end
	
			if (FlxG.save.data.flashing) {
	
			daP3Static.frames = Paths.getSparrowAtlas('Phase3Static');
			daP3Static.animation.addByPrefix('P3Static', 'Phase3Static instance 1', 24, false);
	
			daP3Static.screenCenter();
	
			daP3Static.scale.x = 4;
			daP3Static.scale.y = 4;
			daP3Static.alpha = 0.5;
	
			daP3Static.cameras = [camHUD2];
	
			add(daP3Static);
	
			daP3Static.animation.play('P3Static');
	
			daP3Static.animation.finishCallback = function(pog:String)
			{
				#if debug
				trace('ended p3static');
				#end
				daP3Static.alpha = 0;
	
				remove(daP3Static);
			}}
		}
	

	function doSimpleJump()
		{
			#if debug
			trace('SIMPLE JUMPSCARE');
			#end
	
			var simplejump:FlxSprite = new FlxSprite().loadGraphic(Paths.image('PolishedP1/simplejump'));
	
			simplejump.setGraphicSize(FlxG.width, FlxG.height);
	
			simplejump.screenCenter();
	
			simplejump.cameras = [camHUD2];
	
			FlxG.camera.shake(0.0025, 0.50);
	
			add(simplejump);
	
			FlxG.sound.play(Paths.sound('sppok'), 1);
	
			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				trace('ended simple jump');
				remove(simplejump);
			});
	
			// now for static
	
			var daStatic:FlxSprite = new FlxSprite(0, 0);
	
			daStatic.frames = Paths.getSparrowAtlas('daSTAT');
	
			daStatic.setGraphicSize(FlxG.width, FlxG.height);
	
			daStatic.screenCenter();
	
			daStatic.cameras = [camHUD2];
	
			daStatic.animation.addByPrefix('static', 'staticFLASH', 24, false);
	
			add(daStatic);
	
			FlxG.sound.play(Paths.sound('staticBUZZ'));
	
			if (daStatic.alpha != 0)
				daStatic.alpha = FlxG.random.float(0.1, 0.5);
	
			daStatic.animation.play('static');
	
			daStatic.animation.finishCallback = function(pog:String)
			{
				trace('ended static');
				remove(daStatic);
			}
		}

	function doP3JumpTAILS()
	{
		trace('SIMPLE JUMPSCARE');

		var doP3JumpTAILS:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Tails', 'week-xenophanes'));

		doP3JumpTAILS.setGraphicSize(FlxG.width, FlxG.height);

		doP3JumpTAILS.screenCenter();

		doP3JumpTAILS.cameras = [camHUD2];

		FlxG.camera.shake(0.0025, 0.50);
			add(doP3JumpTAILS);

		FlxG.sound.play(Paths.sound('P3Jumps/TailsScreamLOL', 'week-xenophanes'), .1);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
				remove(doP3JumpTAILS);
		});

		balling.frames = Paths.getSparrowAtlas('daSTAT');
		balling.animation.addByPrefix('static', 'staticFLASH', 24, false);

		balling.setGraphicSize(FlxG.width, FlxG.height);

		balling.screenCenter();

		balling.cameras = [camHUD2];

		add(balling);

		FlxG.sound.play(Paths.sound('staticBUZZ'));

		if (balling.alpha != 0)
			balling.alpha = FlxG.random.float(0.1, 0.5);

		balling.animation.play('static');

		balling.animation.finishCallback = function(pog:String)
		{
			trace('ended static');
			remove(balling);
		}
	}

	function doP3JumpKNUCKLES()
	{
		trace('SIMPLE JUMPSCARE');

		var doP3JumpKNUCKLES:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Knuckles', 'week-xenophanes'));

		doP3JumpKNUCKLES.setGraphicSize(FlxG.width, FlxG.height);

		doP3JumpKNUCKLES.screenCenter();

		doP3JumpKNUCKLES.cameras = [camHUD2];

		FlxG.camera.shake(0.0025, 0.50);

		add(doP3JumpKNUCKLES);

		FlxG.sound.play(Paths.sound('P3Jumps/KnucklesScreamLOL', 'week-xenophanes'), .1);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			trace('ended simple jump');
			remove(doP3JumpKNUCKLES);
		});

		balling.frames = Paths.getSparrowAtlas('daSTAT');

		balling.setGraphicSize(FlxG.width, FlxG.height);

		balling.screenCenter();

		balling.cameras = [camHUD2];

		balling.animation.addByPrefix('static', 'staticFLASH', 24, false);

		add(balling);

		FlxG.sound.play(Paths.sound('staticBUZZ'));

		if (balling.alpha != 0)
			balling.alpha = FlxG.random.float(0.1, 0.5);

		balling.animation.play('static');

		balling.animation.finishCallback = function(pog:String)
		{
			trace('ended static');
			remove(balling);
		}
	}

	function doP3JumpEGGMAN()
	{
		trace('SIMPLE JUMPSCARE');

		var doP3JumpEGGMAN:FlxSprite = new FlxSprite().loadGraphic(Paths.image('eggman', 'week-xenophanes'));

		doP3JumpEGGMAN.setGraphicSize(FlxG.width, FlxG.height);

		doP3JumpEGGMAN.screenCenter();

		doP3JumpEGGMAN.cameras = [camHUD2];

		FlxG.camera.shake(0.0025, 0.50);

		add(doP3JumpEGGMAN);

		FlxG.sound.play(Paths.sound('P3Jumps/EggmanScreamLOL', 'week-xenophanes'), .1);

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			trace('ended simple jump');
			remove(doP3JumpEGGMAN);
		});

		balling.frames = Paths.getSparrowAtlas('daSTAT');

		balling.setGraphicSize(FlxG.width, FlxG.height);

		balling.screenCenter();

		balling.cameras = [camHUD2];

		balling.animation.addByPrefix('static', 'staticFLASH', 24, false);

		add(balling);

		FlxG.sound.play(Paths.sound('staticBUZZ'));

		if (balling.alpha != 0)
			balling.alpha = FlxG.random.float(0.1, 0.5);

		balling.animation.play('static');

		balling.animation.finishCallback = function(pog:String)
		{
			#if debug
			trace('ended static');
			#end
			remove(balling);
		}
	}

	function spirospreidi()
		{
			strumLineNotes.forEach(function(tospin:FlxSprite)
				{
					FlxTween.angle(tospin, 0, 360, 0.2, {ease: FlxEase.quintOut});
				});
			if (majinstrums){
				FlxTween.angle(infinitesimbol, 0, 180, 0.2, {ease: FlxEase.quintOut}); //haha, simetria massa.
			}
		}

	function removeStatics()
		{
			playerStrums.forEach(function(todel:StrumNote)
			{
				playerStrums.remove(todel);
				todel.destroy();
			});
			if(!ClientPrefs.middleScroll){
			opponentStrums.forEach(function(todel:StrumNote)
			{
				opponentStrums.remove(todel);
				todel.destroy();
			});
			thirdplayerStrums.forEach(function(todel:StrumNote)
			{
				thirdplayerStrums.remove(todel);
				todel.destroy();
			});
			}
			strumLineNotes.forEach(function(todel:StrumNote)
			{
				strumLineNotes.remove(todel);
				todel.destroy();
			});
		}

		public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
			var returnVal:Dynamic = FunkinLua.Function_Continue;
			#if LUA_ALLOWED
			for (i in 0...luaArray.length) {
				var ret:Dynamic = luaArray[i].call(event, args);
				if(ret != FunkinLua.Function_Continue) {
					returnVal = ret;
				}
			}
			#end
			return returnVal;
		}
	
		public function setOnLuas(variable:String, arg:Dynamic) {
			#if LUA_ALLOWED
			for (i in 0...luaArray.length) {
				luaArray[i].set(variable, arg);
			}
			#end
		}

	function doJumpscare()
		{
			#if debug
			trace('JUMPSCARE aaaa');
			#end
	
			daJumpscare.frames = Paths.getSparrowAtlas('PolishedP1/sonicJUMPSCARE');
			daJumpscare.animation.addByPrefix('jump', 'sonicSPOOK', 24, false);
	
			daJumpscare.screenCenter();
	
			daJumpscare.scale.x = 1.1;
			daJumpscare.scale.y = 1.1;
	
			daJumpscare.y += 370;
	
			daJumpscare.cameras = [camHUD2];
	
			jumpscareSound.play();
			jumpscareAuxiliar.play();
	
			add(daJumpscare);
	
			daJumpscare.animation.play('jump');
	
			daJumpscare.animation.finishCallback = function(pog:String)
			{
				#if debug
				trace('ended jump');
				#end
				remove(daJumpscare);
			}
		}

		function staticHitMiss()
			{
				if (ClientPrefs.flashing){
				#if debug
				trace('lol you missed the static note!');
				#end
				daNoteStatic = new FlxSprite(0, 0);
				daNoteStatic.frames = Paths.getSparrowAtlas('hitStatic');
		
				daNoteStatic.setGraphicSize(FlxG.width, FlxG.height);
		
				daNoteStatic.screenCenter();
		
				daNoteStatic.cameras = [camHUD2];
		
				daNoteStatic.animation.addByPrefix('static', 'staticANIMATION', 24, false);
		
				daNoteStatic.animation.play('static', true);
				
				
					FlxG.sound.play(Paths.sound("hitStatic1"));
				
				
					add(daNoteStatic);
		
				new FlxTimer().start(.15, function(trol:FlxTimer) // here we go again...
				{
					daNoteStatic.alpha = 0;
					#if debug
					trace('ended HITSTATICLAWL');
					#end
					remove(daNoteStatic);
				});
		
		
		
			}
			}

	function doStaticSign(lestatic:Int = 0, leopa:Bool = true) //ToDo: Aumentar o tempo de duração disso.
		{
			#if debug
			trace('static MOMENT HAHAHAH ' + lestatic);
			#end
			var daStatic:FlxSprite = new FlxSprite(0, 0);
	
			daStatic.frames = Paths.getSparrowAtlas('daSTAT', 'preload');

			daStatic.scale.x = 3.19;
			daStatic.scale.y = 2.41;

			daStatic.cameras = [camHUD2];
	
			daStatic.setGraphicSize(FlxG.width, FlxG.height);
	
			daStatic.screenCenter(XY);

	
			switch (lestatic)
			{
				case 0:
					daStatic.animation.addByPrefix('static', 'staticFLASH', 24, false); //This should do it
				case 1:
					daStatic.animation.addByPrefix('static', 'staticFLASH', 16, false); //Para a YCR especificamente
			}
			add(daStatic);
	
			FlxG.sound.play(Paths.sound('staticBUZZ'), 0.8);
	
			if (leopa)
			{
				if (daStatic.alpha != 0)
					daStatic.alpha = FlxG.random.float(0.1, 0.5);
			}
			else
				daStatic.alpha = 1;
	
			daStatic.animation.play('static');
	
			daStatic.animation.finishCallback = function(pog:String)
			{
				#if debug
				trace('ended static');
				#end
				remove(daStatic);
			}
		}
	
	

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float, extraStrum:Bool = false) {
		var spr:StrumNote = null;
		if(isDad && !extraStrum) {
			spr = strumLineNotes.members[id];
		} else if (extraStrum){
			spr = thirdplayerStrums.members[id % 4];
		}else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public function startachieving(nome:String){ //Isso aqui só deve ser usado para achievements do meio da música
		var id:Int = Achievements.getAchievementIndex(nome);
		if(!Achievements.isAchievementUnlocked(nome)) {
			Achievements.unlockAchievement(nome);
			startAchievement(nome);
			//Basicamente serve para garantir que o achievement seja salvo na hora que ele é desbloqueado no meio da música, e não apenas caso você zere a musica (evitar frustrações sacas?)
		} else{
			#if debug
			trace('conquista '+nome+' já desbloqueada');
			#end
		}
	}

	public var ratingString:String;
	public var ratingPercent:Float;
	public function RecalculateRating() {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('ghostMisses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop) {
			ratingPercent = songScore / (songHits*300);
			if(!Math.isNaN(ratingPercent) && ratingPercent < 0) ratingPercent = 0;

			if(Math.isNaN(ratingPercent)) {
				ratingString = '?';
			} else if(ratingPercent >= 1) {
				ratingPercent = 1;
				ratingString = ratingStuff[ratingStuff.length-1][0]; //Uses last string
			} else {
				for (i in 0...ratingStuff.length-1) {
					if(ratingPercent < ratingStuff[i][1]) {
						ratingString = ratingStuff[i][0];
						break;
					}
				}
			}

			setOnLuas('rating', ratingPercent);
			setOnLuas('ratingName', ratingString);
		}
	}

	function endingTweens(sprite:String = 'good_ending'){ //Tive que usar 80% do qi pra arrumar isso...
		//Talvez isso seja útil pra mais coisas...
		endingIndicator.loadGraphic(Paths.image(sprite));
		endingIndicator.updateHitbox();
		endingIndicator.screenCenter();
		FlxTween.tween(endingIndicator, {alpha: 1}, 1, {ease: FlxEase.expoInOut, 
			onComplete: function(twn:FlxTween) {
				new FlxTimer().start(0.5, function(trol:FlxTimer) // here we go again...
				{
				FlxTween.tween(endingIndicator, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
				});
			}});
	}

	function cinematicBars(appear:Bool) //IF (TRUE) MOMENT?????
	{
		if (appear)
		{
			add(topBar);
			add(bottomBar);
			FlxTween.tween(topBar, {y: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(bottomBar, {y: 550}, 0.5, {ease: FlxEase.quadOut});
		}
		else
		{
			FlxTween.tween(topBar, {y: -170}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(bottomBar, {y: 720}, 0.5, {ease: FlxEase.quadOut, onComplete: function(fuckme:FlxTween)
			{
				remove(topBar);
				remove(bottomBar);
			}});
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String>):String {
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName)) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					//Algumas anotações para quando programar os achivements:
						//Essa outra parte é só para os achievements que são desbloqueados apenas no final da musica.
						//Outra coisa, os desbloqueios colocados aqui serão notificados só ao final da musica.
						//Caso queira que o desbloqueio aconteça durante a música, deverá usar o startachieving
					case 'toastie':
						if(ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) {
							unlock = true;
						}
					case 'besties':
						if(SONG.song.toLowerCase() == 'too-fest' && !usedPractice && !cpuControlled) {
							unlock = true;
						}
					case 'toofest_fc':
						if(SONG.song.toLowerCase() == 'too-fest' && !usedPractice && !cpuControlled && songMisses == 0) {
							unlock = true;
						}
					case 'perfect':
						if(!usedPractice && !cpuControlled && songMisses == 0 && curSong.toLowerCase()!='soulless') {
							unlock = true;
						}
					case 'fake_full_combo':
						if(!usedPractice && !cpuControlled && songMisses == 0 && curSong.toLowerCase()=='soulless') {
							unlock = true;
						}
					case 'bye_bye_fc':
						if(SONG.song.toLowerCase() == 'cycles' && !usedPractice && !cpuControlled && songMisses == 0) {
							unlock = true;
						}
					case 'natal':
						if(SONG.song.toLowerCase() == 'slaybells' && !usedPractice && !cpuControlled) {
							unlock = true;
						}
					case 'sidekick':
						if(SONG.song.toLowerCase() == 'sidekick' && !usedPractice && !cpuControlled) {
							unlock = true;
						}
					case 'personel_clear':
						if(SONG.song.toLowerCase() == 'personel' && !usedPractice && !cpuControlled) {
							unlock = true;
						}
					case 'control_fc':
						if(SONG.song.toLowerCase() == 'control' && !usedPractice && !cpuControlled && ControlSongSubstate.gifPermitido) {
							unlock = true;
						}
					case 'chaos_bot':
						if(SONG.song.toLowerCase() == 'chaos' && cpuControlled) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = 0;
	var curLightEvent:Int = 0;
}

// code da you cant run porém em comentários pois pode dar erros e não tenho assets
/*
function endSong() {

	if (SONG.song.toLowerCase() == 'you-cant-run') 
	{
		var sonicMedo:FlxSprite = new FlxSprite().loadGraphic(Paths.image("sonic"));
		add(sonicMedo);

		FlxG.log.add("Adicionando as mensagens do vírus");
		lime.app.Application.current.window.alert("I AM GOD", "I can see you.");
		lime.app.Application.current.window.alert("YOU CANT RUN", ".");
		lime.app.Application.current.window.alert("...---...", "You're too slow. Want to try again?");
		MusicBeatState.switchState(new FreeplayState());

	}

}
*/
