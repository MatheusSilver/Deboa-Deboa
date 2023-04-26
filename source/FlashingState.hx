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
			Recomendamos gravar a tela e não diretamente o jogo.\n
			Desmarque as opções de Luzes Piscantes e Gore\n
			para não causar problemas aos seus viewers.\n
			Aperte ESC para desativar essas configurações\n
			ou aperte ENTER para ignorar essa mensagem.\n
			Uma boa jogatina!", //Tenho certeza que foi o X02
			25);			// k
		warnText.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
		warnText.screenCenter(XY);
		add(warnText);

		#if mobileC
		addVirtualPad(NONE, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if(controls.ACCEPT) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				GlobalSoundManager.play('confirmMenu');
				FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
					new FlxTimer().start(0.5, function (tmr:FlxTimer) {
						MusicBeatState.switchState(new TitleState());
					});
				});
			}else if(controls.BACK){
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
