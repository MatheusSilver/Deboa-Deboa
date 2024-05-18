

package;

import Utils.BSLTouchUtils;
import Utils.SpriteSwapper;
import flixel.group.FlxGroup.FlxTypedGroup;
import Utils.BSLSwipeUtils;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class CreditsMods extends MusicBeatState
{
	var bg:FlxSprite;
	var faixa:FlxSprite;
	var exe:FlxSprite;
	var canChange:Bool = false;
	var creditList:FlxTypedSpriteGroup<SpriteSwapper>;
	

	var creditStuff:Array<String> = [
		'belowthedepths', 'chaosnightmare', 'endlesscycles', 'executionrecycled', 'finalescape', 'finalratio', 'funkmixmario', 'hypnoslullaby', 'piracysonic',
		'possessed', 'preyp', 'ringsofdespair', 'secrethistories', 'sonicboom', 'vssonicexe', 'vsspeedgif', 'vstailsexe'
	];

	override function create()
	{
		FlxTransitionableState.skipNextTransOut = true;
		Main.mouse_allowed = false;
		canChange = false;
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_credit_menu", "rpc"), null);
		#end
		
		/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
			add(bg); */
		new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (back)'));
				bg.antialiasing = ClientPrefs.globalAntialiasing;
				bg.updateHitbox();
				// faixa.setGraphicSize(Std.int(0.5));
				bg.alpha = 1;
				bg.y = 720;
				add(bg);

				creditList = new FlxTypedSpriteGroup<SpriteSwapper>(-25,FlxG.height*4,creditStuff.length);

				for (i in 0...creditStuff.length){
					var creditSprite:SpriteSwapper;
					creditSprite = new SpriteSwapper(i, Paths.image('sobremenu/creditos/modseports/cards/card-' + creditStuff[i], "locales", true, true), 1, 200, Y, 1.7,creditStuff.length);
					creditSprite.specialOffset = -FlxG.height*0.275;
					creditList.add(creditSprite);
				}
				add(creditList);

				faixa = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (faixa)'));
				faixa.antialiasing = ClientPrefs.globalAntialiasing;
				faixa.updateHitbox();
				// faixa.setGraphicSize(Std.int(0.5));
				faixa.alpha = 1;
				faixa.x = 973;
				add(faixa);

				exe = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/modseports/modseports (sonic)'));
				exe.antialiasing = ClientPrefs.globalAntialiasing;
				exe.updateHitbox();
				// faixa.setGraphicSize(Std.int(0.5));
				exe.alpha = 1;
				exe.x = 1029;
				add(exe);

				FlxTween.tween(faixa, {x: 376}, 1, {ease: FlxEase.quartInOut});
				FlxTween.tween(exe, {x: 326}, 1.25, {ease: FlxEase.quartInOut});
				FlxTween.tween(bg, {y: 0}, 0.8, {ease: FlxEase.quartInOut});
				FlxTween.tween(creditList, {y: -FlxG.height*0.275}, 0.5, {ease: FlxEase.quartInOut, startDelay: 1.35});

				new FlxTimer().start(1.8, function(tmr:FlxTimer)
				{
					canChange = true;
				});

				#if mobileC
				addVirtualPad(LEFT_RIGHT, A_B);
				#end
			});

		BSLSwipeUtils.max_y = 2;
		BSLSwipeUtils.mouseScrollMultiplier=0; //Isso desativa o mouse do BSLSwipeUtils
		BSLSwipeUtils.reset_manual=true;
		Main.mouse_allowed = true;

		super.create();
	}

	override function update(elapsed:Float)
	{
		BSLSwipeUtils.swipeVertical();
		if (controls.BACK && canChange)
		{
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new SobreState());
		}
		if (Main.getMouseVisibility()){
			#if desktop
			if(FlxG.mouse.wheel != 0 && creditList.members[0].tweenController==null)
				changeSelection(Utils.CoolUtil.mathClamp(FlxG.mouse.wheel,-1,1));
			#end
			if (BSLSwipeUtils.scrollY!=0 && creditList.members[0].tweenController==null){
				creditList.forEach(function(spr:SpriteSwapper)
				{				
					spr.y+=BSLSwipeUtils.scrollY*1.1;
				});	
			}else if(BSLSwipeUtils.is_swipping && !BSLTouchUtils.pressionando(bg)){
				creditList.forEach(function(spr:SpriteSwapper)
				{					
					spr.updateTarget();
				});	
				BSLSwipeUtils.is_swipping = false;
			}
		}else{
			if (creditList.members[0].tweenController==null){
				if (controls.UI_UP_P)
					changeSelection(1);
				else if (controls.UI_DOWN_P)
					changeSelection(-1);
			}
		}
		super.update(elapsed);
		if (FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
	}
	function changeSelection(change:Int=0)
	{
		creditList.forEach(function(spr:SpriteSwapper) {
			spr.setTarget(spr.getTarget()+change);
			spr.updateTarget(true);
		});
		GlobalSoundManager.play(scrollMenu);
	}
}