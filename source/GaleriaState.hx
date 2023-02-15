package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Achievements;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using StringTools;
#if desktop
import Discord.DiscordClient;
#end

class GaleriaState extends MusicBeatState
{
	var bg:FlxSprite;
	var bgmusica:FlxSprite;
	var galeriaButton:FlxButton;
	var musicButton:FlxButton;
	var testeButton:FlxButton;
	var sampleTxt:FlxText;
	//var isZoomActivated:Bool = false;
	var isGaleria:Bool = true;
	var playsArray:FlxTypedGroup<FlxSprite>;
	var menuItems:FlxTypedGroup<FlxSprite>;
	public var camAchievement:FlxCamera;

	var alturamodificadaparacalculosmuitopikas:Float=0;

	var holdthatY:Float = 0;

	var leSongs:Array<String> = [];
	var leMusic:Array<String> = [];
	
	override function create()
		{
			WeekData.reloadWeekFiles(true); //Obrigado silvio do passado por essa anotação em FreeplayState.hx
					//DaMusic part
					camAchievement = new FlxCamera();
					camAchievement.bgColor.alpha = 0;
					FlxG.cameras.add(camAchievement);

						for (i in 0...WeekData.weeksList.length) {
							var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
							for (j in 0...leWeek.songs.length) {
								leSongs.push(leWeek.songs[j][3]);
								leMusic.push(leWeek.songs[j][0]);
							}
						}
						for (i in 0...WeekData.freeplayList.length) { //Extração da lista de músicas tanto do freeplas, quanto do modo história.
							var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.freeplayList[i]);
							for (j in 0...leWeek.songs.length) {
								leSongs.push(leWeek.songs[j][3]);
								leMusic.push(leWeek.songs[j][0]);
							}
						}
						/*
						leSongs.sort(function(a,b)
							return Reflect.compare(a.toLowerCase(),b.toLowerCase())
						);
						leMusic.sort(function(a,b) //Basicamente isso faz com que a parada fique em ordem alfabética
							return Reflect.compare(a.toLowerCase(),b.toLowerCase())
						);*/

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

			testeButton = new FlxButton(FlxG.width, 100, '');
			testeButton.loadGraphic(Paths.image('sobremenu/galeria/teste', 'preload'));
			testeButton.updateHitbox();
			testeButton.x = 540;
			testeButton.y = 1916;
			testeButton.alpha = 0;
			//add(testeButton);
			
			menuItems = new FlxTypedGroup<FlxSprite>();
			add(menuItems);
			
			playsArray = new FlxTypedGroup<FlxSprite>();
			add(playsArray);
			
			for (i in 0...leSongs.length) { //Em busca da engine automática k
				var menuItem:FlxSprite = new FlxSprite(50 + 290*(i%4), 450 + 475*Math.floor(i/4)); //Nunca pensei que usaria função piso depois do fundamental
				leSongs[i]=leSongs[i].toLowerCase().replace("ç", "c"); //Você é super legal execução : D
				leSongs[i]=leSongs[i].replace("ã", "a");
				//Ahhhh mas Silvio... PQ não usar o nome real da música? ding ding ding, as músicas não ficariam em ordem alfabética
				menuItem.loadGraphic(Paths.image('galeriamusicas/gm-' + leSongs[i].toLowerCase(), 'preload'));
				menuItem.setGraphicSize(285, 360);
				menuItem.ID = i;
				menuItem.alpha = 0;
				menuItems.add(menuItem);
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				menuItem.updateHitbox();
				
				var icon:FlxSprite = new FlxSprite(0,0);
				icon.loadGraphic(Paths.image('galeriamusicas/play', 'preload'));
				icon.updateHitbox();
				icon.x = menuItem.x + (menuItem.width - icon.width)/2;
				icon.y = menuItem.y + menuItem.height + 20; //Aquele poquinhozinho omegalul
				icon.ID = i;
				icon.alpha = 0;
				icon.antialiasing = ClientPrefs.globalAntialiasing;
				playsArray.add(icon);
				add(icon);

				if(i == leSongs.length - 1)
					holdthatY = menuItem.y  + 25+15*31; //Em busca da engine automática omega kek
			}			

