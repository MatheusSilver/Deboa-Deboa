package multiplayer.menus;

import cpp.abi.Abi;
import haxe.Constraints.Function;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.addons.ui.FlxUIInputText;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.colyseus.Client;
import io.colyseus.Room;
import io.colyseus.events.EventHandler;
import openfl.events.KeyboardEvent;
import flixel.group.FlxSpriteGroup;
import FlxScrollbar.FlxScrollableArea;
import flixel.math.FlxRect;
import openfl.utils.Assets as OpenFlAssets;
import multiplayer.schemas.*;
import multiplayer.entities.*;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;
import gamejolt.*;
import Utils;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;
import multiplayer.menus.shared.Faixa.FaixaLobby;
import Linguagem.LangUtil;

using StringTools;

class Lobby extends MultiplayerMenu
{
    public static var instance:Lobby;

    var bg:FlxSprite;
    public var players:Array<LobbyPlayer> = [new LobbyPlayer(203, -10, true, "0", -1400), new LobbyPlayer(522, 218, false, "0", 1400)];
    var go:FlxButton;

    var readyTxt:FlxText;


    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/lobby/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
        addToMenu(bg, {alpha: 1}, {alpha: 0});

        for (player in players) {
            addToMenu(player, {alpha: 1}, {alpha: 0});
            addTween(player.bf, {x: player.bf.x}, {x: player.posicaoSaida});
        }

        readyTxt = new FlxText(0,0, 0, "PRONTOS: 0/2");
        readyTxt.setFormat(Linguagem.LangUtil.getFont("gobold"), 24, FlxColor.fromRGB(233, 99, 34), FlxTextAlign.LEFT);
        readyTxt.text = (Linguagem.LangUtil.getString("lobby_ready_label", "multiplayer") +" 0/2").toUpperCase();
        readyTxt.screenCenter(X);
        readyTxt.y = FlxG.height-52-readyTxt.height*1.1;
        readyTxt.x=8;

        addToMenu(readyTxt, {y: readyTxt.y}, {y: FlxG.height});

        go = new FlxButton(1126,511, "", function(){
			if(MultiplayerMainMenuState.instance.canInitMatch && !MultiplayerMainMenuState.instance.isPlayingMatch && amActive())
				{	
                    GlobalSoundManager.play(confirmMenu);
					MultiplayerMainMenuState.instance.curRoom.send("toggle-ready");
				}
        });
        go.alpha = 0.75;
        go.onOver.callback = function() {
            GlobalSoundManager.play(scrollMenu);
            go.alpha = 1;
        };
        go.onOut.callback = function() {
            go.alpha = 0.75;
        };
        go.loadGraphic(Paths.image("multiplayer/menus/go", 'preload'));
        addToMenu(go, {x: 1126}, {x: 1350});
        addButton(go, 0);
    }

    public function updateReadyText(texto:String) {
        readyTxt.text = texto.toUpperCase();
    }

    public function resetPlayers() {
		for (player in players) {
            player.resetPlayer();
        }
    }

    public function updatePlayers() {
        for (player in players) {
            player.updatePlayer(player.gjID, true);
        }
    }

    public override function close(nextMenu:MultiplayerMenu, ?tweenar:Bool = true) {
        super.close(nextMenu);
        
        if (!tweenar) return;

        new FlxTimer().start(transitionSpeed+0.1, function(tmr:FlxTimer) {
			resetPlayers();
        });
    }
}

class LobbyPlayer extends FlxSpriteGroup
{
    public var gjID:String;
    public var sessionId:String = "";
	public var noteSkin:String = "NOTE_assets";
    public var faixas:Array<FaixaLobby> = [];
	public var bf:FlxSprite;
    public var isPlayer1:Bool;
    public var posicaoSaida:Float;

    public function new(x:Float, y:Float, isPlayer1:Bool, gamejoltID:String, posicaoSaida:Float)
	{
		super(x,y);
        this.isPlayer1 = isPlayer1;
        bf = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/lobby/"+(isPlayer1?"exe":"bf")));
        bf.setGraphicSize(Std.int(bf.width * 0.6667), Std.int(bf.height * 0.6667));
        this.posicaoSaida = posicaoSaida;
        bf.alpha = 0.75;
        add(bf);
        resetPlayer();
	}

    public function updatePlayer(newGJID:String, ?force:Bool =false) {
        if(gjID == newGJID && !force)
            return;

        var ultimaFaixa:FaixaLobby = currentFaixa(); 

        FlxTween.tween(bf, {alpha: newGJID == "0" ? 0.75 : 1}, 0.25, {ease: FlxEase.sineIn});

        if(ultimaFaixa!=null && ultimaFaixa.text!=null) {
            ultimaFaixa.sair(this);
            faixas.remove(ultimaFaixa);
        }

		var novaFaixa:FaixaLobby = new FaixaLobby(newGJID, 0, bf.y+78, isPlayer1);
        novaFaixa.visible = true;
        if(isPlayer1) {
            novaFaixa.x= (-356.44) - (novaFaixa.width-1050); //nossa eu sou mto burro
        } else {
            novaFaixa.y-=268;
            novaFaixa.x+=120*5.48;
        }

        novaFaixa.aparecer();
        faixas.push(novaFaixa);

        gjID=newGJID;
        add(novaFaixa);
    }

    public function getName():String {
        if(gjID == "0")
            return "Epaminondas";
        var userData:User = GJClient.getUserData(Std.parseInt(gjID));
        return userData == null ? "Epaminondas" : userData.username; 
    }

    public function resetPlayer() {
        bf.alpha = 0.75;
        updatePlayer("0");
    }

    function currentFaixa():FaixaLobby {
        return faixas.length < 1 ? null : faixas[faixas.length-1];
    }

    function ultimaFaixa():FaixaLobby {
        return faixas.length < 2 ? null : faixas[faixas.length-2];
    }
}