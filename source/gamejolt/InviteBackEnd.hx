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
import haxe.Constraints.Function;
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
    var declineBt:FlxButton;
    public var index:Int;
    var canAccept:Bool = false;
    var canDecline:Bool = false;

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
        texto.size = Std.int(Math.max(26, Math.min(10, Math.ceil(300 / texto.text.length))));
        add(texto);

        acceptBt = makeButton(function(){
            if(!canAccept) return;
            acceptBt.alpha = 1;
            GlobalSoundManager.play(scrollMenu);
        }, function(){
            if(!canAccept) return;
            acceptBt.alpha = 0.75;
        }, accept, "menus/gamejolt/acceptBt");
        acceptBt.x = 390;
        acceptBt.y = 7;
        add(acceptBt);

        declineBt = makeButton(function(){
            if(!canDecline) return;
            declineBt.alpha = 1;
            GlobalSoundManager.play(scrollMenu);
        }, function(){
            if(!canDecline) return;
            declineBt.alpha = 0.75;
        }, decline, "menus/gamejolt/declineBt");
        declineBt.x = 317;
        declineBt.y = 7;
        add(declineBt);


        GJClient.getUserAsync(id, this);
    }

    function makeButton(onOver:()->Void, onOut:()->Void, onDown:()->Void, graphic:String):FlxButton
    {
        var bt:FlxButton = new FlxButton(0,0,"",onDown);
        bt.loadGraphic(Paths.image(graphic, 'preload', false));
        bt.onOver.callback=onOver;
        bt.onOut.callback=onOut;
        bt.alpha = 0.75;
        return bt;
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
            canDecline = true;
        }});
        new FlxTimer().start(120, function(twn:FlxTimer){
            canAccept = false;
            canDecline = false;
            acceptBt.alpha = 0.75;
            FlxTween.tween(this, {alpha: 0}, 1.25, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                decline();
            }});
        });
    }

    public function decline()
    {
        if(!canDecline) return;
        canDecline = false;
        canAccept = false;
        MainMenuStateMobile.instance.inviteBackEnd.decline(this);
    }

    public function accept() {
        if(!canAccept) return;
        canAccept = false;
        canDecline = false;
        GlobalSoundManager.play(confirmMenu);
    }
}