			galeriaButton.onDown.callback = function()
				{

					bgmusica.y=0;
					bgmusica.alpha=0;
					bg.alpha=1;
					bg.y=0;
					musicButton.y = 376;
					galeriaButton.y = 376;

					FlxG.sound.play(Paths.sound('click'));
					isGaleria=true;

					playsArray.forEach(function(spr:FlxSprite)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.y -= alturamodificadaparacalculosmuitopikas;
						}
					});
					});

					menuItems.forEach(function(spr:FlxSprite)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.40, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.y -= alturamodificadaparacalculosmuitopikas;
							}
						});
					});
				};

					galeriaButton.onOver.callback = function()
						{
							FlxG.mouse.load(Paths.image('sobremenu/galeria/pointerselected'), 1, 0, 0);
						};

					galeriaButton.onOut.callback = function()
						{
							FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
						};

			
							testeButton.onOver.callback = function()
								{
									//FlxG.mouse.load(Paths.image('sobremenu/galeria/pointerselected'), 1, 0, 0);
									sampleTxt.text="teste yey";
								};
			
								testeButton.onOut.callback = function()
									{
										//FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
										sampleTxt.text="";
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
						FlxG.sound.play(Paths.sound('click'));
						isGaleria=false;
						bg.y=0;
						bg.alpha=0;
						bgmusica.alpha=1;
						musicButton.y = 376;
						galeriaButton.y = 376;
						alturamodificadaparacalculosmuitopikas = 0;
						
						playsArray.forEach(function(spr:FlxSprite)
							{
								FlxTween.tween(spr, {alpha: 1}, 1, {
									ease: FlxEase.quadOut});
							});
		
							menuItems.forEach(function(spr:FlxSprite)
							{
								FlxTween.tween(spr, {alpha: 1}, 1, {
									ease: FlxEase.quadOut});
							});
						
					};

					musicButton.onOver.callback = function()
						{
							FlxG.mouse.load(Paths.image('sobremenu/galeria/pointerselected'), 1, 0, 0);
						};
	
						musicButton.onOut.callback = function()
							{
								FlxG.mouse.load(Paths.image('sobremenu/galeria/pointer'), 1, 0, 0);
							};

								sampleTxt = new FlxText(50, FlxG.height - 200, FlxG.width - 200, "", 30);
								sampleTxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
								sampleTxt.scrollFactor.set();
								sampleTxt.screenCenter(XY);
								sampleTxt.alpha = 1;
								//add(sampleTxt);

			super.create();
        }

		override function update(elapsed:Float)
			{

					playsArray.forEach(function(spr:FlxSprite)
					{
						
					if(FlxG.mouse.overlaps(spr)){
						FlxG.mouse.load(Paths.image('sobremenu/galeria/pointerselected'), 1, 0, 0);

						if(FlxG.mouse.justPressed)
							FlxG.sound.playMusic(Paths.inst(leMusic[spr.ID]), 0.7);
					}

					});

				if(bg.y<-8830)
					{
						Achievements.loadAchievements();
						var achieveID:Int = Achievements.getAchievementIndex('galeria');
						if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
							Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
							add(new AchievementObject('galeria', camAchievement));
							FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
							ClientPrefs.saveSettings();
						}
					}
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
										testeButton.y=1916;
									}
								else if(bg.y<0)
									{
										bg.y=bg.y+15;
										testeButton.y=testeButton.y+15;
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
								
								if(bg.y==-8842)
									{
										bg.y=-8842;
										testeButton.y=1916;
									}
								else if(bg.y>-8842)
									{
										bg.y=bg.y-15;
										testeButton.y=testeButton.y-15;
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
					}
					//Parte da Música
				else
					{
						if(FlxG.mouse.wheel>0) //Aparentemente isso aqui faz o bg subir.
							{
								//trace('estou subindo?'); //Sim
								if(bgmusica.y==0)
									{
										bgmusica.y=0;
									}
								else if(bgmusica.y<0)
								{
									bgmusica.y=bgmusica.y+15;
									alturamodificadaparacalculosmuitopikas = alturamodificadaparacalculosmuitopikas+15;
									playsArray.forEach(function(spr:FlxSprite)
										{spr.y = spr.y+15;});
						
										menuItems.forEach(function(spr:FlxSprite)
										{spr.y = spr.y+15;});
								}
								if(galeriaButton.y==376) //Isso é importante
									{
										galeriaButton.y = 376;
										musicButton.y = 376;
									}
								else
									{
										galeriaButton.y = galeriaButton.y+15;
										musicButton.y = musicButton.y+15;
									}
							
							}else if(FlxG.mouse.wheel<0){
								//trace('estou descendo?'); //Sim
								if(bgmusica.y == -holdthatY + FlxG.height)
									{
										bgmusica.y= -holdthatY + FlxG.height;
									}
								else if(bgmusica.y >-holdthatY + FlxG.height)
									{
										bgmusica.y=bgmusica.y-15;
										alturamodificadaparacalculosmuitopikas=alturamodificadaparacalculosmuitopikas-15;
										playsArray.forEach(function(spr:FlxSprite)
											{spr.y = spr.y-15;});
							
											menuItems.forEach(function(spr:FlxSprite)
											{spr.y = spr.y-15;});
									}

									if(galeriaButton.y==-376)
										{
											galeriaButton.y = -376;
											musicButton.y = -376;
										}
									else
										{
											galeriaButton.y = galeriaButton.y-15;
											musicButton.y = musicButton.y-15;
										}
							}
						
					}
				super.update(elapsed);
			}
}

//Não sei se isso ainda vai ser utilizado, então vo colocar aqui em baixo só pra tirar do meio do caminho
		
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
									if(bg.y<-8842)
										{
											bg.y=8842;
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
									if(bg.y<-8842)
										{
											bg.y=8842;
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