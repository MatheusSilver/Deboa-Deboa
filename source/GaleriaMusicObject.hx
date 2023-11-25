package;

import Utils.BSLTouchUtils;
import openfl.display3D.textures.RectangleTexture;
import flixel.util.FlxSpriteUtil.LineStyle;
import openfl.display.CapsStyle;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

using StringTools;

class GaleriaMusicObject extends FlxSpriteGroup
{

    private static var likeStatus:String="neutral";
    public static var likeSprite:FlxSprite;
    public static var dislikeSprite:FlxSprite;
    private static var nome_da_musica:String;

    public function new(file_name:String, show_name:String, currentStatus:String="neutral")
    {
        likeStatus=currentStatus;
        nome_da_musica=show_name;
        super();

        var thumb:FlxSprite;
        var music_name:FlxText;
        var letra_brasileira:FlxText; //Se não fosse a corzinha diferente isso aqui nem existiria

        thumb = new FlxSprite(100,100).loadGraphic(Paths.image("scrolling/artes/scroll-" + file_name + " (scroll)", 'preload'));
        thumb.setGraphicSize(Std.int(thumb.width*0.125));
        thumb.updateHitbox();
        thumb.x = 420;
        thumb.y = FlxG.height - 75;
        thumb.antialiasing=ClientPrefs.globalAntialiasing;
        add(thumb);
        
        music_name = new FlxText(thumb.x + thumb.width + 20, thumb.y + 7, 200, nome_da_musica, 14);
		music_name.setFormat(Paths.font("Roboto-Black.ttf"), 16, 0xffffff, LEFT);
        music_name.antialiasing=ClientPrefs.globalAntialiasing;
		add(music_name);

        letra_brasileira = new FlxText(music_name.x, music_name.y + music_name.height + 3, 200, "Com letra brasileira", 14);
		letra_brasileira.setFormat(Paths.font("Roboto-Regular.ttf"), 16, 0xc6c6c6, LEFT);
        letra_brasileira.antialiasing=ClientPrefs.globalAntialiasing;
		add(letra_brasileira);

        dislikeSprite = new FlxSprite(letra_brasileira.x + letra_brasileira.width + 10, music_name.y + 15).loadGraphic(Paths.image("galeriamusicas/dislike", "preload"), true, 24, 24);
		add_anims(dislikeSprite);
        dislikeSprite.setGraphicSize(Std.int(dislikeSprite.width*1.1));
        dislikeSprite.updateHitbox();
        dislikeSprite.antialiasing=ClientPrefs.globalAntialiasing;
		add(dislikeSprite);

        likeSprite = new FlxSprite(dislikeSprite.x + dislikeSprite.width + 20, music_name.y + 15).loadGraphic(Paths.image("galeriamusicas/like", "preload"), true, 24, 24);
		add_anims(likeSprite);
        likeSprite.setGraphicSize(Std.int(likeSprite.width*1.1));
        likeSprite.updateHitbox();
        likeSprite.antialiasing=ClientPrefs.globalAntialiasing;
		add(likeSprite);

        if (likeStatus!="neutral")
            reloadLikeStatus();

    }

    private static function add_anims(object:FlxSprite){
        object.animation.add("neutral", [0]);
        object.animation.add("over", [1]);
        object.animation.add("hold", [2]);
        object.animation.add("active", [3]);
        object.animation.play("neutral");
    }

    override function update(elapsed:Float){
        anim_updater(dislikeSprite, false);
        anim_updater(likeSprite, true);
    }

    private static function anim_updater(object:FlxSprite, isLike:Bool){
        if (BSLTouchUtils.over(object)){
            if (BSLTouchUtils.pressionando(object)){
                object.animation.play("hold");
            }else if (BSLTouchUtils.solto(object)){
                GlobalSoundManager.play('click');
                if ((isLike && likeStatus=="like") || (!isLike && likeStatus=="dislike"))
                    setStatus("neutral");
                else if(isLike)
                    setStatus("like");
                else
                    setStatus("dislike");
            }else if(!BSLTouchUtils.pressionando(object) && ((isLike && likeStatus!="like") || (!isLike && likeStatus!="dislike"))){
                object.animation.play("over");
            }
        }else
            reloadLikeStatus(); //Talvez isso seja perigoso...
    }

    private static function reloadLikeStatus():Void
    {
        if(likeStatus=="like"){
            likeSprite.animation.play("active", true);
            dislikeSprite.animation.play("neutral", true);
        }else if (likeStatus=="dislike"){
            likeSprite.animation.play("neutral", true);
            dislikeSprite.animation.play("active", true);
        }else{
            likeSprite.animation.play("neutral", true);
            dislikeSprite.animation.play("neutral", true);
        }
    }

    private static function setStatus(status:String):Void
    {
        likeStatus=status;
        ClientPrefs.likesMap.set(nome_da_musica, status);
        ClientPrefs.save();
        reloadLikeStatus();
    }
}