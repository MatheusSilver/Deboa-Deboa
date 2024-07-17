package;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepad.FlxGamepadModel;
import flixel.tweens.FlxEase;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.utils.Assets;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if android
import haxe.crypto.Md5; // Assim o Md5 não é compilado no PC e não fica como Unused import
import flixel.math.FlxPoint;
import ui.MobileControls.FlxVirtualPad;
#end

enum ResizeMode
{
	FIT_WIDTH;
	FIT_HEIGHT;
	NONE;
}

enum FlxScrollbarOrientation
{
	VERTICAL;
	HORIZONTAL;
}

enum InputDevices //Lista com todos os tipos de controle que esperamos que alguém vá usar, sentimos muito se você tem um amazon luna ou então um OUYA ou sei lá mais o que existe por ai.
{
	Keyboard;
	PS4_Controller;
	Switch_Controller;
	Xinput_Controller;
	AUTO;
}

/**
 * Usada pra usar a mesma função pra plataformas diferentes (Mobile e Android)
 */
class Utils
{
	/**
	 * Lê o conteúdo de um arquivo.
	 * @param id Arquivo que será lido pela função
	 */
	public static function getContent(id:String):String
	{
		#if mobile
		return Assets.getText(id);
		#else
		return File.getContent(id);
		#end
	}

	/**
	 * Retorna entre verdadeiro ou falso a existência do arquivo especificado
	 * @param id Arquivo para verificação
	 */
	public static function exists(id:String):Bool
	{
		#if mobile
		return Assets.exists(id);
		#else
		return FileSystem.exists(id);
		#end
	}

	/**
	 * Lê um arquivo binário (Eu acho :skull:)
	 * @param id Arquivo que será lido pela função
	 */
	public static function getBytes(id:String)
	{
		#if mobile
		return Assets.getBytes(id);
		#else
		return File.getBytes(id);
		#end
	}

	/**
	 * Retorna o nome de todos os arquivos dentro do diretório especificado
	 * @param id Diretório que será lido
	 */
	public static function readDirectory(library:String):Array<String>
	{
		#if mobile
		var something:Array<String> = [];
		var bruh = Assets.list();
		for (folder in bruh.filter(text -> text.contains('$library')))
		{
			if (!folder.startsWith('.'))
				something.push(folder);
		}
		return something;
		#else
		return FileSystem.readDirectory(library);
		#end
	}

	/**
	 * Cria um novo BitmapData de um arquivo.
	 * @param id Arquivo que será usado pra criar o Bitmap
	 */
	public static function fromFile(id:String)
	{
		#if mobile
		return Assets.getBitmapData(id);
		#else
		return BitmapData.fromFile(id);
		#end
	}

	/**
	 * Copia o conteúdo de uma string para o seu histórico do CTRL + C (PC) ou pro teclado (Mobile)
	 * @param id String que será copiada
	 */
	public static function copiarclipboard(coisa:String)
	{
		openfl.system.System.setClipboard(coisa.trim());
	}
}

/**
 * Usado principalmente pro .lua (PC e Android)
 */
class Asset2File
{
	/**
	 * Retorna o Path completo de um arquivo (Desde o caminho de onde ele foi aberto).
	 * @param id Arquivo que será lido pela função
	 */
	public static function getPath(id:String, ?ext:String = "")
	{
		#if android
		var file = Assets.getBytes(id);

		var md5 = Md5.encode(Md5.make(file).toString());

		if (FileSystem.exists(Main.path + md5 + ext))
			return Main.path + md5 + ext;

		File.saveBytes(Main.path + md5 + ext, file);

		return Main.path + md5 + ext;
		#else
		return #if sys Sys.getCwd() + #end id;
		#end
	}
}

/**
 * Serve para fazer o swipe em objetos na tela.
 */
// Não sei para que servem os parâmetros

class SpriteSwapper extends FlxSprite
{
	public var target:Int;
	public var tweenController:FlxTween;

	private var spaceBetween:Int;

	public var tweenTimer:Float = 0.5;

	private var activeAxis:FlxAxes;
	private final num_objects:Int;
	private final objectsList:Int;

	public var specialOffset:Float = 0;

	public function new(target:Int, sprite:FlxGraphic, objects_on_screen:Int = 1, space_between:Int = 1, swipe_axis:FlxAxes = X, size_mult:Float = 1,
			objects_in_list = 1)
	{
		this.num_objects = objects_on_screen - 1;
		this.objectsList = objects_in_list;
		if (num_objects < 1)
			num_objects = 1; // nope, isso não nescessariamente representa o numero de objetos na tela
		// Ou representa se você contar o ZERO

		super(0, 0);
		this.spaceBetween = space_between;
		this.activeAxis = swipe_axis;

		this.loadGraphic(sprite);
		this.setTarget(target);
		if (activeAxis == X)
		{
			this.setGraphicSize(Std.int(FlxG.width / num_objects * size_mult));
			this.setPosition(((FlxG.width / this.num_objects) * this.target - this.width) / 2 + this.target * this.spaceBetween, 0);
			this.screenCenter(Y);
		}
		else if (activeAxis == Y)
		{
			this.setGraphicSize(Std.int(FlxG.height / num_objects * size_mult));
			this.setPosition(0, (FlxG.height / this.num_objects * this.target - this.height) / 2 + this.target * this.spaceBetween);
			this.screenCenter(X);
		}
	}

	public function checkTween():Void
	{
		if (tweenController != null)
			tweenController.cancel();
	}

	public function updateTarget(manual:Bool = false):Void
	{
		this.checkTween();

		if (activeAxis == X)
		{
			if (!manual)
				this.setTarget(Math.round((2 * this.x + this.width) / ((FlxG.width / num_objects) + 2 * this.spaceBetween)));

			tweenController = FlxTween.tween(this, {x: (FlxG.width / num_objects * target - this.width) / 2 + target * this.spaceBetween + specialOffset},
				tweenTimer, {
					ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						tweenController = null;
					}
				});
		}
		else if (activeAxis == Y)
		{
			if (!manual)
				this.setTarget(Math.round((2 * this.y + this.height) / ((FlxG.height / num_objects) + 2 * this.spaceBetween)));
			tweenController = FlxTween.tween(this, {y: (FlxG.height / num_objects * target - this.height) / 2 + target * this.spaceBetween + specialOffset},
				tweenTimer, {
					ease: FlxEase.quadInOut,
					onComplete: function(twn:FlxTween)
					{
						tweenController = null;
					}
				});
		}
	}

	public inline function getTarget():Int
	{
		return this.target;
	}

	public function setTarget(target):Void
	{
		this.target = target; // usa isso pra trocar fazer o scroll
		this.visible = Math.abs(this.target) <= 4;
		if (this.target <= -5)
		{
			this.target += this.objectsList;
		}
		else if (this.target > this.objectsList - 5)
		{
			this.target -= this.objectsList;
		}
	}
}

