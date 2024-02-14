package;

// Aparentemente as coordenadas ficam bugadas em substates...
// Talvez eu precise usar camera, mas não tenho certeza
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flash.filters.BlurFilter;
#if rpc
import Discord.DiscordClient;
#end
import flixel.FlxCamera;

using StringTools;

class GameJoltFriendsMenu extends MusicBeatSubstate
{
	var bg:FlxSprite;
    var voltar_button:FlxButton;
    var label:FlxText;
    public var camElementos:FlxCamera;
    var sumidao:Bool = false;
    var blur:BlurFilter;

	public function new()
	{
		super();
        if(ClientPrefs.shaders)
        {
            blur = new BlurFilter();
            blur.blurX = 0;
            blur.blurY = 0;
        }
        
        MainMenuStateMobile.canClick = false;

        camElementos = new FlxCamera();
		camElementos.bgColor.alpha = 0;
        FlxG.cameras.add(camElementos, false);

		#if rpc
		DiscordClient.changePresence(LangUtil.getString("rpc_friends", "rpc"), null);
		#end

		bg = new FlxSprite(0, 1280).loadGraphic(Paths.image("menus/gamejolt/amigos/BG"));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter(XY);
        bg.y = 1280;
        bg.cameras = [camElementos];
		add(bg);

        voltar_button = new FlxButton(973, 63+1280, function() {
            if(sumidao)
                return;
            sumidao = true;
            tweenSair();
        });
        voltar_button.alpha = 0;
        voltar_button.visible = true;
        voltar_button.label = new FlxText(0, 3, 229, LangUtil.getString("menu_back", "menu"), 50);
        voltar_button.label.setFormat(Paths.font("letravio.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        voltar_button.cameras = [camElementos];
        voltar_button.setGraphicSize(229, 103);
        voltar_button.updateHitbox();
        voltar_button.label.offset.y-=7;
        add(voltar_button);

        label = new FlxText(0, 0, 600, LangUtil.getString("menu_friends", "menu"), 70);
        label.setFormat(Paths.font("letravio.ttf"), 70, FlxColor.WHITE, LEFT);
        label.cameras = [camElementos];
        label.x = 145;
        label.y = 65+1280;
        add(label);
        tweenEntrar();
	}

    function tweenEntrar()
    {
        MainMenuStateMobile.instance.camGame.setFilters([blur]);
        MainMenuStateMobile.instance.camAchievement.setFilters([blur]);
        FlxTween.tween(blur, {blurX: 3, blurY: 3}, 0.5, {ease: FlxEase.quartInOut});
        FlxTween.tween(label, {y: 65}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(voltar_button, {y: 63}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(bg, {y: 0}, 0.5, {ease: FlxEase.expoInOut});
    }

    function tweenSair()
    {
        MainMenuStateMobile.instance.voltarUser();
        FlxTween.tween(blur, {blurX: 0, blurY: 0}, 0.5, {ease: FlxEase.quartInOut});
        FlxTween.tween(label, {y: 65+1280}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(voltar_button, {y: 63+1280}, 0.5, {ease: FlxEase.expoInOut});
        FlxTween.tween(bg, {y: 1280}, 0.5, {ease: FlxEase.expoInOut, onComplete: function(e:FlxTween) {
            #if rpc
            DiscordClient.changePresence(LangUtil.getString("rpc_main_menu", "rpc"), null);
            #end
            MainMenuStateMobile.canClick = true;
            MainMenuStateMobile.instance.camGame.setFilters([]);
            MainMenuStateMobile.instance.camAchievement.setFilters([]);
            close();
        }});
    }

	override function update(elapsed:Float)
	{
        voltar_button.label.alpha = 1;
		super.update(elapsed);
        voltar_button.label.alpha = 1;
	}
}


