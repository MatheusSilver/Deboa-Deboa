package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import HSys;

using StringTools;

class Cache extends MusicBeatState
{
	public static var bitmapData:Map<String,FlxGraphic>;
	public static var bitmapData2:Map<String,FlxGraphic>;

	var images = [];
	var music = [];

	public var canSpace:Bool=false;

	var shitz:FlxText;
	var shitz2:FlxText;

	override function create()
	{
		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('funkay'));
		menuBG.screenCenter();
		//add(menuBG);

		shitz = new FlxText(0, 0, 0, "CARREGANDO", 20);
		shitz.screenCenter();
		shitz.scrollFactor.set();
		shitz.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(shitz);
		shitz2 = new FlxText(0, 0, 0, "ATENÇÃO!\nA versão que você está prestes\na jogar é uma versão de testes!\nAPERTE QUALQUER TECLA PARA JOGAR", 20);
		shitz2.screenCenter();
		shitz2.scrollFactor.set();
		shitz2.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		shitz2.alpha = 0;
		add(shitz2);


		for (i in HSys.readDirectory("assets/shared/images"))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}

		for (i in HSys.readDirectory("assets/preload/images"))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}

		sys.thread.Thread.create(() -> {
			cache();
		});

		super.create();
	}

	override function update(elapsed) 
	{
		super.update(elapsed);
		if(canSpace)
		{
			if(FlxG.keys.justPressed.ANY)
			{
				FlxG.switchState(new TitleState());
			}
		}
	}

	function cache()
	{
		#if !linux
		/*
			var sound1:FlxSound;
			sound1 = new FlxSound().loadEmbedded(Paths.voices('fresh'));
			sound1.play();
			sound1.volume = 0.00001;
			FlxG.sound.list.add(sound1);

			var sound2:FlxSound;
			sound2 = new FlxSound().loadEmbedded(Paths.inst('fresh'));
			sound2.play();
			sound2.volume = 0.00001;
			FlxG.sound.list.add(sound2);
		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
		}



		for (i in music)
		{
			trace(i);
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
		}

		*/
		#end
		Aviso();
	}

	function Aviso()
	{
		shitz.alpha = 0;
		shitz2.alpha=1;
		canSpace = true;
	}

}