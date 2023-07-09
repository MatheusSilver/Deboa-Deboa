package;

import Utils.BSLTouchUtils;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import lime.math.Vector2;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;
import flixel.FlxGame;
import openfl.display.GraphicsShader;
import openfl.filters.ShaderFilter;
import lime.app.Application;
import lime.ui.WindowAttributes;
import flash.filters.BlurFilter;
import lime.ui.Window;
import flixel.tweens.misc.NumTween;

using StringTools;

class ScoreScreenSubstate extends MusicBeatSubstate
{

	var ratingsOverlay:FlxTypedGroup<FlxSprite>;
	var ratingsIcons:FlxTypedGroup<FlxSprite>;
	var hitNumbers:FlxTypedGroup<FlxText>;
	var scoreText:FlxText;
	var scoreTextTween:FlxTween;
	var blurShader:BlurFilter;
	var iconList:Array<String> = ['sick', 'good', 'bad', 'shit', 'miss']; //Esse último ainda não tem uma arte definida.
	var rankingsArray:Array<Int> = [PlayState.sicks, PlayState.goods, PlayState.bads, PlayState.shits, PlayState.instance.songMisses];

	public function new(isMultiplayer:Bool = false)
	{
		//Eventualmente, caso a ideia do multiplayer seja realmente feita, o isMultiplayer deve marcar o uso ou não das informações sobre quem ganhou.
		super();
		blurShader = new BlurFilter();
		var soundsArray:Array<String> = ['good','great','awesome','outstanding','amazing'];

		//FlxG.sound.music.fadeOut(0, 1.0);
		
		if(ClientPrefs.shaders)
			{
				if(PlayState.instance.curSong.toLowerCase()!="round-a-bout")
				{
					PlayState.instance.camGame.setFilters([blurShader]);
					PlayState.instance.camHUD.setFilters([blurShader]);
				}
				FlxTween.tween(blurShader, {blurX: 3, blurY: 3}, 1.25, {ease: FlxEase.quartInOut});
			}

		ratingsOverlay = new FlxTypedGroup<FlxSprite>();
		add(ratingsOverlay);

		ratingsIcons = new FlxTypedGroup<FlxSprite>();
		add(ratingsIcons);

		hitNumbers = new FlxTypedGroup<FlxText>();
		add(hitNumbers);

		for (i in 0...rankingsArray.length){
			generateOverlayBar(i);

			generateIcons(i);

			generateHits(i);
		}

		generateScoreText();

		super.create();

		scoreTextTween = FlxTween.num(0, PlayState.instance.ratingPercent, 10, {ease: FlxEase.linear
		}, function (v:Float) {
			scoreText.text = Std.string(v);
			if (v%20 == 0)
				FlxG.sound.play(soundsArray[Math.floor(v/20)]);
		});

		new FlxTimer().start(10, function(tmr:FlxTimer){
			entrada();
		});

			
	}

	private function entrada()
	{
		ratingsOverlay.forEach(function(spr:FlxSprite)
		{
			FlxTween.tween(ratingsOverlay.members[spr.ID], {x: FlxG.width/2}, 0.35, {ease: FlxEase.expoInOut, startDelay: 0.15});
		});
		ratingsIcons.forEach(function(spr:FlxSprite)
		{
			FlxTween.tween(ratingsIcons.members[spr.ID], {x: FlxG.width/2 - 100}, 0.35, {ease: FlxEase.expoInOut, startDelay: 0.15});
		});

		hitNumbers.forEach(function(spr:FlxText)
		{
			FlxTween.tween(hitNumbers.members[spr.ID], {x: FlxG.width/2 - spr.fieldWidth}, 0.35, {ease: FlxEase.expoInOut, startDelay: 0.15});
		});
	}

	private function generateOverlayBar(i:Int)
		{
			var overlayBar:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ratings/ratingBar', 'preload'));
			overlayBar.x = - overlayBar.width;
			overlayBar.y = 50 + overlayBar.height*i;
			overlayBar.antialiasing = ClientPrefs.globalAntialiasing;
			overlayBar.updateHitbox();
			overlayBar.ID = i;
			ratingsOverlay.add(overlayBar);
		}

	private function generateIcons(i:Int)
	{
		var icon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(iconList[i], 'preload'));
		//icon.setGraphicSize(Std.int(icon.width *1)) 
		icon.updateHitbox();
		icon.x = -icon.width;
		icon.y = ratingsOverlay.members[i].y;
		icon.antialiasing = ClientPrefs.globalAntialiasing;
		icon.ID = i;
		ratingsIcons.add(icon);
	}

	private function generateHits(i:Int)
	{
		var text:FlxText = new FlxText(0,0,0, Std.string(rankingsArray[i]), 16);
		text.setFormat(Paths.font("letravio.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.x = -text.width;
		text.y = ratingsOverlay.members[i].y+15;
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.ID = i;
		hitNumbers.add(text);
	}

	private function generateScoreText()
	{
		scoreText = new FlxText(FlxG.width*0.8, 100, 50, '0', 32);
		scoreText.setFormat(Paths.font("letravio.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.antialiasing = ClientPrefs.globalAntialiasing;
		scoreText.screenCenter(X);
		add(scoreText);
	}

	private function goBack(){
		MusicBeatState.switchState(new EstadoDeTrocaReverso());
		lime.app.Application.current.window.title='FNF: ModBoa EXE';
				
		FlxG.sound.playMusic(Paths.music('newmenu'));
	}

	override function update(elapsed:Float)
	{
		if (Utils.BSLTouchUtils.justTouched())
			goBack();
	}
}