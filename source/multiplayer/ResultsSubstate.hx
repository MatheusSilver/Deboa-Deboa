package multiplayer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class ResultsSubstate extends FlxSpriteGroup
{
    var opp_box:ResultsObject;
    var player_box:ResultsObject;

    public function new(myProperties:PlayerProperties, oppProperties:PlayerProperties, amPlayer1:Bool)
    {
        super(x,y);

        var black_overlay:FlxSprite = new FlxSprite(0,0).makeGraphic(1,1, FlxColor.BLACK);
        black_overlay.setGraphicSize(FlxG.width, FlxG.height);
        black_overlay.alpha = 0.3;

        var upper_black:FlxSprite = new FlxSprite(0,0).makeGraphic(1,1,FlxColor.BLACK);
        upper_black.setGraphicSize(FlxG.width*3, 150);
        upper_black.antialiasing = ClientPrefs.globalAntialiasing;

        
        var song_name:FlxText = new FlxText(0,0,0,CoolUtil.capitalize(PlayState.SONG.song), 32);
        song_name.setFormat(Linguagem.LangUtil.getFont("smb"), 24, FlxColor.WHITE, LEFT);

        var diff_text:FlxText = new FlxText(0,song_name.y+song_name.height + 5, 0, "hard", 32);
        diff_text.setFormat(Linguagem.LangUtil.getFont("smb"), 20, FlxColor.RED, LEFT);

        opp_box = new ResultsObject(FlxColor.RED, oppProperties.results, oppProperties.accuracy, oppProperties.high_combo, oppProperties.score, true);
        opp_box.y = (FlxG.height-opp_box.height)/2+50;
        opp_box.x = !amPlayer1 ? FlxG.width - opp_box.width : 0;
        
        player_box = new ResultsObject(FlxColor.BLUE, myProperties.results, myProperties.accuracy, myProperties.high_combo, myProperties.score, false);
        player_box.y = opp_box.y;
        player_box.x = !amPlayer1 ? 0 : FlxG.width - opp_box.width;

        var opp_name:FlxText = new FlxText(opp_box.x, opp_box.y-40, opp_box.width, oppProperties.name, 24);
        opp_name.setFormat(Linguagem.LangUtil.getFont("vio"), 26, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        
        var player_name:FlxText = new FlxText(player_box.x, player_box.y-40, player_box.width, myProperties.name, 24);
        player_name.setFormat(Linguagem.LangUtil.getFont("vio"), 26, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);



        
        add(black_overlay);
        add(upper_black);
        add(song_name);
        add(diff_text);

        add(opp_box);
        add(opp_name);
        add(player_box);
        add(player_name);

        player_box.intro_anim(myProperties.results, myProperties.score);

    }
}

class PlayerProperties {
    public var results:Array<Int>;
    public var accuracy:Float;
    public var high_combo:Int;
    public var score:Int;
    public var name:String;

    public function new(name:String, score:Int, high_combo:Int, accuracy:Float, results:Array<Int>) {
        this.name = name;
        this.score = score;
        this.high_combo = high_combo;
        this.accuracy = accuracy;
        this.results = results;
    }
}