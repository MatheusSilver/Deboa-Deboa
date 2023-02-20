import flixel.system.FlxSound;
import Discord.DiscordClient;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;

using StringTools;

class GaleriaSubStateMusic extends MusicBeatSubstate
{

		var curSong:FlxSound;
		var prevSong:FlxSound;

		var loopar:Bool = false;
		var playsequencia:Bool = false;
		var playrandom:Bool = false;

		var fundo:FlxSprite;
		var tocandoagorasuporte:FlxSprite;
		var barraInferior:FlxSprite;
		var thumbnail:FlxSprite;
		var thumbnailAuxiliar:FlxSprite;

		var isLetras = false;

		var timeBar:FlxBar;

		var thumbtocandoagora:FlxSprite;
		var sair:FlxSprite;
		var timer:FlxText;

		var songPercent:Float = 0;

		var barrabase:FlxBar;

		var curSelected:Int = 0;

		var botaoesquerda:FlxSprite;
		var botaodireita:FlxSprite;
		var botaoPauseContinue:FlxSprite;
		var overlaySuporte:FlxSprite;

		var songLength:Float = 0;

		
		var mouseskin:String = '';


		var tocandoagora:FlxText; //Isso só tá aqui mesmo por causa dos tweens

		var letrasbotao:FlxSprite;
		var playListbotao:FlxSprite;

		private var checkboxArray:FlxTypedGroup<CheckboxThingie>;
		private var optionTextsArray:FlxTypedGroup<FlxText>;

		static var options:Array<String> = [
			'Reprodução Automática',
			'Reprodução em Looping',
			'Reprodução aleatória'
		];

		private var checkboxNumber:Array<Int> = [];

		private var menuItems:FlxTypedGroup<FlxSprite>;

