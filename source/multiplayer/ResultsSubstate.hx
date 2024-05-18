package multiplayer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class ResultsSubstate extends MusicBeatSubstate
{
    public static var opp_name:String = "";
    public static var opp_data:Array<Int> = [];
    public static var opp_accuracy:Int;
    public static var opp_high_combo:Int;
    public static var opp_score:Int;

    var opp_box:ResultsObject;
    var player_box:ResultsObject;

    public function new(player_results:Array<Int>, player_accuracy:Float, player_high_combo:Int, player_score:Int, player_name:String)
    {
        var black_overlay:FlxSprite = new FlxSprite(0,0).makeGraphic(1,1, FlxColor.BLACK);
        black_overlay.setGraphicSize(FlxG.width, FlxG.height);
        black_overlay.alpha = 0.3;

        var upper_black:FlxSprite = new FlxSprite(0,0).makeGraphic(1,1,FlxColor.BLACK);
        upper_black.setGraphicSize(FlxG.width*3, 150);
        upper_black.antialiasing = ClientPrefs.globalAntialiasing;

        
        var song_name:FlxText = new FlxText(0,0,0,Utils.CoolUtil.capitalize(PlayState.SONG.song), 32);
        song_name.setFormat(Linguagem.LangUtil.getFont("smb"), 24, FlxColor.WHITE, LEFT);

        var diff_text:FlxText = new FlxText(0,song_name.y+song_name.height + 5, 0, "hard", 32);
        diff_text.setFormat(Linguagem.LangUtil.getFont("smb"), 20, FlxColor.RED, LEFT);

        opp_box = new ResultsObject(FlxColor.RED, [1,2,3,4], 0.5, 10, 100, true);
        opp_box.y = (FlxG.height-opp_box.height)/2+50;
        opp_box.x = FlxG.width - opp_box.width;
        
        player_box = new ResultsObject(FlxColor.BLUE, [1,2,3,4], 0.5, 10, 100, false);
        player_box.y = opp_box.y;
        player_box.x = 0;

        var opp_name:FlxText = new FlxText(opp_box.x, opp_box.y-40, opp_box.width, opp_name, 24);
        opp_name.setFormat(Linguagem.LangUtil.getFont("vio"), 26, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        
        var player_name:FlxText = new FlxText(player_box.x, player_box.y-40, player_box.width, player_name, 24);
        player_name.setFormat(Linguagem.LangUtil.getFont("vio"), 26, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);



        super();
        
        add(black_overlay);
        add(upper_black);
        add(song_name);
        add(diff_text);

        add(opp_box);
        add(opp_name);
        add(player_box);
        add(player_name);

        player_box.intro_anim([1,2,3,4], 100);

    }
}