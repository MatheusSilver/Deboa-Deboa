package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
using StringTools;

class SobreState extends MusicBeatState
{
	var videoMenu:FlxSprite = new FlxSprite(0,0);
	var video:MP4Handler = new MP4Handler();
	//var letext:FlxText;
	var bg:FlxSprite;
	var faixa:FlxSprite;
	var gtext:FlxSprite;
	var ctext:FlxSprite;
	var exe:FlxButton;
	var saster:FlxButton;
	var sunny:FlxButton;
	var vio:FlxButton;
	var dav:FlxButton;
	var arrow:FlxButton;
	var curSection:Int=0;
	
	override function create()
		{
			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo o sobre", null);
			#end
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (back)'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			//bg.setGraphicSize(Std.int(0.5));
			bg.alpha = 1;
			add(bg);

			faixa = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (faixa)'));
			faixa.antialiasing = ClientPrefs.globalAntialiasing;
			faixa.updateHitbox();
			//faixa.setGraphicSize(Std.int(0.5));
			faixa.alpha = 1;
			add(faixa);

			gtext = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (txt-galeriavideo)'));
			gtext.antialiasing = ClientPrefs.globalAntialiasing;
			gtext.updateHitbox();
			gtext.x = 107;
			gtext.y=40;
			//gtext.setGraphicSize(Std.int(0.5));
			gtext.alpha = 1;
			add(gtext);

			ctext = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/sobre (txt-creditos)'));
			ctext.antialiasing = ClientPrefs.globalAntialiasing;
			ctext.updateHitbox();
			ctext.x = 666; // btw, isso n foi intencional
			ctext.y = 36;
			//ctext.setGraphicSize(Std.int(0.5));
			ctext.alpha = 1;
			add(ctext);

			exe = new FlxButton(FlxG.width, 100, '');
			exe.loadGraphic(Paths.image('sobremenu/bts/btexe', 'preload'));
			//exe.setGraphicSize(Std.int(0.5));
	
			exe.updateHitbox();
			exe.x = 655;
			exe.y = 280;
			exe.alpha = 0.75;
			add(exe);

			saster = new FlxButton(FlxG.width, 100, '');
			saster.loadGraphic(Paths.image('sobremenu/bts/btsaster', 'preload'));
			//saster.setGraphicSize(Std.int(0.5));
	
			saster.updateHitbox();
			saster.x = 640;
			saster.y = 470;
			saster.alpha = 0.75;
			add(saster);

			sunny = new FlxButton(FlxG.width, 100, '');
			sunny.loadGraphic(Paths.image('sobremenu/bts/btsunny', 'preload'));
			//sunny.setGraphicSize(Std.int(0.5));
	
			sunny.updateHitbox();
			sunny.x = 47;
			sunny.y = 93;
			sunny.alpha = 0.75;
			add(sunny);

			vio = new FlxButton(FlxG.width, 100, '');
			vio.loadGraphic(Paths.image('sobremenu/bts/btvio', 'preload'));
			//vio.setGraphicSize(Std.int(0.5));
	
			vio.updateHitbox();
			vio.x = 640;
			vio.y = 66;
			vio.alpha = 0.75;
			add(vio);

			dav = new FlxButton(FlxG.width, 100, '');
			dav.loadGraphic(Paths.image('sobremenu/bts/btdav', 'preload'));
			//dav.setGraphicSize(Std.int(0.5));
	
			dav.updateHitbox();
			dav.x = 51;
			dav.y = 282;
			dav.alpha = 0.75;
			add(dav);

			arrow = new FlxButton(FlxG.width, 100, '');
			arrow.loadGraphic(Paths.image('sobremenu/arrow', 'preload'));
			//exe.setGraphicSize(Std.int(0.5));
	
			arrow.updateHitbox();
			arrow.x = 280;
			arrow.y = 272;
			arrow.alpha = 0.75;
			add(arrow);
			/*letext = new FlxText(50, FlxG.height - 600, FlxG.width - 95, "SOBRE", 32);
			letext.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			letext.scrollFactor.set();
			letext.alpha = 1;
			add(letext);*/
			/*videobotao = new FlxButton(FlxG.width, 100, '');
			videobotao.loadGraphic(Paths.image('mainmenu/btvideo', 'preload'));
			videobotao.setGraphicSize(Std.int(videobotao.width * 0.75));
	
			videobotao.updateHitbox();
			videobotao.x = 385;
			videobotao.y = 250;
			videobotao.alpha = 0.75;
			add(videobotao);

			credbotao = new FlxButton(FlxG.width, 100, '');
			credbotao.loadGraphic(Paths.image('mainmenu/btcr', 'preload'));
			credbotao.setGraphicSize(Std.int(credbotao.width * 0.75));
	
			credbotao.updateHitbox();
			credbotao.x = 385;
			credbotao.y = 415;
			credbotao.alpha = 0.75;
			add(credbotao);*/
			updateuwu();
			/*#if mobileC
			addVirtualPad(LEFT_RIGHT, A_B);
			#end*/
			super.create();
		}
	override function update(elapsed:Float)
		{
			if(curSection==0)
				{
					arrow.flipX=false;
					arrow.x = 280;
					arrow.y=272;
					arrow.updateHitbox();
				}
			else
				{
					arrow.flipX=true;
					arrow.x = 836;
					arrow.y=272;
					arrow.updateHitbox();
				}
            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuStateMobile());
            }

			/*if(controls.UI_LEFT_P || controls.UI_RIGHT_P) { //ok
				FlxG.sound.play(Paths.sound('scrollMenu'), 1);
				if(curSection==0)
					{
						curSection=1;
						arrow.flipX=false;
						arrow.x = 280;
						arrow.y=272;
						arrow.updateHitbox();
					}
				else
					{
						curSection=0;
						arrow.flipX=true;
						arrow.x = 836;
						arrow.y=272;
						arrow.updateHitbox();
					}
					updateuwu();
			}*/
			super.update(elapsed);
            if(FlxG.sound.music.volume==0) {
                FlxG.sound.music.fadeIn(4, 0, 0.7);
            }
			// agr que eu vi que eu fui burro mas to com preguiça de consertar tudo que eu fiz de errado :)
			// o importante é que funciona

			//section 0
			vio.onOver.callback = vioHover;
			vio.onOut.callback = vioOut;
			vio.onDown.callback = vioClick;
			exe.onOver.callback = exeHover;
			exe.onOut.callback = exeOut;
			exe.onDown.callback = exeClick;
			saster.onOver.callback = sasterHover;
			saster.onOut.callback = sasterOut;
			saster.onDown.callback = sasterClick;

			//section 1
			sunny.onOver.callback = sunnyHover;
			sunny.onOut.callback = sunnyOut;
			sunny.onDown.callback = sunnyClick;
			dav.onOver.callback = davHover;
			dav.onOut.callback = davOut;
			dav.onDown.callback = davClick;

			//arrow
			arrow.onOver.callback = function()
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 1);
				arrow.alpha=1;
			};

			arrow.onOut.callback = function()
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 1);
				arrow.alpha=0.75;
			};


			arrow.onDown.callback = function()
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				arrow.alpha=1;
				if(curSection==0)
					{
						curSection=1;
					}
				else
					{
						curSection=0;
					}
					updateuwu();
			};
		}

		function vioHover():Void
			{
				if(curSection==0)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 1);
						vio.alpha=1;
					}
			}
			function vioOut():Void
				{
					if(curSection==0)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'), 1);
							vio.alpha=0.75;
						}
				}
				function vioClick():Void
					{
						if(curSection==0)
							{
								FlxG.sound.play(Paths.sound('confirmMenu'));
								vio.alpha=1;
								//evento quando clicar
							}
					}
					function exeHover():Void
						{
							if(curSection==0)
								{
									FlxG.sound.play(Paths.sound('scrollMenu'), 1);
									exe.alpha=1;
								}
						}
						function exeOut():Void
							{
								if(curSection==0)
									{
										FlxG.sound.play(Paths.sound('scrollMenu'), 1);
										exe.alpha=0.75;
									}
							}
							function exeClick():Void
								{
									if(curSection==0)
										{
											FlxG.sound.play(Paths.sound('confirmMenu'));
											exe.alpha=1;
											MusicBeatState.switchState(new CreditsMods());
										}
								}
								function sasterHover():Void
									{
										if(curSection==0)
											{
												FlxG.sound.play(Paths.sound('scrollMenu'), 1);
												saster.alpha=1;
											}
									}
									function sasterOut():Void
										{
											if(curSection==0)
												{
													FlxG.sound.play(Paths.sound('scrollMenu'), 1);
													saster.alpha=0.75;
												}
										}
										function sasterClick():Void
											{
												if(curSection==0)
													{
														FlxG.sound.play(Paths.sound('confirmMenu'));
														saster.alpha=1;
														MusicBeatState.switchState(new CreditsMusics());
													}
											}
			
											function sunnyHover():Void
												{
													if(curSection==1)
														{
															FlxG.sound.play(Paths.sound('scrollMenu'), 1);
															sunny.alpha=1;
														}
												}
												function sunnyOut():Void
													{
														if(curSection==1)
															{
																FlxG.sound.play(Paths.sound('scrollMenu'), 1);
																sunny.alpha=0.75;
															}
													}
													function sunnyClick():Void
														{
															if(curSection==1)
																{
																	FlxG.sound.play(Paths.sound('confirmMenu'));
																	sunny.alpha=1;
																	//evento quando clicar
																}
														}

														function davHover():Void
															{
																if(curSection==1)
																	{
																		FlxG.sound.play(Paths.sound('scrollMenu'), 1);
																		dav.alpha=1;
																	}
															}
															function davOut():Void
																{
																	if(curSection==1)
																		{
																			FlxG.sound.play(Paths.sound('scrollMenu'), 1);
																			dav.alpha=0.75;
																		}
																}
																function davClick():Void
																	{
																		if(curSection==1)
																			{
																				FlxG.sound.play(Paths.sound('confirmMenu'));
																				dav.alpha=1;
																				//evento quando clicar
																			}
																	}

	function updateuwu():Void
		{
			if(curSection==0)
				{
					faixa.x = 636;
					gtext.alpha=0;
					dav.alpha=0;
					saster.alpha=0.75;
					ctext.alpha=1;
					vio.alpha=0.75;
					exe.alpha=0.75;
					sunny.alpha=0;
				}
			else
				{
					faixa.x = 43;
					gtext.alpha=1;
					dav.alpha=0.75;
					saster.alpha=0;
					ctext.alpha=0;
					vio.alpha=0;
					exe.alpha=0;
					sunny.alpha=0.75;
				}
		}
}
