package;

import PlayState;
import editors.ChartingState;
import flixel.FlxSprite;
import modifiers.ModifiersManager;

using StringTools;

class Note extends FlxSprite
{
	public var extraData:Map<String, Dynamic> = [];

	public var strumTime:Float = 0;

	public var mustPress:Bool = false;

	public var tail:Array<Note> = []; // for sustains
	public var parent:Note;
	public var isinvisibru:Bool = false;
	public var spawned:Bool = false;
	public var lateHitMult:Float = 1;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var ignoreNote:Bool = false;
	public var hitByOpponent:Bool = false;
	public var noteWasHit:Bool = false;
	public var prevNote:Note;
	public var blockHit:Bool = false; // only works for player
	public var lowPriority:Bool = false;
	public var instakillNote:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType(default, set):String = null;

	public var eventName:String = '';
	public var eventVal1:String = '';
	public var eventVal2:String = '';
	public var eventVal3:String = '';
	public var eventVal4:String = '';
	public var eventPath:String = '';

	public var colorSwap:ColorSwap;
	public var inEditor:Bool = false;

	private var earlyHitMult:Float = 0.5;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	// Lua shit
	public var noteSplashDisabled:Bool = false;
	public var noteSplashTexture:String = null;
	public var noteSplashHue:Float = 0;
	public var noteSplashSat:Float = 0;
	public var noteSplashBrt:Float = 0;

	var jatrocou:Bool = true;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var offsetAngle:Float = 0;
	public var multAlpha:Float = 1;
	public var multSpeed(default, set):Float = 1;

	public var copyX:Bool = true;
	public var copyY:Bool = true;
	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;

	public var hitHealth:Float = 0.023 * 2;
	public var missHealth:Float = 0.06125 * 2;

	public var texture(default, set):String = null;

	public var noAnimation:Bool = false;
	public var hitCausesMiss:Bool = false;
	public var distance:Float = 2000; // plan on doing scroll directions soon -bb

	private function set_multSpeed(value:Float):Float
	{
		resizeByRatio(value / multSpeed);
		multSpeed = value;
		// trace('fuck cock');
		return value;
	}

	public function resizeByRatio(ratio:Float) // haha funny twitter shit
	{
		if (isSustainNote && !animation.curAnim.name.endsWith('end'))
		{
			scale.y *= ratio;
			updateHitbox();
		}
	}

	private function set_texture(value:String):String
	{
		if (texture != value)
		{
			reloadNote('', value);
		}
		texture = value;
		return value;
	}

