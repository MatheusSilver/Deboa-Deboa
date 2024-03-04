package ajustes;

import Utils.BSLTouchUtils;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import gamejolt.*;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class AjustesState extends MusicBeatState
{
	var boom:FlxSprite;
	var gameJoltBG:FlxSprite;
	private var option_buttons:FlxTypedGroup<FlxButton>;
	private var curSelected:Int = 0;

	var letext:FlxText;
	var isCoolBeat:Bool=true;
	//var gradientBar:FlxGradient;
	var optionShit:Array<String> = ['settings','controls', 'arrows', 'language', 'gamejooj'];

	var machine:FlxSprite;
	var logoBl:FlxSprite;
    var line:FlxSprite;
    var trees:FlxSprite;
	var pode:Bool = false;

	override function create()
	{
		//Conductor.changeBPM(112);
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_settings", "rpc"), null);
		#end
		
		if (FlxG.sound.music == null){
			FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0, true);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		else if(FlxG.sound.music != null && FlxG.sound.music.volume==0) {
			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}
		/*camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];*/
		Main.mouse_allowed = true;
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/bg-wfiltro'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(FlxG.width);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);



		machine = new FlxSprite(0).loadGraphic(Paths.image('optionsmenu/ajuste_back', 'preload'));
		machine.scrollFactor.x = 0;
		machine.scrollFactor.y = 0;
		machine.setGraphicSize(FlxG.width, FlxG.height);
		machine.updateHitbox();
		machine.screenCenter();
		machine.visible = true;
		machine.antialiasing = ClientPrefs.globalAntialiasing;
		add(machine);

        trees = new FlxSprite(0).loadGraphic(Paths.image('optionsmenu/ajuste_arvores', 'preload'));
		trees.scrollFactor.x = 0;
		trees.scrollFactor.y = 0;
		trees.setGraphicSize(FlxG.width, FlxG.height);
		trees.updateHitbox();
		trees.screenCenter();
		trees.visible = true;
		trees.antialiasing = ClientPrefs.globalAntialiasing;

		boom = new FlxSprite(0, 0); //ok
		boom.frames = Paths.getSparrowAtlas('optionsmenu/sunkyajustes', 'preload');
		boom.animation.addByPrefix('idle', "sunkyajustes bump",30);
		boom.antialiasing = ClientPrefs.globalAntialiasing;
		boom.setGraphicSize(Std.int(boom.width*1.5));
		boom.updateHitbox();
		boom.y =-700;
		boom.x = -450;
		boom.alpha=1;
		//boom.flipX=true;
		add(boom);

        add(trees);

		option_buttons = new FlxTypedGroup<FlxButton>();
		add(option_buttons);

		var k:Int = Math.floor((FlxG.height - 115*optionShit.length)/2);
		for (i in 0...optionShit.length){
			var button:FlxButton = new FlxButton(FlxG.width, k + 115*i, "");
			if (optionShit[i] == "gamejooj"){
				if(!GJClient.logged && !TitleState.ModoOffline)
					button.loadGraphic(Paths.image('optionsmenu/gamejooj', 'preload'));
				else
					button.loadGraphic(Paths.image('optionsmenu/gamejooj-locked', 'preload'));
			}else{
				button.loadGraphic(Paths.image('buttons_base/SettingsMenu', 'preload'));
				button.label.text =LangUtil.getString("opt_"+optionShit[i], "optionsMenu");
			}
			button.label.setFormat(LangUtil.getFont('sonic-3'), 28, FlxColor.WHITE, LEFT);
			button.labelOffsets = [FlxPoint.get(84,36), FlxPoint.get(84,36), FlxPoint.get(84,36)];
			button.setGraphicSize(Std.int(button.width * 0.6));
			button.updateHitbox();
			button.alpha = 0.75;
			button.labelAlphas = [button.alpha, 1, 1];
			button.ID = i;
			option_buttons.add(button);
		}

        line = new FlxSprite(0).loadGraphic(Paths.image('top_icons/ajustes', 'locales', true, true));
		line.scrollFactor.x = 0;
		line.scrollFactor.y = 0;
		line.setGraphicSize(FlxG.width, FlxG.height);
		line.updateHitbox();
		line.screenCenter();
		line.visible = true;
		line.antialiasing = ClientPrefs.globalAntialiasing;
		add(line);

		super.create();
	
		for (i in 0...optionShit.length){
			new FlxTimer().start(0.1 + 1/optionShit.length*i, function(tmr:FlxTimer) {
				FlxTween.tween(option_buttons.members[i], {x: FlxG.width - 2.5*option_buttons.members[i].width + 786}, 0.6,
					 {ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween){
						if (i == optionShit.length -1)
							pode=true;
					 }});
			});
		}
	}

	var selectedSomethin:Bool = false;

	function sumidao(selecionado:Int){
		pode=false;
		option_buttons.forEach(function(button:FlxButton){
			if (button.ID == selecionado){
				button.alpha = 1;
				FlxTween.tween(button, {x: FlxG.width - button.width}, 0.5, {startDelay: 0.1, ease: FlxEase.expoInOut, onComplete:function(twn:FlxTween){
					FlxTween.tween(button, {x: FlxG.width}, 1.0, {startDelay: 0.15, ease: FlxEase.expoInOut, onComplete: function(twn:FlxTween){
						next_state(optionShit[selecionado]);
					}});
				}});
			}else
				FlxTween.tween(button, {x: FlxG.width}, 0.5, {startDelay: 0.1, ease: FlxEase.expoInOut});
		});
	}

	private function handle_input():Void{
		if (controls.UI_DOWN_P)
		{
			if (curSelected + 1 > optionShit.length - 1)
				curSelected = 0;
			else{
				curSelected +=1;
				if (optionShit[curSelected] == "gamejooj" && (GJClient.logged || TitleState.ModoOffline))
					curSelected = 0;
			}
		}
		else if (controls.UI_UP_P)
		{
			if (curSelected - 1 < 0)
				curSelected = optionShit.length - 1;
				if (optionShit[curSelected] == "gamejooj" && (GJClient.logged || TitleState.ModoOffline))
					curSelected -=1;
			else{
				curSelected -= 1;
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		if(pode)
			//Silvio ser bulo de mais pra entender isso.
			{
				if (!selectedSomethin){
					handle_input();
					option_buttons.forEach(function(object:FlxButton){
						if (Main.getMouseVisibility() ? BSLTouchUtils.apertasimples(object) : controls.ACCEPT)
							click(object);
						else if (Main.getMouseVisibility() ? BSLTouchUtils.over(object) : curSelected == object.ID)
							hover(object);
						else if (object.alpha == 1)
							out(object);
					});
				}
			}

		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		
		if (!selectedSomethin && controls.BACK #if android || FlxG.android.justReleased.BACK #end)
		{
			selectedSomethin = true;
			GlobalSoundManager.play('cancelMenu');
			ClientPrefs.save();
			MusicBeatState.switchState(new MainMenuStateMobile());
		}#if (debug && desktop) else if (FlxG.keys.justPressed.SEVEN)
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new editors.MasterEditorMenu());
		}
		#end
			super.update(elapsed);	
		}

		function hover(object:FlxButton):Void
		{
			if (optionShit[object.ID]!="gamejooj" || (!GJClient.logged && !TitleState.ModoOffline)){
				if (object.alpha != 1){ // pra ele n ficar repetindo o som
					GlobalSoundManager.play("scrollMenu");
					object.alpha = 1;
					curSelected = object.ID;
				}
			}
		}
		
		function out(object:FlxButton):Void
		{
			object.alpha = 0.75;
		}

		function click(object:FlxButton):Void{
			if (optionShit[object.ID]!="gamejooj" || (!GJClient.logged && !TitleState.ModoOffline)){
				object.alpha=1;
				select(curSelected);
			}
		}

		function select(curSelected){
			GlobalSoundManager.play('confirmMenu');
			Main.mouse_allowed = false;
			selectedSomethin = true;
			sumidao(curSelected);
		}

		function next_state(state:String){
			switch (state)
			{
				case 'settings': MusicBeatState.switchState(new ajustes.BaseOptionsMenu()); //graficos, gameplay e etc.
				case 'controls': MusicBeatState.switchState(new #if desktop ajustes.KeysSubstate() #elseif mobile ajustes.ControlesState() #end);
				case 'arrows': MusicBeatState.switchState(new ajustes.NotesSubState());
				case 'gamejooj': MusicBeatState.switchState(new GameJoltLoginState());
				case "language": MusicBeatState.switchState(new LanguageState());
			}	
		}

		override function beatHit()
		{
			super.beatHit();
			if(isCoolBeat){boom.animation.play('idle', true);}
			isCoolBeat = !isCoolBeat;
		}
}