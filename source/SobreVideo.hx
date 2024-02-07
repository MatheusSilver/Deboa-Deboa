package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;
#if rpc
import Discord.DiscordClient;
#end

class SobreVideo extends MusicBeatState
{
    var bg:FlxSprite = new FlxSprite(0,0);
    var botoes:FlxSprite = new FlxSprite(0,0);
    var barra:FlxSprite = new FlxSprite(0,0);
    var barrabranca:FlxSprite  = new FlxSprite(0,0);
	var video:MP4Sprite;
	var sampleTxt:FlxText;
    var ha:Float=0;
    var ha2:Float=177;
	public static var videoPath:String = Paths.video("EngineBase/aviso");


	override function create()
		{
            video = new MP4Sprite(-10, -5, ABOUT);
            video.canSkip = false;
            Main.mouse_allowed = true;
			#if rpc
			// Updating Discord Rich Presence
			DiscordClient.changePresence(LangUtil.getString("rpc_about", "rpc"), null);
			#end
            FlxG.sound.music.fadeIn(0.35, 0.7, 0);
            new FlxTimer().start(0.8, function(tmr:FlxTimer){
                video.playMP4(videoPath, new SobreState());
                video.scale.x = video.scale.y = 0.73;
                video.y -= 70;
                barra.alpha=1;
                FlxTween.num(0.0, 1.0, 73, function(num){ ha = num; });
                FlxTween.tween(barra, {x: 0}, 73);

                new FlxTimer().start(76, function(tmr:FlxTimer){
                    #if desktop
                    FlxG.mouse.unload();
                    #end
                    video.stop();
                    GlobalSoundManager.play('cancelMenu');
                    MusicBeatState.switchState(new SobreState());
                });
            });
            bg.loadGraphic(Paths.image('sobremenu/video/bg', 'preload'));
            barra.loadGraphic(Paths.image('sobremenu/video/barra', 'preload'), false, 0, 4);
            barrabranca.loadGraphic(Paths.image('sobremenu/video/barrabranca', 'preload'), false, 0, 4);
            botoes.loadGraphic(Paths.image('sobremenu/video/botoes', 'preload'));
            barra.x = -463;
            barra.alpha=1;
            barra.scale.set(0, 1);
            add(bg);
            add(video);
            add(barrabranca);
            add(barra);
            add(botoes);
            sampleTxt = new FlxText(50, FlxG.height - 200, FlxG.width - 200, "", 30);
            sampleTxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            sampleTxt.scrollFactor.set();
            sampleTxt.screenCenter(XY);
            sampleTxt.alpha = 1;
            //add(sampleTxt);
            #if desktop
            FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
            #end
			super.create();
		}

	override function update(elapsed:Float)
		{
            barra.scale.set(ha, 1);
            barra.y=0;
            //sampleTxt.text=Std.string(videoMenu.x)+"\n"+Std.string(videoMenu.y);
            video.canSkip = false;
			super.update(elapsed);
            if (controls.BACK) {
                #if desktop
                FlxG.mouse.unload();
                #end
                video.stop();
                GlobalSoundManager.play('cancelMenu');
                MusicBeatState.switchState(new SobreState());
            }
		}
}
