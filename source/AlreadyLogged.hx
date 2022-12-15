package;

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
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
using StringTools;

class AlreadyLogged extends MusicBeatState
{
	var videoMenu:FlxSprite = new FlxSprite(0,0);
	var video:MP4Handler = new MP4Handler();
	var letext:FlxText;
	var simbotao:FlxButton;
	var naobotao:FlxButton;
	
	override function create()
		{
			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo os creditos", null);
			#end
			var supbg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ph'));
			supbg.antialiasing = ClientPrefs.globalAntialiasing;
			supbg.updateHitbox();
			supbg.alpha = 1;
			add(supbg);
			letext = new FlxText(50, FlxG.height - 600, FlxG.width - 100, "Você já está conectado\ndeseja se desconectar?", 32);
			letext.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			letext.scrollFactor.set();
			letext.alpha = 1;
			add(letext);
			ClientPrefs.firstTime=false;
			ClientPrefs.saveSettings();
			simbotao = new FlxButton(FlxG.width, 100, '');
			simbotao.loadGraphic(Paths.image('mainmenu/btsim', 'preload'));
			simbotao.setGraphicSize(Std.int(simbotao.width * 0.75));
	
			simbotao.updateHitbox();
			simbotao.x = 470;
			simbotao.y = 250;
			simbotao.alpha = 0.75;
			add(simbotao);

			naobotao = new FlxButton(FlxG.width, 100, '');
			naobotao.loadGraphic(Paths.image('mainmenu/btnao', 'preload'));
			naobotao.setGraphicSize(Std.int(naobotao.width * 0.75));
	
			naobotao.updateHitbox();
			naobotao.x = 470;
			naobotao.y = 395;
			naobotao.alpha = 0.75;
			add(naobotao);
			//GJClient.initialize();
			super.create();
		}
	override function update(elapsed:Float)
		{
			super.update(elapsed);

			simbotao.onOver.callback = simHover;
			simbotao.onOut.callback = simOut;
			simbotao.onDown.callback = simClick;
			naobotao.onOver.callback = naoHover;
			naobotao.onOut.callback = naoOut;
			naobotao.onDown.callback = naoClick;
		}

	function simHover():Void
		{
			simbotao.alpha=1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
		}
		function simOut():Void
			{
				simbotao.alpha=0.75;
			}

			function simClick():Void
				{
					FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
					GJClient.logout();
					MusicBeatState.switchState(new GameJoltLoginState());
				}
				function naoHover():Void
					{
						naobotao.alpha=1;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
					}
					function naoOut():Void
						{
							naobotao.alpha=0.75;
						}
			
						function naoClick():Void
							{
								FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
								FlxG.switchState(new ajustes.AjustesState());
							}
}