		public function new(songPosInArray:Int = 1)
		{
			super();

			curSelected = songPosInArray;

			fundo = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			fundo.y = FlxG.height;
			add(fundo);

			menuItems = new FlxTypedGroup<FlxSprite>();
			add(menuItems);

			overlaySuporte = new FlxSprite(0,0).makeGraphic(Std.int(FlxG.width*0.353), Std.int(FlxG.height*0.45), FlxColor.BLACK);
			overlaySuporte.y = 0;
			overlaySuporte.alpha = 0;
			overlaySuporte.x = FlxG.width - overlaySuporte.width;
			add(overlaySuporte);

			letrasbotao = new FlxSprite();
			letrasbotao.loadGraphic(Paths.image('galeriamusicas/youtubemusic/letras_botao', 'preload'));
			letrasbotao.x = FlxG.width - 50 - letrasbotao.width;
			letrasbotao.y = 0;
			letrasbotao.alpha = 0;
			add(letrasbotao);

			playListbotao = new FlxSprite();
			playListbotao.loadGraphic(Paths.image('galeriamusicas/youtubemusic/playlist_botao', 'preload'));
			playListbotao.x = letrasbotao.x - playListbotao.width;
			playListbotao.y = letrasbotao.y;
			playListbotao.alpha = 0;
			add(playListbotao);

			var lugar:Float = 0.51; //Não entendi, só sei que foi assim ;-;
			barrabase = new FlxBar(playListbotao.x, playListbotao.y + playListbotao.height, LEFT_TO_RIGHT, Std.int(playListbotao.width+letrasbotao.width), 2, this, 'lugar', 0, 1, true);
			barrabase.scrollFactor.set();
			barrabase.alpha = 0;
			barrabase.numDivisions = 1;
			barrabase.createFilledBar(0x63797979,0xFFFFFFFF);
			add(barrabase);

			tocandoagora = new FlxText(playListbotao.x, overlaySuporte.height - 30, 100, 'Tocando Agora:', 13);
			tocandoagora.setFormat(Paths.font("Arial.ttf"), 13, 0xFF808080, LEFT);
			tocandoagora.alpha = 0;
			add(tocandoagora);

			for (i in 0...GaleriaState.leMusic.length) { //Em busca da engine automática k
				
				var scrollingStuff:FlxSprite = new FlxSprite(playListbotao.x, tocandoagora.y+ tocandoagora.height + 55 + 60*i);
				scrollingStuff.loadGraphic(Paths.image('galeriamusicas/youtubemusic/scrollingshitos/' + GaleriaState.leMusic[i].toLowerCase(), 'preload'));
				
				scrollingStuff.alpha = 0;
				scrollingStuff.antialiasing = ClientPrefs.globalAntialiasing;
				scrollingStuff.updateHitbox();
				scrollingStuff.ID = i;

				//Propósitos de economizar renderização
				menuItems.add(scrollingStuff);
			}

			optionTextsArray = new FlxTypedGroup<FlxText>();
			add(optionTextsArray);

			checkboxArray = new FlxTypedGroup<CheckboxThingie>();
			add(checkboxArray);

			for (i in 0...options.length) { //Em busca da engine automática k
				
				var optionText:FlxText = new FlxText(playListbotao.x, playListbotao.y + playListbotao.height + i*75 + 35, 200, options[i], 16);
				optionText.setFormat(Paths.font("Arial.ttf"), 16, 0xFFFFFFFF, LEFT);
				optionText.alpha = 0;
				optionText.antialiasing = ClientPrefs.globalAntialiasing;
				optionText.updateHitbox();
				optionText.ID = i;
				optionTextsArray.add(optionText);
				
				var checkbox:CheckboxThingie = new CheckboxThingie(FlxG.width - 200, optionText.y - 15, false);
				checkboxNumber.push(i);
				checkbox.ID = i;
				checkbox.alpha = 0;
				checkbox.setGraphicSize(Std.int(checkbox.width * 0.5));
				checkbox.updateHitbox();
				checkbox.x = letrasbotao.x + letrasbotao.width - checkbox.width;
				checkboxArray.add(checkbox);
			}

			thumbnail = new FlxSprite().loadGraphic(Paths.image("scrolling/artes/scroll-" + GaleriaState.leMusic[curSelected].toLowerCase() + " (scroll)", 'preload'));
			thumbnail.setGraphicSize(596,596);
			thumbnail.x = -FlxG.width;
			thumbnail.y = 75;
			add(thumbnail);

			barraInferior = new FlxSprite(0,0).loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/barra_baixo", 'preload'));
			barraInferior.setGraphicSize(FlxG.width,80);
			barraInferior.y = FlxG.height - 80;
			barraInferior.alpha = 0;
			barraInferior.updateHitbox();
			add(barraInferior);

			botaoesquerda = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/change song", 'preload'));
			botaoesquerda.x = 15;
			botaoesquerda.y = barraInferior.y + 30;
			botaoesquerda.alpha = 0;
			botaoesquerda.setGraphicSize(Std.int(botaoesquerda.width*0.5));
			add(botaoesquerda);

			botaoPauseContinue = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/pause", 'preload'));
			botaoPauseContinue.x = botaoesquerda.x+botaoesquerda.width + 40;
			botaoPauseContinue.y = barraInferior.y + 30;
			botaoPauseContinue.alpha = 0;
			botaoPauseContinue.setGraphicSize(Std.int(botaoPauseContinue.width*1.3));
			add(botaoPauseContinue);

			botaodireita = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/change song", 'preload'));
			botaodireita.x = botaoPauseContinue.x+botaoPauseContinue.width + 40;
			botaodireita.y = barraInferior.y + 30;
			botaodireita.alpha = 0;
			botaodireita.setGraphicSize(Std.int(botaodireita.width*0.5));
			botaodireita.flipX = true;
			add(botaodireita);

			timer = new FlxText(botaodireita.x + botaodireita.width + 20, 15, 80, "0:00/0:00", 11);
			timer.setFormat(Paths.font("Arial.ttf"), 14, 0xFF808080, RIGHT);
			timer.y = FlxG.height;
			add(timer);

			thumbnailAuxiliar = new FlxSprite().loadGraphic(Paths.image('galeriamusicas/youtubemusic/scrollingshitos/' + GaleriaState.leMusic[curSelected].toLowerCase(), 'preload'));
			thumbnailAuxiliar.setGraphicSize(Std.int(thumbnailAuxiliar.width * 1.25));
			thumbnailAuxiliar.x = timer.x + 150;
			thumbnailAuxiliar.y = FlxG.height - thumbnailAuxiliar.height;
			thumbnailAuxiliar.alpha = 0;
			add(thumbnailAuxiliar);
			

			thumbtocandoagora = new FlxSprite(playListbotao.x, tocandoagora.y+ tocandoagora.height + 5);
			thumbtocandoagora.loadGraphic(Paths.image('galeriamusicas/youtubemusic/scrollingshitos/' + GaleriaState.leMusic[curSelected].toLowerCase(), 'preload'));
			
			thumbtocandoagora.alpha = 0;
			thumbtocandoagora.antialiasing = ClientPrefs.globalAntialiasing;
			thumbtocandoagora.updateHitbox();

			tocandoagorasuporte = new FlxSprite(0,0).loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/barra_baixo", 'preload'));
			tocandoagorasuporte.setGraphicSize(Std.int(thumbtocandoagora.width),Std.int(thumbtocandoagora.height));
			tocandoagorasuporte.updateHitbox();
			tocandoagorasuporte.x = thumbtocandoagora.x;
			tocandoagorasuporte.y = thumbtocandoagora.y - 5;
			tocandoagorasuporte.alpha = 0;

			add(tocandoagorasuporte);
			add(thumbtocandoagora);

			sair = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/sair", 'preload'));
			sair.x = FlxG.width - 50 - sair.width;
			sair.setGraphicSize(Std.int(sair.width*1.3));
			sair.y = barraInferior.y + 15;
			sair.alpha = 0;
			sair.updateHitbox();
			add(sair);

			timeBar = new FlxBar(0, barraInferior.y-3, LEFT_TO_RIGHT, FlxG.width, 3, this,
			'songPercent', 0, 1);
			timeBar.scrollFactor.set();
			timeBar.createFilledBar(0x63C9C9C9, 0xFFFF0000);
			timeBar.numDivisions = 1280;	
			timeBar.alpha = 0;
			add(timeBar);

			reloadValues();
			entrada();
			changeSong(curSelected);

		}

