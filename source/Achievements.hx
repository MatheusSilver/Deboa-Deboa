import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

using StringTools;

class Achievements {
	//substituir os zeros pelos seus respectivos ID's de achievement da gamejolt
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement, Gamejolt ID
		["Seja bem vindo!",				"Abra o jogo pela primeira vez.",					'modboa',			true, 		181570, 		'geral', 		1], //ok1
		["Ate o proximo encontro",		"Vença slaybells.",									'natal',			false, 		185532, 		'geral', 		1], //ok1
		["G0TT4_G0_F4ST0",				"Irmão... Tu tá bem man? FC na too fest? medo...",	'toofest_fc',		true, 		181571, 		'meme maker', 	3], //ok1
		["Bye, Bye",					"Vença a Cycles sem errar",							'bye_bye_fc',		false, 		185533, 		'ira', 			3], //ok1
		["Sob controle",				"Vença Control com os gifs Ativados",				'control_fc',		false, 		185534, 		'preguica', 	2], //ok1
		["Sarah as 3 da manhã",			"Jogue round-a-bout num horário específico",		'madrugada',		true, 		185535, 		'ganancia', 	3], //ok
		["Skill Issue",					"Morra com o botplay ligado em Caos",				'chaos_bot',		true, 		181572, 		'discordia', 	3],
		["Colecionador",				"Consiga todos os troféus",							'colecionador',		false, 		181719, 		'geral', 		4],
		["Cuspindo fatos",				"Ouça o sunky cuspir fatos em milk",				'sunky_fatos',		false, 		186689, 		'meme maker', 		1],
		["Preciosos Aneis",				"Pegue todos os aneis em Ameaça Tripla",			'rings',			false, 		181720, 		'orgulho', 		3], //ok
		["Herói da Profecia",			"Vença todos os pecados",							'heroi',			false, 		181721, 		'geral', 		2],
		["Nunca confie em robos",		"Morra com o botplay ligado em caça",				'prey_bot',			true, 		181722, 		'alt', 		2], //ok
		["Fake Full Combo",				"Full Combo, PARABENS!!! Pena que foi na soulless logo tudo foi anulado :)", 'fake_full_combo',			true, 		185666, 		'meme maker', 		1], //ok
		["Deja vu",						"Sobreviva ao ataque do Furnace em prey",			'prey_survive',		true, 		181723, 		'alt', 		2], //ok
		["Jogador Nato",				"Complete uma música sem errar",					'perfect',			false, 		181724, 		'geral', 		2], //ok
		["Nada será como antes...",		"Vença a sidekick",									'sidekick',			false, 		181725, 		'orgulho', 		1], //ok
		["Livre para Voar",				"Liberte Tails em Ameaça Tripla",					'tails_free',		true, 		181726, 		'orgulho', 		1], //ok
		["Livre para Defender",			"Liberte Knuckles em Ameaça Tripla",				'knuckles_free',	true, 		181727, 		'orgulho', 		2], //ok
		["Livre para Sacrificar",		"Liberte Eggman em Ameaça Tripla",					'eggman_free',		true, 		181728, 		'orgulho', 		3], //ok
		["Até que a morte nos separe",	"Morra 5x seguidas em Sidekick",					'side_deaths',		true, 		181729, 		'orgulho', 		1],
		["Uma flor amarela",			"Vença a Melhores Amigos sem errar",				'besties',			false, 		181730, 		'alt', 			2], //ok
		["Torradeira Gamer",			"Você tentou rodar isso em uma torradeira?",		'toastie',			false, 		181731, 		'geral', 		1], //ok
	  //["O ato do herói acabou",		"Vença a confronting yourself",						'cy_clear',			false, 		181732, 		'orgulho', 'estrelas', 2],
		["E tambem OnlyFans",			"Vença o ColdSteel",								'personel_clear',	true, 		181733, 		'meme maker', 	1], //ok
		["Duolingo em dia",				"Sobreviva até o meio da Endless",					'fisk',				true, 		181734, 		'luxuria', 		1], //ok
		["Achou que eu estava brincando?","Vença o Pibby Sonic numa batalha de rap",		'pibby',			true, 		181736, 		'alt', 			2], //ok
		["Galeria",						"Veja toda a galeria",								'galeria',			true, 		185895, 		'geral', 		1], 
		["Quem mandou ficar no pause?",	"Deixe seu jogo pausado por muito tempo em triple trouble",	'pause_jumpscare',	true, 		186989, 		'orgulho', 		1]//ok
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		GlobalSoundManager.play('confirmMenu');
		var id:Int = Achievements.getAchievementIndex(name);
		if(GJClient.logged)
			GJClient.trophieAdd(achievementsStuff[id][4]);
		
		ClientPrefs.saveSettings();
	}

	public static function isAchievementUnlocked(name:String, ?naochecar:Bool=true) {
		var id:Int = Achievements.getAchievementIndex(name);
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			if(GJClient.logged && !naochecar)
				GJClient.trophieAdd(achievementsStuff[id][4]);
			return true;
		}
		return false;
	}

	public static function syncAchievementsGJ()
		{
			if(GJClient.logged){
			var GJList:Null<Array<Trophie>> = GJClient.getTrophiesList();
			for (i in 0...GJList.length) {
				if(GJList[i].achieved)
					{
						unlockAchievement(getAchievementID(GJList[i].id));
					}
			}}
		}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function getAchievementID(id:Int):String {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][4] == id) {
				return achievementsStuff[i][2];
			}
		}
		return "";
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}
		}
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		loadGraphic(Paths.imagechecker('conquistas/medalhas/achievements (btt-' + tag + ")"));
		scale.set(1.3, 1.3);
		updateHitbox();
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
		//ClientPrefs.saveSettings();
		//Over do grover

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50);
		var achievename:String = Achievements.achievementsStuff[id][5];
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


		for (i in 1...(Std.int(Achievements.achievementsStuff[id][6])+1)){
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
		

		var achievementName:FlxText = new FlxText(0, achievementBG.y + 50, achievementBG.width*0.6, Achievements.achievementsStuff[id][0], 16);
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