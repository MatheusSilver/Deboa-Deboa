package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import gamejolt.*;

using StringTools;

class Achievements {
	//substituir os zeros pelos seus respectivos ID's de achievement da gamejolt
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement, Gamejolt ID
		['game_clear',		false, 		181573, 		'geral', 		3], //ok1
		['modboa',			true, 		181570, 		'geral', 		1], //ok1
		['tarado_do_menu',	true,		195317, 		'geral', 		1],
		['fe_clear',		false,		195318, 		'orgulho', 		2],
		['hypno_clear',		false,		195319, 		'alt', 			1],
		['mx_clear',		false,		195320, 		'alt', 			2],
		['lx_clear',		false,		195321, 		'alt', 			3],		
		['natal',			false, 		185532, 		'geral', 		1], //ok1
		['toofest_fc',		true, 		181571, 		'meme maker', 	3], //ok1
		['bye_bye_fc',		false, 		185533, 		'ira', 			3], //ok1
		['control_fc',		false, 		185534, 		'preguica', 	2], //ok1
		['madrugada',		true, 		185535, 		'ganancia', 	3], //ok
		['chaos_bot',		true, 		181572, 		'discordia', 	3],
		['colecionador',	false, 		181719, 		'geral', 		4],
		['sunky_fatos',		false, 		186689, 		'meme maker', 	1],
		['rings',			false, 		181720, 		'orgulho', 		3], //ok
		['heroi',			false, 		181721, 		'geral', 		2],
		['prey_bot',		true, 		181722, 		'alt', 			2], //ok
		['prey_survive',	true, 		181723, 		'alt', 			2], //ok
		['perfect',			false, 		181724, 		'geral', 		2], //ok
		['sidekick',		false, 		181725, 		'orgulho', 		1], //ok
		['tails_free',		true, 		181726, 		'orgulho', 		1], //ok
		['knuckles_free',	true, 		181727, 		'orgulho', 		2], //ok
		['eggman_free',		true, 		181728, 		'orgulho', 		3], //ok
		['side_deaths',		true, 		181729, 		'orgulho', 		1],
		['besties',			false, 		181730, 		'alt', 			2], //ok
		['toastie',			false, 		181731, 		'geral', 		1], //ok
	    ['cy_clear',		false, 		181732, 		'orgulho',		2],
		['personel_clear',	true, 		181733, 		'meme maker', 	1], //ok
		['fisk',			true, 		181734, 		'luxuria', 		1], //ok
		['pibby',			true, 		181736, 		'alt', 			2], //ok
		['galeria',			true, 		185895, 		'geral', 		1], 
		['pause_jumpscare',	true, 		186989, 		'orgulho', 		1]//ok
	];

	//static var syncLater:Array<Int> = [];

	public static function unlockAchievement(name:String, ?makeSound:Bool=true, ?gamejolt:Bool=true):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		ClientPrefs.achievementsMap.set(name, true);
		if(makeSound)
			{
				GlobalSoundManager.play(confirmMenu);
			}

		if(gamejolt){
			#if GAMEJOLT_ALLOWED
			var id:Int = Achievements.getAchievementIndex(name);
			TitleState.instance.verificarConexao();
			if(GJClient.logged && !TitleState.ModoOffline)
				GJClient.trophieAdd(achievementsStuff[id][2]);
			#end
		}

		/*if(PlayState.isPlayState && GJClient.logged && !TitleState.ModoOffline){
			syncLater.push(Achievements.getAchievementIndex(name));
		}*/

		ClientPrefs.save();
	}

	/*public static function syncWithGJLater(){
		for(i in syncLater) {
			#if GAMEJOLT_ALLOWED
			TitleState.instance.verificarConexao();
			if(GJClient.logged && !TitleState.ModoOffline)
				GJClient.trophieAdd(achievementsStuff[i][2]);
			#end
			syncLater.remove(i);
		}
	}*/

	public static function isAchievementUnlocked(name:String, ?naochecar:Bool=true) {
		var id:Int = Achievements.getAchievementIndex(name);
		TitleState.instance.verificarConexao();
		if(ClientPrefs.achievementsMap.exists(name) && ClientPrefs.achievementsMap.get(name)) {
			if(GJClient.logged && !naochecar && !TitleState.ModoOffline)
				GJClient.trophieAdd(achievementsStuff[id][2]);
			return true;
		}
		return false;
	}

	static var GJList:Array<Trophie>;
	public static function syncAchievementsGJ(?onSuccess:() -> Void, ?onFail:() -> Void):Void
		{
			#if GAMEJOLT_ALLOWED
			TitleState.instance.verificarConexao(true);
			if(GJClient.logged && !TitleState.ModoOffline){
				GJClient.getTrophiesList(true, function () {
					if(GJList==null) GJList = [];
					for(trophie in GJList)
						{
							unlockAchievement(getAchievementID(trophie.id), false, false);
						}
					GJList = [];
					if(onSuccess != null)
						onSuccess();
				}, function () {
					GJList = [];
					if(onFail != null)
						onFail();
				}, true, function(?result:Null<Dynamic>) {
					if(result.trophies == null)
						GJList = [];
						return;
					GJList = result.trophies;
					//trace("GJList: "+ GJList); eu vou explodir
				});

			}
			#end
		}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][0] == name) {
				return i;
			}
		}
		return -1;
	}

	// Funções auxiliares para acessar propriedades do achievement
	// So porque eu já estava ficando bem pito de ter que pegar cada um desses na mão
	public inline static function getAchievementName(id:Int):String { return achievementsStuff[id][0]; }

	public inline static function isAchievementHidden(id:Int):Bool { return achievementsStuff[id][1]; }

	public inline static function getAchievementGJID(id:Int):Int { return achievementsStuff[id][2]; }

	public inline static function getAchievementCategory(id:Int):String { return achievementsStuff[id][3]; }

	public inline static function getAchievementStars(id:Int):Int { return achievementsStuff[id][4]; }

	public static function getAchievementID(id:Int):String {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == id) {
				return achievementsStuff[i][0];
			}
		}
		return "";
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				ClientPrefs.achievementsMap = FlxG.save.data.achievementsMap;
			}
		}
	}
}

