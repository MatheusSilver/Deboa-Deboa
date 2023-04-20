package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
#if desktop
import Discord.DiscordClient;
#end

class MenuPreHistoria extends MusicBeatState
{
	var apertavel:Bool = false;

	public static var returnedfromsubstate:Bool = false;
	public static var bigmenu:FlxSprite;
	//Eu acho que tenho um probleminha...
	//Na real... Eu só fiquei muito puto fazendo esse menu, mas no fim deu bom, PONTO PRA GRIFINÓRIA!
	var bgSprite:FlxSprite;
	var perfilSprite:FlxSprite;

	public static var curWeek:Int = 0;
	public static var curSave:String;
	var lockedWeeks:Array<Bool> = new Array<Bool>();
	var lockSprite:FlxSprite;
	var blackLock:FlxSprite;
	public static var instance:MenuPreHistoria;

	var blackbarup:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 53, FlxColor.BLACK);
	var blackbardown:FlxSprite = new FlxSprite(0, FlxG.height - 53).makeGraphic(FlxG.width, 53, FlxColor.BLACK);
	
	override function create()
	{
		instance = this;
		verifySave();
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('newmenu'), 0);
		}
		if(FlxG.sound.music.volume==0) {
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		//FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));
		MenuHistoria.curSelected = 0;
		PlayState.modohistoria = false;
		#if !mobile
		FlxG.mouse.visible = false;
		#end
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		bgSprite = new FlxSprite(-1000, 0);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		bigmenu = new FlxSprite(-1000, 0);
		bigmenu.antialiasing = ClientPrefs.globalAntialiasing;
		perfilSprite = new FlxSprite(-1000, 0);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
		lockSprite = new FlxSprite(0, 0);
		lockSprite.loadGraphic(Paths.image("Story_Mode/lock", 'preload'));
		lockSprite.screenCenter(XY);
		lockSprite.antialiasing = ClientPrefs.globalAntialiasing;
		lockSprite.alpha=0;

		blackLock = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackLock.alpha=0;

		add(bigmenu);
		add(bgSprite);
		add(blackbarup);
		add(blackbardown);
		add(perfilSprite);
		add(blackLock);
		add(lockSprite);

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		if(lockedWeeks[curWeek] == true)
			{
				flixel.tweens.FlxTween.tween(lockSprite, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
				flixel.tweens.FlxTween.tween(blackLock, {alpha: 0.55}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
			}
		else
			{
				flixel.tweens.FlxTween.tween(lockSprite, {alpha: 0}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
				flixel.tweens.FlxTween.tween(blackLock, {alpha: 0}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
			}
		super.create();
	}

	function verifySave()
		{
			var save:Array<String> = curSave.split(",");
			for (s in save) 
			{
				if(s!="0")
					{
						lockedWeeks.push(false);
					}
				else
					{
						lockedWeeks.push(true);
					}
			}
			trace(lockedWeeks);
			trace(curSave);
		}

	public static function addProgress(qual:String)
		{
			var saveArray:Array<Int> = curSave.split(",").map(function(s:String):Int { return Std.parseInt(s); });
			if(qual == "outro")
				{
					if(curWeek+1 < saveArray.length && saveArray[curWeek+1]==0)
						{
							saveArray[curWeek+1]++;
						}
				}
			else
				{
					saveArray[curWeek]++;
				}
			curSave = saveArray.join(",");
			trace(saveArray);
			if(GJClient.logged)
				{
					GameJoltLoginState.syncProgress();
				}
			else
				{
					FlxG.save.data.progress = MenuPreHistoria.curSave;
				}
		}

	override function closeSubState() {
		changeWeek();
		movedBack = false;
		selectedWeek = false;
		stopspamming = false; //Super legal :,) Legal demais..................
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		#if desktop
		DiscordClient.changePresence("Pensando em joojar a Week: ", WeekData.weeksList[curWeek], null);
		#end

		if (!movedBack && !selectedWeek)
		{
			if (controls.UI_LEFT_P && apertavel) //silver bulinho kekekek, não saber a diferença entre || e && ;-;
			{
				changeWeek(-1);
				GlobalSoundManager.play('scrollMenu');
			}

			if (controls.UI_RIGHT_P && apertavel)
			{
				changeWeek(1);
				GlobalSoundManager.play('scrollMenu');
			}

			if (controls.ACCEPT && apertavel #if !debug && lockedWeeks[curWeek] != true #end)
			{
				selectWeek();
			}
			#if !debug
			else if(controls.ACCEPT && apertavel && lockedWeeks[curWeek] == true)
				{
					GlobalSoundManager.play('negado');
				}
			#end
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			GlobalSoundManager.play('cancelMenu');
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
				GlobalSoundManager.play('confirmMenu');
				stopspamming = true;
			}

			selectedWeek = true;

			MenuHistoria.dapreselected = WeekData.weeksList[curWeek];

			//Teoricamente, isso deve fazer com que o menu se desfaça uma última vez e dê lugar ao menu de historia...
			

			//ALO TEGER, MANDA UM SALVE!!!
			var weekescolhida:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
			var assetName:String = weekescolhida.weekBackground;
			if(OpenFlAssets.exists(Paths.imagechecker("scrolling/scroll-" + assetName + "/scroll-" + weekescolhida.songs[0][0].toLowerCase() + " (back)", 'preload'))) {
				bigmenu.loadGraphic(Paths.image("scrolling/scroll-" + assetName + "/scroll-" + weekescolhida.songs[0][0].toLowerCase() + " (back)", 'preload'));
			} else {
				FlxG.log.warn('Não foi possível achar ' + Paths.image("scrolling/scroll-" + assetName + "/scroll-" + weekescolhida.songs[0][0].toLowerCase() + " (back)", 'preload'));
				bigmenu.loadGraphic('assets/images/menuDesat.png');
			}
			bigmenu.setGraphicSize(FlxG.width, FlxG.height);
			bigmenu.screenCenter(XY);
			FlxTween.tween(blackbarup, {y: 0 - blackbarup.height}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(blackbardown, {y: FlxG.height}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(bgSprite, {x: 0 - bgSprite.width}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(perfilSprite, {x: FlxG.width + perfilSprite.width}, 1, {ease: FlxEase.expoInOut});
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				openSubState(new MenuHistoria());
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

		
		if(lockedWeeks[curWeek] == true)
			{
				flixel.tweens.FlxTween.tween(lockSprite, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
				flixel.tweens.FlxTween.tween(blackLock, {alpha: 0.55}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
			}
		else
			{
				flixel.tweens.FlxTween.tween(lockSprite, {alpha: 0}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
				flixel.tweens.FlxTween.tween(blackLock, {alpha: 0}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
			}

		PlayState.storyWeek = curWeek;

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
		WeekData.setDirectoryFromWeek(leWeek);

		bgSprite.visible = true;
		perfilSprite.visible = true;
		blackbarup.visible = true;
		blackbardown.visible = true;
		var assetName:String = leWeek.weekBackground;
			if(OpenFlAssets.exists(Paths.imagechecker("Story_Mode/BG_" + assetName, 'preload'))) { //anti crashing moment 
				bgSprite.loadGraphic(Paths.image("Story_Mode/BG_" + assetName, 'preload'));
			} else {
				FlxG.log.warn('Não foi possível achar ' + "assets/images/Story_Mode/BG_" + assetName);
				bgSprite.loadGraphic('assets/images/menuDesat.png');
			}
			if(OpenFlAssets.exists(Paths.imagechecker("Story_Mode/PERFIL" + assetName, 'preload'))) { //anti crashing moment 
				perfilSprite.loadGraphic(Paths.image("Story_Mode/PERFIL" + assetName, 'preload')); 
				//PQP EU SOU MUITO BURRO... Ass:Silvio
			} else {
				FlxG.log.warn('Não foi possível achar ' + "Story_Mode/PERFIL" + assetName);
			}

			bgSprite.setGraphicSize(FlxG.width);
			bgSprite.screenCenter(XY);
			perfilSprite.updateHitbox();

		if(OpenFlAssets.exists(Paths.imagechecker("Story_Mode/Linha" + assetName))) { //anti crashing moment 
			blackbardown.loadGraphic(Paths.image("Story_Mode/Linha" + assetName));
		} else {
			blackbardown.makeGraphic(FlxG.width, 53, FlxColor.BLACK);
		}
		if(OpenFlAssets.exists(Paths.imagechecker("Story_Mode/LinhaUP_" + assetName))) { //anti crashing moment 
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
				bigmenu.setGraphicSize(FlxG.width);
				bigmenu.screenCenter(XY);
				bigmenu.alpha = 1;
			}
		});
		//EU DEFINITIVAMENTE NÃO QUERO FALAR SOBRE ESTE CODE... Ass: Sílvio
	}
}