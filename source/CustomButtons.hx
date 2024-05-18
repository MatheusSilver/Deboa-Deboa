import ui.FlxButton;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

class MenuButton extends FlxSpriteGroup
{
    public var button_bg:FlxSprite;
    public var lock_icon:FlxSprite;
    public var button_text:FlxText;
    public var isLocked:Bool;


    public function new(bg:String, textRef:String, textFile:String, font:String, locked:Bool = false)
    {
        super();
        
        button_bg = new FlxSprite(0, 0, Paths.image("buttons_base/"+bg, 'preload'));
        button_bg.antialiasing=ClientPrefs.globalAntialiasing;
        add(button_bg);

        button_text = new FlxText(0, 0, button_bg.width, Linguagem.LangUtil.getString(textRef, textFile));
        button_text.setFormat(Linguagem.LangUtil.getFont(font), 44, FlxColor.WHITE, LEFT);
        button_text.antialiasing=ClientPrefs.globalAntialiasing;
        button_text.x = (button_bg.width-button_text.width)/2;
        button_text.y += (button_bg.height-button_text.height)/2;

        add(button_text);

        setLock(locked);
    }

    public function setLock(lock:Bool):Void{
        this.isLocked= lock;
        if (this.isLocked)
            changeLock();
    }

    private function changeLock():Void{
        if (lock_icon==null){
            lock_icon = new FlxSprite(0,0,Paths.image("buttons_base/lock", "preload"));
            lock_icon.alpha = 1;
            lock_icon.visible = true;
            lock_icon.x = (button_bg.width-lock_icon.width)/2-150;
            lock_icon.y = (button_bg.height-lock_icon.height)/2-5;
            lock_icon.antialiasing=false;
            add(lock_icon);
        }

		lock_icon.visible = this.isLocked;
		button_text.alpha = this.isLocked ? 0.5 : 1;
    }
}

class PauseButton extends MenuButton
{
    private final bg:String = "PauseMenu";
    private final textFile:String = "data";

    public function new(textRef:String, font:String)
    {
        super(bg, textRef, textFile, font);
    }

    public function changeState(activated:Bool):Void{
            this.button_text.color = activated ? FlxColor.RED : FlxColor.GRAY;
            this.button_text.alpha = activated ? 1 : 0.7;
    }
}

class CreditButton extends FlxSpriteGroup
{
    private var icon:FlxSprite;
    private var label:FlxText;
    public var isOver:Bool = false;
    public var bg:FlxSprite;

    public function new(bgwidth:Float, icon_image:String, iconPos:String, textRef:String, textColor:String)
    {
        super();
        bg = new FlxSprite(0,0).makeGraphic(Std.int(bgwidth-10),100,Utils.CoolUtil.colorFromString("#380601"), false);
        bg.updateHitbox();
        add(bg);

        var text:FlxText = new FlxText(0,0,bg.width*0.65, Linguagem.LangUtil.getString("cred_"+textRef, "credits", '\n').toUpperCase());
        text.setFormat(Linguagem.LangUtil.getFont("smb"), 34, Utils.CoolUtil.colorFromString(textColor), CENTER);
        text.setPosition((bg.width-text.width)/2,(bg.height-text.height)/2);
        text.solid = false;
        add(text);
        
        
        icon = new FlxSprite(0,0, Paths.image("sobremenu/icons/"+icon_image));
        icon.antialiasing = ClientPrefs.globalAntialiasing;
        icon.setGraphicSize(0, Std.int(bg.height*2));
        icon.solid = false; //Remove a hitbox, pra facilitar, a unica hitbox disso é a do bg.

        icon.y -= 40;
        if (iconPos == "left"){
            icon.x -= 5;
            text.x += 40;
        }else{
            icon.x = bg.width - icon.width/3 - 95;
            text.x -= 45;
        }
        add(icon);
    }
}