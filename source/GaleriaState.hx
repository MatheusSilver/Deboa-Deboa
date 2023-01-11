package;

import flixel.addons.ui.FlxSlider;
import flixel.util.FlxTimer;
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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;
using StringTools;

class GaleriaState extends MusicBeatState
{
	var bg:FlxSprite;
	var bgmusica:FlxSprite;
	var galeriaButton:FlxButton;
	var musicButton:FlxButton;
	//var isZoomActivated:Bool = false;
	var isGaleria:Bool = true;
	var playsArray:FlxTypedGroup<FlxSprite>;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var leSongs:Array<String> = [];
	
	override function create()
		{

					//DaMusic part

						for (i in 0...WeekData.freeplayList.length) { //Extração da lista de músicas tanto do freeplas, quanto do modo história.
							var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.freeplayList[i]);
							var leSongs:Array<String> = [];
							for (j in 0...leWeek.songs.length) {
								leSongs.push(leWeek.songs[j][3]);
							}
						}
						for (i in 0...WeekData.weeksList.length) {
							var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
							var leSongs:Array<String> = [];
							for (j in 0...leWeek.songs.length) {
								leSongs.push(leWeek.songs[j][3]);
							}
						}

			//DaGaleria part

			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo a galeria", null);
			#end
            FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/galeria/galeria_back'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			bg.alpha = 1;
            bg.y=0;

			bgmusica = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/galeria/galeria-musicas_back'));
			bgmusica.antialiasing = ClientPrefs.globalAntialiasing;
			bgmusica.updateHitbox();
			bgmusica.alpha = 1;
            bgmusica.y=0;
			
			add(bg);
			add(bgmusica);
			galeriaButton = new FlxButton(FlxG.width, 100, '');
			galeriaButton.loadGraphic(Paths.image('sobremenu/galeria/button', 'preload'));
			galeriaButton.updateHitbox();
			galeriaButton.x = 491;
			galeriaButton.y = 376;
			galeriaButton.alpha = 0;
			add(galeriaButton);
			
						menuItems = new FlxTypedGroup<FlxSprite>();
						add(menuItems);
			
						playsArray = new FlxTypedGroup<FlxSprite>();
						add(playsArray);
			
						for (i in 0...leSongs.length) { //Em busca da engine automática k
							var menuItem:FlxSprite = new FlxSprite(50 + 290*(i%4), Math.floor(i/4)); //Nunca pensei que usaria função piso depois do fundamental
							menuItem.loadGraphic(Paths.image('galeriamusicas/gm-' + leSongs[i].toLowerCase(), 'preload'));
							menuItem.setGraphicSize(285, 360);
							menuItem.ID = i;
							menuItems.add(menuItem);
							menuItem.visible = !isGaleria;
							menuItem.antialiasing = ClientPrefs.globalAntialiasing;
							menuItem.updateHitbox();
				
							var icon:FlxSprite = new FlxSprite(0,0);
							icon.loadGraphic(Paths.image('galeriamusicas/play', 'preload'));
							icon.x = (menuItem.x + menuItem.width - menuItem.width)/2;
							icon.y = menuItem.y + menuItem.height;
							icon.visible = !isGaleria;
							icon.ID = i;
							icon.antialiasing = ClientPrefs.globalAntialiasing;
							playsArray.add(icon);
							add(icon);
						}
			
						//Na real, se pa a única coisa que talvez vá ser aproveitada desse code, é o sistema de formação de lista de icons...
			

			galeriaButton.onDown.callback = function()
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					isGaleria=true;
				};

				galeriaButton.onOver.callback = function()
					{
						FlxG.mouse.load(Paths.image('sobremenu/galeria/pointerselected'), 1, 0, 0);
					};

					galeriaButton.onOut.callback = function()
						{
							FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
						};

				musicButton = new FlxButton(FlxG.width, 100, '');
				musicButton.loadGraphic(Paths.image('sobremenu/galeria/button', 'preload'));
				musicButton.updateHitbox();
				musicButton.x = 640;
				musicButton.y = 376;
				musicButton.alpha = 0;
				add(musicButton);

				musicButton.onDown.callback = function()
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
						isGaleria=false;
						playsArray.visible = true;
						menuItems.visible = true;
						
					};

					musicButton.onOver.callback = function()
						{
							FlxG.mouse.load(Paths.image('sobremenu/galeria/pointerselected'), 1, 0, 0);
						};
	
						musicButton.onOut.callback = function()
							{
								FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
							};

			super.create();
        }

		override function update(elapsed:Float)
			{
				
				if (controls.BACK) {
					FlxG.mouse.unload();
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new SobreState());
				}
				if(isGaleria)
					{
						bg.alpha=1;
						bgmusica.alpha=0;
						if(FlxG.mouse.wheel>0)
							{
								if(bg.y==0)
									{
										bg.y=0;
									}
								else if(bg.y<0)
									{
										bg.y=bg.y+15;
									}

								if(galeriaButton.y==376)
									{
										galeriaButton.y = 376;
									}
								else
									{
										galeriaButton.y = galeriaButton.y+15;
									}

									if(musicButton.y==376)
										{
											musicButton.y = 376;
										}
									else
										{
											musicButton.y = musicButton.y+15;
										}
							}
						else if(FlxG.mouse.wheel<0)
							{
								if(bg.y==-2422)
									{
										bg.y=-2422;
									}
								else if(bg.y>-2422)
									{
										bg.y=bg.y-15;
									}

									if(galeriaButton.y==-376)
										{
											galeriaButton.y = -376;
										}
									else
										{
											galeriaButton.y = galeriaButton.y-15;
										}

										if(musicButton.y==-376)
											{
												musicButton.y = -376;
											}
										else
											{
												musicButton.y = musicButton.y-15;
											}
							}
		
							/*if(isZoomActivated)
								{
									//FlxG.camera.setPosition(FlxG.mouse.screenX, 0);
									FlxTween.tween(FlxG.camera, {zoom: 2}, 0.3, {ease: FlxEase.quartInOut});
									//FlxG.camera.zoom=2;
									bg.x=FlxG.mouse.x-640;
									//bg.y=FlxG.mouse.y;
									if(bg.y>0)
										{
											bg.y=0;
										}
									if(bg.y<-2422)
										{
											bg.y=2422;
										}
								}
							else
								{
									FlxG.camera.x=0;
									FlxG.camera.y=0;
									//FlxG.camera.setPosition(0, 0);
									FlxTween.tween(FlxG.camera, {zoom: 1}, 0.3, {ease: FlxEase.quartInOut});
									bg.x=0;
									/*if(bg.y>0)
										{
											bg.y=0;
										}
									if(bg.y<-2422)
										{
											bg.y=2422;
										}
								}*/
		
						/*if(FlxG.mouse.justReleased && isZoomActivated)
							{
								isZoomActivated = false;
							}
						else if(FlxG.mouse.justReleased && !isZoomActivated)
							{
								isZoomActivated=true;
							}*/
					}
				else
					{
						bg.y=0;
						bg.alpha=0;
						bgmusica.alpha=1;
						musicButton.y = 376;
						galeriaButton.y = 376;
					}
				super.update(elapsed);
			}

}