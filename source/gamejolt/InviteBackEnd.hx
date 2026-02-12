package gamejolt;

import flixel.FlxSubState;
import openfl.display.DisplayObject;
import multiplayer.MultiplayerMainMenuState;
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
import flixel.FlxCamera;
import flixel.group.FlxGroup;

class InviteBackEnd extends FlxGroup
{
    public static var curInvites:Array<InviteObject> = [];
    public static var canSpawn = true;
    public static var instance:InviteBackEnd;
    public static var timer:FlxTimer;
    public static var cam:FlxCamera;

    public static function init()
    {
        instance = new InviteBackEnd();
    }

    public function new()
    {
        super();

        instance = this;
        cam = new FlxCamera();
        cam.bgColor.alpha = 0;
        FlxG.cameras.add(cam, false);
        GJClient.getDesafios(spawnarInvite);
        reInit();
        FlxG.game.onSwitchState=function(invites:Array<InviteObject>) {
            curInvites = invites;
            for(invite in invites)
            {
                invite.redraw();
            }
        };
    }

    public static function reInit()
    {
        if(timer!= null){timer.cancel();}
        if(!CoolUtil.checkPlayState()){GJClient.getDesafios(spawnarInvite);}
        timer = new FlxTimer().start(5, function(e:FlxTimer) {
            if(CoolUtil.checkPlayState()) return;
            GJClient.getDesafios(spawnarInvite);
        }, 0);
    }

    static function spawnarInvite(?result:Null<Dynamic>)
    {
        if(!canSpawn) return;
        if(CoolUtil.checkPlayState()) return;
        if(cam==null) return;
        //trace(GJClient.invites);
        GJClient.canChangeInvites = false;
        for(invite in GJClient.invites)
        {
            if(invite != "" && invite != null && invite != "null")
            {
                var newInvite:InviteObject = new InviteObject(-500, 0, Std.parseInt(invite), curInvites.length);
                curInvites.push(newInvite);
                newInvite.cameras = [cam];
                FlxG.state.add(newInvite);
                trace("spawning invite");
            }
            GJClient.removeInvite(invite);
        }
        GJClient.invites = [];
        new FlxTimer().start(2.5, function(e:FlxTimer) {
            GJClient.canChangeInvites = true;
        });
        for(i in 0...curInvites.length)
            {
                curInvites[i].index = i;
                curInvites[i].updatePos(true);
            }
        //trace(curInvites.length);
    }

    public function decline(which:InviteObject)
    {
        if(which != null)
        {
            canSpawn = false;
            curInvites.remove(which);
            FlxTween.tween(which, {x: -500}, 0.3, {ease: FlxEase.expoInOut, onComplete: function(e:FlxTween) {
                FlxG.state.remove(which);
                which.destroy();
            }});
        }

        new FlxTimer().start(0.25, function(e:FlxTimer) {
            for(i in 0...curInvites.length)
                {
                    curInvites[i].index = i;
                    curInvites[i].updatePos(true);
                }
            canSpawn = true;
        });

    }

    public function sumidao(which:InviteObject)
    {
        canSpawn=false;
        for(invite in curInvites)
        {
            invite.canAccept = false;
            invite.canDecline = false;
            if(invite == which)
            {
                FlxTween.tween(invite, {alpha: 0}, 0.25, {ease: FlxEase.expoInOut, startDelay: 0.6, onComplete: function(e:FlxTween) {
                    canSpawn = true;
                    if(FlxG.state!=null)
                    {
                        FlxG.state.remove(invite);
                    }
                    invite.destroy();
                }});
                
            }
            else
            {
                decline(invite);
            }
        }
    }
}

class InviteObject extends FlxSpriteGroup
{
    public var user:User;
    var texto:FlxText;
    var bg:FlxSprite;
    var acceptBt:FlxButton;
    var declineBt:FlxButton;
    public var index:Int;
    public var canAccept:Bool = false;
    public var canDecline:Bool = false;
    public var timeLeft:Float;