class AttachedAchievement extends FlxSpriteGroup {
	public var sprTracker:FlxSprite;
	private var medalSprite:FlxSprite;
	private var lockedIcon:FlxSprite;
	private var tag:String;
	private var achievementIndex:Int = -1;
	private var stars:Array<FlxSprite> = [];
	
	public function new(x:Float = 0, y:Float = 0, name:String, ?index:Int = -1) {
		super(x, y);

		achievementIndex = index;
		
		medalSprite = new FlxSprite(0, 0);
		lockedIcon = new FlxSprite(0, 0);
		changeAchievement(name);
		medalSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(medalSprite);
		lockedIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(lockedIcon);

		loadStars();
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage(Achievements.isAchievementUnlocked(Achievements.getAchievementName(achievementIndex)));
	}

	public function reloadAchievementImage(unlocked:Bool) {
		medalSprite.loadGraphic(Paths.image('conquistas/medalhas/achievements (btt-' + tag + ")"));
		medalSprite.scale.set(1.3, 1.3);
		medalSprite.updateHitbox();
		if(!unlocked) {
			lockedIcon.loadGraphic(Paths.image('conquistas/medalhas/achievements (btt-locked)'));
			lockedIcon.x += 359 + (lockedIcon.width * 5 / 6) - 13; // matematica avancada
			lockedIcon.y += 8;
			lockedIcon.scale.set(1.3, 1.3);
			lockedIcon.updateHitbox();
		}
		updateHitbox();
	}
	
	private function loadStars() {
		if (achievementIndex < 0)
			return;
			
		final numStars:Int = Achievements.getAchievementStars(achievementIndex);
		final achieveName:String = Achievements.getAchievementCategory(achievementIndex);
		final isUnlocked:Bool = Achievements.isAchievementUnlocked(Achievements.getAchievementName(achievementIndex));
		
		// Limpar estrelas antigas
		for (star in stars) {
			remove(star);
			star.destroy();
		}
		stars = [];
		
		if (isUnlocked && numStars > 0) {
			var starStartX:Float = medalSprite.width - 275;
			var starStartY:Float = (medalSprite.height / 2) - 20;
			
			for (i in 0...numStars) {
				var star:FlxSprite = new FlxSprite(starStartX - (i * 60), starStartY);
				
				if (openfl.Assets.exists(Paths.imagechecker('conquistas/keydSTARS/star-' + achieveName, 'preload')))
					star.loadGraphic(Paths.image('conquistas/keydSTARS/star-' + achieveName, 'preload'));
				else
					star.loadGraphic(Paths.image('conquistas/keydSTARS/star-geral', 'preload'));
				
				star.setGraphicSize(Std.int(star.width*0.9));
				star.updateHitbox();
				star.antialiasing = ClientPrefs.globalAntialiasing;
				stars.push(star);
				add(star);
			}
		}
	}
	
	public function updateStarDisplay() { loadStars(); }
	
