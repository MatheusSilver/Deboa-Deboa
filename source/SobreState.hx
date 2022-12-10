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
import sys.FileSystem;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
using StringTools;

class SobreState extends MusicBeatState
{
	var videoMenu:FlxSprite = new FlxSprite(0,0);
	var video:MP4Handler = new MP4Handler();
	var letext:FlxText;
	var videobotao:FlxButton;
	var credbotao:FlxButton;
	
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
			letext = new FlxText(50, FlxG.height - 600, FlxG.width - 95, "SOBRE", 32);
			letext.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			letext.scrollFactor.set();
			letext.alpha = 1;
			add(letext);
			videobotao = new FlxButton(FlxG.width, 100, '');
			videobotao.loadGraphic(Paths.image('mainmenu/btvideo', 'preload'));
			videobotao.setGraphicSize(Std.int(videobotao.width * 0.75));
	
			videobotao.updateHitbox();
			videobotao.x = 385;
			videobotao.y = 250;
			videobotao.alpha = 0.75;
			add(videobotao);

			credbotao = new FlxButton(FlxG.width, 100, '');
			credbotao.loadGraphic(Paths.image('mainmenu/btcr', 'preload'));
			credbotao.setGraphicSize(Std.int(credbotao.width * 0.75));
	
			credbotao.updateHitbox();
			credbotao.x = 385;
			credbotao.y = 415;
			credbotao.alpha = 0.75;
			add(credbotao);
	
			super.create();
		}
	override function update(elapsed:Float)
		{
            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuStateMobile());
            }
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }
			videobotao.onOver.callback = videoHover;
			videobotao.onOut.callback = videoOut;
			videobotao.onDown.callback = videoClick;
			credbotao.onOver.callback = credHover;
			credbotao.onOut.callback = credOut;
			credbotao.onDown.callback = credClick;
		}

	function videoHover():Void
		{
			videobotao.alpha=1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
		}
		function videoOut():Void
			{
				videobotao.alpha=0.75;
			}

			function videoClick():Void
				{
					FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
					VideoStatePC.videoPath = "assets/videos/aviso.mp4";
					VideoStatePC.NextState = "sobremenu";
					MusicBeatState.switchState(new VideoStatePC());
				}
				function credHover():Void
					{
						credbotao.alpha=1;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
					}
					function credOut():Void
						{
							credbotao.alpha=0.75;
						}
			
						function credClick():Void
							{
								FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
								//MusicBeatState.switchState(new MainMenuStateMobile());
							}
}
