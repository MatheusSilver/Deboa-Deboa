package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;


class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 90;//plan on doing scroll directions soon -bb
	public var downScroll:Bool = false;//plan on doing scroll directions soon -bb
	public var sustainReduce:Bool = true;
	
	private var player:Int;
	
	public var texture(default, set):String = null;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);

		if(PlayState.storyDifficulty == 3) {
			if(PlayState.SONG.song.toLowerCase()=='cross-console-clash' && player == 0)
				texture='arrows-mario';
			if(PlayState.SONG.song.toLowerCase()=='cross-console-clash' && player == 1)
				texture='arrows1-sonic';
		} else if(PlayState.storyDifficulty == 4) {
			if(PlayState.SONG.song.toLowerCase()=='cross-console-clash' && player == 1)
				texture='arrows-mario';
			if(PlayState.SONG.song.toLowerCase()=='cross-console-clash' && player == 0)
				texture='arrows1-sonic';
		}

		if(texture.length < 1) {
			texture = PlayState.SONG.arrowSkin;
			if(texture == null || texture.length < 1)
				texture = 'NOTE_assets';
		}
		
		if(ClientPrefs.middleScroll) {
			switch (player) {
				case 0 | 2:		visible = false;
				case 1:			visible = true;
			}
		}
	}

	public function reloadNote() {
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		if(PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelUI/' + texture));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));

			antialiasing = false;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));

			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);
			switch (Math.abs(noteData) % 4)
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}
		} else if(texture.endsWith('zoom')) {
			loadGraphic(Paths.image('pixelUI/' + texture));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));

			antialiasing = false;
			setGraphicSize(Std.int(width * 0.7));

			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);
			switch (Math.abs(noteData) % 4)
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}
		} else {
			frames = Paths.getSparrowAtlas(texture);
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			if(texture == 'RING_assets')
				animation.addByPrefix('gold', 'arrowSPACE00000');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			antialiasing = ClientPrefs.globalAntialiasing;
			var song:String = PlayState.SONG.song.toLowerCase();
			if(song != 'pasta-night')		setGraphicSize(Std.int(width * 0.7));
			else							setGraphicSize(Std.int(width * 0.65));

			if(texture != 'RING_assets') {
				switch (Math.abs(noteData) % 4)
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			} else {
				switch (Math.abs(noteData) % 5)
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowSPACE');
						animation.addByPrefix('pressed', 'space press', 24, false);
						animation.addByPrefix('confirm', 'space confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 4:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			}
		}
		updateHitbox();

		if(lastAnim != null)
			playAnim(lastAnim, true);
	}

	public function postAddedToGroup() {
		playAnim('static');
		var posMultplier:Int = noteData;
		if (modifiers.ModifiersManager.isEnabledbyName("flip_note")){
			if (PlayState.isRing) { //Preguiça de pensar em solução bunita
				switch (noteData) {
					case 0: 		posMultplier = 4;
					case 4:			posMultplier = 0;
					case 1:			posMultplier = 3;
					case 3: 		posMultplier = 1;
				}
			} else {
				switch (noteData) {
					case 0: 		posMultplier = 3;
					case 3:			posMultplier = 0;
					case 2:			posMultplier = 1;
					case 1: 		posMultplier = 2;
				}
			}
		}
		x += Note.swagWidth * posMultplier;
		if (PlayState.nomehistorico.toLowerCase() != 'noite da rapaziada' || ClientPrefs.middleScroll) {
			x += 50;
			x += ((FlxG.width / 2) * player);

			if(player == 1 && PlayState.isRing)
				x -= 50;

			if(PlayState.SONG.song.toLowerCase()=='cross-console-clash' && !ClientPrefs.middleScroll) {
				if(player == 1)		x -= 85;
				else				x += 85;
			}
		} else {
			switch (player) {
				case 0:		x += ((FlxG.width / 4) * - 1) - (width * 2);
				case 1:		x += ((FlxG.width / 4) * -2) - (width * 2);
				case 2:		x += ((FlxG.width / 4) * -3) - (width * 2);
			}
		}
		if (modifiers.ModifiersManager.isEnabledbyName("only_two")){
			var ajuste:Int = (PlayState.isRing) ? 65 : 85;

			switch (noteData) {
				case 0:		x += ajuste;
				case 2:		visible = PlayState.isRing;
				case 3:		if (!PlayState.isRing) x -= ajuste;
				case 4:		x -= ajuste;
				default:	visible = false;
			}
		}
		ID = noteData;
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage && !texture.endsWith('zoom'))
			centerOrigin();

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
		if(animation.curAnim == null || animation.curAnim.name == 'static')
			colorSwap.hue = colorSwap.saturation = colorSwap.brightness = 0;
		else {
			if (noteData > -1 && noteData < ClientPrefs.arrowHSV.length)
			{
				colorSwap.hue = ClientPrefs.arrowHSV[noteData][0] / 360;
				colorSwap.saturation = ClientPrefs.arrowHSV[noteData][1] / 100;
				colorSwap.brightness = ClientPrefs.arrowHSV[noteData][2] / 100;
			}

			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage && !texture.endsWith('zoom'))
				centerOrigin();
		}
	}
}