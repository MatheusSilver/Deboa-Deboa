package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.util.FlxAxes;
import flixel.graphics.FlxGraphic;

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
	public static function pegarpos(pos:String, ?world:Bool = false):Float
	{
		if (pos == 'x')
			return !world ? FlxG.mouse.x : FlxG.mouse.getPositionInCameraView().x;

		if (pos == 'y')
			return !world ? FlxG.mouse.y : FlxG.mouse.getPositionInCameraView().y;

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

			scrollSpeed = Std.int(CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
		}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollX += FlxG.mouse.wheel * mouseScrollMultiplier;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollX += Std.int(scrollSpeed);
		scrollX = CoolUtil.mathClamp(scrollX, -FlxG.width / max_x, FlxG.width / max_x);
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

			scrollSpeed = Std.int(CoolUtil.mathClamp(scrollSpeed, -maxScrollSpeed, maxScrollSpeed));
		}

		#if desktop
		if (FlxG.mouse.wheel != 0)
		{
			scrollY += FlxG.mouse.wheel * mouseScrollMultiplier;
		}
		// Talvez isso possa vir a ser útil :thinking:
		#end
		scrollY += Std.int(scrollSpeed);
		scrollY = CoolUtil.mathClamp(scrollY, -FlxG.height / max_y, FlxG.height / max_y);
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
 * Serve para fazer o swipe em objetos na tela.
 */
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