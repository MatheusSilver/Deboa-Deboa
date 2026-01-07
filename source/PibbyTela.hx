package;

import Achievements;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
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

		FlxG.sound.play(Paths.sound('stat')); // só pra fazer uma graça..

		new FlxTimer().start(ClientPrefs.pibby == "legitimo" ? 1.5 : 1,
			function(tmr:FlxTimer) // aumentei mais o tempo só pro player ter a percepcao do "easter egg"
			{
				// Antes tinha como ganhar a conquista mesmo com botplay aparentemente.
				// De qualquer jeito, agora ta tudo certo. Mesmo com o botplay você não perde o easter egg.
				if (ClientPrefs.pibby == "legitimo")
				{
					#if ACHIEVEMENTS_ALLOWED
					Achievements.loadAchievements();
					var achieveID:Int = Achievements.getAchievementIndex('pibby');
					if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][0]))
					{
						ClientPrefs.achievementsMap.set(Achievements.achievementsStuff[achieveID][0], true);
						ClientPrefs.save();
						giveAchievement();	
					}
					#end
				}
				else if (ClientPrefs.pibby == "botplay")
				{
					ClientPrefs.pibby = "nulo";
					ClientPrefs.save();
					FlxG.switchState(new TitleState());
				}
			});
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('pibby', camAchievement));
		GlobalSoundManager.play(confirmMenu);
		trace('Giving achievement "pibby"');
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			ClientPrefs.pibby = "nulo";
			ClientPrefs.save();
			FlxG.switchState(new TitleState());
		});
	}
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
