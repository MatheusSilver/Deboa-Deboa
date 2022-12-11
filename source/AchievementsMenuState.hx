package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import Achievements;

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var achievementArray:Array<AttachedAchievement> = [];
	private var achievementIndex:Array<Int> = [];
	private var descText:FlxText;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Menu de conquistas", null);
		#end

		// mensagem:
		// caso quiserem trocar alguma coisa aqui, troquem, eu não acho que ficou muito bom.
		// dav/matheus leiam isso
		// -mateusx02

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		menuBG.color = FlxColor.RED;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		var filter:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/bg-filtro'));
		filter.screenCenter();
		filter.antialiasing = ClientPrefs.globalAntialiasing;
		add(filter);

		var vio:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ModboaMenu'));
		vio.screenCenter();
		vio.antialiasing = ClientPrefs.globalAntialiasing;
		add(vio);

		var gradiente:FlxSprite = new FlxSprite().loadGraphic(Paths.image("vignette"));
		gradiente.color = FlxColor.RED;
		gradiente.antialiasing = ClientPrefs.globalAntialiasing;
		add(gradiente);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...Achievements.achievementsStuff.length) {
			if(!Achievements.achievementsStuff[i][3] || Achievements.achievementsMap.exists(Achievements.achievementsStuff[i][2])) {
				options.push(Achievements.achievementsStuff[i]);
				achievementIndex.push(i);
			}
		}

		for (i in 0...options.length) {
			var achieveName:String = Achievements.achievementsStuff[achievementIndex[i]][2];
			var optionText:Alphabet = new Alphabet(0, (100 * i) + 210, Achievements.isAchievementUnlocked(achieveName) ? Achievements.achievementsStuff[achievementIndex[i]][0] : '?', false, false);
			optionText.isMenuItem = true;
			optionText.x += 280;
			optionText.xAdd = 200;
			optionText.targetY = i;
			grpOptions.add(optionText);

			var icon:AttachedAchievement = new AttachedAchievement(optionText.x - 105, optionText.y, achieveName);
			icon.sprTracker = optionText;
			achievementArray.push(icon);
			add(icon);
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		//chupa yandere devvvv!!!!! - x02
		switch (curSelected)
		{
			case 0:
				menuBG.color = FlxColor.YELLOW;
				filter.color = FlxColor.YELLOW;
				gradiente.color = FlxColor.YELLOW;
				descText.color = FlxColor.YELLOW;
			case 1:
				menuBG.color = FlxColor.BLUE;
				filter.color = FlxColor.BLUE;
				gradiente.color = FlxColor.BLUE;
				descText.color = FlxColor.BLUE;
			case 2: 
				menuBG.color = FlxColor.YELLOW;
				filter.color = FlxColor.YELLOW;
				gradiente.color = FlxColor.YELLOW;
				descText.color = FlxColor.YELLOW;
			case 3:
				menuBG.color = FlxColor.YELLOW;
				filter.color = FlxColor.YELLOW;
				gradiente.color = FlxColor.YELLOW;
				descText.color = FlxColor.YELLOW;
			case 4:
				menuBG.color = FlxColor.YELLOW;
				filter.color = FlxColor.YELLOW;
				gradiente.color = FlxColor.YELLOW;
				descText.color = FlxColor.YELLOW;
			case 5:
				menuBG.color = FlxColor.BLUE;
				filter.color = FlxColor.BLUE;
				gradiente.color = FlxColor.BLUE;
				descText.color = FlxColor.BLUE;
			case 6:
				menuBG.color = FlxColor.RED;
				filter.color = FlxColor.RED;
				gradiente.color = FlxColor.RED;
				descText.color = FlxColor.RED;
			case 7:
				menuBG.color = FlxColor.GREY;
				filter.color = FlxColor.GREY;
				gradiente.color = FlxColor.GREY;
				descText.color = FlxColor.GREY;
			default:
				menuBG.color = FlxColor.RED;
				filter.color = FlxColor.RED;
				gradiente.color = FlxColor.RED;
				descText.color = FlxColor.RED;
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}

		for (i in 0...achievementArray.length) {
			achievementArray[i].alpha = 0.6;
			if(i == curSelected) {
				achievementArray[i].alpha = 1;
			}
		}
		descText.text = Achievements.achievementsStuff[achievementIndex[curSelected]][1];
	}
}
