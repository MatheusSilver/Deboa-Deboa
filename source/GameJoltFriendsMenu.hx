package;

// Aparentemente as coordenadas ficam bugadas em substates...
// Talvez eu precise usar camera, mas não tenho certeza
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
#if rpc
import Discord.DiscordClient;
#end
import flixel.FlxCamera;

using StringTools;

class GameJoltFriendsMenu extends MusicBeatSubstate
{
	var bg:FlxSprite;
    var voltar_button:FlxButton;
    public var camElementos:FlxCamera;

	public function new()
	{
		super();
        
        MainMenuStateMobile.canClick = false;

        camElementos = new FlxCamera();
		camElementos.bgColor.alpha = 0;
        FlxG.cameras.add(camElementos, false);

		#if rpc
		DiscordClient.changePresence(LangUtil.getString("rpc_friends", "rpc"), null);
		#end

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/gamejolt/amigos/BG"));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter(XY);
        bg.cameras = [camElementos];
		add(bg);

        voltar_button = new FlxButton(973, 63, function() {
            #if rpc
            DiscordClient.changePresence(LangUtil.getString("rpc_main_menu", "rpc"), null);
            #end
            MainMenuStateMobile.canClick = true;
            MainMenuStateMobile.instance.voltarUser();
            close();
        });
        voltar_button.visible = true;
        voltar_button.cameras = [camElementos];
        voltar_button.setGraphicSize(229, 103);
        voltar_button.updateHitbox();
        add(voltar_button);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
