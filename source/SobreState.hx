package;

import flixel.text.FlxText;
import Utils.BSLTouchUtils;
import CustomButtons.CreditButton;
#if rpc
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.addons.transition.FlxTransitionableState;
import gamejolt.GJClient;

using StringTools;

class SobreState extends MusicBeatState
{
	var bg:FlxSprite;
	var faixa:FlxSprite;
	var gtext:FlxText;
	var ctext:FlxText;
	var arrow:FlxButton;

	static var menu_isLeft:Bool = false;
	private var buttonMapping:Map<String, CreditButton> = [];
	private final menusArray:Array<String> = ["sunny", "dav", "vio", "exe", "saster" ];
	private var curSelected:Int = 0;

	var helpBt:FlxButton;

	//A ideia já tava tão avançada nesse ponto, então fui para a base da gambiarra.

	override function create()
	{
		#if desktop
		FlxG.mouse.load(Paths.image('sobremenu/galeria/cursor'), 1, 0, 0);
		#end
		Main.mouse_allowed = true;
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_about", "rpc"), null);
		#end
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.updateHitbox();
		bg.alpha = 1;
		add(bg);

		faixa = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (faixa)'));
		faixa.antialiasing = ClientPrefs.globalAntialiasing;
		faixa.updateHitbox();
		faixa.alpha = 1;
		add(faixa);

		gtext = new FlxText(0, 0, faixa.width, Linguagem.LangUtil.getString("menu_video_gallery", "credits").toUpperCase(), 48);
		gtext.antialiasing = ClientPrefs.globalAntialiasing;
		gtext.setFormat(Linguagem.LangUtil.getFont("smb"), 36, Utils.CoolUtil.colorFromString("#f9c9a5"), CENTER);
		gtext.updateHitbox();
		gtext.x = 43;
		gtext.y = 40;
		gtext.alpha = 1;
		add(gtext);

		ctext = new FlxText(0, 0, faixa.width, Linguagem.LangUtil.getString("menu_credit_menu", "credits").toUpperCase(), 48);
		ctext.antialiasing = ClientPrefs.globalAntialiasing;
		ctext.setFormat(Linguagem.LangUtil.getFont("smb"), 36, Utils.CoolUtil.colorFromString("#f9c9a5"), CENTER);
		ctext.updateHitbox();
		ctext.x = 636; // btw, isso n foi intencional
		ctext.y = 36;  // DAV??????????????? :fearful: - Era 666 :skull:
		ctext.alpha = 1;
		add(ctext);

		var exe:CreditButton = new CreditButton(faixa.width, "exe", "left", "mods_ports", "#847eff");
		buttonMapping.set("exe", exe);
		exe.x = 640;
		exe.y = 320;
		exe.alpha = 0.75;
		exe.ID = 3;
		exe.updateHitbox();
		exe.offset.set();
		add(exe);

		var saster:CreditButton = new CreditButton(faixa.width,"saster", "right", "songs_arts", "#ffa9ff");
		buttonMapping.set("saster", saster);

		saster.x = 640;
		saster.y = 490;
		saster.alpha = 0.75;
		saster.ID = 4;
		saster.updateHitbox();
		saster.offset.set();
		add(saster);

		var sunny:CreditButton = new CreditButton(faixa.width,"sunny", "right", "gallery", "#ffcbeb");
		buttonMapping.set("sunny", sunny);
		sunny.x = 47;
		sunny.y = 150;
		sunny.alpha = 0.75;
		sunny.ID = 0;
		sunny.updateHitbox();
		sunny.offset.set();
		add(sunny);

		var vio:CreditButton = new CreditButton(faixa.width,"vio", "right", "team_staff", "#d95500");
		buttonMapping.set("vio", vio);
		vio.x = 640;
		vio.y = 150;
		vio.alpha = 0.75;
		vio.ID = 2;
		vio.updateHitbox();
		vio.offset.set();
		add(vio);

		var dav:CreditButton = new CreditButton(faixa.width,"dav", "left", "our_project", "#6640fc");
		buttonMapping.set("dav", dav);
		dav.x = 47;
		dav.y = 320;
		dav.alpha = 0.75;
		dav.ID = 1;
		dav.updateHitbox();
		dav.offset.set();
		add(dav);

		arrow = new FlxButton(FlxG.width, 100, '');
		arrow.loadGraphic(Paths.image('sobremenu/arrow', 'preload'));

		arrow.updateHitbox();
		arrow.x = 280;
		arrow.y = 272;
		arrow.alpha = 0.75;
		add(arrow);

		helpBt = new FlxButton(0,0,"");
		helpBt.loadGraphic(Paths.image('sobremenu/interrog', 'preload'));
		helpBt.updateHitbox();
		helpBt.x = 68;
		helpBt.y = 599;
		helpBt.alpha = 0.75;
		add(helpBt);

		updateuwu(menu_isLeft);
		super.create();
	}