		var canRender:Bool = false;

		function entrada(){
			FlxTween.tween(fundo, {y: 0}, 0.2, {ease: FlxEase.quartInOut,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(barraInferior, {alpha: 1}, 0.3, {ease: FlxEase.quartInOut,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(sair, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
							FlxTween.tween(timer, {y: barraInferior.y + 40}, 0.1, {ease: FlxEase.quartInOut});
							FlxTween.tween(timeBar, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
							FlxTween.tween(botaodireita, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
							FlxTween.tween(botaoesquerda, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
							FlxTween.tween(botaoPauseContinue, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
							FlxTween.tween(thumbnailAuxiliar, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut,
								onComplete: function(twn:FlxTween)
								{
									overlaySuporte.alpha = 1;
									FlxTween.tween(playListbotao, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
									FlxTween.tween(tocandoagora, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
									FlxTween.tween(letrasbotao, {alpha: 0.5}, 0.1, {ease: FlxEase.quartInOut});
									FlxTween.tween(barrabase, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
									FlxTween.tween(tocandoagorasuporte, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
									FlxTween.tween(thumbtocandoagora, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
									optionTextsArray.forEach(function(spr:FlxText)
										{
											FlxTween.tween(spr, {alpha: 1}, 0.1, {ease: FlxEase.quadOut});
										});
									checkboxArray.forEach(function(spr:CheckboxThingie)
										{
											FlxTween.tween(spr, {alpha: 1}, 0.1, {ease: FlxEase.quadOut});
										});
									menuItems.forEach(function(spr:FlxSprite)
										{
											if(spr.y < FlxG.height + 500 && spr.y > overlaySuporte.height*0.8)
												FlxTween.tween(spr, {alpha: 1}, 0.1, {ease: FlxEase.quadOut,
												onComplete: function(twn:FlxTween)
												{
													canRender = true;
												}
											});
										});
									
								}
							});


						}
					});
				}
			});
		}

		function changeSong(direction:Int){

			if(!loopar){
				FlxG.sound.music.stop();
				FlxG.sound.music.destroy();
			}

			curSelected = direction;
			new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			FlxG.sound.playMusic(Paths.inst(GaleriaState.leMusic[direction].toLowerCase()), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			songLength = FlxG.sound.music.length + 1000; //Um segundo cheio sendo adicionado aqui pois achei que o player de musicas do haxe tivesse o mesmo erro que o player do meu PC que add um sec a mais sempre
			FlxG.sound.music.onComplete = playlistChecker;
			thumbnail.loadGraphic(Paths.image("scrolling/artes/scroll-" + GaleriaState.leMusic[curSelected].toLowerCase() + " (scroll)", 'preload'));
			FlxTween.tween(thumbnail, {x: 175}, 0.1, {ease: FlxEase.quartInOut});
			});

			thumbtocandoagora.loadGraphic(Paths.image('galeriamusicas/youtubemusic/scrollingshitos/' + GaleriaState.leMusic[curSelected].toLowerCase(), 'preload'));
			thumbnailAuxiliar.loadGraphic(Paths.image('galeriamusicas/youtubemusic/scrollingshitos/' + GaleriaState.leMusic[curSelected].toLowerCase(), 'preload'));

		}

		function playlistChecker():Void
			{
				if(!loopar){
				FlxG.sound.music.stop();
				//FlxG.sound.music.destroy();
				}
				if(playsequencia)
					changeSong(curSelected+1);
				else if(playrandom)
					changeSong(FlxG.random.int(0, GaleriaState.leMusic.length-1))
				else if(!loopar)
					FlxG.sound.playMusic(Paths.music('newmenu'), 0.7);

			}

		function reloadValues() {
			for (i in 0...checkboxArray.length) {
				var checkbox:CheckboxThingie = checkboxArray.members[i];
				if(checkbox != null) {
					var daValue:Bool = false;
					switch(options[checkboxNumber[i]]) {
						case 'Reprodução Automática':
							daValue = playsequencia;
						case 'Reprodução em Looping':
							daValue = loopar;
						case 'Reprodução aleatória':
							daValue = playrandom;
					}
					checkbox.daValue = daValue;
				}
			}
		}

		var pausado:Bool = false; //PQ O PAUSED DO FLX SOUND NÃO FUNFA AAAAAAAAAAAAAAAAAAAAA
		var curTime:Float = 0;
		var secondsTotal:Int = 0;


	override function update(elapsed:Float)
		{
			if (controls.BACK || (FlxG.mouse.overlaps(sair) && FlxG.mouse.justPressed)) {
				FlxG.sound.play(Paths.sound('click'));
				GaleriaState.firsttimemusic = false;
				GaleriaState.stoploading = false;
				canRender = false;
				FlxG.sound.music.fadeIn(4, 0, 0);

				new FlxTimer().start(4.1, function(tmr:FlxTimer) {
				FlxG.sound.playMusic(Paths.music('newmenu'), 0.7);
				});
				close();
			}

			if (!pausado && FlxG.sound.music != null){
				curTime = FlxG.sound.music.time;
				if(curTime < 0) curTime = 0;
				songPercent = (curTime / songLength);
				secondsTotal = Math.floor((songLength - curTime) / 1000);
				if(secondsTotal < 0) secondsTotal = 0;
				timer.text = FlxStringUtil.formatTime(Math.floor(curTime/1000), false) + '/' + FlxStringUtil.formatTime(Math.floor(songLength/1000), false);
			}else if (FlxG.sound.music == null){
				timer.text = '0:00/0:00';
			}

			if(!pausado)
				DiscordClient.changePresence("Ouvindo:", GaleriaState.titulos[curSelected], true, songLength - curTime);
			else
				DiscordClient.changePresence("Pausado", GaleriaState.titulos[curSelected], true, songLength - curTime);
			

			if(FlxG.mouse.overlaps(menuItems) || FlxG.mouse.overlaps(checkboxArray) || 
				FlxG.mouse.overlaps(botaodireita) || FlxG.mouse.overlaps(botaoesquerda) ||
					FlxG.mouse.overlaps(botaoPauseContinue) || FlxG.mouse.overlaps(sair) ||
					(FlxG.mouse.overlaps(playListbotao)&&isLetras) || (FlxG.mouse.overlaps(letrasbotao)&&isLetras)){
				if(mouseskin != "pointerselected"){
					mouseskin = 'pointerselected';
					FlxG.mouse.load(Paths.image('sobremenu/galeria/'+mouseskin), 1, 0, 0);
				}
			}else if (mouseskin!='pointer'){
				mouseskin = 'pointer';
				FlxG.mouse.load(Paths.image('sobremenu/galeria/'+ mouseskin), 1, 0, 0);
			} //Central do mouse

			checkboxArray.forEach(function(spr:FlxSprite){
				if(FlxG.mouse.overlaps(spr))
					{
						if(FlxG.mouse.justPressed){
							//trace(options[spr.ID]);
								switch(options[spr.ID]) { //Conserteza daria pra fazer melhor que isso, mas sabe como é né? preguiça
									case 'Reprodução Automática':
										playsequencia = !playsequencia;
										playrandom = false;
										loopar = false;
				
									case 'Reprodução em Looping':
										loopar = !loopar;
										playsequencia = false;
										playrandom = false;
									
									case 'Reprodução aleatória':
										playrandom = !playrandom;
										loopar = false;
										playsequencia = false;
								}
								FlxG.sound.play(Paths.sound('click'));
								reloadValues();
							}

						}
			});

			if(FlxG.mouse.justPressed){
				if (FlxG.mouse.overlaps(botaodireita)){
					FlxTween.tween(thumbnail, {x: -FlxG.width}, 0.1, {ease: FlxEase.quartInOut});
					changeSong(curSelected+1);
					FlxG.sound.play(Paths.sound('click'));
				}else if (FlxG.mouse.overlaps(botaoesquerda)){
					changeSong(curSelected-1);
					FlxTween.tween(thumbnail, {x: -FlxG.width}, 0.1, {ease: FlxEase.quartInOut});
					FlxG.sound.play(Paths.sound('click'));
				}else if (FlxG.mouse.overlaps(botaoPauseContinue)&&pausado){
					FlxG.sound.music.resume();
					pausado = false;
					FlxG.sound.play(Paths.sound('click'));
					if(FlxG.sound.music == null)
						FlxG.sound.playMusic(Paths.inst(GaleriaState.leMusic[curSelected].toLowerCase()), 0);
				
				}else if (FlxG.mouse.overlaps(botaoPauseContinue)&&!pausado){
					FlxG.sound.music.pause();
					pausado = true;
					FlxG.sound.play(Paths.sound('click'));
				}
			}

			menuItems.forEach(function(spr:FlxSprite)
				{				
					if(canRender){ //Isso aqui serve apenas para não sobrecarregar a placa de vídeo com muitos objetos sendo renderizados ao memso tempo
						//Com isso, a placa só irá ter que carregar objetos que realmente estão na camera.
						//Honestamente essa é a primeira vez que tenho que me preocupar com placa de vídeo ao invés de RAM

					if(spr.y < (FlxG.height - barraInferior.height) && spr.y > overlaySuporte.height*0.8)
						spr.visible = true;
					else
						spr.visible = false;

					}

					if(FlxG.mouse.justPressed) 
						{
							if(FlxG.mouse.overlaps(spr) && spr.visible){
								FlxG.sound.play(Paths.sound('click'));
								FlxTween.tween(thumbnail, {x: -FlxG.width}, 0.1, {ease: FlxEase.quartInOut});
								changeSong(spr.ID);
							}
						}

				});

				

			super.update(elapsed);
		}
}