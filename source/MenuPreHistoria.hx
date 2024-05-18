package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;
import gamejolt.*;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class MenuPreHistoria extends MusicBeatState
{
	var apertavel:Bool = false;

	public static var returnedfromsubstate:Bool = false;
	public static var old_bg:FlxSprite=new FlxSprite();
	private var old_perfil:FlxSprite=new FlxSprite();
	private var old_linha_up:FlxSprite=new FlxSprite();
	private var old_linha_down:FlxSprite=new FlxSprite();
	public static var maintainVisible:Bool = false;

	// Eu acho que tenho um probleminha...
	// Na real... Eu só fiquei muito puto fazendo esse menu, mas no fim deu bom, PONTO PRA GRIFINÓRIA!
	var bgSprite:FlxSprite;
	var perfilSprite:FlxSprite;

	public static var curWeek:Int = 0;
	public static var curSave:String;

	var lockedWeeks:Array<Bool> = new Array<Bool>();
	var lockSprite:FlxSprite;
	var blackLock:FlxSprite;

	public static var makeAnimUnlock:Bool = false;
	public static var weekAnimNum:Int = 0;
	public static var firstTime:Bool = true;

	public static var instance:MenuPreHistoria;

	var blackbarup:FlxSprite = new FlxSprite();
	var blackbardown:FlxSprite = new FlxSprite(0, FlxG.height - 53).makeGraphic(FlxG.width, 53, FlxColor.BLACK);

	override function create()
	{
		instance = this;
		verifySave();
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		}
		if (FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		// FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));

		PlayState.modohistoria = false;
		Main.mouse_allowed = false;
		Metadata.WeekData.reloadWeekFiles(true);
		if (curWeek >= Metadata.WeekData.weeksList.length)
			curWeek = 0;

		bgSprite = new FlxSprite(-1000, 0);
		bgSprite.alpha = 1;
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

		old_bg = new FlxSprite(-1000, 0);
		old_bg.antialiasing = ClientPrefs.globalAntialiasing;
		
		perfilSprite = new FlxSprite(-1000, 0);
		perfilSprite.antialiasing = ClientPrefs.globalAntialiasing;

		Metadata.WeekData.setDirectoryFromWeek(Metadata.WeekData.weeksLoaded.get(Metadata.WeekData.weeksList[0]));
		lockSprite = new FlxSprite(0, 0);
		lockSprite.loadGraphic(Paths.image("Story_Mode/lock", 'preload'));
		lockSprite.screenCenter(XY);
		lockSprite.antialiasing = ClientPrefs.globalAntialiasing;
		lockSprite.alpha = 0;

		blackLock = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackLock.alpha = 0;

		add(old_bg);
		add(old_linha_down);
		add(old_linha_up);
		add(old_perfil);
		old_bg.visible = old_linha_down.visible=old_linha_up.visible=old_perfil.visible =false;
		
		add(bgSprite);
		add(blackbarup);
		add(blackbardown);
		add(perfilSprite);
		bgSprite.visible = blackbarup.visible=blackbardown.visible=perfilSprite.visible =false;
		
		add(blackLock);
		add(lockSprite);

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		if (lockedWeeks[curWeek] == true)
		{
			flixel.tweens.FlxTween.tween(lockSprite, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
			flixel.tweens.FlxTween.tween(blackLock, {alpha: 0.55}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
		}
		else if (lockedWeeks[curWeek] == false)
		{
			if (makeAnimUnlock)
			{
				lockSprite.alpha = 0;
				blackLock.alpha = 0;
			}
			else
			{
				flixel.tweens.FlxTween.tween(lockSprite, {alpha: 0}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
				flixel.tweens.FlxTween.tween(blackLock, {alpha: 0}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
			}
		}

		if (makeAnimUnlock)
		{
			curWeek = weekAnimNum;
		}

		changeWeek(); //Por algum motivo que sei lá qual, a função closesubstate era chamada também
		//Logo, não precisa disso aqui.

		//Precisa disso pra voltar do playstate.
		super.create();
	}

	

	function verifySave()
	{
		var save:Array<String> = curSave.split(",");
		for (s in save)
		{
			if (s != "0")
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
		// eu sou mto burro pq eu fiz isso aqui desse jeito socorro pq aaaaaaaaaaaaa
		var saveArray:Array<Int> = curSave.split(",").map(function(s:String):Int
		{
			return Std.parseInt(s);
		});
		if (qual == "outro")
		{
			if (curWeek + 1 < saveArray.length && saveArray[curWeek + 1] == 0)
			{
				makeAnimUnlock = true; // precisa disso pra dar block no input e tbm pra saber quando que pode mudar de coiso
				saveArray[curWeek + 1]++;
				weekAnimNum = curWeek + 1;
			}
		}
		else
		{
			saveArray[curWeek]++;
		}
		curSave = saveArray.join(",");
		trace(saveArray);
		if (GJClient.logged)
			{
				GameJoltLoginState.syncProgress();
			}
			else
			{
				FlxG.save.data.progress = MenuPreHistoria.curSave;
			}
	}

	override function closeSubState()
	{
		// changeWeek(); Mas não precisa disso aqui.
		movedBack = false;
		selectedWeek = false;
		stopspamming = false; // Super legal :,) Legal demais..................
		super.closeSubState();
	}

	var inCut:Bool = false;

	override function update(elapsed:Float)
	{
		#if rpc
		DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_pre_story","rpc")+" ", Linguagem.LangUtil.getString("rpc_week_label_"+Metadata.WeekData.weeksList[curWeek].toLowerCase(),"rpc"), null);
		#end

		if (makeAnimUnlock && !inCut && apertavel && !movedBack && !selectedWeek)
		{
			inCut = true;
			blackLock.alpha = 0.55;
			lockSprite.alpha = 1;

			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('unlocked'), 1);
				if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 0.5);
				FlxG.camera.shake(0.04, 0.43);
				blackLock.alpha = 0;
				lockSprite.alpha = 0;

				new FlxTimer().start(0.7, function(tmr:FlxTimer)
				{
					inCut = false;
					makeAnimUnlock = false;
				});
			});
		}
		if (!movedBack && !selectedWeek && !makeAnimUnlock)
		{
			if (Main.getMouseVisibility()){
				//Deixar só pro mobile depois
				#if desktop
				if(FlxG.mouse.wheel != 0 && apertavel){
					changeWeek(Utils.CoolUtil.mathClamp(FlxG.mouse.wheel,-1,1));
					GlobalSoundManager.play(scrollMenu);
				}
				#end
			}

			if (controls.UI_LEFT_P && apertavel) // silver bulinho kekekek, não saber a diferença entre || e && ;-;
			{
				changeWeek(-1);
				GlobalSoundManager.play(scrollMenu);
			}

			if (controls.UI_RIGHT_P && apertavel)
			{
				changeWeek(1);
				GlobalSoundManager.play(scrollMenu);
			}

			if (controls.ACCEPT && apertavel #if !debug && lockedWeeks[curWeek] != true #end)
			{
				maintainVisible = true;
				selectWeek();
			}
			#if !debug
			else if (controls.ACCEPT && apertavel && lockedWeeks[curWeek] == true)
			{
				GlobalSoundManager.play('negado');
			}
			#end
		}

		if (controls.BACK && !movedBack && !selectedWeek && !inCut && !makeAnimUnlock)
		{
			GlobalSoundManager.play(cancelMenu);
			movedBack = true;
			maintainVisible = false;
			MusicBeatState.switchState(new MainMenuStateMobile());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (MenuHistoria.preHistoriaSelected != curWeek)
		{
			MenuHistoria.curSelected = 0;
		}
		MenuHistoria.preHistoriaSelected = curWeek;
		if (stopspamming == false)
		{
			GlobalSoundManager.play(confirmMenu);
			stopspamming = true;
		}

		selectedWeek = true;

		MenuHistoria.dapreselected = Metadata.WeekData.weeksList[curWeek];

		// Teoricamente, isso deve fazer com que o menu se desfaça uma última vez e dê lugar ao menu de historia...

		// ALO TEGER, MANDA UM SALVE!!!
		old_linha_down.visible=old_linha_up.visible=old_perfil.visible =false;
		bgSprite.visible = perfilSprite.visible = blackbarup.visible = blackbardown.visible= true;
		updateBG();
		old_bg.setGraphicSize(FlxG.width, FlxG.height);
		old_bg.screenCenter(XY);
		FlxTween.tween(blackbarup, {y: 0 - blackbarup.height}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackbardown, {y: FlxG.height}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(bgSprite, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(perfilSprite, {x: FlxG.width + perfilSprite.width}, 1, {ease: FlxEase.expoInOut});
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			openSubState(new MenuHistoria());
			makeAnimUnlock = false;
			inCut = false;
		});
	}

	public function changeWeek(change:Int = 0):Void
	{
		apertavel = false;
		curWeek += change;

		if (curWeek >= Metadata.WeekData.weeksList.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = Metadata.WeekData.weeksList.length - 1;

		PlayState.storyWeek = curWeek;

		var leWeek:Metadata.WeekData = Metadata.WeekData.weeksLoaded.get(Metadata.WeekData.weeksList[curWeek]);
		Metadata.WeekData.setDirectoryFromWeek(leWeek);

		bgSprite.visible = perfilSprite.visible= blackbarup.visible=blackbardown.visible=change != 0 || maintainVisible;
		var assetName:String = leWeek.weekBackground;
		if (OpenFlAssets.exists(Paths.imagechecker("Story_Mode/BG_" + assetName, 'preload')))
		{ // anti crashing moment
			bgSprite.loadGraphic(Paths.image("Story_Mode/BG_" + assetName, "preload"));
		}
		else
		{
			FlxG.log.warn('Não foi possível achar ' + Paths.imagechecker("Story_Mode/BG_" + assetName, "locales", true));
			bgSprite.loadGraphic('assets/images/menuDesat.png');
		}
		if (OpenFlAssets.exists(Paths.imagechecker("Story_Mode/PERFIL" + assetName, "locales", true)))
		{ // anti crashing moment
			perfilSprite.loadGraphic(Paths.image("Story_Mode/PERFIL" + assetName, "locales", true, true));
			// PQP EU SOU MUITO BURRO... Ass:Silvio
		}
		else
		{
			FlxG.log.warn('Não foi possível achar ' + Paths.imagechecker("Story_Mode/PERFIL" + assetName, "locales", true));
		}

		bgSprite.setGraphicSize(FlxG.width);
		bgSprite.screenCenter(XY);
		perfilSprite.updateHitbox();

		if (OpenFlAssets.exists(Paths.imagechecker("Story_Mode/Linha" + assetName)))
		{ // anti crashing moment
			blackbardown.loadGraphic(Paths.image("Story_Mode/Linha" + assetName));
		}
		else
		{
			blackbardown.makeGraphic(FlxG.width, 53, FlxColor.BLACK);
		}
		if (OpenFlAssets.exists(Paths.imagechecker("Story_Mode/LinhaUP_" + assetName, "locales", true)))
		{ // anti crashing moment
			blackbarup.loadGraphic(Paths.image("Story_Mode/LinhaUP_" + assetName, "locales", true, true));
		}
		else
		{
			blackbarup.makeGraphic(FlxG.width, 53, FlxColor.BLACK);
			FlxG.log.warn('Não foi possível achar ' + Paths.imagechecker("Story_Mode/LinhaUP_" + assetName, "locales", true));
		}

		perfilSprite.x = FlxG.width;
		perfilSprite.y = 0;
		bgSprite.x = 0 - bgSprite.width;
		blackbarup.y = 0 - blackbarup.height;
		blackbardown.y = FlxG.height;
		var curtimer:Float = 0.5; // Por pura preguiça de trocar isso o tempo todo...
		bgSprite.visible = perfilSprite.visible = blackbarup.visible = blackbardown.visible= true;
		FlxTween.tween(blackbarup, {y: 0}, curtimer, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackbardown, {y: FlxG.height - 53}, curtimer, {ease: FlxEase.expoInOut});
		FlxTween.tween(bgSprite, {x: 0}, curtimer, {ease: FlxEase.expoInOut});
		FlxTween.tween(perfilSprite, {x: FlxG.width - perfilSprite.width}, curtimer, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				
				old_bg.loadGraphicFromSprite(bgSprite);
				old_linha_down.loadGraphicFromSprite(blackbardown);
				old_linha_up.loadGraphicFromSprite(blackbarup);
				old_perfil.loadGraphicFromSprite(perfilSprite);
				old_perfil.setPosition(perfilSprite.x,perfilSprite.y);
				old_bg.setPosition(bgSprite.x,bgSprite.y);
				old_linha_down.setPosition(blackbardown.x,blackbardown.y);
				old_linha_up.setPosition(blackbarup.x,blackbarup.y);
				apertavel = true; // Só pra garantir que a animação de entrada NÃO ocorra ao mesmo tempo que a de saida.
				old_bg.visible = old_linha_down.visible=old_linha_up.visible=old_perfil.visible = true;
				bgSprite.visible = perfilSprite.visible = blackbarup.visible = blackbardown.visible= false;
			}
		});
		// EU DEFINITIVAMENTE NÃO QUERO FALAR SOBRE ESTE CODE... Ass: Sílvio

		if (lockedWeeks[curWeek] == true)
		{
			flixel.tweens.FlxTween.tween(lockSprite, {alpha: 1}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
			flixel.tweens.FlxTween.tween(blackLock, {alpha: 0.55}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
		}
		else
		{
			if (!makeAnimUnlock)
			{
				flixel.tweens.FlxTween.tween(lockSprite, {alpha: 0}, 0.5, {ease: flixel.tweens.FlxEase.expoInOut});
				flixel.tweens.FlxTween.tween(blackLock, {alpha: 0}, 0.25, {ease: flixel.tweens.FlxEase.expoInOut});
			}
			else
			{
				lockSprite.alpha = 1;
				blackLock.alpha = 0.55;
			}
		}
	}

	public function updateBG()
	{
		bgSprite.alpha = 1;
		var weekescolhida:Metadata.WeekData = Metadata.WeekData.weeksLoaded.get(Metadata.WeekData.weeksList[curWeek]);
		var assetName:String = weekescolhida.weekBackground;
		old_bg.loadGraphic(Paths.image("scrolling/scroll-"+ assetName+ "/scroll-"+ weekescolhida.songs[MenuHistoria.curSelected][0].toLowerCase() + " (back)", 'preload'));
	}
}