	private function set_noteType(value:String):String
	{
		noteSplashTexture = PlayState.SONG.splashSkin;
		colorSwap.hue = ClientPrefs.arrowHSV[noteData % 4][0] / 360;
		colorSwap.saturation = ClientPrefs.arrowHSV[noteData % 4][1] / 100;
		colorSwap.brightness = ClientPrefs.arrowHSV[noteData % 4][2] / 100;

		if (noteData > -1 && noteType != value)
		{
			switch (value)
			{
				case 'player3':
					mustPress = false; // Eu ia quebrar a cabeça com isso no playstate, mas essa solução é bem mais simples.
				case 'Hurt Note':
					ignoreNote = mustPress;
					reloadNote('HURT');
					noteSplashTexture = 'HURTnoteSplashes';
					colorSwap.hue = 0;
					colorSwap.saturation = 0;
					colorSwap.brightness = 0;
					if (isSustainNote)
					{
						missHealth = 0.1 * 2;
					}
					else
					{
						missHealth = 0.3 * 2;
					}
					hitCausesMiss = true;
					lowPriority = true;

				case 'CCC Regen': // Silverson comentários aleatórios em momentos que ele está coringando
					colorSwap.hue = 0;
					colorSwap.saturation = 0;
					colorSwap.brightness = 0;

				case 'No Animation':
					noAnimation = true;
				default:
					if (ModifiersManager.isEnabledbyName("more_damage"))
						missHealth = 0.075 * 2;
					else if (ModifiersManager.isEnabledbyName("less_damage"))
						missHealth = 0.0475 * 2;
					else if (ModifiersManager.isEnabledbyName("more_regen"))
						hitHealth = 0.036 * 2;
			}
			noteType = value;
		}
		noteSplashHue = colorSwap.hue;
		noteSplashSat = colorSwap.saturation;
		noteSplashBrt = colorSwap.brightness;
		return value;
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inEditor:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.inEditor = inEditor;

		x += (ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X) + 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;
		if (!inEditor)
			this.strumTime += ClientPrefs.noteOffset /*-35*/;

		this.noteData = noteData;

		if (noteData > -1)
		{
			texture = '';
			colorSwap = new ColorSwap();
			shader = colorSwap.shader;

			x += swagWidth * (noteData % 4);

			if (PlayState.isRing)
			{
				if (!isSustainNote)
				{ // Doing this 'if' check to fix the warnings on Senpai songs
					var animToPlay:String = '';
					switch (noteData % 5)
					{
						case 0:
							animToPlay = 'purple';
						case 1:
							animToPlay = 'blue';
						case 2:
							animToPlay = 'ring';
						case 3:
							animToPlay = 'green';
						case 4:
							animToPlay = 'red';
					}
					animation.play(animToPlay + 'Scroll');
				}
			}
			else
			{
				x += swagWidth * (noteData % 4);
				if (!isSustainNote)
				{ // Doing this 'if' check to fix the warnings on Senpai songs
					var animToPlay:String = '';
					switch (noteData % 4)
					{
						case 0:
							animToPlay = 'purple';
						case 1:
							animToPlay = 'blue';
						case 2:
							animToPlay = 'green';
						case 3:
							animToPlay = 'red';
					}
					animation.play(animToPlay + 'Scroll');
				}
			}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			multAlpha = 0.6;
			if (ClientPrefs.downScroll)
				flipY = true;

			offsetX += width / 2;
			copyAngle = false;

			if (PlayState.isRing)
			{
				switch (noteData)
				{
					case 0:
						animation.play('purpleholdend');
					case 1:
						animation.play('blueholdend');
					case 2:
						animation.play('greenholdend');
					case 3:
						animation.play('greenholdend');
					case 4:
						animation.play('redholdend');
				}
			}
			else
				switch (noteData)
				{
					case 0:
						animation.play('purpleholdend');
					case 1:
						animation.play('blueholdend');
					case 2:
						animation.play('greenholdend');
					case 3:
						animation.play('redholdend');
				}

			updateHitbox();

			offsetX -= width / 2;

			if (PlayState.isPixelStage)
				offsetX += 30; // TOC

			if (prevNote.isSustainNote)
			{
				if (PlayState.isRing)
					switch (prevNote.noteData)
					{
						case 0:
							prevNote.animation.play('purplehold');
						case 1:
							prevNote.animation.play('bluehold');
						case 2:
							prevNote.animation.play('bluehold');
						case 3:
							prevNote.animation.play('greenhold');
						case 4:
							prevNote.animation.play('redhold');
					}
				else
					switch (prevNote.noteData)
					{
						case 0:
							prevNote.animation.play('purplehold');
						case 1:
							prevNote.animation.play('bluehold');
						case 2:
							prevNote.animation.play('greenhold');
						case 3:
							prevNote.animation.play('redhold');
					}

				prevNote.scale.y *= Song.Conductor.stepCrochet / 100 * 1.05 * PlayState.instance.songSpeed;
				if (PlayState.isPixelStage)
				{
					prevNote.scale.y *= 1.19;
					prevNote.scale.y *= (6 / height); // Auto adjust note size
				}
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}

			if (PlayState.isPixelStage)
			{
				scale.y *= PlayState.daPixelZoom;
				updateHitbox();
			}
		}
		else if (!isSustainNote)
		{
			earlyHitMult = 1;
		}
		x += offsetX;

		if (isSustainNote && PlayState.SONG.arrowSkin.endsWith("zoom"))
			offsetX += 36;
	}

	var zoomCoiso:Bool = false;
	var lastNoteOffsetXForPixelAutoAdjusting:Float = 0;

	public var originalHeightForCalcs:Float = 6;

