package minigame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Testing extends MusicBeatState
{
    var canMove:Bool = true;
	var player:FlxSprite;
    var levelC:FlxSprite;
	var levelS:FlxSprite;
	var pSpeed:Float = 20;

	override public function create():Void
	{
		FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xffaaaaaa;

		levelS = new FlxSprite(0, 0);
		levelS.loadGraphic(Paths.image('minigame/cenario', 'preload'));
		levelS.setGraphicSize(Std.int(levelS.width*2.5));
		levelS.setPosition(7253, -880);
		levelS.immovable=true;
		add(levelS);

		levelC = new FlxSprite(0,0);
		levelC.loadGraphic(Paths.image('minigame/col', 'preload'));
		levelC.setPosition(-9, 583);
		levelC.immovable=true;
		levelC.visible=false;
		add(levelC);


		player = new FlxSprite(FlxG.width / 2 - 5);
		player.makeGraphic(80, 150, FlxColor.RED);
		player.maxVelocity.set(300, 1200);
		player.acceleration.y = 3200;
		player.drag.x = player.maxVelocity.x * pSpeed;
        player.updateHitbox();
		add(player);

        
	}

	override public function update(elapsed:Float):Void
	{
		player.acceleration.x = 0;

		if(canMove){
			if (FlxG.keys.anyPressed([LEFT, A]))
			{
				player.acceleration.x = -player.maxVelocity.x * pSpeed;
			}

			if (FlxG.keys.anyPressed([RIGHT, D]))
			{
				player.acceleration.x = player.maxVelocity.x * pSpeed;
			}
		}

		/*if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && player.isTouching(FLOOR))
		{
			player.velocity.y = -player.maxVelocity.y / 1;
		}*/

		super.update(elapsed);

		FlxG.collide(levelC, player);

		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
	}
}