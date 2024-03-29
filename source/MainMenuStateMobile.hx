package;

import Achievements;
import editors.MasterEditorMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.net.URLRequest;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import Utils.BSLTouchUtils;
import CustomButtons.MenuButton;
import gamejolt.*;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class MainMenuStateMobile extends MusicBeatState
{
	public static var psychEngineVersion:String = 'V1'; //This is also used for Discord RPC

	public var camGame:FlxCamera;
	public var camAchievement:FlxCamera;
	var clicavel:Bool = false;


	private var curSelected:Int = 0;
	var boom:FlxSprite;
	var gameJoltBG:FlxSprite;

	var letext:FlxText;
	var isCoolBeat:Bool=true;
	public static var instance:MainMenuStateMobile;
	//var gradientBar:FlxGradient;
	
	var optionShit:Array<String> = 
	['story',
	'freeplay', 
	'multiplayer', 
	'achievements', 
	'credits', 
	'options'];
	private var menuItems:FlxTypedGroup<FlxSprite>;
	var machine:FlxSprite;
	var bg:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var logoBl:FlxSprite;
	var checkiftouch:Bool = false;
	public static var canClick:Bool = false;
	public static var newVersion:Bool = false;
	var gameJoltIcon:FlxSprite;

	public static var version:String = '0.10.0';
	public static var changelogString:String = 'V'+version+'\nRemake Multiplayer;\nMenus Via Touch/Teclado;\nFixes VideoPlayer.';
	public static var verificaDnvIdiota:Bool = false;

	public static var passouCY:Bool = false;

	var gamejoltUser:GameJoltUserObject;
	public var inviteBackEnd:InviteBackEnd;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		Conductor.changeBPM(112);
		instance = this;
		GameJoltLoginState.syncProgress();
		if(GJClient.logged) {
			inviteBackEnd = new InviteBackEnd(this);
		}
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_main_menu", "rpc"), null);
		#end

		if(FlxG.sound.music == null || !FlxG.sound.music.active) {
			FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
		}
		if(FlxG.sound.music.volume==0) {
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		Main.mouse_allowed = true;
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menus/bg-wfiltro'));
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.screenCenter(X);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);


		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, null, 1);

		machine = new FlxSprite(0).loadGraphic(Paths.image('menus/faixa', 'preload'));
		machine.scrollFactor.x = 0;
		machine.scrollFactor.y = 0;
		machine.setGraphicSize(FlxG.width, FlxG.height);
		machine.updateHitbox();
		machine.screenCenter();
		machine.visible = true;
		machine.antialiasing = ClientPrefs.globalAntialiasing;
		add(machine);

		boom = new FlxSprite(0, 0); //ok
		boom.frames = Paths.getSparrowAtlas('menus/sonicmenu1', 'preload');
		boom.animation.addByPrefix('idle', "sonicmenu1 idle",30); //30
		boom.antialiasing = ClientPrefs.globalAntialiasing;
		//boom.setGraphicSize(Std.int));
		//boom.flipX = true;
		boom.updateHitbox();
		boom.y = -565;
		boom.flipX=true;
		boom.x = -751;
		boom.alpha=1;
		add(boom);
		
		gamejoltUser = new GameJoltUserObject();
		gamejoltUser.x = bg.x - 150;
		gamejoltUser.y = bg.y - 380;
		add(gamejoltUser);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length){
			var botao:MenuButton = new MenuButton("MainMenu", "menu_"+optionShit[i], 'menu', "sonic-3", false);
			botao.setLock(optionShit[i]=="multiplayer" && (!GJClient.logged||!passouCY) || optionShit[i]=="freeplay"&&!passouCY);
			/*if (botao.isLocked)
				botao.alpha = 0.75;*/
			botao.alpha = 0.75;
			botao.ID = i;
			botao.forEach(function(spr:FlxSprite){
				spr.setGraphicSize(Std.int(spr.width*0.6));
				spr.updateHitbox();
			});
			botao.screenCenter(Y);
			botao.y -= FlxG.height/optionShit.length*(optionShit.length-i)-62;
			botao.x = FlxG.width;

			botao.button_text.x += 85;
			botao.button_text.y -= 28;

			if(botao.lock_icon!=null){botao.lock_icon.x-=160;}
			
			menuItems.add(botao);
			
		}



		for (i in 0...optionShit.length){
			FlxTween.tween(menuItems.members[i], {x: FlxG.width - (2.15+(-i/13))*(menuItems.members[i].width/1.42)}, 0.3, {ease: FlxEase.expoInOut, startDelay: 0.1*(1+2*i)});
		}

		new FlxTimer().start(0.1*(1 + 2*optionShit.length) + 0.3, function(tmr:FlxTimer){
			clicavel = true;
		});

		checkiftouch = false;

		#if ACHIEVEMENTS_ALLOWED
			test_unlock('modboa'); 
			//Ok, isso pode parecer estranho, mas a questão é
			//O mano sempre precisará mexer nas opções pra desbloquear toastie
			//Mas a questão é que pra isso, o mano vai ter que passar aqui primeiro. (eu acho...)
			if (ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) test_unlock("toastie");
		#end


		var versionShit:FlxText = new FlxText(12, FlxG.height - 34, 0, "ModBoa: EXE v" + version, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("sonic-1-hud-font.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.updateHitbox();
		add(versionShit);

		if(newVersion)
			{
				var preto:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				preto.alpha=0.75;
				preto.updateHitbox();
				preto.cameras = [camAchievement];
				add(preto);
				var novoBG:FlxSprite = new FlxSprite(421, 87, Paths.image('mainmenu/updatescreen', 'locales', true, true));
				novoBG.cameras = [camAchievement];
				add(novoBG);
				var textinho:FlxText = new FlxText(0, 0, 400, changelogString, 12);
				textinho.scrollFactor.set();
				textinho.setFormat("sonic-1-hud-font.ttf", 36, FlxColor.GRAY, LEFT);
				textinho.x = 446;
				textinho.y = 162;
				textinho.updateHitbox();
				textinho.cameras = [camAchievement];
				add(textinho);
				var novoButton:FlxButton = new FlxButton(523, 548, '');
				novoButton.cameras = [camAchievement];
				novoButton.loadGraphic(Paths.image('mainmenu/btok', 'preload'));
				novoButton.alpha = 0.75;
				novoButton.onOver.callback = function(){novoButton.alpha=1; GlobalSoundManager.play(scrollMenu);};
				novoButton.onOut.callback = function(){novoButton.alpha=0.75;};
				novoButton.onDown.callback = function(){
					FlxG.save.data.gameVersion = version;
					ClientPrefs.save();
					novoButton.visible=false;
					novoBG.visible=false;
					preto.visible=false;
					textinho.visible=false;
					GlobalSoundManager.play(confirmMenu);
					newVersion = false;
					canClick = true;
				};
				add(novoButton);
				canClick=false;
			}
		else
			{
				FlxG.save.data.gameVersion = version;
				ClientPrefs.save();
				canClick=true;
			}
		super.create();

		new FlxTimer().start(300, function(twn:FlxTimer){
			test_unlock('tarado_do_menu');
		});

		if (Lambda.count(ClientPrefs.achievementsMap) == 32) test_unlock("colecionador");
	}

	function test_unlock(achieve:String){
		#if ACHIEVEMENTS_ALLOWED
		var achieveID:Int = Achievements.getAchievementIndex(achieve);
		if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][0])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
			ClientPrefs.achievementsMap.set(Achievements.achievementsStuff[achieveID][0], true);
			giveAchievement(achieve);
			ClientPrefs.save();
		}
		#end
		return;
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement(achievementname) {
		add(new AchievementObject(achievementname, camAchievement));
		GlobalSoundManager.play(confirmMenu);
		trace('Giving achievement '+ achievementname);
	}
	#end

	var selectedSomethin:Bool = false;

	function sumidao(selecionado:Int){
		//Honestamente, nunca pensei que um dia conseguiria fazer algo assim.
		//É simples, mas só de ver a diferença entre a primeira versão desse code, pra de agora...

		menuItems.forEach(function(spr:FlxSprite)
			{
				if(spr.ID == selecionado){
					spr.alpha = 1;
					FlxTween.tween(menuItems.members[spr.ID], {x: spr.x-35}, 0.5, {ease: FlxEase.expoInOut, startDelay: 0.1,
						onComplete: function(proximo:FlxTween)
						{
							FlxTween.tween(menuItems.members[spr.ID], {x: FlxG.width+10}, 1.0, {ease: FlxEase.expoInOut, startDelay: 0.3});
						}});
				}else{
					FlxTween.tween(spr, {x: FlxG.width+10}, 0.5, {ease: FlxEase.expoInOut, startDelay: 0.1});
				}
			});
		}

	function trocaDeState(state:Int){
		//Main.mouse_allowed = false;
		selectedSomethin = true;
		clicavel = false;
		checkiftouch = true;
		sumidao(state);
		GlobalSoundManager.play(confirmMenu);
		var daChoice:String = optionShit[state];
		sumidao(state);
		new FlxTimer().start(1.7, function(tmr:FlxTimer) {
			switch (daChoice)
			{
				case 'story':
					MusicBeatState.switchState(new EstadoDeLimpeza());
				case 'freeplay':
					if(!passouCY)
						return;
					MusicBeatState.switchState(new FreeplayState());
				case 'achievements':
					MusicBeatState.switchState(new AchievementsMenuState());
				case 'credits':
					MusicBeatState.switchState(new SobreState());
				case 'options':
					MusicBeatState.switchState(new ajustes.AjustesState());
				case 'multiplayer':
					if(GJClient.logged)
					{
						MusicBeatState.switchState(new multiplayer.MultiplayerMainMenuState());
					} // A minha ideia pra essa parte era fazer um gerador de Popups em substate pra dizer que tu precisa estar conectado na GJ pra usar isso...
					// apenas uma ideia :thumbsup:
			}			
		});
	}

	var selectingFriends:Bool = false;
	private function handle_input():Void{
		if(!selectingFriends)
		{
			if (controls.UI_DOWN_P)
				{
					if (curSelected + 1 > menuItems.length - 1)
						curSelected = 0;
					else{
						curSelected +=1;
						if (optionShit[curSelected] == "freeplay" && !passouCY)
							curSelected +=1;
						if (optionShit[curSelected] == "multiplayer" && (!GJClient.logged || !passouCY))
							curSelected +=1;
					}
				}
				else if (controls.UI_UP_P)
				{
					if (curSelected - 1 < 0)
						curSelected = menuItems.length - 1;
					else{
						curSelected -= 1;
						if (optionShit[curSelected] == "multiplayer" && (!GJClient.logged || !passouCY))
							curSelected -=1;
						if (optionShit[curSelected] == "freeplay" && !passouCY)
							curSelected -=1;
					}
				}

			if(controls.UI_LEFT_P && GJClient.logged)
			{
				selectingFriends = true;
				GlobalSoundManager.play(scrollMenu);
			}

		}
		else
		{
			if(controls.UI_RIGHT_P)
			{
				selectingFriends = false;
			}
		}

	}

	override function update(elapsed:Float)
	{
		#if debug
		if(FlxG.keys.justPressed.FOUR) giveAchievement('modboa');
		#end
		#if (desktop && debug)
		if(FlxG.keys.justPressed.SIX) MusicBeatState.switchState(new editors.VideoEventState());
		#end
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if(canClick)
			{
				handle_input();
				if(clicavel && !checkiftouch){
					menuItems.forEach(function(spr:FlxSprite){
						if(!selectingFriends || Main.getMouseVisibility())
						{
							if((optionShit[spr.ID] == "freeplay" && passouCY) || (optionShit[spr.ID]=="multiplayer"&&GJClient.logged&&passouCY))
								{
									if((Main.getMouseVisibility() ? BSLTouchUtils.over(spr) : spr.ID == curSelected) && spr.alpha == 0.75){
										curSelected = spr.ID;
										menuItems.members[spr.ID].alpha=1;
										GlobalSoundManager.play(scrollMenu);
									}else if(!(Main.getMouseVisibility() ? BSLTouchUtils.over(spr) : spr.ID == curSelected) ){
										spr.alpha=0.75;
									}
		
									if(Main.getMouseVisibility() ? BSLTouchUtils.apertasimples(spr) : (spr.ID == curSelected && controls.ACCEPT)){
										trocaDeState(spr.ID);
									}
								}
								else if(optionShit[spr.ID] != "freeplay" && optionShit[spr.ID] != "multiplayer")
								{
									if((Main.getMouseVisibility() ? BSLTouchUtils.over(spr) : spr.ID == curSelected) && spr.alpha == 0.75){
										menuItems.members[spr.ID].alpha=1;
										curSelected = spr.ID;
										GlobalSoundManager.play(scrollMenu);
									}else if(!(Main.getMouseVisibility() ? BSLTouchUtils.over(spr) : spr.ID == curSelected) ){
										spr.alpha=0.75;
									}
		
									if(Main.getMouseVisibility() ? BSLTouchUtils.apertasimples(spr) : (spr.ID == curSelected && controls.ACCEPT)){
										trocaDeState(spr.ID);
									}
								}
						}
						else if(selectingFriends && !Main.getMouseVisibility())
						{
							spr.alpha=(optionShit[spr.ID] == "freeplay" && passouCY) || (optionShit[spr.ID]=="multiplayer"&&GJClient.logged&&passouCY) || (optionShit[spr.ID] != "freeplay" && optionShit[spr.ID] != "multiplayer") ? 0.75 : 1;
						}
					});

					gamejoltUser.alpha = GJClient.logged ? Main.getMouseVisibility() ? 1 : selectingFriends ? 1 : 0.75 : 1;
					if((Main.getMouseVisibility() ? BSLTouchUtils.apertasimples(gamejoltUser) : (selectingFriends && controls.ACCEPT)) && GJClient.logged){
						FlxTween.tween(gamejoltUser, {x: -1200}, 0.5, {ease: FlxEase.expoInOut});
						openSubState(new GameJoltFriendsMenu());
					}
				}
			}

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin && canClick)
		{

			if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
			{
				selectedSomethin = true;
				GlobalSoundManager.play(cancelMenu);
				MusicBeatState.switchState(new TitleState());
			}
			
			#if (desktop && debug)
			else if (FlxG.keys.justPressed.SEVEN)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
			
		}

		#if debug
		if(FlxG.keys.justPressed.P)
		{
			GJClient.desafiarAmigo(GJClient.myID);
		}
		#end

		super.update(elapsed);

	}


	public function voltarUser()
	{
		FlxTween.tween(gamejoltUser, {x: bg.x-150}, 0.5, {ease: FlxEase.expoInOut});
	}

	override function beatHit()
		{
			super.beatHit();
			if(isCoolBeat){boom.animation.play('idle', true);}
			isCoolBeat = !isCoolBeat;
		}
}
