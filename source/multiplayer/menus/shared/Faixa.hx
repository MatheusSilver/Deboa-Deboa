package multiplayer.menus.shared;

import gamejolt.User;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.ErrorEvent;
import openfl.display.Loader;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import gamejolt.GJClient;
import multiplayer.menus.Lobby.LobbyPlayer;
import Utils;

using StringTools;

class Faixa extends FlxSpriteGroup
{
	var icon:FlxSprite;
	var bg:FlxSprite;
	var text:Array<FlxText>;

	public function new(x:Int, y:Int)
	{
		super(x, y);

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/faixa"));
		bg.x = 0;
		bg.y = 0;
		add(bg);

		icon = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
		icon.antialiasing = ClientPrefs.globalAntialiasing;
		icon.setGraphicSize(62, 62);
		icon.y = 9;
		icon.x = 50;
		add(icon);

		text = createColoredText("ONLINE", [FlxColor.fromRGB(233, 99, 34), FlxColor.fromRGB(253, 246, 241)], 122, 0, 48, Linguagem.LangUtil.getFont("gobold"),
			-2);
		for (letra in text)
		{
			add(letra);
		}
		pegarIcon();
	}

	function pegarIcon()
	{
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void
		{
			if (!GJClient.avatarURL.contains("no-avatar"))
			{
				var bmp:Bitmap = cast(loader.content, Bitmap);
				var bmd:BitmapData = bmp.bitmapData;
				icon.loadGraphic(FlxGraphic.fromBitmapData(bmd, false));
				icon.setGraphicSize(62, 62); // aparentemente aquele numero do link é uma mentira :womp: :womp:
				icon.updateHitbox();
				var tempMask:FlxSprite = new FlxSprite(icon.x, icon.y);
				// Por algum motivo, não posso só colocar ele pra trackear o userOutline :fist::pensive:
				tempMask.makeGraphic(62, 62, FlxColor.TRANSPARENT);
				var tempCircle:FlxSprite = FlxSpriteUtil.drawCircle(tempMask, (tempMask.width) / 2, (tempMask.height) / 2,
					Math.min(tempMask.width, tempMask.height) / 2 - 3, FlxColor.RED);
				// add(tempCircle);
				FlxSpriteUtil.alphaMaskFlxSprite(icon, tempCircle, icon);
				tempMask.destroy();
				tempCircle.destroy();
			}
		});
		loader.load(new URLRequest(GJClient.avatarURL.replace("/62/", '/${Std.int(icon.height)}/').replace(".webp", ".png")));
	}

	public static function createColoredText(text:String, colors:Array<FlxColor>, x:Float, y:Float, size:Int, font:String, ?offset:Int = 0,
			?inverted:Bool = false):Array<FlxText>
	{
		var currentX:Float = x;
		var allTexts:Array<FlxText> = new Array<FlxText>();

		for (i in 0...text.length)
		{
			var char:String = text.charAt(i);
			var color:FlxColor = colors[i < 2 ? 0 : 1];
			var textPart:FlxText = new FlxText(currentX, y, 0, char);
			textPart.setFormat(font, size, color);

			if (inverted)
			{
				currentX -= textPart.width - offset;
			}
			else
			{
				currentX += textPart.width + offset;
			}
			allTexts.push(textPart);
		}

		return allTexts;
	}
}

class FaixaLobby extends FlxSpriteGroup
{
	var gameJoltID:Int;
	var icon:FlxSprite;
	var bgInicio:FlxSprite;
	var bgFinal:FlxSprite;

	public var bgMeio:FlxSprite;
	public var text:Array<FlxText>;

	var userData:User;
	var baseX:Float;
	var foraX:Float;

