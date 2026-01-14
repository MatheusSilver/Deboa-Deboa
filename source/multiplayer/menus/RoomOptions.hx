package multiplayer.menus;

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
import multiplayer.menus.shared.*;
import flixel.FlxSprite;
import flixel.FlxG;
import Linguagem.LangUtil;

using StringTools;

class RoomOptions extends MultiplayerMenu
{
    public static var instance:RoomOptions;
    var bg:FlxSprite;
    var faixa:Faixa;

    var musicSelector:OptionSelectionList;
    var modoSelector:OptionSelectionList;
    var reverseBt:ReverseButton;

    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/noteskins/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
		addToMenu(bg, {alpha: 1}, {alpha: 0.5});

        musicSelector = new OptionSelectionList(78, 136, true);
        addToMenu(musicSelector, {y: 136}, {y: 1280});

        modoSelector = new OptionSelectionList(561, 135, false);
        addToMenu(modoSelector, {y: 135}, {y: 1280});

        reverseBt = new ReverseButton(561, 322);
        addToMenu(reverseBt, {y: 322}, {y: 1280});

        faixa = new Faixa(0, 66);
		addToMenu(faixa, {x: 0}, {x: -faixa.width*1.1}, "faixa");
    }

    public function setarCallbacks(bt:FlxButton) {
		bt.onOut.callback = function() {
			if(!MultiplayerMainMenuState.instance.canClick || !amActive())
				return;
			bt.alpha = 0.5;
		}

        bt.onOver.callback = function() {
			if(!MultiplayerMainMenuState.instance.canClick || !amActive())
				return;
            GlobalSoundManager.play(scrollMenu);
			bt.alpha = 1;
		}
	}
}

class ReverseButton extends FlxSpriteGroup {
    var ativado:Bool;
    var button:FlxButton;
    var reference:String;

    public function new(x:Float, y:Float) {
        super(x,y);
        init();
    }
    
    public function init() {
        reference = "TrocarLados";
		ativado = Reflect.getProperty(MultiplayerMainMenuState.instance, reference);
		button = new FlxButton(0, 0, "", clickButton);
		button.loadGraphic(Paths.image(ativado?'multiplayer/menus/options/reversed/reverseBt-off':'multiplayer/menus/options/reversed/reverseBt-on', 'preload'));
		button.updateHitbox();
		add(button);
        RoomOptions.instance.setarCallbacks(button);
        RoomOptions.instance.addButton(button, 2);
    }

	function clickButton()
	{
        if(!RoomOptions.instance.amActive()) return;

        GlobalSoundManager.play(confirmMenu);
		ativado = !ativado;
		button.loadGraphic(Paths.image(ativado?'multiplayer/menus/options/reversed/reverseBt-off':'multiplayer/menus/options/reversed/reverseBt-on', 'preload'));
		save();
	}

	function save()
	{
		Reflect.setProperty(MultiplayerMainMenuState.instance, reference, ativado);
	}
}

class OptionSelectionList extends FlxSpriteGroup {
    var selectionList:SelectionList;
    var isMusic:Bool;
    
    var bg:FlxSprite;
    var bgLabel:FlxText;

    public function new(x:Float, y:Float, isMusic:Bool) {
        super(x, y);

        this.isMusic = isMusic;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/options/"+(isMusic?"musica":"modos")+"/card", 'preload'));
        add(bg);

        bgLabel = new FlxText(0, 0, 0, isMusic?(Linguagem.LangUtil.getString("opt_cursong_name", "multiplayer")).toUpperCase():(Linguagem.LangUtil.getString("opt_gamemode_name", "multiplayer")).toUpperCase(), 8, true, -8);
        bgLabel.setFormat(Paths.font("Early GameBoy.ttf"), 59, 0xFFFFFF, CENTER);
        add(bgLabel);

        construir();

        bgLabel.x = isMusic ? 448 : 581;
        bgLabel.y = isMusic ? 584 : 144;
    }

    var selectedSprite:FlxSprite;
    function construir() {
        var setaDireita:FlxButton = createSeta(true);
        setaDireita.y = 397;
        var setaEsquerda:FlxButton = createSeta(false);
        setaEsquerda.y = 397;

        if (isMusic) {
            selectionList = new SelectionList(["MusicaAtual", "musicasDesbloqueadas", false], MultiplayerMainMenuState.instance);

            setaEsquerda.x = 9;
            setaDireita.x = 293;
            selectedSprite = new FlxSprite(42, 29).loadGraphic(Paths.image('galeriamusicas/gm-'+selectionList.getNameOfValue(), 'preload'));
            add(selectedSprite);

            selectionList.onChange= function() {
                selectedSprite.loadGraphic(Paths.image('galeriamusicas/gm-'+selectionList.getNameOfValue(), 'preload'));
            }

            add(setaEsquerda);
            add(setaDireita);

            RoomOptions.instance.addButton(setaDireita, 1);
            RoomOptions.instance.addButton(setaEsquerda, 0);
        } else {
            selectionList = new SelectionList(["ModoDeJogo", "modos", true], MultiplayerMainMenuState.instance);

            setaEsquerda.x = 254;
            setaDireita.x = 538;

            var circulo:FlxSprite = new FlxSprite(342, 33).loadGraphic(Paths.image('multiplayer/menus/options/modos/criculo', 'preload'));
            add(circulo);

            selectedSprite = new FlxSprite(342, 33).loadGraphic(Paths.image('multiplayer/menus/options/modos/icon_'+selectionList.getIdOfValue(), 'preload'));
            add(selectedSprite);

            var selectedName:FlxText = new FlxText(273, 215, 310);
            selectedName.setFormat(Linguagem.LangUtil.getFont("gobold2"), 37, FlxColor.fromRGB(250,243,34), FlxTextAlign.CENTER);
            add(selectedName);
            
            var selectedDesc:FlxText = new FlxText(316, 277, 228);
            selectedDesc.height = 128;
            selectedDesc.setFormat(Linguagem.LangUtil.getFont("gobold2"), 29, FlxColor.WHITE, FlxTextAlign.CENTER);
            add(selectedDesc);

            selectedName.text = selectionList.getRawValue()[0];
            selectedDesc.text = selectionList.getRawValue()[1];

            selectionList.onChange= function() {
                selectedSprite.loadGraphic(Paths.image('multiplayer/menus/options/modos/icon_'+selectionList.getIdOfValue(), 'preload'));
                selectedName.text = selectionList.getRawValue()[0];
                selectedDesc.text = selectionList.getRawValue()[1];
            }

            add(setaEsquerda);
            add(setaDireita);
            RoomOptions.instance.addButton(setaDireita, 4);
            RoomOptions.instance.addButton(setaEsquerda, 3);
        }

        RoomOptions.instance.setarCallbacks(setaEsquerda);
        RoomOptions.instance.setarCallbacks(setaDireita);
    }

    function createSeta(direita:Bool):FlxButton {
		var bt = new FlxButton(0, 0, "", function(){
            if(!RoomOptions.instance.amActive())
				return;
			GlobalSoundManager.play(scrollMenu);
            
            if (direita) {
                selectionList.clickDireita();
            } else {
                selectionList.clickEsquerda();
            }
        });
		bt.loadGraphic(Paths.image('multiplayer/menus/noteskins/seta', 'preload'));
		bt.updateHitbox();
        bt.flipX=direita;

        return bt;
    }
}