	public function reloadNote(?prefix:String = '', ?texture:String = '', ?suffix:String = '')
	{
		if (prefix == null)
			prefix = '';
		if (texture == null)
			texture = '';
		if (suffix == null)
			suffix = '';

		var skin:String = texture;
		if (texture.length < 1)
		{
			skin = PlayState.SONG.arrowSkin;
			if (skin == null || skin.length < 1)
			{
				skin = 'NOTE_assets';
			}
		}

		var animName:String = null;
		if (animation.curAnim != null)
		{
			animName = animation.curAnim.name;
		}

		var arraySkin:Array<String> = skin.split('/');
		arraySkin[arraySkin.length - 1] = prefix + arraySkin[arraySkin.length - 1] + suffix;

		var lastScaleY:Float = scale.y;
		var blahblah:String = arraySkin.join('/');
		if (PlayState.isPixelStage)
		{
			if (isSustainNote)
			{
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'));
				width = width / 4;
				height = height / 2;
				originalHeightForCalcs = height;
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'), true, Math.floor(width), Math.floor(height));
			}
			else
			{
				loadGraphic(Paths.image('pixelUI/' + blahblah));
				width = width / 4;
				height = height / 5;
				loadGraphic(Paths.image('pixelUI/' + blahblah), true, Math.floor(width), Math.floor(height));
			}
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			loadPixelNoteAnims();
			antialiasing = false;

			if (isSustainNote)
			{
				offsetX += lastNoteOffsetXForPixelAutoAdjusting;
				lastNoteOffsetXForPixelAutoAdjusting = (width - 7) * (PlayState.daPixelZoom / 2);
				offsetX -= lastNoteOffsetXForPixelAutoAdjusting;
			}
		}
		else if (skin.endsWith('zoom'))
		{
			if (isSustainNote)
			{
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'));
				width = width / 4;
				height = height / 2;
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'), true, Math.floor(width), Math.floor(height));
			}
			else
			{
				loadGraphic(Paths.image('pixelUI/' + blahblah));
				width = width / 4;
				height = height / 5;
				loadGraphic(Paths.image('pixelUI/' + blahblah), true, Math.floor(width), Math.floor(height));
			}
			setGraphicSize(Std.int(width * 0.7));
			loadPixelNoteAnims();
			antialiasing = false;
		}
		else
		{
			frames = Paths.getSparrowAtlas(blahblah);
			loadNoteAnims();
			antialiasing = ClientPrefs.globalAntialiasing;
		}
		if (isSustainNote)
		{ // 0.951
			scale.y = lastScaleY;
		}
		if (texture.endsWith('zoom') && isSustainNote && !zoomCoiso)
		{
			scale.y = lastScaleY * 0.951;
			zoomCoiso = true;
		}
		else if (!texture.endsWith('zoom') && isSustainNote && zoomCoiso)
		{
			scale.y = lastScaleY * 1.05152;
			zoomCoiso = false;
		}
		updateHitbox();

		if (animName != null)
			animation.play(animName, true);

		if (inEditor)
		{
			setGraphicSize(ChartingState.GRID_SIZE, ChartingState.GRID_SIZE);
			updateHitbox();
		}
	}

	function loadNoteAnims()
	{
		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		if (PlayState.isRing)
		{
			animation.addByPrefix('ringScroll', 'gold0');
		}
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		if (isSustainNote)
		{
			animation.addByPrefix('purpleholdend', 'pruple end hold');
			animation.addByPrefix('greenholdend', 'green hold end');
			animation.addByPrefix('redholdend', 'red hold end');
			animation.addByPrefix('blueholdend', 'blue hold end');

			animation.addByPrefix('purplehold', 'purple hold piece');
			animation.addByPrefix('greenhold', 'green hold piece');
			animation.addByPrefix('redhold', 'red hold piece');
			animation.addByPrefix('bluehold', 'blue hold piece');
		}

		if (PlayState.nomehistorico.toLowerCase() != 'noite da rapaziada')
		{
			setGraphicSize(Std.int(width * 0.7));
		}
		else
		{
			setGraphicSize(Std.int(width * 0.65));
		}
		updateHitbox();
	}

	function loadPixelNoteAnims()
	{
		if (isSustainNote)
		{
			animation.add('purpleholdend', [PURP_NOTE + 4]);
			animation.add('greenholdend', [GREEN_NOTE + 4]);
			animation.add('redholdend', [RED_NOTE + 4]);
			animation.add('blueholdend', [BLUE_NOTE + 4]);

			animation.add('purplehold', [PURP_NOTE]);
			animation.add('greenhold', [GREEN_NOTE]);
			animation.add('redhold', [RED_NOTE]);
			animation.add('bluehold', [BLUE_NOTE]);
		}
		else
		{
			animation.add('greenScroll', [GREEN_NOTE + 4]);
			animation.add('redScroll', [RED_NOTE + 4]);
			animation.add('blueScroll', [BLUE_NOTE + 4]);
			animation.add('purpleScroll', [PURP_NOTE + 4]);
		}
	}

	var curcounterCCC:Float = 2; // Tentativa de consertar um uso desnecessauro de memória

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (noteType == 'CCC Regen'
			&& curcounterCCC != PlayState.cccVidaCounter
			&& PlayState.nomehistorico.toLowerCase() == 'cross console clash')
		{
			curcounterCCC = PlayState.cccVidaCounter;
			if (PlayState.storyDifficulty == 4)
			{ // 4 = dificuldade do mauro
				if (PlayState.cccVidaCounter == 0)
				{
					reloadNote('', 'shroom-clash');
				}
				else if (PlayState.cccVidaCounter == 1)
				{
					reloadNote('', 'flower-clash');
				}
			}
			else
			{
				if (PlayState.cccVidaCounter < 2)
				{
					reloadNote('', 'ring-clash');
				}
			}
		}
		if (mustPress)
		{
			// ok river
			if (strumTime > Song.Conductor.songPosition - (Song.Conductor.safeZoneOffset * lateHitMult)
				&& strumTime < Song.Conductor.songPosition + (Song.Conductor.safeZoneOffset * earlyHitMult))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Song.Conductor.songPosition - Song.Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime < Song.Conductor.songPosition + (Song.Conductor.safeZoneOffset * earlyHitMult))
			{
				if ((isSustainNote && prevNote.wasGoodHit) || strumTime <= Song.Conductor.songPosition)
					wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}