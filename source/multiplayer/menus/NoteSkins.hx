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
import multiplayer.menus.shared.*;
import Linguagem.LangUtil;

using StringTools;

class NoteSkins extends MultiplayerMenu
{
    public static var instance:NoteSkins;

    var bg:FlxSprite;
	var faixa:Faixa;

	public var skinSelector:SkinSelector;


    public function new() {
        super();
        instance = this;

        bg = new FlxSprite(0,0).loadGraphic(Paths.image("multiplayer/menus/noteskins/bg", 'preload'));
        bg.setGraphicSize(FlxG.width, FlxG.height);
		addToMenu(bg, {alpha: 1}, {alpha: 0});

		faixa = new Faixa(0, 62);
		addToMenu(faixa, {x: 0}, {x: -faixa.width*1.1}, "faixa");
		
		skinSelector = new SkinSelector();
		skinSelector.y+=50;
		addToMenu(skinSelector, {y: skinSelector.y}, {y: skinSelector.height*4});

    }
}

class SkinSelector extends FlxSpriteGroup
{
	var skinAtual:Int = 0;
	var skinList:Array<Dynamic>;

	var box:FlxSprite;
	var atual:FlxText;
	var setaDireita:FlxButton;
	var setaEsquerda:FlxButton;

	var noteSprite:FlxSprite;

	public function new()
	{
		super();
		skinAtual = Reflect.getProperty(MultiplayerMainMenuState.instance, "skinAtual");
		skinList = Reflect.getProperty(MultiplayerMainMenuState.instance, "skins");

		box = new FlxSprite(335,151).loadGraphic(Paths.image('multiplayer/menus/noteskins/box'));
		add(box);
		
		atual = new FlxText(box.x+11, box.y+21, 600, skinList[skinAtual][0], 46);
		atual.setFormat(LangUtil.getFont("gameboy"), 46, FlxColor.WHITE, FlxTextAlign.CENTER);
		atual.wordWrap = false;
		atual.alignment = CENTER;
		add(atual);

		setaEsquerda = new FlxButton(295, 356, "", clickEsquerda);
		setaEsquerda.loadGraphic(Paths.image('multiplayer/menus/noteskins/seta', 'preload'));
		setaEsquerda.updateHitbox();
		add(setaEsquerda);
		setarCallbacks(setaEsquerda);

		NoteSkins.instance.addButton(setaEsquerda, 0);

		setaDireita = new FlxButton(920, 360, "", clickDireita);
		setaDireita.loadGraphic(Paths.image('multiplayer/menus/noteskins/seta', 'preload'));
		setaDireita.flipX=true;
		setaDireita.updateHitbox();
		add(setaDireita);
		setarCallbacks(setaDireita);
		
		NoteSkins.instance.addButton(setaDireita, 1);

		noteSprite = new FlxSprite(0, 0);
		noteSprite.frames = Paths.getSparrowAtlas('multiplayer/notes/'+skinList[skinAtual][1], 'preload');
		noteSprite.animation.addByPrefix('idle', 'blue0');
		noteSprite.animation.play('idle');
		noteSprite.setGraphicSize(Std.int(noteSprite.width*1.3));
		noteSprite.y = 331;
		noteSprite.screenCenter(X);
		add(noteSprite);
	}

	function setarCallbacks(bt:FlxButton) {
		bt.onOut.callback = function() {
			if(!MultiplayerMainMenuState.instance.canClick || !NoteSkins.instance.amActive())
				return;
			bt.alpha = 0.5;
		}

        bt.onOver.callback = function() {
			if(!MultiplayerMainMenuState.instance.canClick || !NoteSkins.instance.amActive())
				return;
            GlobalSoundManager.play(scrollMenu);
			bt.alpha = 1;
		}
	}

	function clickEsquerda()
		{
			if(!NoteSkins.instance.amActive())
				return;
			GlobalSoundManager.play(scrollMenu);
			if(skinAtual-1 >= 0)
				{
					skinAtual--;
				}
				else
				{
					skinAtual = skinList.length-1;
				}
			save();
	
		}
	
		function clickDireita()
			{
				if(!NoteSkins.instance.amActive())
					return;
				GlobalSoundManager.play(scrollMenu);
				if(skinAtual+1 < skinList.length)
					{
						skinAtual++;
					}
					else
					{
						skinAtual = 0;
					}
				save();
		
			}

	public function save()
	{
		atual.text = skinList[skinAtual][0];
		Reflect.setProperty(MultiplayerMainMenuState.instance, "skinAtual", skinAtual);
		ClientPrefs.curMultiplayerNoteSkin = skinAtual;
		ClientPrefs.save();
		atualizarNoteSprite();
	}

	public function atualizarNoteSprite() {
		remove(noteSprite);
		noteSprite = new FlxSprite(0, 0);
		noteSprite.frames = Paths.getSparrowAtlas('multiplayer/notes/'+skinList[skinAtual][1], 'preload');
		noteSprite.animation.addByPrefix('idle', 'blue0');
		noteSprite.animation.play('idle');
		noteSprite.setGraphicSize(Std.int(noteSprite.width*1.3));
		noteSprite.y = 331;
		noteSprite.screenCenter(X);
		add(noteSprite);
	}

}
