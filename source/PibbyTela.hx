package;

import Achievements;
import flixel.*;
import flixel.util.FlxTimer;

class PibbyTela extends MusicBeatState
{
	private var camAchievement:FlxCamera;

	public function new()
	{
		super();
	}

	override function create()
	{
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		super.create();

		FlxG.cameras.add(camAchievement);

		var screen:FlxSprite = new FlxSprite().loadGraphic(Paths.image("omgcrashou/ModboaFatalAlt"));
		add(screen);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			#if ACHIEVEMENTS_ALLOWED
			Achievements.loadAchievements();
			var achieveID:Int = Achievements.getAchievementIndex('pibby');
			if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][0]))
			{
				ClientPrefs.achievementsMap.set(Achievements.achievementsStuff[achieveID][0], true);
				giveAchievement();
				ClientPrefs.save();
			}
			#end
		});
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('pibby', camAchievement));
		GlobalSoundManager.play('confirmMenu');
		trace('Giving achievement "pibby"');
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{ 
			ClientPrefs.pibby = false;
			FlxG.switchState(new TitleState());
            ClientPrefs.save();
		});
	}
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