/**
 * Usado para funções de touch (Mobile) e mouse (Desktop)
 */
class BSLTouchUtils
{
	// Code por Matheus Silver e Lorena provavelmente
	public static var prevTouched:Int = -1;

	/**
	 * Retorna verdadeiro ou falso caso você dê um Toque na tela (Mobile) ou aperte o botão do Mouse (Desktop)
	 */
	public static function justTouched():Bool // Copiado do Hsys k
	{
		#if (flixel && android)
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				justTouched = true;
		}

		return justTouched;
		#else
		return FlxG.mouse.justPressed; // Isso aqui é mais válido pro modboa mas né?
		#end
	}

	/**
	 * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop).
	 */
	public static function touched():Bool
	{
		#if (flixel && android)
		var touched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.pressed)
				touched = true;
		}

		return touched;
		#else
		return FlxG.mouse.pressed;
		#end
	}

	/**
	 * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop).
	 */
	public static function justSolto():Bool
	{
		#if (flixel && android)
		var justReleased:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justReleased)
				justReleased = true;
		}

		return justReleased;
		#else
		return FlxG.mouse.justReleased;
		#end
	}

	/**
	 * Função para tocar em uma coisa duas vezes para poder realmente selecionar ele
	 * @param coisas As coisas uai
	 * @param coisasID Socorro Silvio nunca entendi como sua função (ou função da Lorena 🤔) funciona
	 */
	public static function aperta(coisas:Dynamic,
			coisasID:Int):String // Esse code foi feito só pq em outro projeto, eu usei um padrãozinho deste várias vezes e fiquei com preguiça de fazer isso de novo
	{
		var leToqueOrdem:String = '';
		#if desktop
		if (over(coisas) && FlxG.mouse.justPressed && prevTouched == coisasID)
		{
			leToqueOrdem = 'segundo';
		}
		else if (over(coisas) && FlxG.mouse.justPressed)
		{
			prevTouched = coisasID;
			leToqueOrdem = 'primeiro';
		}
		#elseif mobile
		for (touch in FlxG.touches.list)
		{
			if (over(coisas) && touch.justPressed && prevTouched == coisasID)
				leToqueOrdem = 'segundo';
			else if (over(coisas) && touch.justPressed)
			{
				prevTouched = coisasID;
				leToqueOrdem = 'primeiro';
			}
		}
		#end
		return leToqueOrdem;
	}

	/**
	 * Retorna verdadeiro ou falso caso você tenha apertado um objeto
	 * @param coisa Texto, sprite ou qualquer coisa que será apertada
	 */
	public static function apertasimples(coisa:Dynamic):Bool
	{
		#if desktop
		if (over(coisa) && FlxG.mouse.justPressed)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justPressed)
				return true;
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso o touch (Mobile) ou cursor (Desktop) sobreponha um objeto
	 * @param coisa ..a coisa uai
	 */
	public static function over(coisa:Dynamic):Bool
	{
		#if desktop
		if (!Main.getMouseVisibility())
			return false; // Provavelmente a única coisa que faz o BSLTouchUtils se pagar no ModBoa.
		return FlxG.mouse.overlaps(coisa);
		#elseif mobile
		for (touch in FlxG.touches.list)
			return touch.overlaps(coisa);
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso você esteja com Segurando o toque na tela (Mobile) ou Segurando o botão do Mouse (Desktop) em um objeto.
	 * @param coisa ............. Tu já sabe né?
	 */
	public static function pressionando(coisa:Dynamic):Bool
	{
		#if desktop
		return (over(coisa) && FlxG.mouse.pressed);
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justPressed && !touch.justReleased)
				return true;
		#end

		return false;
	}

	/**
	 * Retorna verdadeiro ou falso caso tenha parado de Tocar na tela (Mobile) ou Soltado o botão do Mouse (Desktop) em um objeto.
	 * @param coisa ............. Tu já sabe né?
	 */
	public static function solto(coisa:Dynamic):Bool
	{
		#if desktop
		if (over(coisa) && FlxG.mouse.justReleased)
			return true;
		#elseif mobile
		for (touch in FlxG.touches.list)
			if (over(coisa) && touch.justReleased)
				return true;
		#end

		return false;
	}

	// Adaptação para um code bem antigo do ytb music
	public static function justsolto():Bool
	{
		#if desktop
		return FlxG.mouse.justReleased;
		#elseif mobile
		for (touch in FlxG.touches.list)
			return touch.justReleased;
		#end

		return false;
	}

	#if desktop
	/**
	 * Retorna uma int da posição atual do seu mouse
	 * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
	 */
	public static function pegarpos(pos:String):Int
	{
		if (pos == 'x')
			return FlxG.mouse.x;

		if (pos == 'y')
			return FlxG.mouse.y;

		return 0;
	}

	#elseif mobile
	/**
	 * Retorna uma int da posição atual do seu toque
	 * @param pos A posição que tu quer (X ou Y) - deve ser escrita como "x" ou "y".
	 */
	public static function pegarpos(pos:String):Int
	{
		for (touch in FlxG.touches.list)
		{
			if (pos == 'x')
				return touch.x;

			if (pos == 'y')
				return touch.y;
		}
		return 0;
	}
	#end

	public static function teclado(acao:String)
	{ // Converter para lua
		#if mobile
		if (acao == "abrir")
		{
			FlxG.stage.window.textInputEnabled = true;
		}
		else if (acao == "fechar")
		{
			FlxG.stage.window.textInputEnabled = false;
		}
		#else
		trace("Abrir/fechar teclado e uma funcao exclusiva do mobile.");
		#end
	}
}

/**
 * Usado para o Deslize na Tela (Mobile) e Scroll do Mouse (Desktop)
 */
class BSLSwipeUtils
{
	public static var scrollSpeed:Float = 0;
	public static final scrollAcceleration:Float = 1;
	public static final maxScrollSpeed:Float = 10.0;
	public static var mouseScrollMultiplier:Int = 1;

	public static var scrollX:Int = 0;
	public static var scrollY:Int = 0;

	public static var prevTouchX:Int = 0;
	public static var prevTouchY:Int = 0;

	public static var max_y:Int = 1;
	public static var max_x:Int = 1;

	private static var touchY:Int;
	private static var touchX:Int;

	public static var is_swipping:Bool = false;
	public static var reset_manual = false;

