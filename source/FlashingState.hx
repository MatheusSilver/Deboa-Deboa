package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var texto:String = "Aperte ENTER para prosseguir ou\nESC para desativar as configurações citadas";
	override function create()
	{
		super.create();

		#if mobile
		texto = "Toque na tela para prosseguir ou\nBotão BACK para desativar as configurações citadas";
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"AVISO IMPORTANTE\n
			Este mod contém luzes piscantes e gore.\n
			Caso esteja gravando sua tela (youtubers/streamers):\n
			Recomendamos gravar a tela e não diretamente o jogo.\n
			Desmarque as opções de Luzes Piscantes e Gore\n
			para não causar problemas aos seus viewers.\n" +
			"${texto}",
			25);
		warnText.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		warnText.screenCenter(XY);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if(controls.ACCEPT #if mobile || BSLTouchUtils.justTouched() #end) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				GlobalSoundManager.play('confirmMenu');
				FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
					new FlxTimer().start(0.5, function (tmr:FlxTimer) {
						MusicBeatState.switchState(new TitleState());
					});
				});
			}else if(controls.BACK #if mobile || FlxG.android.justReleased.BACK #end){
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				GlobalSoundManager.play('confirmMenu');
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						ClientPrefs.gore = false;
						ClientPrefs.flashing = false;
						MusicBeatState.switchState(new TitleState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
