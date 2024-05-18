package gamejolt;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.net.URLRequest; // chamoy

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

		userBG = new FlxSprite(0, 75).loadGraphic(Paths.image("menus/gamejolt/userBG", "preload", false));
		userOutline = new FlxSprite(icon_pos[0], icon_pos[1]).loadGraphic(Paths.image("menus/gamejolt/userOutline", "preload", false));
        userOutline.updateHitbox();
		userIcon = new FlxSprite(icon_pos[0], icon_pos[1]);
        
        if (GJClient.logged) {
			if (MainMenuStateMobile.verificaDnvIdiota)
			{
				GameJoltLoginState.syncProgress();
				GameJoltLoginState.syncProgressFreeplay();
				MainMenuStateMobile.verificaDnvIdiota = false;
			}

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void {
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
			});
			loader.load(new URLRequest(GJClient.avatarURL.replace("/60/",'/${Std.int(userOutline.height)}/').replace(".webp", ".png")));
		}

		if(userIcon.graphic == null) {
			userIcon.loadGraphic(Paths.image("menus/gamejolt/userIcon"));
			userIcon.setGraphicSize(Std.int(userOutline.width), Std.int(userOutline.height));
			userIcon.updateHitbox();
		}

		userName = new FlxText(userOutline.x+userOutline.width + 5, userBG.y, userBG.width - userIcon.width, GJClient.logged ? GJClient.userName:Linguagem.LangUtil.getString("menu_disconnected", "menu"));
		userName.setFormat(Linguagem.LangUtil.getFont("vio"), 36, 0xffffff, LEFT, OUTLINE, FlxColor.BLACK);
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

/* Já que esse state é de minha posse...

			MAMONAS ASSASSINAS
			    Robocop Gay

		Um tanto quanto másculo
		Com M maiúsculo
		Vejam só os meus músculos
		Que com amor cultivei
		Minha pistola é de plástico
		Em formato cilíndrico
		Sempre me chamam de cínico
		Mas o porquê eu não sei
		O meu bumbum era flácido
		Mas esse assunto é tão místico
		Devido ao ato cirúrgico
		Hoje eu me transformei
		O meu andar é erótico
		Com movimentos atômicos
		Sou uma amante robótico
		Com direito a replay
		Um ser humano fantástico
		Com poderes titânicos
		Foi um moreno simpático
		Por quem me apaixonei
		E hoje estou tão eufórico
		Com mil pedaços biônicos
		Ontem eu era católico
		Ai, hoje eu sou um gay
		Abra sua mente
		Gay também é gente
		Baiano fala oxente
		E come vatapá
		Você pode ser gótico
		Ser punk ou skinhead
		Tem gay que é Muhamed
		Tentando camuflar
		(Allah meu bom Allah)
		Faça bem a barba
		Arranque seu bigode
		Gaúcho também pode
		Não tem que disfarçar
		Faça uma plástica
		Aí entre na ginástica
		Boneca cibernética
		Um robocop gay
		Um robocop gay, um robocop gay
		Ai eu sei, eu sei
		Um robocop gay
		Ai como dói

	Dedico essa música ao Rafael 
*/