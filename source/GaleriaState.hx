package;

import flixel.util.FlxTimer;
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
#if rpc
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
	var isMiddleClicking:Bool = false;

	var alturamodificadaparacalculosmuitopikas:Float=0;
	var clicavel:Bool = true;

	var holdthatY:Float = 0;

	public static var firsttimemusic:Bool = true;

	public static var leSongs:Array<String> = [];
	public static var leMusic:Array<String> = [];
	public static var titulos:Array<String> = []; //Usados apenas para integração com o Discord por causa dos malditos acentos da lingua portuguesa.
	
	override function create()
		{
			Paths.clearStoredMemory();
			Paths.clearUnusedMemory();

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

			if (FlxG.save.data.likesMap==null){
				for (i in 0...titulos.length){
					ClientPrefs.likesMap.set(titulos[i], "neutral");
				}
			}

			//DaGaleria part

			Main.mouse_allowed = true;
			#if rpc
			// Updating Discord Rich Presence
			DiscordClient.changePresence(LangUtil.getString("rpc_galeria", "rpc"), null);
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
			galeriaButton = new FlxButton(FlxG.width, 100, LangUtil.getString("gall_gallery_button", "gallery"));
			galeriaButton.makeGraphic(158,50, FlxColor.TRANSPARENT);
			galeriaButton.label.setFormat(LangUtil.getFont("roboto"), 24, CoolUtil.colorFromString("0xc6c6c6"), CENTER);
			galeriaButton.labelAlphas=[galeriaButton.alpha,galeriaButton.alpha+0.15,1];		
			galeriaButton.updateHitbox();
			galeriaButton.x = 491;
			galeriaButton.y = 376;
			galeriaButton.alpha = 1;
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

			musicButton = new FlxButton(FlxG.width, 100, LangUtil.getString("gall_music_button", "gallery"));
			musicButton.makeGraphic(158,50, FlxColor.TRANSPARENT);
			musicButton.label.setFormat(LangUtil.getFont("roboto"), 22, CoolUtil.colorFromString("0xc6c6c6"), CENTER);
			musicButton.labelAlphas=[musicButton.alpha,musicButton.alpha+0.15,1];	
			musicButton.updateHitbox();
			musicButton.x = 640;
			musicButton.y = 376;
			musicButton.alpha = 0.7;
			add(musicButton);

			#if mobile
			//addhitboxtouch();
			#end
	
			super.create();
        }

		public static var stoploading:Bool = false;

		override function closeSubState()
			{
				#if rpc
				DiscordClient.changePresence(LangUtil.getString("rpc_galeria", "rpc"), null);
				#end

				stoploading = false;

				persistentDraw = true;
				persistentUpdate = true;

				
				playsArray.visible = true;
				menuItems.visible = true;

				super.closeSubState();
			}

		var scrollSpeed:Int = 15; //15;
		override function update(elapsed:Float)
			{		
				isMiddleClicking = FlxG.mouse.pressedMiddle;
				scrollSpeed = isMiddleClicking ? 30 : 15; 
				//A ordem aparentemente faz uma diferença ferrada na otimização disso.
				if(!stoploading){
				if(Utils.BSLTouchUtils.over(playsArray) || (Utils.BSLTouchUtils.over(galeriaButton)&&!isGaleria) || (Utils.BSLTouchUtils.over(musicButton)&&isGaleria)){
					if(mouseskin != "pointerselected" && !isMiddleClicking){
						mouseskin = 'pointerselected';
						#if desktop
						FlxG.mouse.load(Paths.imagechecker('sobremenu/galeria/'+mouseskin), 1, 0, 0);
						#end
					}
				}else if (mouseskin!='pointer'){
					mouseskin = 'pointer';
					#if desktop
					FlxG.mouse.load(Paths.imagechecker('sobremenu/galeria/'+ mouseskin), 1, 0, 0);
					#end
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

					if(Utils.BSLTouchUtils.justTouched() && clicavel && !isMiddleClicking)
					{
						if(Utils.BSLTouchUtils.over(spr)){
							stoploading = true;
							GlobalSoundManager.play('click');
							GaleriaStateMusic.songPosInArray = spr.ID;
							MusicBeatState.switchState(new GaleriaStateMusic());
							FlxG.sound.music.fadeOut(1, 0);
						}else if (Utils.BSLTouchUtils.over(galeriaButton) && !isGaleria){
							galeriapressed();
							GlobalSoundManager.play('click');
						}else if (Utils.BSLTouchUtils.over(musicButton) && isGaleria){
							musicpressed();
							GlobalSoundManager.play('click');
						}
					}

				});
				}

				if(bg.y<-8830)
					{
						Achievements.loadAchievements();
						var achieveID:Int = Achievements.getAchievementIndex('galeria');
						if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][0])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
							ClientPrefs.achievementsMap.set(Achievements.achievementsStuff[achieveID][0], true);
							add(new AchievementObject('galeria', camAchievement));
							GlobalSoundManager.play('confirmMenu');
							ClientPrefs.save();
						}
					}
				if (controls.BACK) {
					mouseskin = '';
					#if desktop
					FlxG.mouse.unload();
					#end
					GlobalSoundManager.play('cancelMenu');
					MusicBeatState.switchState(new SobreState());
				}
				scrollSpeed = scrollSpeed * 3;
				if(isGaleria)
					{
						if(FlxG.mouse.wheel>0 || isMiddleClicking && FlxG.mouse.y<360)
							{
								
								if(bg.y==0)
								{
									bg.y=0;
									galeriaButton.y = 376;
									musicButton.y = 376;
								}
								else if(bg.y<0)
								{
									bg.y+=scrollSpeed;
									galeriaButton.y +=scrollSpeed;
									musicButton.y += scrollSpeed;
								}				
							}
						else if(
							//#if mobile hitboxbaixo.justReleased || #end 
							FlxG.mouse.wheel<0 || isMiddleClicking && FlxG.mouse.y>360)
						{
							if(bg.y==-8842)
							{
								bg.y=-8842;
								galeriaButton.y =musicButton.y= -8466;
							}
							else if(bg.y>-8842)
							{
								bg.y-=scrollSpeed;
								galeriaButton.y -= scrollSpeed;
								musicButton.y -= scrollSpeed;
							}
						}
					}
					//Parte da Música
				else
					{
						if(FlxG.mouse.wheel>0 || isMiddleClicking && FlxG.mouse.y<360) //Aparentemente isso aqui faz o bg subir.
							{
								if(bgmusica.y==0)
								{
									bgmusica.y=0;
									galeriaButton.y = 376;
									musicButton.y = 376;
								}
								else if(bgmusica.y<0)
								{
									bgmusica.y+=scrollSpeed;
									galeriaButton.y +=scrollSpeed;
									musicButton.y +=scrollSpeed;
									alturamodificadaparacalculosmuitopikas = alturamodificadaparacalculosmuitopikas+scrollSpeed;
									playsArray.forEach(function(spr:FlxSprite)
										{spr.y = spr.y+scrollSpeed;});
						
										menuItems.forEach(function(spr:FlxSprite)
										{spr.y = spr.y+scrollSpeed;});
								}
							
							}else if(
								//#if mobile hitboxbaixo.justReleased || #end 
								FlxG.mouse.wheel<0 || isMiddleClicking && FlxG.mouse.y<360){
								if(bgmusica.y == -holdthatY + FlxG.height)
								{
									bgmusica.y= -holdthatY + FlxG.height;
									galeriaButton.y =musicButton.y= -holdthatY + FlxG.height+376;
								}
								else if(bgmusica.y >-holdthatY + FlxG.height)
								{
									bgmusica.y-=scrollSpeed;
									galeriaButton.y -=scrollSpeed;
									musicButton.y -=scrollSpeed;
									alturamodificadaparacalculosmuitopikas=alturamodificadaparacalculosmuitopikas-scrollSpeed;
									playsArray.forEach(function(spr:FlxSprite)
										{spr.y = spr.y-scrollSpeed;});
						
										menuItems.forEach(function(spr:FlxSprite)
										{spr.y = spr.y-scrollSpeed;});
								}
							}
						
					}
				super.update(elapsed);
			}

			function musicpressed(){
				isGaleria=false;
				musicButton.alpha = 1;
				galeriaButton.alpha = 0.6;
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
				galeriaButton.alpha = 1;
				musicButton.alpha = 0.7;
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