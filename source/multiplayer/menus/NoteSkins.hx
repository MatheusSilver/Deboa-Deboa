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
import Utils.FlxScrollableArea;
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

class NoteSkins extends FlxTypedGroup<FlxBasic> 
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
        add(bg);

		faixa = new Faixa(0, 62);
		add(faixa);
		
		skinSelector = new SkinSelector();
		skinSelector.y+=50;
		add(skinSelector);

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

		setaDireita = new FlxButton(920, 360, "", clickDireita);
		setaDireita.loadGraphic(Paths.image('multiplayer/menus/noteskins/seta', 'preload'));
		setaDireita.flipX=true;
		setaDireita.updateHitbox();
		add(setaDireita);

		noteSprite = new FlxSprite(0, 0);
		noteSprite.frames = Paths.getSparrowAtlas('multiplayer/notes/'+skinList[skinAtual][1], 'preload');
		noteSprite.animation.addByPrefix('idle', 'blue0');
		noteSprite.animation.play('idle');
		noteSprite.setGraphicSize(Std.int(noteSprite.width*1.3));
		noteSprite.y = 331;
		noteSprite.screenCenter(X);
		add(noteSprite);
	}

	function clickEsquerda()
		{
			if(!this.visible)
				return;
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
				if(!this.visible)
					return;
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