	public function new(gameJoltID:String, x:Float, y:Float, isLeft:Bool)
	{
		super(x, y);

		this.gameJoltID = Std.parseInt(gameJoltID);
		userData = GJClient.getUserData(Std.parseInt(gameJoltID));

		if (!isLeft)
		{
			text = Faixa.createColoredText(userData != null ? userData.username.toUpperCase() : " ",
				[FlxColor.fromRGB(233, 99, 34), FlxColor.fromRGB(253, 246, 241)], 122, -1, 36, Linguagem.LangUtil.getFont("gobold"), -2);

			bgInicio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa1"));

			bgMeio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa3"));
			bgMeio.setGraphicSize(Std.int(text[text.length - 1].x - bgInicio.x) - 1, 56);
			bgMeio.updateHitbox();
			add(bgMeio);
			add(bgInicio);
			bgMeio.x += bgInicio.width;
			bgMeio.y += 1;

			bgFinal = new FlxSprite(bgMeio.x + bgMeio.width, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa2"));
			add(bgFinal);

			icon = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
			icon.antialiasing = ClientPrefs.globalAntialiasing;
			icon.setGraphicSize(62, 62);
			icon.y = -2;
			icon.x = 50;
			icon.visible = false;
			add(icon);

			foraX = this.width*1.5;
		}
		else
		{
			text = Faixa.createColoredText(userData != null ? userData.username.toUpperCase() : " ",
				[FlxColor.fromRGB(233, 99, 34), FlxColor.fromRGB(253, 246, 241)], 122, -1, 36, Linguagem.LangUtil.getFont("gobold"), -2);

			bgInicio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa2"));
			bgInicio.flipX = true;

			bgMeio = new FlxSprite(0, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa3"));
			bgMeio.setGraphicSize(Std.int(text[text.length - 1].x - bgInicio.x) - 1, 56);
			bgMeio.updateHitbox();
			add(bgMeio);
			add(bgInicio);
			bgMeio.x += bgInicio.width;
			bgMeio.y += 1;

			bgFinal = new FlxSprite(bgMeio.x + bgMeio.width, 0).loadGraphic(Paths.image("multiplayer/menus/lobby/faixa1"));
			bgFinal.flipX = true;
			add(bgFinal);

			for (textinho in text)
			{
				textinho.x += (bgMeio.x + 1) - 120;
			}

			icon = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/userIcon"));
			icon.antialiasing = ClientPrefs.globalAntialiasing;
			icon.setGraphicSize(62, 62);
			icon.y = -2;
			icon.x = bgFinal.x - 80;
			icon.visible = false;
			add(icon);

			foraX = -this.width*1.5;
		}

		for (letra in text)
		{
			add(letra);
		}
		pegarIcon();
	}

	public function setBase() {
		baseX = this.x;
	}

	function pegarIcon()
	{
		if (userData == null)
		{
			icon.loadGraphic(Paths.image("menus/gamejolt/userIcon"));
			var bmd:BitmapData = icon.graphic.bitmap;
			modifySprite(bmd);
		}
		else
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):Void
			{
				if (!GJClient.avatarURL.contains("no-avatar"))
				{
					var bmp:Bitmap = cast(loader.content, Bitmap);
					var bmd:BitmapData = bmp.bitmapData;
					modifySprite(bmd);
				}
			});
			loader.load(new URLRequest(userData.avatar_url.replace("/62/", '/${Std.int(icon.height)}/').replace(".webp", ".png")));
		}
	}

	var imageLoaded:Bool = false;
	function modifySprite(bmd:BitmapData)
	{
		icon.loadGraphic(FlxGraphic.fromBitmapData(bmd, false));
		icon.setGraphicSize(62, 62); // aparentemente aquele numero do link é uma mentira :womp: :womp:
		icon.updateHitbox();
		var tempMask:FlxSprite = new FlxSprite(icon.x, icon.y);
		// Por algum motivo, não posso só colocar ele pra trackear o userOutline :fist::pensive:
		tempMask.makeGraphic(62, 62, FlxColor.TRANSPARENT);
		var tempCircle:FlxSprite = FlxSpriteUtil.drawCircle(tempMask, (tempMask.width) / 2, (tempMask.height) / 2,
			Math.min(tempMask.width, tempMask.height) / 2 - 3, FlxColor.RED);
		// add(tempCircle);
		FlxSpriteUtil.alphaMaskFlxSprite(icon, tempCircle, icon);
		tempMask.destroy();
		tempCircle.destroy();
		icon.setGraphicSize(47, 47);
		icon.visible = true;

		imageLoaded = true;
	}

	public function aparecer() {
		setBase();
		this.x = foraX; 
		if (gameJoltID == 0) 
			return;

		FlxTween.tween(this, {x: baseX}, 0.75, {ease: FlxEase.sineOut});
	}


	public function sair(parent:LobbyPlayer) {
		FlxTween.tween(this, {x: foraX}, 0.5, {ease: FlxEase.sineIn, onComplete: function(tw:FlxTween) {
			for(texto in text) {
                remove(texto);
            }
            parent.remove(this);
		}});
	}
}