	public function updateBanner(isUnlocked:Bool, isSelected:Bool) {
		if (isUnlocked) {
			medalSprite.color = FlxColor.WHITE;
			for (star in stars) star.color = FlxColor.WHITE;
		} else {
			medalSprite.shader = new Shaders.GrayscaleShader();
			for (star in stars) star.shader = new Shaders.GrayscaleShader();
		}
		if (isSelected && isUnlocked) {
			medalSprite.alpha = 1;
			for (star in stars) star.alpha = 1;
		} else {
			medalSprite.alpha = 0.6;
			for (star in stars) star.alpha = 0.6;
		}
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	var estrela1:FlxSprite;
	var estrela2:FlxSprite;
	var estrela3:FlxSprite;
	var estrela4:FlxSprite; //Tentei fazer do mesmo jeito que o menu principal maaaaaaaaaas.... Anyway são 4 da manhã e estou com sono então vai assim mesmo.
	public function new(name:String, camera:FlxCamera)
	{
		super(x, y);
		//ClientPrefs.save();
		//Over do grover

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50);
		var achievename:String = Achievements.achievementsStuff[id][3];
		if(openfl.Assets.exists(Paths.imagechecker('conquistas/medalhas/achievements (btt-'+achievename+')', 'preload'))){ //Principalmente para ser usado na Clickbait, mas pode ser util para mais coisas
			achievementBG.loadGraphic(Paths.image('conquistas/medalhas/achievements (btt-'+achievename+')', 'preload'));
		} else {
			achievementBG.loadGraphic(Paths.image('conquistas/medalhas/achievements (btt-geral)', 'preload'));
		}
		achievementBG.setGraphicSize(Std.int(achievementBG.width));
		achievementBG.x -= achievementBG.width*0.2;
		achievementBG.updateHitbox();
		achievementBG.scrollFactor.set();

		add(achievementBG);

		var k:Int = 120;

		estrela1 = new FlxSprite(achievementBG.x + achievementBG.width*0.35 + k, achievementBG.y + 75);
		estrela2 = new FlxSprite(achievementBG.x + achievementBG.width*0.35 - 1*30 + k, achievementBG.y + 75);
		estrela3 = new FlxSprite(achievementBG.x + achievementBG.width*0.35 - 2*30 +k, achievementBG.y + 75);
		estrela4 = new FlxSprite(achievementBG.x + achievementBG.width*0.35 - 3*30 +k, achievementBG.y + 75);

		if(openfl.Assets.exists(Paths.imagechecker('conquistas/keydSTARS/star-'+achievename, 'preload'))){ //Principalmente para ser usado na Clickbait, mas pode ser util para mais coisas
			estrela1.loadGraphic(Paths.image('conquistas/keydSTARS/star-'+achievename, 'preload'));
			estrela2.loadGraphic(Paths.image('conquistas/keydSTARS/star-'+achievename, 'preload'));
			estrela3.loadGraphic(Paths.image('conquistas/keydSTARS/star-'+achievename, 'preload'));
			estrela4.loadGraphic(Paths.image('conquistas/keydSTARS/star-'+achievename, 'preload'));
		} else {
			estrela1.loadGraphic(Paths.image('conquistas/keydSTARS/star-geral', 'preload'));
			estrela2.loadGraphic(Paths.image('conquistas/keydSTARS/star-geral', 'preload'));
			estrela3.loadGraphic(Paths.image('conquistas/keydSTARS/star-geral', 'preload'));
			estrela4.loadGraphic(Paths.image('conquistas/keydSTARS/star-geral', 'preload'));
		}

		estrela1.setGraphicSize(Std.int(estrela1.width/2));
		estrela2.setGraphicSize(Std.int(estrela2.width/2));
		estrela3.setGraphicSize(Std.int(estrela3.width/2));
		estrela4.setGraphicSize(Std.int(estrela4.width/2));


		for (i in 1...(Std.int(Achievements.achievementsStuff[id][4])+1)){
		switch(i){
			case 1:
				add(estrela1);
			case 2:
				add(estrela2);
			case 3:
				add(estrela3);
			case 4:
				add(estrela4);
		}
		}
		

		var achievementName:FlxText = new FlxText(0, achievementBG.y + 50, achievementBG.width*0.6, Linguagem.LangUtil.getString("ach_name_"+Achievements.achievementsStuff[id][0], "achievement"), 16);
		achievementName.setFormat(Paths.font("letravio.ttf"), 24, FlxColor.WHITE, RIGHT);
		achievementName.scrollFactor.set();

		add(achievementName);
		//add(achievementText);

		var cam:Array<FlxCamera> = [camera]; //Basicamente aquilo praticamente não era usado, a não ser é claro pra dar aviso de deprecated
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		estrela1.cameras = cam;
		estrela2.cameras = cam;
		estrela3.cameras = cam;
		estrela4.cameras = cam;
		//achievementText.cameras = cam;
		x = -achievementBG.width;
		y = 0;
		alpha = 1;
		alphaTween = FlxTween.tween(this, {x: 0}, 0.5, {ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween) { 
			//Honestamente eu não sabia que tinha que usar o 'this' "tmj dav slk man kkkk"
			// 👍
			alphaTween = FlxTween.tween(this, {y: FlxG.height}, 1.45,{
				ease: FlxEase.circInOut, // não sei qual colocar, se quiser escolhe algum outro dps
				startDelay: 1.8,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					this.alpha = 0;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}