	function helpPopUps(){
		openSubState(new PopUpSubState("tutorial", "tutorial_1", null, function(){
			closeSubState();
			openSubState(new PopUpSubState("tutorial", "tutorial_2", null, function(){
				closeSubState();
				openSubState(new PopUpSubState("tutorial", "tutorial_3", null, function(){
					closeSubState();
				}, 150, false, true));
			}, 150, false, true));
		}));
	}

	private function handle_input():Void{
		if (controls.UI_DOWN_P)
		{
			if (curSelected + 1 > (menu_isLeft ? 1 : menusArray.length - 1))
				curSelected = (menu_isLeft ? 0 : 2);
			else
				curSelected +=1;
			
		}
		else if (controls.UI_UP_P)
		{
			if (curSelected - 1 < (menu_isLeft ? 0 : 2))
				curSelected = (menu_isLeft ? 1 : menusArray.length - 1);
			else
				curSelected -= 1;
		}else if ((menu_isLeft ? controls.UI_RIGHT_P : controls.UI_LEFT_P)){
			updateuwu(!menu_isLeft);
			GlobalSoundManager.play(confirmMenu);
		}
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
		{
			GlobalSoundManager.play(cancelMenu);
			MusicBeatState.switchState(new MainMenuStateMobile());
		}

		#if debug
		if(FlxG.keys.justPressed.P)
		{
			GJClient.desafiarAmigo(GJClient.myID, null, null, true);
		}
		#end

		super.update(elapsed);
		if (FlxG.sound.music.volume == 0)
		{
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		// agr que eu vi que eu fui burro mas to com preguiça de consertar tudo que eu fiz de errado :)
		// o importante é que funciona

		handle_input();
		for (key in buttonMapping.iterator()){
			if ((Main.getMouseVisibility() ? BSLTouchUtils.over(key.bg) : curSelected == key.ID) && !key.isOver && key.visible)
				hover(key);
			else if ((Main.getMouseVisibility() ? BSLTouchUtils.apertasimples(key.bg) : controls.ACCEPT) && key.isOver && key.visible)
				click(key);
			else if (key.isOver && !(Main.getMouseVisibility() ? BSLTouchUtils.over(key.bg) : curSelected == key.ID) && key.visible)
				out(key);
		}

		// arrow
		arrow.onOver.callback = function()
		{
			GlobalSoundManager.play(scrollMenu);
			arrow.alpha = 1;
		};

		arrow.onOut.callback = function(){arrow.alpha = 0.75;};

		arrow.onDown.callback = function()
		{
			arrow.alpha = 1;
			GlobalSoundManager.play(confirmMenu);
			updateuwu(!menu_isLeft);
		};

		helpBt.onOver.callback = function() {
			if(!helpBt.visible)
				return;
			GlobalSoundManager.play(scrollMenu);
			helpBt.alpha = 1;
		}

		helpBt.onOut.callback = function(){
			if(!helpBt.visible)
				return;
			helpBt.alpha = 0.75;
		};

		helpBt.onDown.callback = function() {
			if(!helpBt.visible)
				return;
			helpBt.alpha = 1;
			GlobalSoundManager.play(confirmMenu);
			helpPopUps();
		}
	}

	function hover(object:CreditButton):Void
	{
		object.isOver = true;
		GlobalSoundManager.play(scrollMenu);
		object.alpha = 1;
		curSelected = object.ID;
	}

	function out(object:CreditButton):Void
	{
		object.isOver = false;
		object.alpha = 0.75;
	}

	function click(object:CreditButton)
	{
		GlobalSoundManager.play(confirmMenu);
		object.alpha = 1;
		FlxTransitionableState.skipNextTransOut = true;
		switch (menusArray[object.ID]){
			case "vio":
				MusicBeatState.switchState(new TimeDaVio());
			case "exe":
				MusicBeatState.switchState(new CreditsMods());
			case "saster":
				MusicBeatState.switchState(new CreditsMusics());
			case "dav":
				#if desktop
				MusicBeatState.switchState(new SobreVideo());
				#elseif mobile
				FlxG.switchState(new Videos.VideoState('assets/videos/EngineBase/aviso', (new SobreState())));
				#end
			case "sunny":
				MusicBeatState.switchState(new GaleriaState());
		}
		
	}

	function updateuwu(side:Bool):Void
	{
		menu_isLeft=side;
		curSelected = menu_isLeft ? 0 : 2;
		faixa.x = menu_isLeft ? 43 : 636;
		gtext.visible = menu_isLeft;
		buttonMapping.get("dav").visible = menu_isLeft;
		buttonMapping.get("sunny").visible = menu_isLeft;
		buttonMapping.get("saster").visible = !menu_isLeft;
		buttonMapping.get("vio").visible = !menu_isLeft;
		buttonMapping.get("exe").visible = !menu_isLeft;
		helpBt.visible = menu_isLeft;
		ctext.visible = !menu_isLeft;
		arrow.flipX = menu_isLeft;
		arrow.x = !menu_isLeft ? 280 : 836;
		arrow.updateHitbox();
	}
}