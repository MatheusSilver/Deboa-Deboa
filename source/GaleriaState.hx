package;

import flixel.addons.ui.FlxSlider;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
using StringTools;

class GaleriaState extends MusicBeatState
{
	var bg:FlxSprite;
	
	override function create()
		{
			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo a galeria", null);
			#end
            
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/galeria/galeria_back'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
            bg.y=0;
			add(bg);


			super.create();
        }

		override function update(elapsed:Float)
			{
				if(FlxG.mouse.wheel>0)
					{
						if(bg.y==0)
							{
								bg.y=0;
							}
						else if(bg.y<0)
							{
								bg.y=bg.y+15;
							}
					}
				else if(FlxG.mouse.wheel<0)
					{
						if(bg.y==-1402)
							{
								bg.y=-1402;
							}
						else if(bg.y>-1402)
							{
								bg.y=bg.y-15;
							}
					}
				super.update(elapsed);
			}

}