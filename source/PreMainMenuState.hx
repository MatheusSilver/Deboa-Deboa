package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using StringTools;

#if rpc
import Discord.DiscordClient;
#end

class PreMainMenuState extends MusicBeatState
{
	var letext:FlxText;
	var simbotao:FlxButton;
	var naobotao:FlxButton;

	override function create()
	{
		Main.mouseVisibility(true);
		#if rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence(LangUtil.getString("rpc_credit_menu", "rpc"), null);
		#end
		// FunkinLua.addShaderToCamera('orig', new ChromaticAberrationEffect(0.0010));
		var supbg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ph'));
		supbg.antialiasing = ClientPrefs.globalAntialiasing;
		supbg.updateHitbox();
		supbg.alpha = 1;
		add(supbg);
		letext = new FlxText(50, FlxG.height - 600, FlxG.width - 100, "Parece que é sua primeira vez aqui, quer assistir ao vídeo?", 32);
		letext.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		letext.scrollFactor.set();
		letext.alpha = 0;
		add(letext);
		ClientPrefs.firstTime = false;
		ClientPrefs.save();
		simbotao = new FlxButton(FlxG.width, 100, '');
		simbotao.loadGraphic(Paths.image('mainmenu/btsim', 'preload'));
		simbotao.setGraphicSize(Std.int(simbotao.width * 0.75));

		simbotao.updateHitbox();
		simbotao.x = 470;
		simbotao.y = 1500;
		simbotao.alpha = 0.75;
		add(simbotao);

		naobotao = new FlxButton(FlxG.width, 100, '');
		naobotao.loadGraphic(Paths.image('mainmenu/btnao', 'preload'));
		naobotao.setGraphicSize(Std.int(naobotao.width * 0.75));

		naobotao.updateHitbox();
		naobotao.x = 470;
		naobotao.y = 1500;
		naobotao.alpha = 0.75;
		add(naobotao);

		FlxTween.tween(letext, {alpha: 1}, 1.0, {ease: FlxEase.expoInOut});
		FlxTween.tween(simbotao, {y: 250}, 1.5, {ease: FlxEase.expoInOut}); // tá ai dav
		FlxTween.tween(naobotao, {y: 395}, 2.3, {ease: FlxEase.expoInOut});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		simbotao.onOver.callback = simHover;
		simbotao.onOut.callback = simOut;
		simbotao.onDown.callback = simClick;
		naobotao.onOver.callback = naoHover;
		naobotao.onOut.callback = naoOut;
		naobotao.onDown.callback = naoClick;
	}

	function simHover():Void
	{
		simbotao.alpha = 1;
		GlobalSoundManager.play('scrollMenu');
	}

	function simOut():Void
	{
		simbotao.alpha = 0.75;
	}

	function simClick():Void
	{
		GlobalSoundManager.play('confirmMenu');
		#if desktop
		VideoStatePC.specialSetting = NORMAL;
		VideoStatePC.videoPath = Paths.video("aviso.mp");
		VideoStatePC.NextState = new MainMenuStateMobile();
		MusicBeatState.switchState(new VideoStatePC());
		#elseif mobile
		LoadingState.loadAndSwitchState(new VideoState('assets/videos/aviso.mp', new MainMenuStateMobile()));
		#end
	}

	function naoHover():Void
	{
		naobotao.alpha = 1;
		GlobalSoundManager.play('scrollMenu');
	}

	function naoOut():Void
	{
		naobotao.alpha = 0.75;
	}

	function naoClick():Void
	{
		GlobalSoundManager.play('confirmMenu');
		MusicBeatState.switchState(new MainMenuStateMobile());
	}
}
