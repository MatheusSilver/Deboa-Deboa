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
	//var isZoomActivated:Bool = false;
	var isGaleria:Bool = true;
	var playsArray:FlxTypedGroup<FlxSprite>;
	var menuItems:FlxTypedGroup<FlxSprite>;
	public var camAchievement:FlxCamera;

	var mouseskin:String = '';

	var alturamodificadaparacalculosmuitopikas:Float=0;
	var clicavel:Bool = true;

	var holdthatY:Float = 0;

	public static var firsttimemusic:Bool = true;

	public static var leSongs:Array<String> = [];
	public static var leMusic:Array<String> = [];
	public static var titulos:Array<String> = []; //Usados apenas para integração com o Discord por causa dos malditos acentos da lingua portuguesa.
	
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
					titulos.push(leWeek.songs[j][3]);
					}
			}
			for (i in 0...WeekData.freeplayList.length) { //Extração da lista de músicas tanto do freeplas, quanto do modo história.
				var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.freeplayList[i]);
				for (j in 0...leWeek.songs.length) {
					leSongs.push(leWeek.songs[j][3]);
					leMusic.push(leWeek.songs[j][0]);
					titulos.push(leWeek.songs[j][3]);
				}
			}

			//DaGaleria part

			FlxG.mouse.visible = true;
			#if desktop
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Vendo a galeria", null);
			#end
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/galeria/galeria_back'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.updateHitbox();
			bg.alpha = 1;
            bg.y=0;

			bgmusica = new FlxSprite(0, 0).loadGraphic(Paths.image('sobremenu/galeria/galeria-musicas_back'));
			bgmusica.antialiasing = ClientPrefs.globalAntialiasing;
			bgmusica.updateHitbox();
			bgmusica.alpha = 0;
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
				var menuItem:FlxSprite = new FlxSprite(50 + 290*(i%4), 450 + 475*Math.floor(i/4)); //Nunca pensei que usaria função piso depois do fundamental
				leSongs[i]=leSongs[i].toLowerCase().replace("ç", "c"); //Você é super legal execução : D
				leSongs[i]=leSongs[i].replace("ã", "a");	
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

			musicButton = new FlxButton(FlxG.width, 100, '');
			musicButton.loadGraphic(Paths.image('sobremenu/galeria/button', 'preload'));
			musicButton.updateHitbox();
			musicButton.x = 640;
			musicButton.y = 376;
			musicButton.alpha = 0;
			add(musicButton);

			super.create();
        }

		public static var stoploading:Bool = false;

		override function closeSubState()
			{
				
				DiscordClient.changePresence("Vendo a galeria", null);
				stoploading = false;

				persistentDraw = true;
				persistentUpdate = true;

				
				playsArray.visible = true;
				menuItems.visible = true;

				super.closeSubState();
			}

		override function update(elapsed:Float)
			{		

				//A ordem aparentemente faz uma diferença ferrada na otimização disso.
				if(!stoploading){
				if(FlxG.mouse.overlaps(playsArray) || (FlxG.mouse.overlaps(galeriaButton)&&!isGaleria) || (FlxG.mouse.overlaps(musicButton)&&isGaleria)){
					if(mouseskin != "pointerselected"){
						mouseskin = 'pointerselected';
						FlxG.mouse.load(Paths.image('sobremenu/galeria/'+mouseskin), 1, 0, 0);
					}
				}else if (mouseskin!='pointer'){
					mouseskin = 'pointer';
					FlxG.mouse.load(Paths.image('sobremenu/galeria/'+ mouseskin), 1, 0, 0);
				}

				menuItems.forEach(function(spr:FlxSprite)
				{					
					if(!isGaleria){
						if(spr.y < FlxG.height + 500 && spr.y > bgmusica.y -500)
							spr.visible = true;
						else
							spr.visible = false;
					}
				});

				playsArray.forEach(function(spr:FlxSprite) //Aparentemente, quem controla se um objeto é ou não renderizado pela placa de vídeo é o visible ;-;
				{	
					if(!isGaleria){
						if(spr.y < FlxG.height + 500 && spr.y > bgmusica.y -500)
						spr.visible = true;
					else
						spr.visible = false;
					}

					if(FlxG.mouse.justPressed && clicavel)
					{
						if(FlxG.mouse.overlaps(spr)){
							stoploading = true;
							FlxG.sound.play(Paths.sound('click'));
							playsArray.visible = false;
							menuItems.visible = false;
							persistentDraw = false;
							persistentUpdate = false;
							openSubState(new GaleriaSubStateMusic(spr.ID));
						}else if (FlxG.mouse.overlaps(galeriaButton) && !isGaleria){
							galeriapressed();
							FlxG.sound.play(Paths.sound('click'));
						}else if (FlxG.mouse.overlaps(musicButton) && isGaleria){
							musicpressed();
							FlxG.sound.play(Paths.sound('click'));
						}
					}

				});
				}

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
					mouseskin = '';
					FlxG.mouse.unload();
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new SobreState());
				}
				if(isGaleria)
					{
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
							}
						else if(FlxG.mouse.wheel<0)
							{
								
								if(bg.y==-8842)
									{
										bg.y=-8842;
									}
								else if(bg.y>-8842)
									{
										bg.y=bg.y-15;
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

			function musicpressed(){
				isGaleria=false;
				bg.y=0;
				bg.alpha=0;
				bgmusica.alpha=1;
				musicButton.y = 376;
				galeriaButton.y = 376;
				clicavel = false;
				alturamodificadaparacalculosmuitopikas = 0;
				
				playsArray.forEach(function(spr:FlxSprite)
					{
						FlxTween.tween(spr, {alpha: 1}, 0.1, {
							ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							clicavel = true;
						}
						});
					});

					menuItems.forEach(function(spr:FlxSprite)
					{
						FlxTween.tween(spr, {alpha: 1}, 0.1, {
							ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							clicavel = true;
						}
						});
					});
			}

			function galeriapressed()
			{
				bgmusica.y=0;
				bgmusica.alpha=0;
				bg.alpha=1;
				bg.y=0;
				musicButton.y = 376;
				galeriaButton.y = 376;
				clicavel = false;

				isGaleria=true;

				playsArray.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.1, {
						ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.y -= alturamodificadaparacalculosmuitopikas;
						clicavel = true;
					}
				});
				});

				menuItems.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.1, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.y -= alturamodificadaparacalculosmuitopikas;
						}
					});
				});
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