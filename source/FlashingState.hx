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
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Ooopa!\n
			Este mod contém luzes piscantes e gore!\n
			Caso esteja gravando sua tela:\n
			Recomendamos gravar somente a tela e não diretamente o jogo.\n
			Desmarque as opções de Luzes Piscantes e Gore,\n
			Para não causar problemas aos seus viewers.\n
			Recomendamos ir ao menu de opções antes de jogar,\n
			Aperte ESC para ir até as configurações,\n
			ou aperte ENTER para ir direto ao jogo.\n
			Uma boa jogatina.", //Tenho certeza que foi o X02
			32);			// k
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(XY);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if(controls.ACCEPT) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
					new FlxTimer().start(0.5, function (tmr:FlxTimer) {
						MusicBeatState.switchState(new TitleState());
					});
				});
			}else if(controls.BACK){
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new ajustes.BaseOptionsMenu());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
