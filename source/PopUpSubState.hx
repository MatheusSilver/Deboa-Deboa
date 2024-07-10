package;

import GlobalSoundManager.Sounds;
import flixel.util.FlxColor;
import Linguagem.LangUtil;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.tweens.FlxTween;
import flixel.FlxG;

class PopUpSubState extends MusicBeatSubstate {

    private var background:FlxSprite;
    private var popupBG:FlxSprite;
    private var okButton:FlxButton;
    private var titleText:FlxText;
    private var contentText:FlxText;
    private var inAnimation:Bool = true;
    public function new(titleID:String, contentID:String, ?camera:FlxCamera, ?callback:() -> Void, ?yValue:Float = 150, ?otherFont:Bool = false, ?skipAnim:Bool = false) {
        super();

        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        background.alpha = 0;
        if(camera != null) background.cameras = [camera];
        background.updateHitbox();
        background.setPosition();
        background.screenCenter(XY);
        add(background);

        popupBG = new FlxSprite().loadGraphic(Paths.image("menus/POPUP_BG", "preload"));
        popupBG.setPosition();
        if(camera != null) popupBG.cameras = [camera];
        popupBG.updateHitbox();
        popupBG.screenCenter(XY);
        add(popupBG);

        okButton = new FlxButton(function(){
            if(callback!=null){
                callback();
            }
            onClick();
        });
        okButton.loadGraphic(Paths.image("mainmenu/btokPOPUP", "preload"));
        if(camera != null) okButton.cameras = [camera];
        okButton.setGraphicSize(Std.int(okButton.width*0.99)); //Aquele um por cento é
        okButton.updateHitbox();
        okButton.setPosition(popupBG.x + popupBG.width/2-okButton.width/2+2, popupBG.y + popupBG.height*0.88); //O y de fato tem que calculo com constantes
        add(okButton);

        // Create texts
        titleText = new FlxText(popupBG.x + popupBG.width/2-2, popupBG.y + popupBG.height*0.08, popupBG.width*0.612, LangUtil.getString('title_${titleID}', "popupTitles", "\n"));
        titleText.x -= titleText.width/2;
        if(camera != null) titleText.cameras = [camera];
        titleText.y -= titleText.height;
        titleText.setFormat(LangUtil.getFont("sonic-3"), 26, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
        titleText.alpha = 0;
        add(titleText);

        contentText = new FlxText(popupBG.x + 17, titleText.y + yValue, popupBG.width*0.95, LangUtil.getString('desc_${contentID}', "popupDescs", otherFont?"\n":"\n\n"));
        contentText.setFormat(LangUtil.getFont(otherFont ? "sonic-1" : "sonic-3"), otherFont ? 30 : 20, FlxColor.WHITE, "center", FlxTextBorderStyle.NONE);
        if(camera != null) contentText.cameras = [camera];
        contentText.alpha = 0;
        add(contentText);

        showPopup(skipAnim);
    }

    private function onClick():Void {
        if (inAnimation) return;
        hidePopup();
        GlobalSoundManager.play(Sounds.confirmMenu);
    }

    public function hidePopup():Void {
        inAnimation = true;
        // Tween background alpha to 0.25
        FlxTween.tween(background, {alpha: 0}, 1);

        // Tween popup, texts, and button alpha to 1
        FlxTween.tween(popupBG, {alpha: 0}, 1);
        FlxTween.tween(okButton, {alpha: 0}, 1);
        FlxTween.tween(titleText, {alpha: 0}, 1);
        FlxTween.tween(contentText, {alpha: 0}, 1, {onComplete: function (twn:FlxTween){
            inAnimation = false;
            closeSubState();
        }});
    }

    public function showPopup(skipAnim:Bool):Void {
        inAnimation = true;
        
        if(skipAnim) {
            background.alpha = 0.25;
            popupBG.alpha = 1;
            okButton.alpha = 1;
            titleText.alpha = 1;
            contentText.alpha = 1;
            inAnimation = false;
            return;
        }

        // Tween background alpha to 0.25
        FlxTween.tween(background, {alpha: 0.25}, 0.5);

        // Tween popup, texts, and button alpha to 1
        FlxTween.tween(popupBG, {alpha: 1}, 0.5);
        FlxTween.tween(okButton, {alpha: 1}, 0.5);
        FlxTween.tween(titleText, {alpha: 1}, 0.5);
        FlxTween.tween(contentText, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween){
            inAnimation = false;
        }});
    }
}
