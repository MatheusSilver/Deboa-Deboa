import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	//substituir os zeros pelos seus respectivos ID's de achievement da gamejolt
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement, Gamejolt ID
		["Seja bem vindo!",				"Abra o jogo pela primeira vez.",					'modboa',			true, 181570, 'geral', 'estrelas'], //na real, meio que tanto faz isso.
		["GOTTA GO FAST",				"Vença a Too Fest sem errar",						'toofest_fc',		false, 181571, 'meme maker', 'estrelas'],
		["Skill Issue",					"Morra com o botplay ligado em Caos",				'chaos_bot',		true, 181572, 'discordia', 'estrelas'],
		["Colecionador",				"Consiga todos os troféus",							'colecionador',		false, 181719, 'geral', 'estrelas'],
		["Preciosos Aneis",				"Pegue todos os aneis em Ameaça Tripla",			'rings',			false, 181720, 'orgulho', 'estrelas'],
		["Herói da Profecia",			"Vença todos os pecados",							'heroi',			false, 181721, 'geral', 'estrelas'],
		["Nunca confie em robôs",		"Morra com o botplay ligado em caça",				'prey_bot',			true, 181722, 'bonus', 'estrelas'],
		["Deja vu",						"Sobreviva ao ataque do Furnace em prey",			'prey_survive',		false, 181723, 'bonus', 'estrelas'],
		["Jogador Nato",				"Complete uma música sem errar",					'perfect',			false, 181724, 'geral', 'estrelas'],
		["Nada será como antes...",		"Vença a sidekick",									'sidekick',			false, 181725, 'orgulho', 'estrelas'],
		//["Psicopata",					"Assista o Carlitos morrer 100 vezes.",				'roadkill_enthusiast',false, 0], guardado para a posteridade
		["Livre para Voar",				"Liberte Tails em Ameaça Tripla",					'tails_free',		true, 181726, 'orgulho', 'estrelas'],
		["Livre para Defender",			"Liberte Knuckles em Ameaça Tripla",				'knuckles_free',	true, 181727, 'orgulho', 'estrelas'],
		["Livre para Sacrificar",		"Liberte Eggman em Ameaça Tripla",					'eggman_free',		true, 181728, 'orgulho', 'estrelas'],
		["Até que a morte nos separe",	"Morra 5x seguidas em Sidekick",					'side_deaths',		false, 181729, 'orgulho', 'estrelas'],
		["Uma flor amarela",			"Vença a Melhores Amigos sem errar",				'besties',			false, 181730, 'historias alternativas', 'estrelas'],
		["Torradeira Gamer",			"Você tentou rodar isso em uma torradeira?",		'toastie',			false, 181731, 'geral', 'estrelas'],
		["O ato do herói acabou",		"Vença a confronting yourself",						'cy_clear',			false, 181732, 'orgulho', 'estrelas'],
		["Me siga no OnlyFans",			"Vença o ColdSteel",								'personel_clear',	true, 181733, 'meme maker', 'estrelas'],
		["Duolingo em dia",				"Sobreviva até o meio da Endless",					'fisk',				true, 181734, 'luxuria', 'estrelas'],
		["Fruto do Jardim",				"Assista ao poema em Lerdeza",						'poems',			true, 181735, 'orgulho', 'estrelas'],
		["Achou que eu estava brincando?","Vença o Pibby Sonic numa batalha de rap",		'pibby',			true, 181736, 'historias alternativas', 'estrelas']  //True quer dizer que é secreto shhhhhhhh
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		var id:Int = Achievements.getAchievementIndex(name);
		GJClient.trophieAdd(achievementsStuff[id][4]);
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			if(GJClient.logged)
				{
					GJClient.trophieAdd(achievementsStuff[getAchievementIndex(name)][4]);
				}
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
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
		loadGraphic(Paths.image('conquistas/medalhas/achievements (btt-' + tag + ")"));
		/*if(Achievements.isAchievementUnlocked(tag)) {
			//To think: Como indicar pro manito quais achievements ele tem, e quais ele não tem?
		} else {
			loadGraphic(Paths.image('conquistas/png/exe_blocked'));
		}*/
		scale.set(0.35, 0.35);
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
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.RED);
		achievementBG.alpha = 0.70;
		achievementBG.scrollFactor.set();

		var amongusgameplayoficial:FlxSprite = new FlxSprite(achievementBG.x, achievementBG.y).loadGraphic(Paths.image('menus/bg-filtro'));
		amongusgameplayoficial.setGraphicSize(FlxG.width, FlxG.height);


		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image('conquistas/icones/' + name)); //Isso vai facilitar bastatne nossa vida com os icones dos achievements, confia.
		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = true; //vai ficar legal, confia em mim.


		

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("GhoulFriAOE.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("GhoulFriAOE.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();



		add(achievementBG);
		add(amongusgameplayoficial);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
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