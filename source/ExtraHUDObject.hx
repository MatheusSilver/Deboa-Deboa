package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

class ExtraHUDObject extends FlxSpriteGroup
{
	// Needle/Sunshine
	public static var efeito_estatico:FlxSprite;

	// Needlemouse
	var tempogravador:FlxText;
	private final meses:Array<String> = [
		'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
	];

	// Chasing
	var contadordevida:FlxSprite;
	var monitor:FlxSprite;

	// Triple Trouble
	var ringCounter:FlxSprite;
	var counterNum:FlxText;

	public function new(songName:String) // Isso tem que ser aqui, por motivos de que: alguns huds são iniciados em locais diferentes no playstate
	{
		super();

		// Talvez tenham mais músicas com HUD diferenciado, mas as que eu achei já estão aqui
		// Qualquer coisa é só me marcar lá no Discord e eu faço
		// Ou caso você quiser fazer... O CamHUD só é acessado com o instance.
		switch (songName)
		{
			case "round-a-bout":
				// Isso aqui era pra ficar bem na frente mesmo da tela, mas ele tá mexendo e fica no "fundo"
				tempogravador = new FlxText(50, 0, 0, "", 48);
				tempogravador.text = '';
				tempogravador.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				tempogravador.updateHitbox();
				tempogravador.screenCenter(XY);
				tempogravador.x += 125;
				tempogravador.y += 125;
				tempogravador.visible = ClientPrefs.shaders;
				tempogravador.antialiasing = false;
				tempogravador.cameras = [PlayState.instance.camHUD];
				add(tempogravador);

				if (ClientPrefs.shaders)
				{
					efeito_estatico = new FlxSprite(0, 0);
					efeito_estatico.frames = Paths.getSparrowAtlas("estatica", "week-sunshine");
					efeito_estatico.animation.addByPrefix('idle', 'estatica idle', 14, true);
					efeito_estatico.color = FlxColor.WHITE;
					efeito_estatico.alpha = 0.15;
					efeito_estatico.animation.play("idle", true);
					efeito_estatico.setGraphicSize(Std.int(FlxG.width * 1.7));
					efeito_estatico.screenCenter(XY);
					efeito_estatico.visible = false;
					efeito_estatico.cameras = [PlayState.instance.camHUD];
					add(efeito_estatico);
				}

				PlayState.instance.analog_shader();
			case "sunshine":
				efeito_estatico = new FlxSprite(0, 0);
				efeito_estatico.frames = Paths.getSparrowAtlas("estatica", "week-sunshine");
				efeito_estatico.animation.addByPrefix('idle', 'estatica idle', 14, true);
				efeito_estatico.color = FlxColor.WHITE;
				efeito_estatico.alpha = 0.15;
				efeito_estatico.animation.play("idle", true);
				efeito_estatico.cameras = [PlayState.instance.camHUD];
				efeito_estatico.setGraphicSize(Std.int(FlxG.width * 1.7));
				efeito_estatico.screenCenter(XY);
				efeito_estatico.visible = false;
				add(efeito_estatico);
			case "chasing":
				monitor = new FlxSprite(-108, -100, Paths.image('cenarios/chasing/monitor'));
				monitor.antialiasing = ClientPrefs.globalAntialiasing;
				monitor.scale.y = 0.85;
				monitor.scrollFactor.set(1, 1);
				monitor.updateHitbox();

				contadordevida = new FlxSprite(56, 805, Paths.image('cenarios/chasing/HedgehogLives'));
				contadordevida.antialiasing = ClientPrefs.globalAntialiasing;
				contadordevida.scale.y = 0.9;
				contadordevida.scale.x = 0.9;
				contadordevida.scrollFactor.set(1, 1);
				contadordevida.updateHitbox();
				add(contadordevida);
				add(monitor);
			case "triple-trouble":
				ringCounter = new FlxSprite(1083, ClientPrefs.downScroll ? 50 : 610).loadGraphic(Paths.image('tp_ring_counter', "locales", true, true));
				add(ringCounter);
				ringCounter.cameras = [PlayState.instance.camHUD];
	
				counterNum = new FlxText(1157, ClientPrefs.downScroll ? 56 : 606, 0, '0', 10, false);
				counterNum.setFormat('EurostileTBla', 60, FlxColor.fromRGB(255, 204, 51), FlxTextBorderStyle.OUTLINE, FlxColor.fromRGB(204, 102, 0));
				counterNum.setBorderStyle(OUTLINE, FlxColor.fromRGB(204, 102, 0), 3, 1);
				add(counterNum);
				counterNum.cameras = [PlayState.instance.camHUD];
		}
	}

	override function update(elapsed:Float)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "round-a-bout":
				var leDate = Date.now();

				tempogravador.text = (leDate.getHours() <= 12 ? leDate.getHours() : leDate.getHours() - 12)
					+ ":"
					+ (leDate.getMinutes() < 10 ? "0" + Std.string(leDate.getMinutes()) : Std.string(leDate.getMinutes()))
					+ ':'
					+ (leDate.getSeconds() < 10 ? "0" + Std.string(leDate.getSeconds()) : Std.string(leDate.getSeconds()))
					+ '\n'
					+ (leDate.getHours() <= 12 ? "AM" : "PM")
					+ "\n"
					+ Std.string(leDate.getDate())
					+ " "
					+ meses[leDate.getMonth()]
					+ "\n";
			case "triple-trouble":
				counterNum.text = Std.string(PlayState.instance.cNum);
		}

		super.update(elapsed);
	}
}
