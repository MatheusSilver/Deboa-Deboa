package;

import Utils.BSLSwipeUtils;
import Utils.BSLTouchUtils;
import Utils.SpriteSwapper;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
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

class CreditsMusics extends MusicBeatState
{
	// var letext:FlxText;
	var bg:FlxSprite;
	// var faixa:FlxSprite;
	// var exe:FlxSprite;
	var creditList:FlxTypedSpriteGroup<SpriteSwapper>;

	var creditStuff:Array<String> = [
		'mars', 'penkaru', 'saster', 'solunary', 'spookawaii', 'teles', 'ankinluu', 'apartygoer', 'c52278', 'd4rksp1ne20', 'ehtmareiner', 'jark1412',
		'kanihuman', 'panchonatorr', 'phantasmpixel', 'pikatio', 'soufon', 'shadowmario'
	];

	override function create()
	{
		FlxTransitionableState.skipNextTransOut = true;
		BSLSwipeUtils.max_x = 3;
		BSLSwipeUtils.mouseScrollMultiplier=0; //Isso desativa o mouse do BSLSwipeUtils
		BSLSwipeUtils.reset_manual=true;
		Main.mouse_allowed = true;
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_credit_menu", "rpc"), null);
		#end
		/*bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.visible = true;
			add(bg); */

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/creditos/musicseartes/artemusica (back)'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		// faixa.setGraphicSize(Std.int(0.5));
		bg.visible = true;
		bg.y = 720;
		add(bg);

		creditList = new FlxTypedSpriteGroup<SpriteSwapper>(FlxG.width*3,0,creditStuff.length);

		for (i in 0...creditStuff.length){
			var creditSprite:SpriteSwapper;
			creditSprite = new SpriteSwapper(i, Paths.image('sobremenu/creditos/musicseartes/artemusica (' + creditStuff[i] + ')', "locales", true, true), 3, 250, X, 1, creditStuff.length);
			creditSprite.specialOffset = creditSprite.width*0.125; //0.125 = 0.25 (tamanho do zoom) / 2 para dar metade da largura ganha com zoom
			creditList.add(creditSprite);
		}
		add(creditList);
		
		FlxTween.tween(bg, {y: 0}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(creditList, {x: 0}, 0.5, {ease: FlxEase.quartInOut, startDelay: 1});

		super.create();
	}

	override function update(elapsed:Float)
	{
		BSLSwipeUtils.swipeHorizontal();
		creditList.forEach(function(spr:SpriteSwapper)
			{				
				if (spr.visible){
					if ((spr.x+spr.width/2) > FlxG.width/2){
						spr.scale.x = spr.scale.y = 0.75+(0.25 * ((FlxG.width/2)/(spr.x+spr.width/2)));
					}else{
						spr.scale.x = spr.scale.y = 0.75+(0.25 * ((spr.x+spr.width/2)/(FlxG.width/2)));
					}
				}
			});	
		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
		{
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new SobreState());
		}
		if (Main.getMouseVisibility()){
			#if desktop
			if(FlxG.mouse.wheel != 0 && creditList.members[0].tweenController==null)
				changeSelection(Utils.CoolUtil.mathClamp(FlxG.mouse.wheel,-1,1));
			#end
			if (BSLSwipeUtils.scrollX!=0 && creditList.members[0].tweenController==null){
				creditList.forEach(function(spr:SpriteSwapper)
				{				
					spr.x+=BSLSwipeUtils.scrollX;
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
				if (controls.UI_RIGHT_P)
					changeSelection(-1);
				else if (controls.UI_LEFT_P)
					changeSelection(1);
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