	/**
	 * Função de Swipe (Mobile) e Scroll do Mouse (Desktop)
	 */
	// foi o que eu entendi da função pelo menos
	public static function swipeHorizontal():Void
	{
		#if mobile
		if (BSLTouchUtils.justTouched())
		{
			prevTouchX = Std.int(BSLTouchUtils.pegarpos("x") / max_x);
		} // Captura a posição inicial do toque.
		else if (BSLTouchUtils.touched())
		{
			touchX = Std.int(BSLTouchUtils.pegarpos("x") / max_x);
			var deltaX:Int = (touchX - prevTouchX); // k

			scrollX = deltaX;

			prevTouchX = touchX;
		} // Enquanto está segurando, calcula o deslocamento da posição inicial do toque e a velocidade do deslocamento
		  // Válido apenas para toque na tela.
		else #end if (Math.abs(scrollX) > 0)
		{
			if (scrollX > 0)
				scrollSpeed -= scrollAcceleration;
			else if (scrollX < 0)
				scrollSpeed += scrollAcceleration;

			scrollSpeed = Std.int(Utils.CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
		}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollX += FlxG.mouse.wheel * mouseScrollMultiplier;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollX += Std.int(scrollSpeed);
		scrollX = Utils.CoolUtil.mathClamp(scrollX, -FlxG.width / max_x, FlxG.width / max_x);
		if (Math.abs(scrollX) <= Math.abs(scrollSpeed))
			resetScrolls();
		else
			is_swipping = true;
	}

	/**
	 * Função de Swipe (Mobile) e Scroll do Mouse (Desktop)
	 */
	public static function swipeVertical():Void
	{
		#if mobile
		if (BSLTouchUtils.justTouched())
		{
			prevTouchY = Std.int(BSLTouchUtils.pegarpos("y") / max_y);
		}
		else if (BSLTouchUtils.touched())
		{
			touchY = Std.int(BSLTouchUtils.pegarpos("y") / max_y);
			var deltaY:Int = (touchY - prevTouchY);

			scrollY = deltaY;

			prevTouchY = touchY;
		}
		else #end if (Math.abs(scrollY) > 0)
		{
			if (scrollY > 0)
				scrollSpeed -= scrollAcceleration;
			else if (scrollY < 0)
				scrollSpeed += scrollAcceleration;

			scrollSpeed = Std.int(Utils.CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
		}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollY += FlxG.mouse.wheel * mouseScrollMultiplier;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollY += Std.int(scrollSpeed);
		scrollY = Utils.CoolUtil.mathClamp(scrollY, -FlxG.height / max_y, FlxG.height / max_y);
		if (Math.abs(scrollY) <= Math.abs(scrollSpeed))
			resetScrolls();
		else
			is_swipping = true;
	}

	inline public static function resetScrolls():Void
	{
		scrollX = scrollY = 0;
		scrollSpeed = 0;
		if (!reset_manual)
			is_swipping = false;
	}
}

/**
 * Simple scrollbar.  Draws itself and also handles dragging.  (It's up to you to use the provided data to update whatever you're scrolling.)
 * @author In the Beginning was the Word Game
 */
class FlxScrollbar extends FlxSpriteGroup
{
	private var _orientation:FlxScrollbarOrientation;
	private var _colour:FlxColor;
	private var _minProportion:Float = 0.1; // smallest barProportion of the track that the bar can be
	private var _track:FlxSprite; // Sits under the bar, and takes up the whole side.
	private var _bar:FlxSprite;
	private var _stale:Bool = true;
	private var _state:FlxState;
	private var _camera:FlxScrollableArea;
	private var _dragStartedAt:FlxPoint = null; // null signifying that we are not currently dragging, this is the mousedown spot
	private var _dragStartedWhenBarWasAt:Float; // the x or y (depending on orientation) of the bar at drag start (also for whole page movements)
	private var _trackClickCountdown = 0.0; // timer until you start getting repeated whole-page-movements when holding down the mouse button
	private var _mouseWheelMultiplier:Int;
	private var canScroll:Bool;

	/**
	 * Create a new scrollbar graphic.  You'll have to hide it yourself when needed.
	 * 
	 * @param	X						As with any sprite.
	 * @param	Y						"
	 * @param	Width					"
	 * @param	Height					"
	 * @param	Orientation				Whether it's meant to operate vertically or horizontally.  (This is not assumed from the width/height.)
	 * @param	Colour					The colour of the draggable part of the scrollbar.  The rest of it will be the same colour added to FlxColor.GRAY.
	 * @param	Camera					The parent scrollable area to control with this scrollbar.
	 * @param	InitiallyVisible		Bool to set .visible to.
	  	 * @param	State					Which state to add the scrollbar(s) to.  If you're in a FlxSubState with its parent paused, pass it in here.
	 * @param	MouseWheelMultiplier	How much to multiply mouse wheel deltas by.  Set to 0 to disable mouse wheeling.  Default 100.
	 */
	public function new(X:Float, Y:Float, Width:Float, Height:Float, Orientation:FlxScrollbarOrientation, Colour:FlxColor, Camera:FlxScrollableArea,
			?InitiallyVisible:Bool = false, ?State:FlxState, ?MouseWheelMultiplier:Int = 100, ?canScroll:Bool = true)
	{
		super(X, Y);
		this.canScroll = canScroll;
		_state = State;
		if (_state == null)
			_state = FlxG.state;

		_orientation = Orientation;
		_colour = Colour;
		_camera = Camera;
		_mouseWheelMultiplier = MouseWheelMultiplier;

		_track = new FlxSprite();
		_track.makeGraphic(Std.int(Width), Std.int(Height), FlxColor.add(FlxColor.GRAY, _colour), true);
		add(_track);

		_bar = new FlxSprite();
		_bar.makeGraphic(Std.int(Width), Std.int(Height), _colour, true);
		add(_bar);

		visible = InitiallyVisible;
	}

	override public function draw()
	{
		if (_stale)
		{
			var barProportion:Float;
			var scrolledProportion:Float;
			if (_orientation == HORIZONTAL)
			{
				barProportion = FlxMath.bound(_track.width / _camera.content.width, _minProportion);
				_bar.makeGraphic(Std.int(_track.width * barProportion), Std.int(_track.height), _colour, true);
				if (_camera.content.width == _track.width)
					scrolledProportion = 0;
				else
					scrolledProportion = FlxMath.bound((_camera.scroll.x - _camera.content.x) / (_camera.content.width - _track.width), 0, 1);
				_bar.x = x + scrolledProportion * (_track.width * (1 - barProportion));
			}
			else
			{
				barProportion = FlxMath.bound(_track.height / _camera.content.height, _minProportion);
				_bar.makeGraphic(Std.int(_track.width), Std.int(_track.height * barProportion), _colour, true);
				if (_camera.content.height == _track.height)
					scrolledProportion = 0;
				else
					scrolledProportion = FlxMath.bound((_camera.scroll.y - _camera.content.y) / (_camera.content.height - _track.height), 0, 1);
				_bar.y = y + scrolledProportion * (_track.height * (1 - barProportion));
			}
			_stale = false;
		}
		super.draw();
	}

	override public function update(elapsed:Float)
	{
		if (!visible || !canScroll)
			return;
		var mousePosition = FlxPoint.get(Utils.BSLTouchUtils.pegarpos("x"), Utils.BSLTouchUtils.pegarpos("y"));
		var tryToScrollPage = false;
		if (Utils.BSLTouchUtils.justTouched())
		{
			if (_bar.overlapsPoint(mousePosition))
			{
				_dragStartedAt = mousePosition;
				if (_orientation == HORIZONTAL)
				{
					_dragStartedWhenBarWasAt = _bar.x;
				}
				else
				{
					_dragStartedWhenBarWasAt = _bar.y;
				}
			}
			else if (_track.overlapsPoint(mousePosition))
			{
				_trackClickCountdown = 0.5;
				if (_orientation == HORIZONTAL)
				{
					_dragStartedWhenBarWasAt = _bar.x;
				}
				else
				{
					_dragStartedWhenBarWasAt = _bar.y;
				}
				tryToScrollPage = true;
			}
		}
		else if (Utils.BSLTouchUtils.touched())
		{
			_trackClickCountdown -= elapsed;
			if (_trackClickCountdown < 0 && !_bar.overlapsPoint(mousePosition) && _track.overlapsPoint(mousePosition))
				tryToScrollPage = true;
		}
		if (_dragStartedAt != null)
		{
			if (_orientation == HORIZONTAL)
			{
				if (mousePosition.y < (_camera.y + _camera.height / 2)) // allow 50% of height away before jumping back to original position
					mousePosition.x = _dragStartedAt.x;
				_bar.x = FlxMath.bound(_dragStartedWhenBarWasAt + (mousePosition.x - _dragStartedAt.x), _track.x, _track.x + _track.width - _bar.width);
			}
			else
			{ // VERTICAL
				if (mousePosition.x < (_camera.x + _camera.width / 2)) // allow 50% of width away before jumping back to original position
					mousePosition.y = _dragStartedAt.y;
				_bar.y = FlxMath.bound(_dragStartedWhenBarWasAt + (mousePosition.y - _dragStartedAt.y), _track.y, _track.y + _track.height - _bar.height);
			}
			updateViewScroll();
		}
		else if (tryToScrollPage)
		{
			/**
			 * Tries to scroll a whole viewport width/height toward wherever the mousedown on the track is.
			 * 
			 * "Tries" because (to emulate standard scrollbar behaviour) you only scroll in one direction while holding the mouse button down.
			 * 
			 * E.g. on a vertical scrollbar, if you click & hold below the bar, it scrolls down, but if, while still holding, you move to above the bar, nothing happens.
			 */
			var whichWayToScroll:Int = 0; // 0: don't; 1: positive along axis; 2: negative along axis
			if (_orientation == HORIZONTAL)
			{
				if (_bar.x > _dragStartedWhenBarWasAt)
				{ // scrolling right
					if (mousePosition.x > _bar.x + _bar.width) // and far enough right to scroll more
						whichWayToScroll = 1;
				}
				else if (_bar.x > _dragStartedWhenBarWasAt)
				{ // scrolling left
					if (mousePosition.x < _bar.x) // and far enough left to scroll more
						whichWayToScroll = -1;
				}
				else
				{ // first scroll...which way?
					if (mousePosition.x < _bar.x) // left of bar
						whichWayToScroll = -1;
					else // either right of bar, or on the bar; but if on the bar, execution shouldn't reach here in the first place
						whichWayToScroll = 1; // start scrolling right
				}
				if (whichWayToScroll == 1)
					_bar.x = FlxMath.bound(_bar.x + _bar.width, null, _track.x + _track.width - _bar.width);
				else if (whichWayToScroll == -1)
					_bar.x = FlxMath.bound(_bar.x - _bar.width, _track.x);
			}
			else
			{ // VERTICAL
				if (_bar.y > _dragStartedWhenBarWasAt)
				{ // scrolling down
					if (mousePosition.y > _bar.y + _bar.height) // and far enough down to scroll more
						whichWayToScroll = 1;
				}
				else if (_bar.y > _dragStartedWhenBarWasAt)
				{ // scrolling up
					if (mousePosition.y < _bar.y) // and far enough up to scroll more
						whichWayToScroll = -1;
				}
				else
				{ // first scroll...which way?
					if (mousePosition.y < _bar.y) // up of bar
						whichWayToScroll = -1;
					else // either down of bar, or on the bar; but if on the bar, execution shouldn't reach here in the first place
						whichWayToScroll = 1; // start scrolling down
				}
				if (whichWayToScroll == 1)
					_bar.y = FlxMath.bound(_bar.y + _bar.height, null, _track.y + _track.height - _bar.height);
				else if (whichWayToScroll == -1)
					_bar.y = FlxMath.bound(_bar.y - _bar.height, _track.y);
			}
			if (whichWayToScroll != 0)
				updateViewScroll();
		}
		#if !mobile
		else if (FlxG.mouse.wheel != 0)
		{
			if (_orientation == HORIZONTAL)
			{
				_bar.x = FlxMath.bound(_bar.x - FlxG.mouse.wheel * _mouseWheelMultiplier, _track.x, _track.x + _track.width - _bar.width);
			}
			else
			{ // VERTICAL
				_bar.y = FlxMath.bound(_bar.y - FlxG.mouse.wheel * _mouseWheelMultiplier, _track.y, _track.y + _track.height - _bar.height);
			}
			updateViewScroll();
		}
		#end
		if (Utils.BSLTouchUtils.justSolto())
			_dragStartedAt = null;
		super.update(elapsed);
	}

	/**
	 * Updates the view's scroll.  Should be done from the outside if there's a resize.
	 */
	public function updateViewScroll()
	{
		var scrolledProportion:Float;
		if (_orientation == HORIZONTAL)
		{
			if (_track.width == _bar.width)
				scrolledProportion = 0;
			else
				scrolledProportion = FlxMath.bound((_bar.x - x) / (_track.width - _bar.width), 0, 1);
			_camera.scroll.x = _camera.content.x + (_camera.content.width - _track.width) * scrolledProportion;
		}
		else
		{
			if (_track.height == _bar.height)
				scrolledProportion = 0;
			else
				scrolledProportion = FlxMath.bound((_bar.y - y) / (_track.height - _bar.height), 0, 1);
			_camera.scroll.y = _camera.content.y + (_camera.content.height - _track.height) * scrolledProportion;
		}
	}

	override private function set_width(Value:Float):Float
	{
		if (_track != null && _track.width != Value)
		{
			_track.makeGraphic(Std.int(Value), Std.int(height), FlxColor.add(FlxColor.GRAY, _colour), true);
			_stale = true;
		}
		return super.set_width(Value);
	}

	override private function set_height(Value:Float):Float
	{
		if (_track != null && _track.height != Value)
		{
			_track.makeGraphic(Std.int(width), Std.int(Value), FlxColor.add(FlxColor.GRAY, _colour), true);
			_stale = true;
		}
		return super.set_height(Value);
	}

	override private function set_x(Value:Float):Float
	{
		if (_track != null && x != Value)
		{
			_stale = true;
		}
		return super.set_x(Value);
	}

	override private function set_y(Value:Float):Float
	{
		if (_track != null && y != Value)
		{
			_stale = true;
		}
		return super.set_y(Value);
	}

	override private function set_visible(value:Bool):Bool
	{
		if (visible != value)
		{
			if (visible == false)
			{ // becoming visible: make sure we're on top
				for (piece in [_track, _bar])
				{
					FlxG.state.remove(piece);
					FlxG.state.add(piece);
				}
			}
			return super.set_visible(value);
		}
		else
			return value;
	}

	public function forceRedraw()
	{
		if (visible)
			_stale = true;
	}
}

/**
 * An area of the screen that has automatic scrollbars, if needed.
 * @author In the Beginning was the Word Game
 */
class FlxScrollableArea extends FlxCamera
{
	/**
	 * If your viewing area changes (perhaps in your state's onResize function) you need to update this to reflect it.
	 */
	public var viewPort(default, set):FlxRect;

	/**
	 * If your content's area changes (e.g. the content itself changes, or you override onResize), you need to update this to reflect it.
	 */
	public var content(default, set):FlxRect;

	/**
	 * Returns the best layout strategy you should use in your state's onResize function.  If you passed NONE in the constructor,
	 * this function just returns that.
	 * 
	 * Be sure to resize the viewport before calling this function, which will trigger a recalculation of this value and the scrollbar sizes.
	 * 
	 * For example, you may normally want to FIT_WIDTH, so you pass that into the constructor.  But, at a certain resize ratio with a
	 * certain content aspect ratio, there will be a conflict between this goal and whether there should be a scrollbar.  I.e., if your
	 * content is resized to fit the width of the viewport, it will be too long and require a scrollbar.  But, if you resize it to allow for
	 * a scrollbar, it will then be short enough not to need a scrollbar anymore.  In this case, .bestMode will tell you that you should
	 * instead FIT_HEIGHT, so that, gracefully, you have no scrollbar, but still make things as big as possible.  I.e., your content will
	 * take up part of what a scrollbar would have.
	 * 
	 * Remember to also take into account the scrollbar thickness using horizontalScrollbarHeight and/or verticalScrollbarWidth.
	 */
	public var bestMode(get, null):ResizeMode;

	public var horizontalScrollbarHeight(get, null):Int;
	public var verticalScrollbarWidth(get, null):Int;

	#if !FLX_NO_MOUSE
	public var scrollbarThickness:Int = 20;
	#else
	public var scrollbarThickness:Int = 4;
	#end

	private var _state:FlxState;
	private var _horizontalScrollbar:FlxScrollbar;
	private var _verticalScrollbar:FlxScrollbar;
	private var _scrollbarColour:FlxColor;
	private var _resizeModeGoal:ResizeMode;
	private var _hiddenPixelAllowance:Float = 1.0; // don't bother showing scrollbars if this many pixels would go out of view (float weirdness fix)

	/**
	 * Creates a specialized FlxCamera that can be added to FlxG.cameras.
	 *
	 * @param	ViewPort				The area on the screen, in absolute pixels, that will show content.
	 * @param	Content					The area (probably off-screen) to be viewed in ViewPort.  Must have a non-zero width and height.
	 * @param	Mode					State the goal of your own resizing code, so that the .bestMode property contains an accurate value.
	 * @param	ScrollbarThickness		Defaults to 20 for mice and 4 "otherwise" (touch is assumed.)
	 * @param	ScrollbarColour			Passed to FlxScrollbar.  ("They say geniuses pick green," so don't change the default unless you're the supergenius we all know you to be.)
	 * @param	State					Which state to add the scrollbar(s) to.  If you're in a FlxSubState with its parent paused, pass it in here.
	 * @param	MouseWheelMultiplier	How much to multiply mouse wheel deltas by.  Set to 0 to disable mouse wheeling.  Default 100.
	 */
	public function new(ViewPort:FlxRect, Content:FlxRect, Mode:ResizeMode, ?ScrollbarThickness:Int = -1, ?ScrollbarColour:FlxColor = FlxColor.LIME,
			?State:FlxState, ?MouseWheelMultiplier:Int = 100)
	{
		super();

		_state = State;
		if (_state == null)
			_state = FlxG.state;
		content = Content;
		_resizeModeGoal = Mode; // must be before we set the viewport, because set_viewport uses it; likewise next line
		if (ScrollbarThickness > -1)
			scrollbarThickness = ScrollbarThickness;
		viewPort = ViewPort;
		_scrollbarColour = ScrollbarColour;

		scroll.x = content.x;
		scroll.y = content.y;

		_verticalScrollbar = new FlxScrollbar(0, 0, scrollbarThickness > 0 ? scrollbarThickness : 1, 1, FlxScrollbarOrientation.VERTICAL, ScrollbarColour,
			this, false, _state, MouseWheelMultiplier, scrollbarThickness > 0 ? false : true);
		_horizontalScrollbar = new FlxScrollbar(0, 0, 1, scrollbarThickness > 0 ? scrollbarThickness : 1, FlxScrollbarOrientation.HORIZONTAL, ScrollbarColour,
			this, false, _state, MouseWheelMultiplier, scrollbarThickness > 0 ? false : true);
		_verticalScrollbar.alpha = scrollbarThickness > 0 ? 1 : 0;
		_horizontalScrollbar.alpha = scrollbarThickness > 0 ? 1 : 0;
		_state.add(_verticalScrollbar);
		_state.add(_horizontalScrollbar);

		onResize();
	}

	/**
	 * Based on the new viewPort, sets bestMode, horizontalScrollbarHeight, and verticalScrollbarWidth.
	 * 
	 * @param	value	The new viewPort.
	 * @return			The same as you passed in, for assignment chaining.
	 */
	function set_viewPort(value:FlxRect):FlxRect
	{
		verticalScrollbarWidth = 0;
		horizontalScrollbarHeight = 0; // until otherwise calculated

		#if !FLX_NO_MOUSE
		if (_resizeModeGoal == NONE)
		{ // base it directly on content, since this is only used from onResize
			bestMode = NONE;
			if (content.width - value.width > _hiddenPixelAllowance)
			{
				horizontalScrollbarHeight = scrollbarThickness;
			}
			if (content.height - (value.height - horizontalScrollbarHeight) > _hiddenPixelAllowance)
			{
				verticalScrollbarWidth = scrollbarThickness;
				// now, with less width available, do we still fit?
				if (content.width - (value.width - verticalScrollbarWidth) > _hiddenPixelAllowance)
				{
					horizontalScrollbarHeight = scrollbarThickness;
				}
			}
		}
		else
		{
			// base it on the ratio only, because this will be used outside the class to determine new content size
			var contentRatio = content.width / content.height;
			var viewPortRatio = value.width / value.height;
			if (_resizeModeGoal == FIT_HEIGHT)
			{
				if (viewPortRatio >= contentRatio)
				{
					bestMode = FIT_HEIGHT;
					horizontalScrollbarHeight = 0;
				}
				else
				{
					var scrollbarredContentRatio = content.width / (content.height + scrollbarThickness);
					if (viewPortRatio <= scrollbarredContentRatio)
					{
						bestMode = FIT_HEIGHT;
						horizontalScrollbarHeight = scrollbarThickness;
					}
					else
					{ // in the twilight zone
						bestMode = FIT_WIDTH;
						horizontalScrollbarHeight = 0;
					}
				}
			}
			else
			{ // FIT_WIDTH
				if (viewPortRatio <= contentRatio)
				{
					bestMode = FIT_WIDTH;
					verticalScrollbarWidth = 0;
				}
				else
				{
					var scrollbarredContentRatio = (content.width + scrollbarThickness) / content.height;
					if (viewPortRatio >= scrollbarredContentRatio)
					{
						bestMode = FIT_WIDTH;
						verticalScrollbarWidth = scrollbarThickness;
					}
					else
					{ // in the twilight zone
						bestMode = FIT_HEIGHT;
						verticalScrollbarWidth = 0;
					}
				}
			}
		}
		#end
		return viewPort = value;
	}

	/**
	 * Assumes that .viewPort has already been set in the parent state's onResize function.
	 * 
	 * This is automatically re-run the moment .visible is set to true, to make sure that the correct scrollbars are visible.
	 * 
	 * During resizing, this is skipped if .visible is false.
	 */
	override public function onResize()
	{
		if (!visible)
			return;
		super.onResize();

		#if !FLX_NO_MOUSE
		if (verticalScrollbarWidth > 0)
		{
			_verticalScrollbar.visible = true;
			if (horizontalScrollbarHeight > 0)
			{ // both
				_horizontalScrollbar.visible = true;
				_horizontalScrollbar.width = viewPort.width - verticalScrollbarWidth;
				_verticalScrollbar.height = viewPort.height - horizontalScrollbarHeight;
			}
			else
			{ // just vert
				_horizontalScrollbar.visible = false;
				_verticalScrollbar.height = viewPort.height;
			}
		}
		else
		{
			_verticalScrollbar.visible = false;
			if (horizontalScrollbarHeight > 0)
			{ // just horiz
				_horizontalScrollbar.visible = true;
				_horizontalScrollbar.width = viewPort.width;
			}
			else
			{ // neither
				_horizontalScrollbar.visible = false;
			}
		}
		if (_verticalScrollbar.visible)
		{
			_verticalScrollbar.x = viewPort.right - scrollbarThickness;
			_verticalScrollbar.y = viewPort.y;
		}
		if (_horizontalScrollbar.visible)
		{
			_horizontalScrollbar.x = viewPort.x;
			_horizontalScrollbar.y = viewPort.bottom - scrollbarThickness;
		}
		if (_verticalScrollbar.visible || _horizontalScrollbar.visible)
		{
			_verticalScrollbar.updateViewScroll();
			_horizontalScrollbar.updateViewScroll();
		}
		if (_verticalScrollbar.visible)
			_verticalScrollbar.draw();
		if (_horizontalScrollbar.visible)
			_horizontalScrollbar.draw();
		#end
		x = Std.int(viewPort.x);
		y = Std.int(viewPort.y);
		width = Std.int(viewPort.width - verticalScrollbarWidth);
		height = Std.int(viewPort.height - horizontalScrollbarHeight);
	}

	function get_bestMode():ResizeMode
	{
		return bestMode;
	}

	function get_horizontalScrollbarHeight():Int
	{
		return horizontalScrollbarHeight;
	}

	function get_verticalScrollbarWidth():Int
	{
		return verticalScrollbarWidth;
	}

	override public function set_visible(value:Bool):Bool
	{
		super.set_visible(value); // so onResize doesn't return early
		if (value) // if visible
			onResize(); // show only if needed (recalc)
		else
			_horizontalScrollbar.visible = _verticalScrollbar.visible = false; // don't show
		return value;
	}

	override public function destroy()
	{
		for (bar in [_horizontalScrollbar, _verticalScrollbar])
		{
			_state.remove(bar);
			bar.destroy();
		}
		super.destroy();
	}

	function set_content(value:FlxRect):FlxRect
	{
		content = value;
		if (viewPort != null) // not during the constructor, but normally...
			set_viewPort(viewPort); // ...force update
		return content;
	}

	/**
	 * Force a redraw of any visible scrollbars.  Call this if you modify the scroll manually, e.g. to force something to be scrolled into view.
	 */
	public function redrawBars()
	{
		_horizontalScrollbar.forceRedraw();
		_verticalScrollbar.forceRedraw();
	}
}

#if mobile
/**
 * Variáveis e configurações fundamentais para o uso dos controles (VirtualPad e Hitbox)
 */
class Config
{
	// Modificado pelo Silver (Ele só pediu pra eu fazer uma commit que mudava umas coisas)
	// Criado por LuckyDog7
	// https://github.com/MatheusSilver/miku-public/

	/**
	 * Função para retornar o modo dos controles.
	 * @return Retorna uma Int (ClientPrefs.buttonsMode) que representa o modo dos controles de acordo com o save.
	 */
	public static function getcontrolmode():Int
	{
		// load control mode num from FlxSave
		if (ClientPrefs.buttonsMode != null)
			return ClientPrefs.buttonsMode[0];
		return 0;
	}

	/**
	 * Função para trocar o modo dos controles e salva ele nas variáveis do ClientPrefs.
	 * @param mode A Int da troca de modos, ou seja, ClientPrefs.buttonsMode[0] = mode.
	 * @return Retorna uma Int que representa o modo dos controles de acordo com o save.
	 */
	public static function setcontrolmode(mode:Int = 0):Int
	{
		// save control mode num from FlxSave
		if (ClientPrefs.buttonsMode == null)
			ClientPrefs.buttonsMode = new Array();
		ClientPrefs.buttonsMode[0] = mode;
		ClientPrefs.save();

		return ClientPrefs.buttonsMode[0];
	}

	/**
	 * Salva a customização feita nos controles, quando o modo é "Customizado".
	 * @param _pad O VirtualPad (ui.FlxVirtualPad)
	 */
	public static function savecustom(_pad:FlxVirtualPad)
	{
		trace("saved");

		if (ClientPrefs.buttons == null)
		{
			ClientPrefs.buttons = new Array();

			for (buttons in _pad)
			{
				ClientPrefs.buttons.push(FlxPoint.get(buttons.x, buttons.y));
			}
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in _pad)
			{
				ClientPrefs.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}
		ClientPrefs.save();
	}

	/**
	 * Carrega o save da customização dos controles, quando o modo é "Customizado".
	 * @param _pad O VirtualPad (ui.FlxVirtualPad)
	 * @return Retorna a variável _pad após as posições serem trocadas.
	 */
	public static function loadcustom(_pad:FlxVirtualPad):FlxVirtualPad
	{
		// load pad
		if (ClientPrefs.buttons == null)
			return _pad;
		var tempCount:Int = 0;

		for (buttons in _pad)
		{
			buttons.x = ClientPrefs.buttons[tempCount].x;
			buttons.y = ClientPrefs.buttons[tempCount].y;
			tempCount++;
		}
		return _pad;
	}
}
#end

class CoolUtil
{
	/**
	 * Umma Array que contém o nome e prefixo das dificuldades.
	 */
	public static var difficultyStuff:Array<Dynamic> = [
		['Easy', '-easy'], // 0
		['Normal', ''], // 1
		['Hard', '-hard'], // 2 - honestamente estou pensando em trocar o 'Hard' por 'Difícil' mas né? a maioria da rapaziada tá acostumada com 'Hard'
		['Sonic', '-sega'], // 3
		['Mario', '-nintendo'], // 4
		['MX', '-mx'], // 5
		['Lord-X', '-lorx-x'], // 6
		['Hypno', '-hypno'] // 7
	];

	/**
	 * Uma função aproximadamente 2-6 vezes mais rápida do que a do Math. (Margem de < 0.05% de erros - pode ser impreciso)
	 * @param Número que será utilizado na função
	 * @return Float
	 */
	inline public static function seno(n:Float):Float {
		return FlxMath.fastSin(n);
	}

	/**
	 * Uma função aproximadamente 2-6 vezes mais rápida do que a da classe 'Math'. (Margem de < 0.05% de erros - pode ser impreciso)
	 * @param Número que será utilizado na função
	 * @return Float
	 */
	inline public static function cosseno(n:Float):Float {
		return FlxMath.fastCos(n);
	}

	/**
	 * Uma função que retorna um número aproximado de pi.
	 * @return Float (Math.PI)
	 */
	 inline public static function pi():Float {
		return Math.PI;
	}

	// Não sei o que isso faz
	inline public static function formatScore(zeros_vezes:Int, num_vezes:Int):String
	{
		var zeros:String = repeat("0",
			zeros_vezes - (Std.int(Math.log(num_vezes) / Math.log(10)) + 1)); // Maldito haxe que não tem função log10 já imbutida :skull:
		var num:String = Std.string(num_vezes);

		return zeros + num;
	}

	// Não sei o que isso faz
	inline public static function repeat(str:String, times:Int):String
	{
		var result:String = "";
		for (i in 0...times)
			result += str;
		return result;
	}

	// Não sei o que isso faz
	public static function mathClamp(n:Float, min:Float, max:Float):Int
	{
		return Std.int(Math.min(Math.max(n, min), max));
	}

	/**
	 * Formata um texto deixando ele bonitinho (Letras maíusculas e minúsculas)
	 * @param text O texto que você vai capitalizar. (nem sei se essa palavra existe pra ser bem sincero)
	 */
	inline public static function capitalize(text:String)
	{
		return text.charAt(0).toUpperCase() + text.substr(1);
	}

	/**
	 * Retorna uma cor de uma String.
	 * @param color A cor em formato de String. 
	 * @return Retorna um FlxColor.
	 */
	inline public static function colorFromString(color:String):FlxColor // Já estava ficando deveras pito com isso...
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x'))
			color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if (colorNum == null)
			colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	/**
	 * Função que retorna a dificuldade em Uppercase.
	 * @return Retorna uma String que representa a dificuldade em Uppercase. (EASY, NORMAL, HARD.)
	 */
	public static function difficultyString():String
	{
		return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
	}

	// Não sei o que isso faz
	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;
		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;
		return newValue;
	}
	
	/**
	 * Carrega um arquivo de Texto (pode carregar outros arquivos também, mas o foco principal são arquivos .txt)
	 * @param path Caminho do seu arquivo
	 * @return Retorna uma Array<String> que contém o seu texto.
	 */
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		if (Assets.exists(path))
			daList = Assets.getText(path).trim().split('\n');
		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	/**
	 * Transforma uma String em Array usando o método .split para criar linebreaks.
	 * @param string A String que será utilizada para criar a lista.
	 * @return Retorna uma lista (Array<String>) com as linhas da Array separadas.
	 */
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	// Não sei o que isso faz
	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
					{
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					}
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
					{
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	/**
	 * Cria uma Array de números
	 * @param max O número máximo que sua Array terá. 
	 * @param min O número mínimo que sua Array terá. (Já é 0 por padrão.)
	 * @return Array completa com números entre min e max
	 */
	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	// Não sei pra que isso serve, então aqui não tem explicação
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	/**
	 * Abre um URL.
	 * @param URL do Site que você deseja abrir.
	 */
	public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/**
	 * Retorna o path da Savedata do jogo (Compatível com as versões antigas e novas do Flixel.)
	 * @return Path da Savedata
	 */
	public static function getSavePath():String
	{
		@:privateAccess // galakxisne
		return #if (flixel < "5.0.0") 'galaccine' #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}
}

class GamepadUtil
{
	private static final bindsBlackList:Map<InputDevices, Array<Int>>=[
		Switch_Controller => [-1],
		PS4_Controller    => [-1],
		Xinput_Controller => [-1, 10] 
	];



	inline public static function formatKey(inputData:Dynamic):String
	{
		if (Main.isKeyboard) return Input.InputFormatter.getKeyName(inputData);
		else 			     return Input.InputFormatter.getKeyNameGamepad(inputData);
	}


	public static function isValidInput(keyPressed:Int, gamepadModel:InputDevices):Bool
	{
		return !bindsBlackList.get(gamepadModel).contains(keyPressed);
	}

	inline public static function getActualGamepadModel():InputDevices
	{
		switch (FlxG.gamepads.lastActive.detectedModel)
		{
			case SWITCH_PRO: return Switch_Controller;
			case PS4:    	 return PS4_Controller;
			default:	   	 return Xinput_Controller;
		}
	}

	inline public static function getDisplayGamepadModel():InputDevices
	{
		if (Main.isKeyboard) return Keyboard;
		else if (ClientPrefs.gamepadDisplay==AUTO) return getActualGamepadModel();
		else								 return ClientPrefs.gamepadDisplay;
	}

	inline public static function anyGamepadButtonPressed():Bool
	{
		return (FlxG.gamepads.anyButton() && isValidInput(FlxG.gamepads.lastActive.firstJustPressedID(), getActualGamepadModel()));
	}

	inline public static function getGamepadPressedButton():Int
	{
		if (isValidInput(FlxG.gamepads.lastActive.firstJustPressedID(), getActualGamepadModel())) return FlxG.gamepads.lastActive.firstJustPressedID();
		return -1; // Só pra poder padronizar como none.
	}

	inline public static function checkGamepadPressedButton(button:FlxGamepadInputID):Bool
	{
		return FlxG.gamepads.anyJustPressed(button);
	}

	inline public static function getGamepadConnected():Bool
	{
		return FlxG.gamepads.lastActive != null;
	}
}

class ProgressionUtil 
{
	public static function terminouHistoria():Bool {
		Metadata.WeekData.reloadWeekFiles(true);

		var historiaMusicas:Int = 0;
		for (i in 0...Metadata.WeekData.weeksList.length) {
			var leWeek:Metadata.WeekData = Metadata.WeekData.weeksLoaded.get(Metadata.WeekData.weeksList[i]);
			historiaMusicas += leWeek.songs.length;
		}

		//trace("Total de musicas: "+ historiaMusicas + "\n" + "Progresso: " + getSaveSum());
		return getSaveSum() == historiaMusicas+1;
	}

	public static function terminouFreeplay():Bool {
		Metadata.WeekData.reloadWeekFiles(true);

		var freeplayMusicas:Int = 0;
		for (i in 0...Metadata.WeekData.freeplayList.length) {
			var leWeek:Metadata.WeekData = Metadata.WeekData.weeksLoaded.get(Metadata.WeekData.freeplayList[i]);
			freeplayMusicas += leWeek.songs.length;
		}

		//trace("Total de musicas freeplay: "+ freeplayMusicas + "\n" + "Progresso freeplay: " + FreeplayState.progressFreeplay);
		return FlxG.save.data.freeplayProgress == freeplayMusicas+1;
	}

	public static function terminouTudo():Bool {
		return terminouFreeplay() && terminouHistoria();
	}

	public static function getSaveSum():Int {
		var sum:Int = 0;
		for (i in 0...MenuPreHistoria.curSave.length) {
			sum += Std.parseInt(MenuPreHistoria.curSave.split(",")[i]);
		}
		return sum;
	}
}

// O que tem no esconderijo?
// .........,,,,,,,,*******/////(((((##############################################
// .........,,,,,,,,********//////(((((###########(((((((((((((/((((((((###%%%#####
// ...........,,...,,,,,,,****//////////////////////(((((###############%%%%&%###%#
//   ....,***///(((#########((###%%%%%%%%####%%%%&&&&&&&&%%%%%%%%&&&&&&&%%%%%%%%&#
// .**(((((##%%&&&&&&&%%%%%%&&&&&&&&%%%%%&&&&&&&&&&&&&%&&&&&&&@@@&&&&%%%&&&&&&&&%&#
// ,*/%%&&&&&&&&&&%%%%&&&&&&&&&&&&&&&@@@@@&&&&&&&&&@@@@@@&&&&&&&&&&@@@@&&&&&&&&&&&%
//*/#&@@&&&&&&&%&&&@@@@&&&&&@@@@@@@@@@&&@@@@@@@@@@&&&&&&&&&&@@@@%#/*//********/&&&
////%&@@@&&&&&@@@@@********(#%%%%%%%&&&&&@@%.,.,........&@@@@@@&&&&&&%&&&%(*,,*&&&
//*/(%@@@@@&&@@@@@%***#&@@@@@@@@&#/*,,..............,,,,,,,,,,,,,,,,**/(%&&&%//&&&
// (((((((#((@@@&&&&%%&%%%%%%%&&&&&&%%%%&&@@@&&&&&&&&&&&&&&&&&&&&&%%%%%%%&&&&&&%%%%
// ...,*/#(#@@@&@@&&&&&&&&&&&&%%%%&&&@@@@&&&&&&#####&@@&&&&&&%%%%%%&&&&&%%%%####%(
// ,,,.,,(((&@@/&@@@@@&&%%%%%%&&&&&&&%%%%&&&&(.....,,%@@&%%%%&&&&&&%%%#######%%%%/
// ..,, .,/((&@@//@@&&%%&&&@@@&&&%%%%%%%%%&&%.,,......,/@@@@@&&&&%%%######%%%&&&&//
// ..,,*///((#&%***(&@@@@@&&&%%%%%%##((////,,,,,,...............,,,,,,,,,,,*****%//
// ,**///((((#**/***,,*/,,,,***,..........,,,,,,,,,...........       .....,,,***&&/
//  ..,********(****,,,/@@&%(/*,...       /,,,,,,,,,,,,,,.............,,,,,****&@@
//*  .,,*******(****,,,,,*&&&&&&%%%%%#.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%%%%%((###((
// ,....,*****/*//***,,,,,,,,,*###((((*...,.,,,,,,,,,,,,,,,,,,,,,,,,,,,&&&%#//(##//
// ,,..,..,,**//*****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********&@&%#(//*%,,
// (((((##%%%&&&&/*******,*,,,,,********************///((##%%%%&&&&&&&@@@&&%%%#(*,,
// &&&&&%%%%&&&&&&%**********/((#%%%&&%/////////////////***/#%#####%%%%%%#%%%%#(#*,
// %%%######&%%%&&&&@&&&%#((((##%%%%%#####/*/********,,,(#(%#######((((##((%%%#((#%
// %%%%%%%%#%%%%%%%&&&&%%%###(######(((((///(((#############(((((######((((&%%#((((
// ##%&%%&&%#%%%%###%%%%%%#((%%((((((((((((##############(((#####(%#((#(((#@%%%%%%%
// &&%##%&&%####(%@@@@&%(###((#@@%((#%%%###########(((((##(((((%@@((##((##%&&&&&&&&
// @@&&&%%#(#%@@@@@@@@&&%((###(%@@@@@&#((###%#####((((((((#&@@@@@%(##((###&&@@@@@@@
// @@@@&%%*#%&&&@@@@@@&&&%#((###@@@@@@@@@@@@&#((((##&@@@@@@@@@@@@(#%(((###@@@@@@#(/
// @@@@....#%%&&&@@@@@@&%%%%#(##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&(%%%#%%#%@@@@/////
