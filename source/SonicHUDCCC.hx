package;

import PlayState;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class SonicHUDCCC extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	var accuracyText:FlxText;
	var accuracyText2:FlxText;

	var isMario:Bool;

	var scoreLast:Float = -1;
	var scoreGroup:FlxTypedGroup<FlxSprite>;

	public static var ringsText:FlxSprite;
	var ringNum:FlxSprite;
	
	public var ratingIcon:FlxSprite;

	var scoreIndex:Array<Dynamic> = [	
		[7, 100],
		[6, 95],
		[5, 90],
		[4, 85],
		[3, 80],
		[2, 75],
		[1, 70],
		[0, 65]
	];

	public static var barralateral:FlxSprite;
	public static var barralateral2:FlxSprite;


	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		if(PlayState.storyDifficulty == 3){ //Dificuldade do Mario
		isMario = false;}
		else{isMario = true;}

		// le healthbar setup
		var barY = FlxG.height - (7 * 6);
		if (ClientPrefs.downScroll)
			barY = 3 * 6;
		
		var UIBox:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('bg'));
		UIBox.setGraphicSize(Std.int(UIBox.width * 6));
		UIBox.updateHitbox();
		UIBox.scrollFactor.set();
		UIBox.antialiasing = false;
		UIBox.screenCenter(X);
		add(UIBox);

		barralateral = new FlxSprite(0,0).loadGraphic(Paths.image('barra lateral'));
		barralateral.antialiasing = false;
		barralateral.scale.x = 1.68;
		barralateral.scale.y = 2.05;

		add(barralateral);

		barralateral2 = new FlxSprite(0,0).loadGraphic(Paths.image('barra lateral'));
		barralateral2.antialiasing = false;
		barralateral2.flipX = true;
		barralateral2.scale.x = 3.225;
		barralateral2.scale.y = 4;
		barralateral2.x = FlxG.width - barralateral2.width;
		barralateral.scale.x = 3.225;
		barralateral.scale.y = 4;
		add(barralateral2);

		if (ClientPrefs.downScroll)
		{
			UIBox.flipY = true;
			UIBox.y -= 1; 
		}

		scoreGroup = new FlxTypedGroup<FlxSprite>();
		add(scoreGroup);

		for (index in 0...6)
		{
			var scoreNum:FlxSprite = new FlxSprite(8 * index * 6, barY - (1 * 6)).loadGraphic(Paths.image('score'), true, 8, 8);
			scoreNum.animation.add('idle', [0,1,2,3,4,5,6,7,8,9], 0, false);
			scoreNum.animation.frameIndex = 0;

			
			scoreNum.x += 4 * 6 + scoreNum.width * 18;
			scoreNum.setGraphicSize(Std.int(scoreNum.width * 6));
			scoreNum.updateHitbox();
			scoreGroup.add(scoreNum);
		}

		ringNum = new FlxSprite(300, barY + (2 * 6)).loadGraphic(Paths.image('score'), true, 8, 8);
		ringNum.visible = !isMario;
		ringNum.antialiasing = false;
		ringsText = new FlxSprite(250, barY + (1 * 6)).loadGraphic(Paths.image('sonicUI/sonic2/rings'));
		ringsText.visible = !isMario;
		ringsText.setGraphicSize(Std.int(ringsText.width * 4.3636363636636));
		ringsText.antialiasing = false;
		ringNum.setGraphicSize(Std.int(ringNum.width * 6));
		ringNum.animation.add('idle', [0,1,2,3,4,5 ,6,7,8,9], 0, false);
		ringNum.animation.frameIndex = 2;
		ringsText.screenCenter(X);
		ringsText.x -= 1.5*ringsText.width;
		ringNum.screenCenter(X);
		ringNum.x += 60;
		add(ringsText);
		add(ringNum);

		accuracyText = new FlxText(0, barY, 0, "000000.00%");
		accuracyText.autoSize = false;
		accuracyText.borderSize = 0;
		accuracyText.setFormat(Paths.font("smb1.ttf"), 8, FlxColor.WHITE, LEFT);
		accuracyText.setGraphicSize(Std.int(accuracyText.width * 6));
		accuracyText.scrollFactor.set();
		accuracyText.antialiasing = false;
		add(accuracyText);

		accuracyText2 = new FlxText(0, barY + (1 * 6) + 2, 0, "000000.00%");
		accuracyText2.autoSize = false;
		accuracyText2.borderSize = 0;
		accuracyText2.setFormat(Paths.font("pixel_smaller.ttf"), 5, FlxColor.WHITE, LEFT);
		accuracyText2.setGraphicSize(Std.int(accuracyText2.width * 6));
		accuracyText2.scrollFactor.set();
		accuracyText2.antialiasing = false;
		add(accuracyText2);

		ratingIcon = new FlxSprite(0, 
		barY + (1 * 6)).loadGraphic(Paths.image("rankings"), true, 8, 8);
		ratingIcon.animation.add("icon", [0, 1, 2, 3, 4, 5, 6, 7], 0, false);
		ratingIcon.animation.frameIndex = 0;
		
		ratingIcon.setGraphicSize(Std.int(ratingIcon.width * 6));
		ratingIcon.antialiasing = false;
		add(ratingIcon);

		updateScoreText();
	}

	public function flicker(object:FlxBasic)
	{
		if (object.visible && FlxG.random.bool(3))
		{
			object.visible = false;
		}
		else
		{
			object.visible = true;
		}
	}

	private final divider:String = ' - ';

	public function updateScoreText()
	{
		var importSongScore = PlayState.instance.songScore;
		var scoreText = Std.string(importSongScore);

		///
		var accuracyString:String;
		if(Math.isNaN(PlayState.instance.ratingPercent)) {
			accuracyString = '0.0';
		}else{
		accuracyString = Std.string(Math.floor(PlayState.instance.ratingPercent*100));
		}
		var stringSplit = accuracyString.split(".");
		switch (stringSplit[0].length)
		{
			case 1:
				stringSplit[0] = "00" + stringSplit[0];
			case 2:
				stringSplit[0] = "0" + stringSplit[0];
		}
		if (stringSplit[1].length == 1)
			stringSplit[1] = "0" + stringSplit[1];
		if (stringSplit[1] == null)
			stringSplit[1] = "00";
		accuracyText.text = stringSplit[0];
		accuracyText2.text = "." + stringSplit[1] + '%';
		///

		var isNegative:Bool = false;
		if (scoreText.charAt(0) == "-") 
		{
			scoreText = scoreText.substr(1);
			isNegative = true;
		}

		// lol i'm lazy and don't want to use math for this
		switch (scoreText.length)
		{
			case 1:
				scoreText = "00000" + scoreText;
			case 2:
				scoreText = "0000" + scoreText;
			case 3:
				scoreText = "000" + scoreText;
			case 4:
				scoreText = "00" + scoreText;
			case 5:
				scoreText = "0" + scoreText;
		}

		var index = 0;

		ringNum.animation.frameIndex = PlayState.cccVidaCounter;

		for (scoreNum in scoreGroup)
		{
			scoreNum.animation.frameIndex = Std.parseInt(scoreText.charAt(index));
			scoreNum.color = (isNegative) ? 0xB53120 : 0xFFFFFF;
			index += 1;
		}

		accuracyText.x = FlxG.width - (18 * 16);
		accuracyText2.x = accuracyText.x + (24 * 6);
		ratingIcon.x = accuracyText.x - 180;

		var animselector:Int = 0;

		for (i in 0...scoreIndex.length-1) {
			if(PlayState.instance.ratingPercent*100 < scoreIndex[i][1]) {
				animselector = scoreIndex[i][0];
				break;
			}
		}

		ratingIcon.animation.frameIndex = animselector;
	}
}