    public function new(x, y, id:Int, index:Int, ?user:User = null)
    {
        super(x, y);
        this.index = index;
        updatePos();
        bg = new FlxSprite(0,0).loadGraphic(Paths.image("menus/gamejolt/userBG", 'preload', false));
        bg.x=-36;
        add(bg);
        texto = new FlxText(10,25,464,"",30);
        texto.setFormat(Paths.font("letravio.ttf"), 30, FlxColor.WHITE, LEFT);
        texto.size = Std.int(Math.max(26, Math.min(10, Math.ceil(300 / texto.text.length))));
        add(texto);

        acceptBt = makeButton(function(){
            if(FlxG.state!=null){
                if(FlxG.state.subState!=null)
                {
                    return;
                }
            }
            if(!canAccept) return;
            acceptBt.alpha = 1;
            GlobalSoundManager.play(scrollMenu);
        }, function(){
            if(FlxG.state!=null){
                if(FlxG.state.subState!=null)
                {
                    return;
                }
            }
            if(!canAccept) return;
            acceptBt.alpha = 0.75;
        }, accept, "menus/gamejolt/acceptBt");
        acceptBt.x = 390;
        acceptBt.y = 7;
        add(acceptBt);

        declineBt = makeButton(function(){
            if(FlxG.state!=null){
                if(FlxG.state.subState!=null)
                {
                    return;
                }
            }
            if(!canDecline) return;
            declineBt.alpha = 1;
            GlobalSoundManager.play(scrollMenu);
        }, function(){
            if(FlxG.state!=null){
                if(FlxG.state.subState!=null)
                {
                    return;
                }
            }
            if(!canDecline) return;
            declineBt.alpha = 0.75;
        }, function(){decline(false);}, "menus/gamejolt/declineBt");
        declineBt.x = 317;
        declineBt.y = 7;
        add(declineBt);

        if(user != null) {
            this.x=0;
            canAccept = true;
            canDecline = true;
            return;
        }
        GJClient.getUserAsync(id, this);
    }
    
    function resetar()
    {
        declineBt.x = 317;
        declineBt.y = 7;
        acceptBt.x = 390;
        acceptBt.y = 7;
        bg.x=-36;
        texto.x=10;
        texto.y=25;
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

    public function redraw()
    {
        if(InviteBackEnd.cam==null) return;
        this.cameras = [InviteBackEnd.cam];
        //resetar();
    }

    public function setInfo(usuario:User, ?jaTinha:Bool = false)
    {
        user = usuario;
        texto.text = '${user.username} ${Linguagem.LangUtil.getString("menu_friends_invite_request", "menu")}';
        if(jaTinha)
            return;
        aparecer();
    }

    public function updatePos(?smooth:Bool = false)
    {
        if(smooth)
        {
            FlxTween.tween(this, {y: (600-(90*(index)))}, 0.2, {ease: FlxEase.linear});
        }
        else
        {
            this.y = (600-(90*(index)));
        }
    }

    public function aparecer()
    {
		GlobalSoundManager.play(confirmMenu);
        FlxTween.tween(this, {x: 0}, 1.25, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween){
            canAccept = true;
            canDecline = true;
        }});
        /*new FlxTimer().start(120, function(twn:FlxTimer){
            canAccept = false;
            canDecline = false;
            acceptBt.alpha = 0.75;
            FlxTween.tween(this, {x: -500}, 1, {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween){
                decline(true);
            }});
        });*/
    }

    public function decline(?force:Bool = false)
    {
        if(!canDecline && !force) return;
        if(FlxG.state!=null){
            if(FlxG.state.subState!=null)
            {
                return;
            }
        }
        canDecline = false;
        canAccept = false;
        GlobalSoundManager.play(confirmMenu);
        InviteBackEnd.instance.decline(this);
    }

    public function accept() {
        if(!canAccept) return;
        if(CoolUtil.checkPlayState()) return;
        if(FlxG.state!=null){
            if(FlxG.state.subState!=null)
            {
                return;
            }
        }
        canAccept = false;
        canDecline = false;
        InviteBackEnd.instance.sumidao(this);
        GlobalSoundManager.play(confirmMenu);
        new FlxTimer().start(1.25, function(twn:FlxTimer){
            //InviteBackEnd.instance.decline(this);
            var multiplayerState:MultiplayerMainMenuState = new MultiplayerMainMenuState();
            multiplayerState.aceitarConvite(Std.string(user.id), false);
            MusicBeatState.switchState(multiplayerState);
        });
    }
}