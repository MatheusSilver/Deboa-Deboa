package gamejolt;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class InviteBackEnd
{
    var curInvites:Array<InviteObject> = [];
    var parentState:FlxState;

    public function new(parent:FlxState)
    {
        this.parentState = parent;
        GJClient.getDesafios(spawnarInvite);
        new FlxTimer().start(10, function(e:FlxTimer) {
            GJClient.getDesafios(spawnarInvite);
        }, 0);
    }

    function spawnarInvite()
    {
        //trace(GJClient.invites);
        GJClient.canChangeInvites = false;
        for(invite in GJClient.invites)
        {
            if(invite != "" && invite != null && invite != "null")
            {
                var newInvite:InviteObject = new InviteObject(-500, 0, Std.parseInt(invite), curInvites.length);
                curInvites.push(newInvite);
                newInvite.cameras = [Reflect.getProperty(parentState, "camAchievement")];
                parentState.add(newInvite);
            }
            GJClient.removeInvite(invite);
        }
        GJClient.invites = [];
        new FlxTimer().start(2.5, function(e:FlxTimer) {
            GJClient.canChangeInvites = true;
        });
        //trace(curInvites.length);
    }

    public function decline(which:InviteObject)
    {
        parentState.remove(which);
        curInvites.remove(which);
        which.destroy();

        for(i in 0...curInvites.length)
        {
            curInvites[i].index = i;
            curInvites[i].updatePos(true);
        }
    }
}

class InviteObject extends FlxSpriteGroup
{
    var user:User;
    var texto:FlxText;
    var bg:FlxSprite;
    var acceptBt:FlxButton;
    public var index:Int;
    var canAccept:Bool = false;

    public function new(x, y, id:Int, index:Int)
    {
        super(x, y);
        this.index = index;
        updatePos();
        bg = new FlxSprite(0,0).loadGraphic(Paths.image("menus/gamejolt/userBG", 'preload', false));
        bg.x=-36;
        add(bg);
        texto = new FlxText(10,20,464,"",30);
        texto.setFormat(Paths.font("letravio.ttf"), 30, FlxColor.WHITE, LEFT);
        texto.size = Std.int(Math.max(30, Math.min(10, Math.ceil(350 / texto.text.length))));
        add(texto);

        acceptBt = new FlxButton(0,0,"",accept);
        acceptBt.loadGraphic(Paths.image("menus/gamejolt/acceptBt", "preload", false));
        acceptBt.onOver.callback=function(){
            if(!canAccept) return;
            acceptBt.alpha = 1;
            GlobalSoundManager.play(scrollMenu);
        }
        acceptBt.onOut.callback=function(){
            if(!canAccept) return;
            acceptBt.alpha = 0.75;
        }
        acceptBt.alpha = 0.75;
        acceptBt.x = 390;
        acceptBt.y = 7;
        add(acceptBt);

        GJClient.getUserAsync(id, this);
    }

    public function setInfo(usuario:User)
    {
        user = usuario;
        texto.text = '${user.username} está te desafiando!';
        aparecer();
    }

    public function updatePos(?smooth:Bool = false)
    {
        if(smooth)
        {
            FlxTween.tween(this, {y: 600-(90*(index))}, 0.2, {ease: FlxEase.linear});
        }
        else
        {
            this.y = 600-(90*(index));
        }
    }

    public function aparecer()
    {
		GlobalSoundManager.play(confirmMenu);
        FlxTween.tween(this, {x: 0}, 1.25, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween){
            canAccept = true;
        }});
        new FlxTimer().start(10, function(twn:FlxTimer){
            canAccept = false;
            acceptBt.alpha = 0.75;
            FlxTween.tween(this, {alpha: 0}, 1.25, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                decline();
            }});
        });
    }

    public function decline()
    {
        MainMenuStateMobile.instance.inviteBackEnd.decline(this);
    }

    public function accept() {
        if(!canAccept) return;
        canAccept = false;
        GlobalSoundManager.play(confirmMenu);
    }
}