package;

import Utils.BSLSwipeUtils;
#if rpc
import Discord.DiscordClient;
#end
import Achievements;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gamejolt.*;

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	public var options:Map<Int, String>;
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;

	private var achievementArray:Array<AttachedAchievement> = [];
	private var descText:FlxText;
	private var titleText:FlxText;
	var descBox:FlxSprite;
	var majin:FlxSprite;
	var apertavel:Bool = true;

	public static var FirstTimeAqui:Bool = true;

	var isCoolBeat:Bool = true;
	var sincronizando:Bool = false;
	private var achieve_list_len:Int;

	override function create()
	{
		#if rpc
		DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_achievement_menu", "rpc"), null);
		#end
		achieve_list_len = 0;
		options = [];
		Main.mouse_allowed=true;
		BSLSwipeUtils.resetScrolls();
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('conquistas/menu/achievements_back'));
		menuBG.setGraphicSize(FlxG.width, FlxG.height);
		menuBG.updateHitbox();
		menuBG.screenCenter(XY);
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...Achievements.achievementsStuff.length)
		{
			if (!Achievements.achievementsStuff[i][1] || ClientPrefs.achievementsMap.exists(Achievements.achievementsStuff[i][0]))
			{
				achieve_list_len++;
				options.set(i, Achievements.achievementsStuff[i][0]);
			}
		}

		for (i in 0...achieve_list_len)
		{
			var achieveAlbum:String = Achievements.achievementsStuff[i][3];
			var optionText:Alphabet = new Alphabet(-150, (250 * i) + 100, '', false, false);
			optionText.isMenuTrem = true;
			optionText.x += 25;
			optionText.xAdd = 25;
			optionText.targetY = i;
			grpOptions.add(optionText);

			var icon:AttachedAchievement = new AttachedAchievement(-150, optionText.y, achieveAlbum);
			icon.sprTracker = optionText;
			achievementArray.push(icon);
			add(icon);
		}
		var linha:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("conquistas/menu/achievements_linha"));
		linha.antialiasing = ClientPrefs.globalAntialiasing;
		add(linha);

		var linha2:FlxSprite = new FlxSprite().loadGraphic(Paths.image("conquistas/menu/achievements_perfil"));
		linha2.antialiasing = ClientPrefs.globalAntialiasing;
		linha2.y = 0;
		linha2.x = FlxG.width - linha2.width;
		add(linha2);

		majin = new FlxSprite(512 - 80 + 30, -250);
		majin.frames = Paths.getSparrowAtlas('conquistas/menu/majinnatalino', 'preload');
		majin.animation.addByPrefix('majinnatalino idle', "majinnatalino idle", 28);
		majin.flipX = true;
		majin.setGraphicSize(Std.int(majin.width * 1.35));
		majin.antialiasing = ClientPrefs.globalAntialiasing;
		add(majin);
		majin.animation.play('majinnatalino idle', true);

		descBox = new FlxSprite().loadGraphic(Paths.image('conquistas/menu/achievements_texto'));
		// descBox.alpha = 0.6;
		// descBox.alpha = 0.6;
		descBox.scale.x = 1280 / 1920;
		descBox.scale.y = 720 / 1080;
		descBox.updateHitbox();
		descBox.x = FlxG.width - 29 - descBox.width;
		descBox.y = FlxG.height - 10 - descBox.height;
		add(descBox);

		descText = new FlxText(0, 0, descBox.width - 10, "", 32);
		descText.setFormat(Paths.font("letravio.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.x = descBox.x + 5;
		descText.y = descBox.y + 50;
		descText.borderSize = 2.4;
		add(descText);

		titleText = new FlxText(0, 0, descBox.width - 10, "", 24);
		titleText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 24, 0x9755F0, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleText.scrollFactor.set();
		titleText.x = descBox.x + 5;
		titleText.y = descBox.y + 10;
		titleText.borderSize = 2.4;
		add(titleText);
		if (GJClient.logged && FirstTimeAqui && !TitleState.ModoOffline)
		{
			var announceText:FlxText;
			sincronizando = true;
			announceText = new FlxText(0, 0, 0, Linguagem.LangUtil.getString("ach_desc_sync", "achievement"), 24);
			announceText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 24, 0xFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			announceText.screenCenter(XY);
			var preto:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			preto.alpha = 0.75;
			add(preto);
			add(announceText);
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				Achievements.loadAchievements();
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					Achievements.syncAchievementsGJ(function(){
						trace("sincronizadissimo");

						for (i in 0...Achievements.achievementsStuff.length)
							{
								Achievements.isAchievementUnlocked(Achievements.achievementsStuff[i][0], false);
								FirstTimeAqui = false;
							}

						remove(preto);
						remove(announceText);
						sincronizando = false;
						changeSelection();
					}, function(){
						trace("nao consegui sincronizar mano dsclp ae :c");

						remove(preto);
						remove(announceText);
						sincronizando = false;
						changeSelection();
					});
				});
			});
		}
		if (!sincronizando)
		{
			changeSelection();
		}
		Song.Conductor.changeBPM(112);

		BSLSwipeUtils.max_y = Std.int(FlxG.width/(achieve_list_len)*2);//Isso serve pra permitir que o player possa ir no máximo até a metade da lista ao passar o dedo do topo até o fim de sua tela.
		BSLSwipeUtils.mouseScrollMultiplier=1;
		BSLSwipeUtils.reset_manual=false;
		super.create();
	}
	var reload:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(sincronizando)
			return;

		Utils.BSLSwipeUtils.swipeVertical();
		if (controls.UI_UP && apertavel)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN && apertavel)
		{
			changeSelection(1);
		}

		if (Math.abs(change_swipe) <= Math.abs(BSLSwipeUtils.scrollY) && BSLSwipeUtils.scrollY != 0 && apertavel)
			change_swipe = -BSLSwipeUtils.scrollY;
		else if(Math.abs(change_swipe) > 0 && apertavel)
		{
			reload = true;
			changeSelection(true);
		}else if (change_swipe == 0 && reload && !BSLSwipeUtils.is_swipping){
			BSLSwipeUtils.resetScrolls();
			reload = false; //Serve apenas pra isso não ficar spammando.
			changeSelection();
		}
		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
		{
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
	}

	private var change_swipe:Int = 0;

	function changeSelection(?change:Int = 0, ?swipping:Bool = false)
	{
		
		if (!swipping || change_swipe == 0)	
			apertavel = false;
		if (change_swipe != 0){
			change = Std.int(Math.abs(change_swipe)/change_swipe);
			change_swipe -= change;
		}


		curSelected += change;
		if (curSelected < 0)
			curSelected = achieve_list_len - 1;
		if (curSelected >= achieve_list_len)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.targetY == 0 && !apertavel)
			{
				flixel.tweens.FlxTween.tween(item, {x: -50}, 0.5, {
					ease: flixel.tweens.FlxEase.expoInOut,
					onComplete: function(twn:flixel.tweens.FlxTween)
					{
						apertavel = true;
					}
				});
			}
			else if (item.x == -50)
			{
				flixel.tweens.FlxTween.tween(item, {x: -150}, 1.0, {ease: flixel.tweens.FlxEase.expoInOut});
			}
		}

		for (i in 0...achievementArray.length)
		{
			achievementArray[i].alpha = 0.6;
			if (i == curSelected)
			{
				achievementArray[i].alpha = 1;
			}
		}
		descText.text = Linguagem.LangUtil.getString("ach_desc_"+Achievements.achievementsStuff[curSelected][0], "achievement");
		titleText.text = Achievements.isAchievementUnlocked(options.get(curSelected)) ? Linguagem.LangUtil.getString("ach_name_"+options.get(curSelected), "achievement") : '?????';
	}

	override function beatHit()
	{
		super.beatHit(); // interessante, ovô rosbar
		if (isCoolBeat)
		{
			majin.animation.play('majinnatalino idle', true);
		}
		isCoolBeat = !isCoolBeat;
	}
}
