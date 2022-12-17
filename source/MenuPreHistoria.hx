package;

import flixel.input.mouse.FlxMouseButton;
import flixel.ui.FlxButton;
import flixel.tweens.FlxEase;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxSprite;
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

class MenuPreHistoria extends MusicBeatState
{
	var apertavel:Bool = false;

	var bigmenu:FlxSprite;
	//Eu acho que tenho um probleminha...
	//Na real... Eu só fiquei muito puto fazendo esse menu, mas no fim deu bom, PONTO PRA GRIFINÓRIA!
	var bgSprite:FlxSprite;
	var perfilSprite:FlxSprite;

	private static var curWeek:Int = 0;

	var blackbarup:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 53, FlxColor.BLACK);
	var blackbardown:FlxSprite = new FlxSprite(0, FlxG.height - 53).makeGraphic(FlxG.width, 53, FlxColor.BLACK);
	
	override function create()
	{
		#if !mobile
		FlxG.mouse.visible = false;
		#end
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		bgSprite = new FlxSprite(0, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		bigmenu = new FlxSprite(0, 0);
		bigmenu.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(0, 0);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));

		add(bigmenu);
		add(bgSprite);
		add(blackbarup);
		add(blackbardown);
		add(perfilSprite);

		changeWeek();

		#if mobileC
		addVirtualPad(UP_DOWN, A_B);
		#end
		super.create();
	}

	override function update(elapsed:Float)
	{
		#if desktop
		DiscordClient.changePresence("Pensando em joojar a Week: " + WeekData.weeksList[curWeek], null);
		#end

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_LEFT_P && apertavel) //silver bulinho kekekek, não saber a diferença entre || e && ;-;
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_RIGHT_P && apertavel)
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
				stopspamming = true;
			}

			selectedWeek = true;

			var botaoselect = WeekData.weeksList[curWeek];
			FreeplayState.dapreselected = botaoselect;
			
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
			MusicBeatState.switchState(new MenuHistoria());
			});
		}

	public function changeWeek(change:Int = 0):Void
	{
		apertavel = false;
		curWeek += change;

		if (curWeek >= WeekData.weeksList.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = WeekData.weeksList.length - 1;

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
		WeekData.setDirectoryFromWeek(leWeek);

		bgSprite.visible = true;
		perfilSprite.visible = true;
		blackbarup.visible = true;
		blackbardown.visible = true;
		var assetName:String = leWeek.weekBackground;
			if(OpenFlAssets.exists(Paths.image("Story_Mode/BG_" + assetName, 'preload'))) { //anti crashing moment 
				bgSprite.loadGraphic(Paths.image("Story_Mode/BG_" + assetName, 'preload'));
			} else {
				FlxG.log.warn('Não foi possível achar ' + "assets/images/Story_Mode/BG_" + assetName);
				bgSprite.loadGraphic('assets/images/menuDesat.png');
			}
			if(OpenFlAssets.exists(Paths.image("Story_Mode/PERFIL" + assetName, 'preload'))) { //anti crashing moment 
				perfilSprite.loadGraphic(Paths.image("Story_Mode/PERFIL" + assetName, 'preload')); 
				//PQP EU SOU MUITO BURRO... Ass:Silvio
			} else {
				FlxG.log.warn('Não foi possível achar ' + "Story_Mode/PERFIL" + assetName);
			}
			bigmenu.setGraphicSize(FlxG.width);
			bigmenu.screenCenter(XY);
			bgSprite.setGraphicSize(FlxG.width);
			bgSprite.screenCenter(XY);
			perfilSprite.updateHitbox();

		if(OpenFlAssets.exists(Paths.image("Story_Mode/Linha" + assetName))) { //anti crashing moment 
			blackbardown.loadGraphic(Paths.image("Story_Mode/Linha" + assetName));
		} else {
			blackbardown.makeGraphic(FlxG.width, 53, FlxColor.BLACK);
		}
		if(OpenFlAssets.exists(Paths.image("Story_Mode/LinhaUP_" + assetName))) { //anti crashing moment 
			blackbarup.loadGraphic(Paths.image("Story_Mode/LinhaUP_" + assetName));
		} else {
			blackbarup.makeGraphic(FlxG.width, 53, FlxColor.BLACK);
			FlxG.log.warn('Não foi possível achar ' + Paths.image("Story_Mode/LinhaUP_" + assetName));
		}

		perfilSprite.x = FlxG.width;
		perfilSprite.y = 0;
		bgSprite.x = 0 - bgSprite.width;
		blackbarup.y = 0 - blackbarup.height;
		blackbardown.y = FlxG.height;

		var curtimer:Float = 0.5; //Por pura preguiça de trocar isso o tempo todo...
		FlxTween.tween(blackbarup, {y: 0}, curtimer, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackbardown, {y: FlxG.height - 53}, curtimer, {ease: FlxEase.expoInOut});
		FlxTween.tween(bgSprite, {x: 0}, curtimer, {ease: FlxEase.expoInOut});
		FlxTween.tween(perfilSprite, {x: FlxG.width - perfilSprite.width}, curtimer, {ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween) {
				apertavel = true; //Só pra garantir que a animação de entrada NÃO ocorra ao mesmo tempo que a de saida.
				bigmenu.loadGraphic(Paths.image("Story_Mode/BIGMENU_" + assetName, 'preload'));
			}
		});
		//EU DEFINITIVAMENTE NÃO QUERO FALAR SOBRE ESTE CODE... Ass: Sílvio
	}
}