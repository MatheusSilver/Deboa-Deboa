package;
import flixel.util.FlxTimer;
import Achievements;
import flixel.*;

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
		
		var screen:FlxSprite = new FlxSprite().loadGraphic(Paths.image("PibbyTela"));
		
		add(screen);

        new FlxTimer().start(0.5, function(tmr:FlxTimer)
            {
        #if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
			var achieveID:Int = Achievements.getAchievementIndex('pibby');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		#end
            });
		
		
	}

    #if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('pibby', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "pibby"');
	}
	#end
	
	
	override function update(elapsed:Float) 
	{
		super.update(elapsed);
		
		if (controls.ACCEPT){
            ClientPrefs.pibby = false;
			FlxG.switchState(new TitleState());
            ClientPrefs.saveSettings();
		}
		
		
		
	}
	
}