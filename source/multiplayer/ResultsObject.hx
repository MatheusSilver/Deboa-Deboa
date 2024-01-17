package multiplayer;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.events.TextEvent;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class ResultsObject extends FlxSpriteGroup
{
    private final sprites_array:Array<String> = ["sick", "good", "bad", "shit"];
 
    private var results_text:FlxTypedSpriteGroup<FlxText>;
    private var results_sprite:FlxTypedSpriteGroup<FlxSprite>;
    private var normal_bottom_text:FlxText;
    private var score_bottom_text:FlxText;
    private var scoreTxt:FlxText;

    public function new(bgcolor:FlxColor, results_array:Array<Int>, accuracy:Float, high_combo:Int, score:Int, ?startReady:Bool = true){
        
        //Bloco de cima
        super();
        var upper_bg:FlxSprite = new FlxSprite(0,0).makeGraphic(Std.int(FlxG.width/2.5), 100, FlxColor.GRAY);
        upper_bg.antialiasing=ClientPrefs.globalAntialiasing;
        add(upper_bg);
        
        scoreTxt = new FlxText(upper_bg.x, 0, upper_bg.width, CoolUtil.formatScore(6, score), 36);
        scoreTxt.setFormat(LangUtil.getFont("smb"), 36, FlxColor.WHITE, RIGHT, OUTLINE_FAST, FlxColor.BLACK);
        if (!startReady) scoreTxt.text = "0000000";
        scoreTxt.updateHitbox();
        scoreTxt.y = upper_bg.y + (upper_bg.height- scoreTxt.height)/2;
        add(scoreTxt);
        
        
        //Bloco de baixo
        var lower_bg:FlxSprite = new FlxSprite(0,upper_bg.x+upper_bg.y+upper_bg.height + 30).makeGraphic(Std.int(upper_bg.width), Std.int(FlxG.height/2), bgcolor);
        lower_bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(lower_bg);


        results_sprite = new FlxTypedSpriteGroup<FlxSprite>();
        add(results_sprite);

        results_text = new FlxTypedSpriteGroup<FlxText>();
        add(results_text);

        for (i in 0...results_array.length){
            var sprite:FlxSprite = new FlxSprite(5 + 0.5*lower_bg.width*i%2, 25 + lower_bg.y + lower_bg.height/4*Std.int(i/2)).loadGraphic(Paths.image(sprites_array[i], "locales", true, true));
            sprite.antialiasing=ClientPrefs.globalAntialiasing;
            sprite.scale.x = sprite.scale.y = 0.35;
            sprite.updateHitbox(); 
            if (!startReady)
                sprite.alpha = 0;
            sprite.ID = i;
            results_sprite.add(sprite);

            var text:FlxText = new FlxText(sprite.x + sprite.width + 15, 0, 0, CoolUtil.formatScore(3, Std.int(results_array[i])), 32);
            if (!startReady)
                text.alpha = 0;
            text.setFormat(LangUtil.getFont('smb'), 20, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
            text.antialiasing=ClientPrefs.globalAntialiasing;
            text.updateHitbox();
            text.y = sprite.y + (sprite.height - text.height)/2;
            text.ID = i + results_array.length;
            results_text.add(text);
        }

        normal_bottom_text = new FlxText(25, lower_bg.height-35, lower_bg.width - 25, LangUtil.getString('play_counter_combo', 'playstate') + "  " + LangUtil.getString('play_counter_accuracy', 'playstate'));
        if (!startReady)
            normal_bottom_text.alpha = 0;
        normal_bottom_text.setFormat(LangUtil.getFont("smb"), 26, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
        add(normal_bottom_text);

        score_bottom_text = new FlxText(normal_bottom_text.x, normal_bottom_text.y+ normal_bottom_text.height + 10, normal_bottom_text.fieldWidth, CoolUtil.formatScore(4, high_combo) + "      " + Math.floor(accuracy * 100) + "%");
        if (!startReady)
            score_bottom_text.alpha = 0;
        score_bottom_text.setFormat(LangUtil.getFont("smb"), 26, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
        add(score_bottom_text);
    }

    private final baseTweenDuration:Float = 0.5; // Duração base da animação
    private final delay:Float = 0.2; // Ajuste conforme necessário

    public function intro_anim(results_array:Array<Int>, score:Int):Void
    {
        FlxTween.num(0, score, baseTweenDuration + score * 0.000005, {ease: FlxEase.linear}, function(v:Float)
        {
            scoreTxt.text = CoolUtil.formatScore(7, Std.int(v));
        });
        FlxTween.tween(score_bottom_text, { alpha:1 }, 0.5);
        FlxTween.tween(normal_bottom_text, { alpha:1 }, 0.5);
        new FlxTimer().start(baseTweenDuration + score * 0.000005, function(tmr:FlxTimer)
            {
                for (i in 0...results_array.length)
                {
                    FlxTween.tween(results_sprite.members[i], { alpha:1 }, 0.5, { startDelay: i * delay });
        
                    FlxTween.tween(results_sprite.members[i].scale, { x: 0.45, y: 0.45 }, 0.2, { startDelay: i * delay, onComplete: function(twn:FlxTween){
                        FlxTween.tween(results_sprite.members[i].scale, { x:0.35, y:0.35}, 0.2);
                        GlobalSoundManager.play("confirm");
                    }});
        
                    FlxTween.tween(results_text.members[i], { alpha:1 }, 0.5, { startDelay: i * delay });
        
                    var tweenDuration:Float = baseTweenDuration + results_array[i] * 0.005;
        
                    FlxTween.num(0, results_array[i], tweenDuration, {ease: FlxEase.linear, startDelay: i * delay + 0.5 }, function(v:Float)
                    {
                        results_text.members[i].text = CoolUtil.formatScore(3, Std.int(v));
                    });
                }
            });
    }
}