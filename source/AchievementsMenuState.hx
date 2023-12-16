package;

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

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;

	private var achievementArray:Array<AttachedAchievement> = [];
	private var achievementIndex:Array<Int> = [];
	private var descText:FlxText;
	private var titleText:FlxText;
	var descBox:FlxSprite;
	var majin:FlxSprite;
	var apertavel:Bool = true;

	public static var FirstTimeAqui:Bool = true;

	var isCoolBeat:Bool = true;
	var sincronizando:Bool = false;

	override function create()
	{
		#if rpc
		DiscordClient.changePresence("No menu de conquistas", null);
		#end

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
			if (!Achievements.achievementsStuff[i][3] || ClientPrefs.achievementsMap.exists(Achievements.achievementsStuff[i][2]))
			{
				options.push(Achievements.achievementsStuff[i]);
				achievementIndex.push(i);
			}
		}

		for (i in 0...options.length)
		{
			var achieveAlbum:String = Achievements.achievementsStuff[achievementIndex[i]][5];
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
			announceText = new FlxText(0, 0, 0, "SINCRONIZANDO CONQUISTAS", 24);
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
					Achievements.syncAchievementsGJ();
				});
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					remove(preto);
					remove(announceText);
					sincronizando = false;
					changeSelection();
				});
				for (i in 0...Achievements.achievementsStuff.length)
				{
					Achievements.isAchievementUnlocked(Achievements.achievementsStuff[i][2], false);
					FirstTimeAqui = false;
				}
			});
		}
		if (!sincronizando)
		{
			changeSelection();
		}
		Conductor.changeBPM(112);

		#if mobileC
		addVirtualPad(UP_DOWN, B);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P && apertavel)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P && apertavel)
		{
			changeSelection(1);
		}

		if (controls.BACK && !sincronizando)
		{
			GlobalSoundManager.play('cancelMenu');
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
	}

	function changeSelection(change:Int = 0)
	{
		apertavel = false;
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.targetY == 0)
			{
				flixel.tweens.FlxTween.tween(item, {x: -50}, 0.5, {
					ease: flixel.tweens.FlxEase.expoInOut,
					onComplete: function(twn:flixel.tweens.FlxTween)
					{
						apertavel = true;
					}
				});
			}
			else if (item.targetY != 0 && item.x == -50)
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
		descText.text = Achievements.achievementsStuff[achievementIndex[curSelected]][1];
		titleText.text = Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achievementIndex[curSelected]][2]) ? Achievements.achievementsStuff[achievementIndex[curSelected]][0] : '?????';
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
