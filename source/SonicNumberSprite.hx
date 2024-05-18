package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class SonicNumberSprite extends FlxSpriteGroup
{
    private var song:String;
    private var hudStyle:String = 'sonic2';
    private var ringsNumbers:Array<SonicNumber> = [];
	private var minNumber:SonicNumber;
	private var scoreNumbers:Array<SonicNumber> = [];
    private var missNumbers:Array<SonicNumber> = [];
	private var vidaNumbers:Array<SonicNumber> = [];
	private var secondNumberA:SonicNumber;
	private var secondNumberB:SonicNumber;
	private var millisecondNumberA:SonicNumber;
	private var millisecondNumberB:SonicNumber;

    public function new(hud:String){
        super();

        this.hudStyle = hud;

        song = PlayState.instance.curSong.toLowerCase();
        
        if (PlayState.sonicHUDStyles.exists(song))
            hudStyle = PlayState.sonicHUDStyles.get(song);
        var hudFolder = hudStyle;
        if (hudStyle == 'soniccd')
            hudFolder = 'sonic1';
        if (song == 'round-a-bout')
        {
            hudStyle = 'sonic3';
            hudFolder = 'sonic3';
        }

        var scoreLabel:FlxSprite = new FlxSprite(15, 25).loadGraphic(Paths.image("sonicUI/" + hudFolder + "/score"));
        scoreLabel.setGraphicSize(Std.int(scoreLabel.width * 3));
        scoreLabel.updateHitbox();
        scoreLabel.x = 15;
        scoreLabel.antialiasing = false;
        scoreLabel.scrollFactor.set();
        add(scoreLabel);

        var timeLabel:FlxSprite = new FlxSprite(15, 70).loadGraphic(Paths.image("sonicUI/" + hudFolder + "/time"));
        timeLabel.setGraphicSize(Std.int(timeLabel.width * 3));
        timeLabel.updateHitbox();
        timeLabel.x = 15;
        timeLabel.antialiasing = false;
        timeLabel.scrollFactor.set();

        add(timeLabel);

        var missLabel:FlxSprite = new FlxSprite(15, 160).loadGraphic(Paths.image("sonicUI/" + hudFolder + "/misses"));
        missLabel.setGraphicSize(Std.int(missLabel.width * 3));
        missLabel.y = 115;
        missLabel.updateHitbox();
        missLabel.x = 15;
        missLabel.antialiasing = false;
        missLabel.scrollFactor.set();
        add(missLabel);

        // score numbers
        if (hudFolder == 'sonic3')
        {
            for (i in 0...7)
            {
                var number = new SonicNumber(0, 0, 0);
                number.folder = hudFolder;
                number.setGraphicSize(Std.int(number.width * 3));
                number.updateHitbox();
                number.x = scoreLabel.x + scoreLabel.width + ((9 * i) * 3);
                number.y = scoreLabel.y;
                scoreNumbers.push(number);
                add(number);
            }
        }
        else
        {
            for (i in 0...7)
            {
                var number = new SonicNumber(0, 0, 0);
                number.folder = hudFolder;
                number.setGraphicSize(Std.int(number.width * 3));
                number.updateHitbox();
                number.x = scoreLabel.x + scoreLabel.width + ((9 * i) * 3);
                number.y = scoreLabel.y;
                scoreNumbers.push(number);
                add(number);
            }
        }

        // miss numbers
        for (i in 0...4)
        {
            var number = new SonicNumber(0, 0, 0);
            number.folder = hudFolder;
            number.setGraphicSize(Std.int(number.width * 3));
            number.updateHitbox();
            number.x = missLabel.x + missLabel.width + (6 * 3) + ((9 * i) * 3);
            number.y = missLabel.y;
            missNumbers.push(number);
            add(number);
        }

        // time numbers
        minNumber = new SonicNumber(0, 0, 0);
        minNumber.folder = hudFolder;
        minNumber.setGraphicSize(Std.int(minNumber.width * 3));
        minNumber.updateHitbox();
        minNumber.x = timeLabel.x + timeLabel.width;
        minNumber.y = timeLabel.y;
        if (song != 'round-a-bout')
        {
            add(minNumber);
        }

        // vida numbers
        for (i in 0...3)
        {
            var number = new SonicNumber(0, 0, 0);
            number.folder = hudFolder;
            number.setGraphicSize(Std.int(number.width * 3));
            number.updateHitbox();
            number.x = timeLabel.x + timeLabel.width + (6 * 3) + ((9 * i) * 3);
            number.y = timeLabel.y;
            vidaNumbers.push(number);
            if (song == 'round-a-bout')
            {
                add(number);
            }
        }

        var percentagesimbol:FlxText;
        percentagesimbol = new FlxText(minNumber.width, 0, 0, "", 44);
        percentagesimbol.text = '%';
        percentagesimbol.setFormat(Paths.font("vcr.ttf"), 44, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        percentagesimbol.updateHitbox();
        percentagesimbol.x = minNumber.x + minNumber.width * 3;
        percentagesimbol.y = minNumber.y - 5;
        percentagesimbol.antialiasing = false;
        percentagesimbol.scrollFactor.set();
        if (song == 'round-a-bout')
        {
            add(percentagesimbol);
        }

        var timeColon:FlxSprite = new FlxSprite(0, 0);
        if (song.toLowerCase() == 'prey')
        { // Silvio bulo pt2 - Isso é pra corrigir um bug em needlemouse e YCR, possivelmente CY tambem
            timeColon.loadGraphic(Paths.image("sonicUI/" + hudFolder + "/quote2"));
        }
        else
        {
            timeColon.loadGraphic(Paths.image("sonicUI/" + hudFolder + "/colon"));
        }
        timeColon.setGraphicSize(Std.int(timeColon.width * 3));
        timeColon.updateHitbox();
        timeColon.x = 170;
        timeColon.y = timeLabel.y;
        timeColon.antialiasing = false;
        timeColon.scrollFactor.set();
        if (song == 'prey' || song == 'you-cant-run')
        {
            add(timeColon);
        }

        secondNumberA = new SonicNumber(0, 0, 0);
        secondNumberA.folder = hudFolder;
        secondNumberA.setGraphicSize(Std.int(secondNumberA.width * 3));
        secondNumberA.updateHitbox();
        secondNumberA.x = 186;
        secondNumberA.y = timeLabel.y;
        if (song == 'prey' || song == 'you-cant-run')
        {
            add(secondNumberA);
        }

        secondNumberB = new SonicNumber(0, 0, 0);
        secondNumberB.folder = hudFolder;
        secondNumberB.setGraphicSize(Std.int(secondNumberB.width * 3));
        secondNumberB.updateHitbox();
        secondNumberB.x = 213;
        secondNumberB.y = timeLabel.y;
        if (song == 'prey' || song == 'you-cant-run')
        {
            add(secondNumberB);
        }

        var timeQuote:FlxSprite = new FlxSprite(0, 0);
        if (hudFolder == 'sonic1')
        {
            timeQuote.loadGraphic(Paths.image("sonicUI/" + hudFolder + "/quote"));
            timeQuote.setGraphicSize(Std.int(timeQuote.width * 3));
            timeQuote.updateHitbox();
            timeQuote.x = secondNumberB.x + secondNumberB.width;
            timeQuote.y = timeLabel.y;
            timeQuote.antialiasing = false;
            timeQuote.scrollFactor.set();
            add(timeQuote);

            millisecondNumberA = new SonicNumber(0, 0, 0);
            millisecondNumberA.folder = hudFolder;
            millisecondNumberA.setGraphicSize(Std.int(millisecondNumberA.width * 3));
            millisecondNumberA.updateHitbox();
            millisecondNumberA.x = timeQuote.x + timeQuote.width + (2 * 3);
            millisecondNumberA.y = timeLabel.y;
            add(millisecondNumberA);

            millisecondNumberB = new SonicNumber(0, 0, 0);
            millisecondNumberB.folder = hudFolder;
            millisecondNumberB.setGraphicSize(Std.int(millisecondNumberB.width * 3));
            millisecondNumberB.updateHitbox();
            millisecondNumberB.x = millisecondNumberA.x + millisecondNumberA.width + 3;
            millisecondNumberB.y = timeLabel.y;
            add(millisecondNumberB);
        }

        switch (hudFolder)
        {
            case 'sonic2':
                minNumber.x = timeLabel.x + timeLabel.width + (4 * 3);
                timeColon.x = minNumber.x + minNumber.width + (2 * 3);
                secondNumberA.x = timeColon.x + timeColon.width + (4 * 3);
                secondNumberB.x = secondNumberA.x + secondNumberA.width + 3;
            case 'sonic3':
                minNumber.x = timeLabel.x + timeLabel.width + (4 * 3);
            default:
        }

        if (!ClientPrefs.downScroll && song != 'round-a-bout')
        {
            for (member in this.members)
            {
                member.y = FlxG.height - member.height - member.y;
            }
        }

        if (song == 'prey' || song == 'round-a-bout')
        {
            PlayState.instance.scoreTxt.visible = false;
            PlayState.instance.timeBar.visible = false;
            if (song == 'round-a-bout')
            {
                PlayState.instance.timeTxt.x = FlxG.width - PlayState.instance.timeTxt.width + 100;
            }
            if (hudFolder != 'sonic3')
            {
                PlayState.instance.timeTxt.visible = false;
            }
            else
            {
                PlayState.instance.healthBar.visible = false;
                PlayState.instance.healthBarBG.visible = false;
                PlayState.instance.iconP1.visible = false;
                PlayState.instance.iconP2.visible = false;
            }
            PlayState.instance.timeBarBG.visible = false;
            PlayState.instance.judgementCounter.visible = false;
        }
        else if (song == 'you-cant-run')
        {
            this.visible= false;
        }
    }

    override function update(elapsed:Float){
        var minutesRemaining:Int = Math.floor(PlayState.instance.secondsTotal / 60);
        var secondsRemaining:String = '' + PlayState.instance.secondsTotal % 60;

        if (secondsRemaining.length < 2)
            secondsRemaining = '0' + secondsRemaining; // Dunno how to make it display a zero first in Haxe lol

        PlayState.instance.timeTxt.text = minutesRemaining + ':' + secondsRemaining;

        var curMS:Float = Math.floor(Song.Conductor.songPosition - ClientPrefs.noteOffset);
        var curSex:Int = Math.floor(curMS / 1000);
        if (curSex < 0)
            curSex = 0;

        var curMins = Math.floor(curSex / 60);
        curMS %= 1000;
        curSex %= 60;

        if (song == 'prey' || song == 'you-cant-run')
        {
            minNumber.number = curMins;
        }
        var sepSex = Std.string(curSex).split("");
        if (curSex < 10)
        {
            secondNumberA.number = 0;
            secondNumberB.number = curSex;
        }
        else
        {
            secondNumberA.number = Std.parseInt(sepSex[0]);
            secondNumberB.number = Std.parseInt(sepSex[1]);
        }
        if (millisecondNumberA != null && millisecondNumberB != null)
        {
            curMS = Math.round(curMS / 10);
            if (curMS < 10)
            {
                millisecondNumberA.number = 0;
                millisecondNumberB.number = Math.floor(curMS);
            }
            else
            {
                var sepMSex = Std.string(curMS).split("");
                millisecondNumberA.number = Std.parseInt(sepMSex[0]);
                millisecondNumberB.number = Std.parseInt(sepMSex[1]);
            }
        }

        updateSonicScore();
        updateSonicMisses();
        updateSonicVida();
    }

    private function updateSonicScore()
	{
		var seperatedScore:Array<String> = Std.string(PlayState.instance.songScore).split("");
		if (seperatedScore.length < scoreNumbers.length)
		{
			for (idx in seperatedScore.length...scoreNumbers.length)
			{
				if (hudStyle == 'chaotix' || hudStyle == 'sonic2' || hudStyle == 'soniccd' || hudStyle == 'sonic3')
				{
					seperatedScore.unshift('');
				}
				else
				{
					seperatedScore.unshift('0');
				}
			}
		}
		if (seperatedScore.length > scoreNumbers.length)
			seperatedScore.resize(scoreNumbers.length);

		for (idx in 0...seperatedScore.length)
		{
			if (seperatedScore[idx] != '' || idx == scoreNumbers.length - 1)
			{
				var val = Std.parseInt(seperatedScore[idx]);
				if (Math.isNaN(val))
					val = 0;
				scoreNumbers[idx].number = val;
				scoreNumbers[idx].visible = true;
			}
			else
				scoreNumbers[idx].visible = false;
		}
	}

	private function updateSonicMisses()
	{
		var seperatedScore:Array<String> = Std.string(PlayState.instance.songMisses).split("");
		if (seperatedScore.length < missNumbers.length)
		{
			for (idx in seperatedScore.length...missNumbers.length)
			{
				if (hudStyle == 'chaotix' || hudStyle == 'sonic2' || hudStyle == 'soniccd' || hudStyle == 'sonic3')
				{
					seperatedScore.unshift('');
				}
				else
				{
					seperatedScore.unshift('0');
				}
			}
		}
		if (seperatedScore.length > missNumbers.length)
			seperatedScore.resize(missNumbers.length);

		for (idx in 0...seperatedScore.length)
		{
			if (seperatedScore[idx] != '' || idx == missNumbers.length - 1)
			{
				var val = Std.parseInt(seperatedScore[idx]);
				if (Math.isNaN(val))
					val = 0;
				missNumbers[idx].number = val;
				missNumbers[idx].visible = true;
			}
			else
				missNumbers[idx].visible = false;
		}
	}

	private function updateSonicVida()
	{
		var seperatedScore:Array<String> = Std.string(Std.int(health * 50))
			.split(""); // Quando você entender o motivo de ser 50 e não 100... Meu amigo... tu vai curtir muito.
		if (seperatedScore.length < vidaNumbers.length)
		{
			if (hudStyle == 'chaotix' || hudStyle == 'sonic2' || hudStyle == 'soniccd' || hudStyle == 'sonic3')
			{
				seperatedScore.unshift('');
			}
			else
			{
				seperatedScore.unshift('0');
			}
		}
		if (seperatedScore.length > vidaNumbers.length)
			seperatedScore.resize(vidaNumbers.length);

		for (idx in 0...seperatedScore.length)
		{
			if (seperatedScore[idx] != '' || idx == vidaNumbers.length - 1)
			{
				var val = Std.parseInt(seperatedScore[idx]);
				if (Math.isNaN(val))
					val = 0;
				vidaNumbers[idx].number = val;
				vidaNumbers[idx].visible = true;
			}
			else
				vidaNumbers[idx].visible = false;
		}
	}
}