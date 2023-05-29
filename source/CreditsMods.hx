package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;
#if desktop
import Discord.DiscordClient;
#end

class CreditsMods extends MusicBeatState
{
	//var videoMenu:FlxSprite = new FlxSprite(0,0);
	//var video:MP4Handler = new MP4Handler();
	//var letext:FlxText;
	var bg:FlxSprite;
	var faixa:FlxSprite;
    var exe:FlxSprite;
	var curSelected:Int=0;
    var curSelectedBkp:Int=0;
    var canChange:Bool=false;
    var newcredit:FlxSprite;
    var dummycredit:FlxSprite;

    var creditStuff:Array<String> = ['belowthedepths', 'chaosnightmare', 'endlesscycles', 'executionrecycled', 'finalescape', 'finalratio', 'funkmixmario', 'hypnoslullaby', 'piracysonic', 'possessed', 'preyp', 'ringsofdespair', 'secrethistories', 'sonicboom', 'vssonicexe', 'vsspeedgif', 'vstailsexe'];
	
	override function create()
		{
			FlxG.mouse.visible = false;
            canChange=false;
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

            
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
            bg.y=-720;
			add(bg);

            dummycredit = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelectedBkp]));
            dummycredit.antialiasing = ClientPrefs.globalAntialiasing;
            dummycredit.alpha=0;
            dummycredit.y=0;
            add(dummycredit);
            newcredit = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelected]));
            newcredit.antialiasing = ClientPrefs.globalAntialiasing;
            //newcredit.setGraphicSize(Std.int(0.8));
            newcredit.alpha=1;
            //newcredit.x=525;
            newcredit.y=-724;
            add(newcredit);

            faixa = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (faixa)'));
			faixa.antialiasing = ClientPrefs.globalAntialiasing;
			faixa.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			faixa.alpha = 1;
            faixa.x = 973;
			add(faixa);

            exe = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (sonic)'));
			exe.antialiasing = ClientPrefs.globalAntialiasing;
			exe.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			exe.alpha = 1;
            exe.x = 1029;
			add(exe);


            FlxTween.tween(faixa, {x: 376}, 1, {ease: FlxEase.quartInOut});
            FlxTween.tween(exe, {x: 326}, 1.25, {ease: FlxEase.quartInOut});
            FlxTween.tween(bg, {y: 0}, 0.8, {ease: FlxEase.quartInOut});
            FlxTween.tween(newcredit, {y: 0}, 0.5, {ease: FlxEase.quartInOut, startDelay: 1.35});

            new FlxTimer().start(1.8, function(tmr:FlxTimer){
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

			if(controls.UI_RIGHT_P) { //ok
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

            if(controls.UI_LEFT_P) { //ok
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
			}
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }

		}

        function changeSelection(newCurselected:Int)
            {
                dummycredit.loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelectedBkp]));
                dummycredit.alpha=1;
                dummycredit.y=0;
                FlxTween.tween(dummycredit, {y: 724}, 0.5, {ease: FlxEase.quartInOut});

                FlxTween.tween(newcredit, {y: 0}, 0.5, {ease: FlxEase.quartInOut, startDelay: 0.6});

                new FlxTimer().start(1.1, function(tmr:FlxTimer){
                    canChange=true;
                });
                newcredit.y=-724;
                newcredit.loadGraphic(Paths.image('sobremenu/creditos/modseports/cards/card-'+creditStuff[curSelected]));
            }

}