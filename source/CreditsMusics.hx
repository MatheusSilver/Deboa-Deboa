package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;
#if rpc
import Discord.DiscordClient;
#end

class CreditsMusics extends MusicBeatState
{
	//var letext:FlxText;
	var bg:FlxSprite;
	//var faixa:FlxSprite;
    //var exe:FlxSprite;
	var curSelected:Int=0;
    var curSelectedBkp:Int=0;
    var canChange:Bool=false;
    var newcredit:FlxSprite;
    var newcredit1:FlxSprite;
    var dummycredit:FlxSprite;
    var dummycredit1:FlxSprite;
    var dummycredit2:FlxSprite;

    var creditStuff:Array<String> = ['mars', 'penkaru', 'saster', 'solunary', 'spookawaii', 'teles', 'ankinluu', 'apartygoer', 'c52278', 'd4rksp1ne20', 'ehtmareiner', 'jark1412', 'kanihuman', 'panchonatorr', 'phantasmpixel', 'pikatio', 'soufon', 'shadowmario'];
	
	override function create()
		{
			FlxG.mouse.visible = false;
			#if rpc
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo os créditos", null);
			#end
			/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
			add(bg);*/

            
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
            bg.y=-720;
			add(bg);

            dummycredit = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelectedBkp]+')'));
            dummycredit.antialiasing = ClientPrefs.globalAntialiasing;
            dummycredit.alpha=0;
            dummycredit.y=25;
            dummycredit1 = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelectedBkp+1]+')'));
            dummycredit1.antialiasing = ClientPrefs.globalAntialiasing;
            dummycredit1.alpha=0;
            dummycredit1.y=25;
            dummycredit2 = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected+1]+')'));
            dummycredit2.antialiasing = ClientPrefs.globalAntialiasing;
            dummycredit2.alpha=0;
            dummycredit2.y=25;
            newcredit = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected]+')'));
            newcredit.antialiasing = ClientPrefs.globalAntialiasing;
            //newcredit.setGraphicSize(Std.int(0.8));
            newcredit.alpha=1;
            //newcredit.x=525;
            newcredit.x=-279;
            newcredit.y=724;
            add(newcredit);

            newcredit1 = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected+1]+')'));
            newcredit1.antialiasing = ClientPrefs.globalAntialiasing;
            //newcredit.setGraphicSize(Std.int(0.8));
            newcredit1.alpha=1;
            //newcredit.x=525;
            newcredit1.x=274;
            newcredit1.y=724;
            add(newcredit1);
            add(dummycredit);
            add(dummycredit1);
            add(dummycredit2);
            FlxTween.tween(bg, {y: 0}, 1, {ease: FlxEase.quartInOut});
            FlxTween.tween(newcredit, {y: 25}, 0.5, {ease: FlxEase.quartInOut, startDelay: 1});
            FlxTween.tween(newcredit1, {y: 25}, 0.6, {ease: FlxEase.quartInOut, startDelay: 1});

            new FlxTimer().start(1.65, function(tmr:FlxTimer){
                canChange=true;
            });


			#if mobileC
			addVirtualPad(LEFT_RIGHT, A_B);
			#end
			super.create();
		}
	override function update(elapsed:Float)
		{
            if (controls.BACK) {
                GlobalSoundManager.play('cancelMenu');
                MusicBeatState.switchState(new SobreState());
            }

			if(controls.UI_RIGHT_P || controls.UI_LEFT_P) { //ok
                if(canChange)
                    {
                        if(curSelected+1 > creditStuff.length-1)
                            {
                                curSelectedBkp=curSelected;
                                curSelected=0;
                                changeSelection(curSelected);
                            }
                        else
                            {
                                curSelectedBkp=curSelected;
                                curSelected=curSelected+1; 
                                changeSelection(curSelected);
                            }
                        canChange=false;
                        GlobalSoundManager.play('scrollMenu');
                    }
			}

            /*if(controls.UI_LEFT_P) { //ok
                if(canChange)
                    {
                        if(curSelected-1 < 0)
                            {
                                curSelectedBkp=curSelected;
                                curSelected=creditStuff.length-1;
                                changeSelection(curSelected);
                            }
                        else
                            {
                                curSelectedBkp=curSelected;
                                curSelected=curSelected-1; 
                                changeSelection(curSelected);
                            }
                        canChange=false;
                        GlobalSoundManager.play('scrollMenu');
                    }
			}*/ //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }

		}

        function changeSelection(newCurselected:Int)
            {
                dummycredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelectedBkp]+')'));
                dummycredit.alpha=1;
                dummycredit.x=newcredit.x;
                dummycredit.y=newcredit.y;

                //dummycredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected]+')'));

                    if(curSelected+1 < creditStuff.length)
                        {
                            dummycredit2.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected+1]+')'));
                        }
                    else
                        {
                            dummycredit2.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[0]+')'));
                        }
                dummycredit1.alpha=1;
                dummycredit1.x=newcredit1.x;
                dummycredit1.y=newcredit1.y;
                dummycredit2.alpha=1;
                dummycredit2.x=900;

                //newcredit.x=newcredit1.x;
                //newcredit1.x = -279;
                newcredit.alpha=0;
                newcredit1.alpha=0;


                if(curSelected+1 > creditStuff.length-1)
                    {
                        dummycredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[creditStuff.length-1]+')'));
                    }
                else
                    {
                        dummycredit1.loadGraphic(newcredit1.graphic);
                    }
                FlxTween.tween(dummycredit, {x: -900}, 0.5, {ease: FlxEase.quartInOut});
                FlxTween.tween(dummycredit1, {x: newcredit.x}, 0.6, {ease: FlxEase.quartInOut});
                FlxTween.tween(dummycredit2, {x: newcredit1.x}, 0.7, {ease: FlxEase.quartInOut});
                //FlxTween.tween(dummycredit1, {alpha: 0}, 0.3, {ease: FlxEase.quartInOut});
                //FlxTween.tween(newcredit, {x: 18}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.6});

                new FlxTimer().start(0.75, function(tmr:FlxTimer){
                    dummycredit1.alpha=0;
                    dummycredit2.alpha=0;
                    dummycredit.alpha=0;
                    newcredit.alpha=1;
                    newcredit1.alpha=1;
                    canChange=true;
                });
                //newcredit.y=-724;
                newcredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected]+')'));
                if(curSelected+1 < creditStuff.length)
                    {
                        newcredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected+1]+')'));
                    }
                else
                    {
                        newcredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[0]+')'));
                    }
            }

            function changeSelectionMinus(newCurselected:Int)
                {
                    dummycredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelectedBkp]+')'));
                    dummycredit.alpha=1;
                    dummycredit.x=newcredit.x;
                    dummycredit.y=newcredit.y;
    
                    //dummycredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected]+')'));
    
                        if(curSelected-1 < -1)
                            {
                                dummycredit2.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected-1]+')'));
                            }
                        else
                            {
                                dummycredit2.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[creditStuff.length-1]+')'));
                            }
                    dummycredit1.alpha=1;
                    dummycredit1.x=newcredit1.x;
                    dummycredit1.y=newcredit1.y;
                    dummycredit2.alpha=1;
                    dummycredit2.x=900;
    
                    //newcredit.x=newcredit1.x;
                    //newcredit1.x = -279;
                    newcredit.alpha=0;
                    newcredit1.alpha=0;
    
    
                    if(curSelected-1 > -1)
                        {
                            dummycredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected-1]+')'));
                        }
                    else
                        {
                            dummycredit1.loadGraphic(newcredit1.graphic);
                        }
                    FlxTween.tween(dummycredit, {x: -900}, 0.5, {ease: FlxEase.quartInOut});
                    FlxTween.tween(dummycredit1, {x: newcredit.x}, 0.6, {ease: FlxEase.quartInOut});
                    FlxTween.tween(dummycredit2, {x: newcredit1.x}, 0.7, {ease: FlxEase.quartInOut});
                    //FlxTween.tween(dummycredit1, {alpha: 0}, 0.3, {ease: FlxEase.quartInOut});
                    //FlxTween.tween(newcredit, {x: 18}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.6});
    
                    new FlxTimer().start(0.75, function(tmr:FlxTimer){
                        dummycredit1.alpha=0;
                        dummycredit2.alpha=0;
                        dummycredit.alpha=0;
                        newcredit.alpha=1;
                        newcredit1.alpha=1;
                        canChange=true;
                    });
                    //newcredit.y=-724;
                    newcredit.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected]+')'));
                    if(curSelected-1 < -1)
                        {
                            newcredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[curSelected-1]+')'));
                        }
                    else
                        {
                            newcredit1.loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica ('+creditStuff[creditStuff.length-1]+')'));
                        }
                }
}