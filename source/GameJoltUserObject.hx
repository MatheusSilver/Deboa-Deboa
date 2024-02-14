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
	var userName:FlxText;
	private final OUTLINE_SIZE:Int = 3;
	private final icon_pos:Array<Int> = [2,40];
	public function new()
	{
		super();

		userBG = new FlxSprite(0, 75).loadGraphic(Paths.image("menus/gamejolt/userBG"));
		userOutline = new FlxSprite(icon_pos[0], icon_pos[1]).loadGraphic(Paths.image("menus/gamejolt/userOutline"));
        userOutline.updateHitbox();
		userIcon = new FlxSprite(icon_pos[0], icon_pos[1]);
        
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
				}
				else
				{
					FlxG.log.add("Achei a PFP da Gamejolt");
					var bmp:Bitmap = cast(loader.content, Bitmap);
					var bmd:BitmapData = bmp.bitmapData;
					userIcon.loadGraphic(FlxGraphic.fromBitmapData(bmd, false));
					userIcon.setGraphicSize(Std.int(userOutline.width), Std.int(userOutline.height));
					userIcon.updateHitbox();
					var tempMask:FlxSprite = new FlxSprite(icon_pos[0], icon_pos[1]);
					//Por algum motivo, não posso só colocar ele pra trackear o userOutline :fist::pensive:
					tempMask.makeGraphic(Std.int(userOutline.width), Std.int(userOutline.height), FlxColor.TRANSPARENT);
					var tempCircle:FlxSprite = FlxSpriteUtil.drawCircle(tempMask,(tempMask.width+OUTLINE_SIZE)/2,(tempMask.height+OUTLINE_SIZE)/2,Math.min(tempMask.width, tempMask.height)/2-OUTLINE_SIZE,FlxColor.RED);
					// add(tempCircle);
					FlxSpriteUtil.alphaMaskFlxSprite(userIcon, tempCircle, userIcon);
					tempMask.destroy();
					tempCircle.destroy();
				}
			});
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, function(event:Event):Void
			{
				FlxG.log.add("Não achei a PFP da Gamejolt");
			});
			loader.load(new URLRequest(GJClient.avatarURL.replace("/60/",'/${Std.int(userOutline.height)}/').replace(".webp", ".png")));
		}
		else
		{
            FlxG.log.add("Você não está conectado na Gamejolt.");
		}

		if(userIcon.graphic==null)
		{
			userIcon.loadGraphic(Paths.image("menus/gamejolt/userIcon"));
			userIcon.setGraphicSize(Std.int(userOutline.width), Std.int(userOutline.height));
			userIcon.updateHitbox();
		}

		userName = new FlxText(userOutline.x+userOutline.width + 5, userBG.y, userBG.width - userIcon.width, GJClient.logged ? GJClient.userName:LangUtil.getString("menu_disconnected", "menu"));
		userName.setFormat(LangUtil.getFont("vio"), 36, 0xffffff, LEFT, OUTLINE, FlxColor.BLACK);
		userName.y += userName.height/3;
		userBG.antialiasing = ClientPrefs.globalAntialiasing;
		userIcon.antialiasing = ClientPrefs.globalAntialiasing;
		userOutline.antialiasing = ClientPrefs.globalAntialiasing;
		add(userBG);
		add(userName);
		add(userIcon);
		add(userOutline);
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