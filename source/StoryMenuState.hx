package;

import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

using StringTools;


#if windows
import Discord.DiscordClient;
#end

class StoryMenuState extends MusicBeatState
{
	var ezbg:FlxSprite;

	var elevador:Float = -1;

	var curdiff:Int = 3;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var portrait3:FlxSprite;

	var portrait2:FlxSprite;

	var portrait1:FlxSprite;

	var titulo1:FlxSprite;

	var titulo2:FlxSprite;

	var titulo3:FlxSprite;

	public static var nomedamusica = ['Lerdeza', 'Não Pode Fugir', 'Conflito Triplo', 'Gran Finale'];

	var real:Int = 0;

	var oneclickpls:Bool = true;

	var sonic1:FlxSprite;
	var sonic2:FlxSprite;
	var sonic3:FlxSprite;

	var setabaixo:FlxSprite;

	var songArray = ['too-slow', 'you-cant-run', 'triple-trouble'];

	var redBOX:FlxSprite;

	//var staticscreen:FlxSprite;

	override function create()
	{
		Main.dumpCache();
		FlxG.sound.playMusic(Paths.music('storymodemenumusic'), 1, true);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Modo História: Conflito Triplo", null);
		#end

		var bg:FlxSprite;

		bg = new FlxSprite(0, 0); //ok
		bg.frames = Paths.getSparrowAtlas('exestuff/SMMStatic');
		bg.animation.addByPrefix('idlexd', "damfstatic", 24);
		bg.animation.play('idlexd');
		bg.alpha = 1;
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 2));
		bg.updateHitbox();
		add(bg);
		
		portrait1 = new FlxSprite(108, 500);

		portrait1 = new FlxSprite().loadGraphic(Paths.image('quadros/' + songArray[0]));
		portrait1.setGraphicSize(Std.int(portrait1.width * 0.65));
		portrait1.antialiasing = true;
		portrait1.x += 245 - 215;
		portrait1.y += 100;
		portrait1.updateHitbox();

		add(portrait1);

		portrait2 = new FlxSprite(108, 500);

		portrait2 = new FlxSprite().loadGraphic(Paths.image('quadros/' + songArray[1]));
		portrait2.setGraphicSize(Std.int(portrait2.width * 0.65));
		portrait2.antialiasing = true;
		portrait2.x += 245 + 420*1 - 215;
		portrait2.y += 100;
		portrait2.updateHitbox();

		add(portrait2);

		portrait3 = new FlxSprite(108, 500); //Resquiscios de um ato desesperado de um homem pistola com isso.

		portrait3 = new FlxSprite().loadGraphic(Paths.image('quadros/' + songArray[2]));
		portrait3.setGraphicSize(Std.int(portrait3.width * 0.65));
		portrait3.antialiasing = true;
		portrait3.x += 245 + 420*2 - 215;
		portrait3.y += 100;
		portrait3.updateHitbox();

		add(portrait3);

		redBOX = new FlxSprite(portrait1.x, portrait1.y).loadGraphic(Paths.image('exestuff/redbox'));
		redBOX.alpha = 1;
		redBOX.setGraphicSize(Std.int(portrait3.width));
		redBOX.antialiasing = true;
		redBOX.updateHitbox();

		#if mobileC
		addVirtualPad(FULL, A_B);
		#end

		add(redBOX);

		sonic1 = new FlxSprite(0, 0); //ok
		sonic1.frames = Paths.getSparrowAtlas('exestuff/sonic');
		sonic1.animation.addByPrefix('idle1', "SONICmoveIDLE", 28);
		sonic1.animation.addByPrefix('risada1', "SONIClaugh", 48);
		sonic1.animation.play('idle1');
		sonic1.alpha = 1;
		sonic1.x = portrait1.x + 125;
		sonic1.y = portrait1.y + 220;
		sonic1.antialiasing = true;
		sonic1.setGraphicSize(Std.int(sonic1.width * 0.32));
		sonic1.updateHitbox();
		add(sonic1);

		sonic2 = new FlxSprite(0, 0); //ok
		sonic2.frames = Paths.getSparrowAtlas('exestuff/P2Sonic_Assets');
		sonic2.animation.addByPrefix('idle2', "NewPhase2Sonic Idle instance ", 18);
		sonic2.animation.addByPrefix('risada2', "NewPhase2Sonic Laugh instance ", 48);
		sonic2.animation.play('idle2');
		sonic2.animation.stop();
		sonic2.alpha = 1;
		sonic2.x = portrait2.x + 125 - 40 + 14;
		sonic2.y = sonic1.y -13;
		sonic2.antialiasing = true;
		sonic2.setGraphicSize(Std.int(sonic2.width * 0.2975));
		sonic2.updateHitbox();
		add(sonic2);

		sonic3 = new FlxSprite(0, 0); //ok
		sonic3.frames = Paths.getSparrowAtlas('exestuff/BeastTP');
		sonic3.animation.addByPrefix('idle3', "Beast_IDLE", 30);
		sonic3.animation.addByPrefix('risada3', "Beast_LAUGH", 48);
		sonic3.animation.play('idle3');
		sonic3.animation.stop();
		sonic3.alpha = 1;
		sonic3.x = portrait3.x + 125;
		sonic3.y = sonic1.y;
		sonic3.antialiasing = true;
		sonic3.setGraphicSize(Std.int(sonic2.width * 0.75));
		sonic3.updateHitbox();
		add(sonic3);

		setabaixo = new FlxSprite(portrait1.x, portrait1.y).loadGraphic(Paths.image('exestuff/seta_pra_baixo')); 
		setabaixo.alpha = 1; //baixo só que pra cima
		setabaixo.setGraphicSize(Std.int(setabaixo.width * 0.25));
		setabaixo.x = portrait2.x + 100 + 105 - 43;
		setabaixo.y = portrait2.y - 65 - 10 - 15;
		setabaixo.antialiasing = true;
		setabaixo.updateHitbox();	
		add(setabaixo);
		FlxTween.tween(setabaixo, {y: setabaixo.y - 15}, 3, {ease: FlxEase.quadInOut, type: PINGPONG});

		titulo1 = new FlxSprite(portrait1.x, portrait1.y).loadGraphic(Paths.image('exestuff/Titulo[0]'));
		titulo1.alpha = 1;
		titulo1.setGraphicSize(Std.int(titulo1.width * 1.25));
		titulo1.visible = true;
		titulo1.x = portrait2.x - 25 - 20;
		titulo1.y = portrait2.y + portrait2.height + 75 - 45 - 15;
		titulo1.antialiasing = true;
		titulo1.updateHitbox();
		add(titulo1);

		titulo2 = new FlxSprite(portrait1.x, portrait1.y).loadGraphic(Paths.image('exestuff/Titulo[1]'));
		titulo2.alpha = 1;
		titulo2.setGraphicSize(Std.int(titulo1.width));
		titulo2.visible = false;
		titulo2.x = titulo1.x;
		titulo2.y = titulo1.y;
		titulo2.antialiasing = true;
		titulo2.updateHitbox();
		add(titulo2);

		titulo3 = new FlxSprite(portrait1.x, portrait1.y).loadGraphic(Paths.image('exestuff/Titulo[2]'));
		titulo3.alpha = 1;
		titulo3.setGraphicSize(Std.int(titulo1.width));
		titulo3.visible = false;
		titulo3.x = titulo1.x;
		titulo3.y = titulo1.y;
		titulo3.antialiasing = true;
		titulo3.updateHitbox();
		add(titulo3);

		super.create();
	}

	function changeAct(diff:Int = 1)
	{
			FlxG.sound.play(Paths.sound('scrollMenu'));


			real += diff;
			if (real < 0)
				real = songArray.length - 1;
			else if (real > songArray.length - 1)
				real = 0;

			redBOX.x = portrait1.x + real*(portrait2.x - portrait1.x);



			if(real == 0){
				sonic1.animation.play('idle1');
				sonic2.animation.stop();
				sonic3.animation.stop();
				titulo1.visible = true;
				titulo2.visible = false;
				titulo3.visible = false;
			} else if (real == 1) {
				sonic2.animation.play('idle2');
				sonic1.animation.stop();
				sonic3.animation.stop();
				titulo2.visible = true;
				titulo1.visible = false;
				titulo3.visible = false;
			} else {
				sonic3.animation.play('idle3');
				sonic1.animation.stop();
				sonic2.animation.stop();
				titulo3.visible = true;
				titulo1.visible = false;
				titulo2.visible = false;
			}
		}

	override public function update(elapsed:Float)
	{

		if (controls.UI_LEFT_P && oneclickpls)
		{
				changeAct(-1);
		}

		if (controls.UI_RIGHT_P && oneclickpls)
		{
				changeAct(1);
		}

		if (controls.UI_UP_P && oneclickpls)
			{
				PlayState.SONG = Song.loadFromJson('final-escape' + '-hard', 'final-escape');
				PlayState.isStoryMode = false;
				MusicBeatState.switchState(new PlayState());
			}

		if (controls.BACK && oneclickpls)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.sound.music.fadeOut(0.5, 0);
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{ 
					MusicBeatState.switchState(new MainMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
				});
		}

		if (controls.ACCEPT)
		{
			if (oneclickpls)
			{
				oneclickpls = false;


				FlxG.sound.play(Paths.sound('risada_du_mal'));
				FlxG.camera.flash(FlxColor.RED, 0.5);

					PlayState.SONG = Song.loadFromJson(songArray[real].toLowerCase() + '-hard', songArray[real].toLowerCase());


				if (songArray[real] == 'too-slow')
				{
					sonic1.animation.play("risada1");
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{ 
							PlayState.storyPlaylist = ['too-slow', 'you-cant-run', 'triple-trouble', 'final-escape'];
							MusicBeatState.switchState(new PlayState());
							PlayState.isStoryMode = true;
						});
				} else {
					if (songArray[real] == 'you-cant-run'){
						sonic2.animation.play("risada2");
					} else {
						sonic3.animation.play("risada3");
					}
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{ 
							PlayState.isStoryMode = false;
							MusicBeatState.switchState(new PlayState());
						});
				}
			}
			}

			if (FlxG.save.data.flashing)
			{
				FlxFlicker.flicker(redBOX, 1, 0.06, false, false, function(flick:FlxFlicker) {});
			}

		super.update(elapsed);
	}
}