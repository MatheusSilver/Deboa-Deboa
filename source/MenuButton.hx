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

        button_text = new FlxText(0, 0, button_bg.width, LangUtil.getString(textRef, textFile));
        button_text.setFormat(LangUtil.getFont(font), 44, FlxColor.WHITE, LEFT);
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
        if (lock_icon!=null){
            lock_icon = new FlxSprite(0,0,Paths.image("buttons_base/lock", "preload"));
            lock_icon.visible = true;
            lock_icon.x = (button_bg.width-lock_icon.width)/2;
            lock_icon.y = (button_bg.height-lock_icon.height)/2;
            lock_icon.antialiasing=false;
            add(lock_icon);
        }else
            lock_icon.visible = this.isLocked;

    }
}

class PauseButton extends MenuButton
{
    private var activated:Bool;

    public function new(bg:String, textRef:String, textFile:String, font:String, activated:Bool)
    {
        super(bg, textRef, textFile, font);
        this.activated = activated;
        this.changeState();
    }

    public function setActive(activated:Bool):Void{
        this.activated = activated;
        this.changeState();
    }

    private function changeState():Void{
        if (activated)
        {
            this.button_text.color = FlxColor.RED;
            this.button_text.alpha = 1;
        }
        else
        {
            this.button_text.color = FlxColor.BLACK;
            this.button_text.alpha = 0.3;
        }
    }
}