package;

import flixel.graphics.FlxGraphic;
import openfl.events.Event;
import openfl.events.ErrorEvent;
import openfl.display.Loader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import Utils.BSLTouchUtils;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.net.URLRequest; // chamoy
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

using StringTools;

class GameJoltUserObject extends FlxSpriteGroup
{
	var userBG:FlxSprite;
	var userIcon:FlxSprite;
	var userOutline:FlxSprite;

	public function new()
	{
		super();

		userBG = new FlxSprite(0, 75).loadGraphic(Paths.image("menus/gamejolt/userBG"));
		userOutline = new FlxSprite(2, 40).loadGraphic(Paths.image("menus/gamejolt/userOutline"));
        userIcon = new FlxSprite(2, 40);
        
        if (GJClient.logged)
		{
			if (MainMenuStateMobile.verificaDnvIdiota)
			{
				GameJoltLoginState.syncProgress();
				GameJoltLoginState.syncProgressFreeplay();
				MainMenuStateMobile.verificaDnvIdiota = false;
			}

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
                if(GJClient.avatarURL.contains("no-avatar"))
                {
					FlxG.log.add("Você não possui uma PFP, usando o placeholder");
					userIcon.loadGraphic(Paths.image("menus/gamejolt/userIcon")); // Placeholder
                    userIcon.setGraphicSize(152, 152);
                    userIcon.updateHitbox();
				}
				else
				{
					FlxG.log.add("Achei a PFP da Gamejolt");
					var bmp:Bitmap = cast(loader.content, Bitmap);
					var bmd:BitmapData = bmp.bitmapData;
					userIcon.loadGraphic(FlxGraphic.fromBitmapData(bmd, false));
					userIcon.setGraphicSize(152, 152);
					userIcon.updateHitbox();
					var tempMask:FlxSprite = new FlxSprite(2, 40);
					tempMask.makeGraphic(152, 152, FlxColor.TRANSPARENT, true);
					FlxSpriteUtil.drawCircle(tempMask, -1, -1, 50, FlxColor.WHITE);
					FlxSpriteUtil.alphaMaskFlxSprite(userIcon, tempMask, userIcon);
				}
			});
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, function(event:Event):Void
			{
				FlxG.log.add("Não achei a PFP da Gamejolt");
				userIcon = new FlxSprite().loadGraphic(Paths.image("menus/gamejolt/userIcon"));
				userIcon.setGraphicSize(152, 152);
				userIcon.updateHitbox();
			});
			loader.load(new URLRequest(GJClient.avatarURL.replace(".webp", ".png")));
		}
		else
		{
            FlxG.log.add("Você não está conectado na Gamejolt.");
		}

		userBG.antialiasing = ClientPrefs.globalAntialiasing;
		userIcon.antialiasing = ClientPrefs.globalAntialiasing;
		userOutline.antialiasing = ClientPrefs.globalAntialiasing;
		add(userBG);
		add(userIcon);
		add(userOutline);
	}

	override function update(elapsed)
	{
		if (BSLTouchUtils.apertasimples(userIcon) || BSLTouchUtils.apertasimples(userOutline))
		{ // Vai que o cara aperta errado né...
			// Aqui é a parte onde tu vai pros amigos da Gamejolt, só que o state não tá pronto
		}

		super.update(elapsed);
	}
}
/*Todo state meu tem que ter uma música ou algo gigante no fim né?

	PAGODE JAPONES:
	Eu estava me emboscando
	Eu estava espreitando
	Seus lábios como o mel
	De longe, de longe

	Eu estava viajando
	Eu estava sofrendo pra te procurar
	A namoração da internet é bom, né?

	Eu sou galinha
	Eu quis te olhar, a mulher nua
	Mas agora você está batendo no meu coração
	Aí, gatinha
	Me dá uma chance pra este lixo
	Ma-ra-vi-lho-so

	Com seu sorriso, por favor
	Faz-me moer, moer, moer, moer
	Vem cá, meu bem
	Ou vou aí no seu lado, é?

	Não sei mentir, pois o meu
	Está doendo à esquerda, esquerda, esquerda
	Querido meu amor
	Me ensina o feitio da felicidade

	Com seu sorriso, por favor
	Faz-me moer, moer, moer, moer
	Vem cá, meu bem
	Ou vou aí no seu lado, é?

	Não sei mentir, pois o meu
	Está doendo à esquerda, esquerda, esquerda
	Querido meu amor
	Me ensina o feitio da felicidade

	Eu sou galinha
	Eu quis te olhar, a mulher nua
	Mas agora você está batendo no meu coração
	Aí, gatinha
	Me dá uma chance pra este lixo
	Ma-ra-vi-lho-so

	Com seu sorriso, por favor
	Faz-me moer, moer, moer, moer
	Vem cá, meu bem
	Ou vou aí no seu lado, é?

	Não sei mentir, pois o meu
	Está doendo à esquerda, esquerda, esquerda
	Querido meu amor
	Me ensina o feitio da felicidade

	Com seu sorriso, por favor
	Faz-me moer, moer, moer, moer
	Vem cá, meu bem
	Ou vou aí no seu lado, é?

	Não sei mentir, pois o meu
	Está doendo à esquerda, esquerda, esquerda
	Querido meu amor
	Me ensina o feitio da felicidade */

// linda canção x02