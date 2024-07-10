package;

import Linguagem.LangUtil;
import Utils.BSLSwipeUtils;
import flixel.math.FlxPoint;
import ui.FlxButton;
import Utils.BSLTouchUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxTexturePackerSource;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;

using StringTools;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
#if rpc
import Discord.DiscordClient;
#end

class GaleriaStateMusic extends MusicBeatState
{


	// daLyric Stuff

	private var loading_list:Queue;

	var daLyric:Array<String>;
	var textGroup:FlxTypedGroup<FlxText>;

	var curSong:FlxSound;
	var prevSong:FlxSound;

	var scrollableArea:FlxSprite;
	var scrollableLetras:FlxSprite;

	var loopar:Bool = false;
	var playsequencia:Bool = false;
	var playrandom:Bool = false;

	var fundo:FlxSprite;
	var tocandoagorasuporte:FlxSprite;
	var barraInferior:FlxSprite;
	var thumbnail:FlxSprite;
	var thumbnailAuxiliar:GaleriaMusicObject;

	var segureoPrimeiroY:Float;
	var segureoUltimoY:Float;

	var isLetras = false;

	var timeBar:FlxBar;

	var thumbtocandoagora:FlxSprite;
	var sair:FlxSprite;
	var timer:FlxText;

	var loopar_mini:FlxSprite;
	var random_play_mini:FlxSprite;
	var songPercent:Float = 0;

	var curSelected:Int = 0;

	var botaoesquerda:FlxSprite;
	var botaodireita:FlxSprite;
	var botaoPauseContinue:FlxSprite;
	var overlaySuporte:FlxSprite;

	var songLength:Float = 0;

	
	var mouseskin:String = '';


	var tocandoagora:FlxText; //Isso só tá aqui mesmo por causa dos tweens

	var letrasbotao:FlxButton;
	var playListbotao:FlxButton;

	private var checkboxArray:FlxTypedGroup<CheckboxThingie>;
	private var optionTextsArray:FlxTypedGroup<FlxText>;

	static var options:Array<String> = [
		'rep_auto',
		'rep_loop',
		'rep_rand'
	];

	private var checkboxNumber:Array<Int> = [];

	public static var songPosInArray:Int = 1;

	private var menuItems:FlxTypedGroup<FlxSprite>;

	override function create()
	{

		curSelected = songPosInArray;

		fundo = new FlxSprite(0,0).makeGraphic(1, 1, FlxColor.BLACK);
		fundo.setGraphicSize(FlxG.width,FlxG.height);
		fundo.y = FlxG.height;
		add(fundo);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		//Lyrics Stuff
		textGroup = new FlxTypedGroup<FlxText>();
		add(textGroup);

		overlaySuporte = new FlxSprite(0,0).makeGraphic(Std.int(FlxG.width*0.353), 60, FlxColor.BLACK);
		overlaySuporte.y = 0;
		overlaySuporte.visible = false;
		overlaySuporte.x = FlxG.width - overlaySuporte.width;
		add(overlaySuporte);

		letrasbotao = new FlxButton(0,0,Linguagem.LangUtil.getString("gall_lyrics_button", "gallery"));
		letrasbotao.loadGraphic(Paths.image('buttons_base/ytb_music_button', "preload"));
		letrasbotao.x = FlxG.width - 50 - letrasbotao.width;
		letrasbotao.label.setFormat(Linguagem.LangUtil.getFont("hiraginoSans"), 16, Utils.CoolUtil.colorFromString("0xc6c6c6"), CENTER);
		letrasbotao.labelAlphas=[letrasbotao.alpha,letrasbotao.alpha+0.15,1];	
		letrasbotao.labelOffsets = [FlxPoint.get(0,20), FlxPoint.get(0,20), FlxPoint.get(0,20)];
		letrasbotao.label.bold=true;
		letrasbotao.y = 0;
		letrasbotao.alpha = 0;

		playListbotao = new FlxButton(0,0,Linguagem.LangUtil.getString("gall_playlist_button", "gallery"));
		playListbotao.loadGraphic(Paths.image('buttons_base/ytb_music_button', "preload"));
		playListbotao.label.setFormat(Linguagem.LangUtil.getFont("hiraginoSans"), 16, Utils.CoolUtil.colorFromString("0xc6c6c6"), CENTER);
		playListbotao.labelAlphas=[playListbotao.alpha,playListbotao.alpha+0.15,1];	
		playListbotao.label.bold=true;
		playListbotao.labelOffsets = [FlxPoint.get(0,20), FlxPoint.get(0,20), FlxPoint.get(0,21)];
		playListbotao.x = letrasbotao.x - playListbotao.width;
		playListbotao.y = letrasbotao.y;
		playListbotao.alpha = 0;

		tocandoagora = new FlxText(playListbotao.x, FlxG.height*0.45 - 30, 100, Linguagem.LangUtil.getString("gall_play_now", "gallery"), 13);
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

			if (i == 0)
				segureoPrimeiroY = scrollingStuff.y + 15;

			//Propósitos de economizar renderização
			menuItems.add(scrollingStuff);
		}

		optionTextsArray = new FlxTypedGroup<FlxText>();
		add(optionTextsArray);

		checkboxArray = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxArray);

		for (i in 0...options.length) { //Em busca da engine automática k
			
			var optionText:FlxText = new FlxText(playListbotao.x, playListbotao.y + playListbotao.height + i*75 + 35, 200, Linguagem.LangUtil.getString("gall_"+options[i], "gallery"), 16);
			optionText.setFormat(Paths.font("Arial.ttf"), 16, 0xFFFFFF, LEFT);
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
		botaoesquerda.y = barraInferior.y + 25;
		botaoesquerda.alpha = 0;
		botaoesquerda.setGraphicSize(Std.int(botaoesquerda.width*0.4));
		add(botaoesquerda);

		botaoPauseContinue = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/pause", 'preload'));
		botaoPauseContinue.x = botaoesquerda.x+botaoesquerda.width + 40;
		botaoPauseContinue.y = barraInferior.y + 25;
		botaoPauseContinue.alpha = 0;
		botaoPauseContinue.setGraphicSize(Std.int(botaoPauseContinue.width*0.65));
		add(botaoPauseContinue);

		botaodireita = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/change song", 'preload'));
		botaodireita.x = botaoPauseContinue.x+botaoPauseContinue.width + 40;
		botaodireita.y = barraInferior.y + 25;
		botaodireita.alpha = 0;
		botaodireita.setGraphicSize(Std.int(botaodireita.width*0.4));
		botaodireita.flipX = true;
		add(botaodireita);

		timer = new FlxText(botaodireita.x + botaodireita.width + 15, 0, 80, "0:00/0:00", 10);
		timer.setFormat(LangUtil.getFont("hiraginoSans"), 12, 0xaaaaaa, LEFT);
		timer.y = botaodireita.y + botaodireita.height/2 - timer.height/2;
		add(timer);
		
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

		scrollableArea= new FlxSprite(0,0).makeGraphic(Std.int(overlaySuporte.width), Std.int(FlxG.height - barraInferior.height - FlxG.height*0.45*0.8), FlxColor.TRANSPARENT);
		scrollableArea.x = overlaySuporte.x;
		scrollableArea.y = thumbtocandoagora.y;
		scrollableArea.visible=false;
		add(scrollableArea);

		scrollableLetras= new FlxSprite(0,0).makeGraphic(Std.int(overlaySuporte.width), Std.int(FlxG.height - barraInferior.height - overlaySuporte.height), FlxColor.TRANSPARENT);
		scrollableLetras.x = overlaySuporte.x;
		scrollableLetras.y = overlaySuporte.y + overlaySuporte.height;
		scrollableLetras.visible=false;
		add(scrollableLetras);

		add(tocandoagorasuporte);
		add(thumbtocandoagora);

		sair = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/sair", 'preload'));
		sair.x = FlxG.width - 10 - sair.width;
		sair.setGraphicSize(Std.int(sair.width*0.45));
		sair.y = barraInferior.y + 25;
		sair.alpha = 0;
		sair.updateHitbox();
		add(sair);

		random_play_mini = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/aleatorio", 'preload'));
		random_play_mini.x = sair.x - 70;
		random_play_mini.setGraphicSize(Std.int(random_play_mini.width*0.45));
		random_play_mini.y = sair.y;
		random_play_mini.alpha = 0.3;
		random_play_mini.updateHitbox();
		add(random_play_mini);

		loopar_mini = new FlxSprite().loadGraphic(Paths.imagechecker("galeriamusicas/youtubemusic/repetir", 'preload'));
		loopar_mini.x = random_play_mini.x - 70;
		loopar_mini.setGraphicSize(Std.int(random_play_mini.width*1));
		loopar_mini.y = sair.y;
		loopar_mini.alpha = 0.3;
		loopar_mini.updateHitbox();
		add(loopar_mini);

		timeBar = new FlxBar(0, barraInferior.y-3, LEFT_TO_RIGHT, FlxG.width, 3, this,
		'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0x63C9C9C9, 0xFFFF0000);
		timeBar.numDivisions = 800;	
		timeBar.alpha = 0;
		add(timeBar);

		FlxG.sound.music.fadeOut(1, 0);

		textGroup.visible = false;
		isLetras = false;

		add(playListbotao);
		add(letrasbotao);

		BSLSwipeUtils.mouseScrollMultiplier=10;
		//Estes valores precisem ser calibrados

		super.create();

		loading_list = new Queue();

		thumbnailAuxiliar = new GaleriaMusicObject(GaleriaState.leMusic[curSelected].toLowerCase(), GaleriaState.titulos[curSelected], ClientPrefs.likesMap.get(GaleriaState.titulos[curSelected]));
		thumbnailAuxiliar.alpha = 0;
		add(thumbnailAuxiliar);

		reloadLyrics();
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
						FlxTween.tween(timer, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
						FlxTween.tween(timeBar, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
						FlxTween.tween(botaodireita, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
						FlxTween.tween(botaoesquerda, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
						FlxTween.tween(botaoPauseContinue, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut,
							onComplete: function(twn:FlxTween)
							{
								FlxTween.tween(playListbotao, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
								FlxTween.tween(tocandoagora, {alpha: 1}, 0.1, {ease: FlxEase.quartInOut});
								FlxTween.tween(letrasbotao, {alpha: 0.5}, 0.1, {ease: FlxEase.quartInOut});
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

		if(direction < 0)
			direction = GaleriaState.leMusic.length-1
		else if (direction > GaleriaState.leMusic.length-1)
			direction = 0;

		FlxG.sound.music.stop();

		if (loading_list.len > 4){
			loading_list.remove_keys(loading_list.get_by_index(1));	//A ordem importa.
			loading_list.remove_keys(loading_list.get_by_index(0));
		}
		
		//HAHAHAHAHAHH ADEUS YOUTUBE MUSIC, AGORA O ELON MOSKA COMPRARÁ VOCÊ E TRANSFORMARÁ EM
		//High Space Musical X NYEHEHEHHEHEHGEHEHYEHEHEHEHEHEHEHEHEH

		//NAAAO HIGH SPACE MUSICAL X NAAAAO CORRAM TODOS

		curSelected = direction;
		FlxG.sound.playMusic(Paths.inst(GaleriaState.leMusic[curSelected].toLowerCase()), 0);
		menutoca=false;
		FlxG.sound.music.fadeIn(4, 0, 0.85);
		songLength = FlxG.sound.music.length + 1000; //Um segundo cheio sendo adicionado aqui pois achei que o player de musicas do haxe tivesse o mesmo erro que o player do meu PC que add um sec a mais sempre
		FlxG.sound.music.onComplete = playlistChecker;
		FlxTween.tween(thumbnail, {x: -FlxG.width}, 0.1, {ease: FlxEase.quartInOut, onComplete: function (twn:FlxTween){
			thumbnail.loadGraphic(Paths.image("scrolling/artes/scroll-" + GaleriaState.leMusic[curSelected].toLowerCase() + " (scroll)", 'preload'));
			FlxTween.tween(thumbnail, {x: 175}, 0.1, {ease: FlxEase.quartInOut});	
		}});
		thumbtocandoagora.loadGraphic(Paths.image('galeriamusicas/youtubemusic/scrollingshitos/' + GaleriaState.leMusic[curSelected].toLowerCase(), 'preload'));
		FlxTween.tween(thumbnailAuxiliar, {alpha: 0}, 0.1, {ease: FlxEase.linear, onComplete: function (twn:FlxTween){
			thumbnailAuxiliar.reload_object(GaleriaState.leMusic[curSelected].toLowerCase(), GaleriaState.titulos[curSelected], ClientPrefs.likesMap.get(GaleriaState.titulos[curSelected]));
			thumbnailAuxiliar.alpha = 0;
			FlxTween.tween(thumbnailAuxiliar, {alpha: 1}, 0.3, {ease: FlxEase.linear});
		}});
		
		if(isLetras)
			textGroup.forEach(function(spr:FlxSprite){FlxTween.tween(spr, {alpha: 0}, 0.1, {ease: FlxEase.linear});});

		loading_list.queue("scrolling/artes/scroll-" + GaleriaState.leMusic[curSelected].toLowerCase() + " (scroll)");
		loading_list.queue(GaleriaState.leMusic[curSelected].toLowerCase());

		reloadLyrics(isLetras);
	}

	function playlistChecker():Void
		{
			//trace('o ato da musica acabou, os bugs parecem sem fim');
			if(playsequencia){
				changeSong(curSelected+1);
				//trace('tentando tocar sequencia');
			}else if(playrandom){
				//trace('tentando tocar random');
				changeSong(FlxG.random.int(0, GaleriaState.leMusic.length-1));
			}else if(!loopar){
				FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0);
				menutoca=true;
				FlxG.sound.music.fadeIn(4, 0, 0.85);
				pausado = true;
				songPercent = 0;
				timer.text = '0:00' + '/' + FlxStringUtil.formatTime(Math.floor(songLength/1000), false);

				if(canRender)
				{
					botaoPauseContinue.loadGraphic(Paths.image('galeriamusicas/youtubemusic/play', 'preload')); // tava crashando antes quando o jogador n tava mais nesse state e tava tentando carregar uma textura pra um objeto que tecnicamente não existia k
				}
			}
		}


	function reloadValues() {
		for (i in 0...checkboxArray.length) {
			var checkbox:CheckboxThingie = checkboxArray.members[i];
			if(checkbox != null) {
				var daValue:Bool = false;
				switch(options[checkboxNumber[i]]) {
					case 'rep_auto':
						daValue = playsequencia;
					case 'rep_loop':
						daValue = loopar;
						if (daValue)
							loopar_mini.alpha = 1;
						else
							loopar_mini.alpha = 0.3;
					case 'rep_rand':
						daValue = playrandom;
						if (daValue)
							random_play_mini.alpha = 1;
						else
							random_play_mini.alpha = 0.3;
				}
				checkbox.daValue = daValue;
			}
		}
	}

	var pausado:Bool = false; //PQ O PAUSED DO FLX SOUND NÃO FUNFA AAAAAAAAAAAAAAAAAAAAA
	var curTime:Float = 0;
	var secondsTotal:Int = 0;

	var menutoca:Bool = true;


	override function update(elapsed:Float)
	{
		BSLSwipeUtils.swipeVertical();
		if(isLetras && BSLTouchUtils.over(scrollableLetras))
		{
			if(textGroup.members[0].y + BSLSwipeUtils.scrollY <= playListbotao.height+playListbotao.y + 10 && textGroup.members[textGroup.length-1].y + BSLSwipeUtils.scrollY >= FlxG.height - barraInferior.height - 30)
				textGroup.forEach(function(spr:FlxText){spr.y += BSLSwipeUtils.scrollY;});
			
		}else if (!isLetras && BSLTouchUtils.over(scrollableArea))
			if(menuItems.members[0].y + BSLSwipeUtils.scrollY <= segureoPrimeiroY && menuItems.members[GaleriaState.leMusic.length-1].y + BSLSwipeUtils.scrollY>= FlxG.height - barraInferior.y + 510)
				menuItems.forEach(function(spr:FlxSprite){spr.y += BSLSwipeUtils.scrollY;});

		if (controls.BACK || (Utils.BSLTouchUtils.over(sair) && Utils.BSLTouchUtils.justTouched())) {
			menutoca= true;
			GlobalSoundManager.play('click');
			GaleriaState.firsttimemusic = false;
			GaleriaState.stoploading = false;
			canRender = false;
			if (FlxG.sound.music != null)
				FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween){
					FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0, true);
					FlxG.sound.music.fadeIn(4, 0, 0.85);
					MusicBeatState.switchState(new GaleriaState());
				});
			else{
				FlxG.sound.playMusic(Paths.music('newmenu', 'preload'), 0, true);
				FlxG.sound.music.fadeIn(4, 0, 0.85);
				MusicBeatState.switchState(new GaleriaState());
			}
		}

		if (FlxG.sound.music == null)
			timer.text = '0:00/0:00';
		else if (!pausado){
			curTime = FlxG.sound.music.time + 1000;
			if(curTime < 0) curTime = 0;
			songPercent = (curTime / songLength);
			secondsTotal = Math.floor((songLength - curTime) / 1000);
			if(secondsTotal < 0) secondsTotal = 0;
			timer.text = FlxStringUtil.formatTime(Math.floor(curTime/1000), false) + '/' + FlxStringUtil.formatTime(Math.floor(songLength/1000), false);
		}

			#if rpc
			if(!pausado)
				DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_ytb_music_listening", "rpc"), GaleriaState.titulos[curSelected], true, songLength - curTime);
			else
				DiscordClient.changePresence(Linguagem.LangUtil.getString("rpc_ytb_music_paused", "rpc"), GaleriaState.titulos[curSelected], true, songLength - curTime);
			#end

		if((BSLTouchUtils.over(menuItems)&&!isLetras) || BSLTouchUtils.over(checkboxArray) ||
			BSLTouchUtils.over(GaleriaMusicObject.likeSprite) || BSLTouchUtils.over(GaleriaMusicObject.dislikeSprite) ||
		BSLTouchUtils.over(botaodireita) || BSLTouchUtils.over(botaoesquerda) ||
		BSLTouchUtils.over(botaoPauseContinue) || BSLTouchUtils.over(sair) || 
						(BSLTouchUtils.over(playListbotao)&&isLetras) || (BSLTouchUtils.over(letrasbotao)&&!isLetras)){
			if(mouseskin != "pointerselected"){
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
		} //Central do mouse

		checkboxArray.forEach(function(spr:FlxSprite){
			if(BSLTouchUtils.over(spr))
			{
				if(BSLTouchUtils.justTouched()){
					switch(options[spr.ID]) { //Conserteza daria pra fazer melhor que isso, mas sabe como é né? preguiça
						case 'rep_auto':
							playsequencia = !playsequencia;
							playrandom = false;
							loopar = false;
	
						case 'rep_loop':
							loopar = !loopar;
							playsequencia = false;
							playrandom = false;
						
						case 'rep_rand':
							playrandom = !playrandom;
							loopar = false;
							playsequencia = false;
					}
					reloadValues(); //Silvio Bulinho kek
				}
			}else if (BSLTouchUtils.apertasimples(random_play_mini)){
				playrandom = !playrandom;
				loopar = false;
				playsequencia = false;
				GlobalSoundManager.play('click');
				reloadValues();
			}else if(BSLTouchUtils.apertasimples(loopar_mini)){
				loopar = !loopar;
				playsequencia = false;
				playrandom = false;
				GlobalSoundManager.play('click');
				reloadValues();
			}
		});

		//Feito muito, mas MUITO TEMPO DEPOIS...
		if(playListbotao.justPressed&&isLetras&&canChange)
			showPlaylist();
		else if(letrasbotao.justPressed &&!isLetras&&canChange)
			showLyrics();

		//Só essa parte mesmo, o resto to com preguiça de converter pra TouchUtils.
		//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

		if (controls.UI_LEFT_P)
			changeSong(curSelected-1);
		else if (controls.UI_RIGHT_P)
			changeSong(curSelected+1);

		if(BSLTouchUtils.justTouched()){
			if (BSLTouchUtils.over(botaodireita)){
				changeSong(curSelected+1);
				GlobalSoundManager.play('click');
			}else if (BSLTouchUtils.over(botaoesquerda)){
				changeSong(curSelected-1);
				GlobalSoundManager.play('click');
			}else if (BSLTouchUtils.over(botaoPauseContinue)&&pausado){
				pausado = false;
				botaoPauseContinue.loadGraphic(Paths.image('galeriamusicas/youtubemusic/pause', 'preload'));
				GlobalSoundManager.play('click');
				if(menutoca){
					FlxG.sound.music.fadeOut(1, 0);
					FlxG.sound.playMusic(Paths.inst(GaleriaState.leMusic[curSelected].toLowerCase()),0);
					menutoca=false;
					FlxG.sound.music.fadeIn(4, 0, 0.85);					
				} else{
					FlxG.sound.music.resume();
				}
			}else if (BSLTouchUtils.over(botaoPauseContinue)&&!pausado){
				FlxG.sound.music.pause();
				botaoPauseContinue.loadGraphic(Paths.image('galeriamusicas/youtubemusic/play', 'preload'));
				pausado = true;

				GlobalSoundManager.play('click');
			}
		}

		if (!isLetras)
			menuItems.forEach(function(spr:FlxSprite)
				{				
					if(canRender){ //Isso aqui serve apenas para não sobrecarregar a placa de vídeo com muitos objetos sendo renderizados ao memso tempo
						//Com isso, a placa só irá ter que carregar objetos que realmente estão na camera.
						//Honestamente essa é a primeira vez que tenho que me preocupar com placa de vídeo ao invés de RAM

						// bla bla bla

					if(spr.y >= FlxG.height*0.45*0.95 && spr.y <= FlxG.width)
						spr.visible = true;
					else
						spr.visible = false;

					}

					if(BSLTouchUtils.justsolto() && !BSLSwipeUtils.is_swipping) 
						{
							if(BSLTouchUtils.over(spr) && spr.visible && !BSLTouchUtils.over(barraInferior)){
								GlobalSoundManager.play('click');
								changeSong(spr.ID);
							}
						}

				});
		else
			textGroup.forEach(function(spr:FlxText)
			{				
				if(canRender)
					if(spr.y >= playListbotao.y && spr.y <= FlxG.width)
						spr.visible = true;
					else
						spr.visible = false;
				
			});

			

		super.update(elapsed);
	}

	private function reloadLyrics(reShow:Bool = false)
	{
		textGroup.clear();

		//Limpa primeiro, depois recarrega a letra
		if (openfl.utils.Assets.exists(Paths.lyric(GaleriaState.leMusic[curSelected].toLowerCase(), "locales", true)))
			daLyric = Utils.CoolUtil.coolTextFile(Paths.lyric(GaleriaState.leMusic[curSelected].toLowerCase(), "locales", true));
		else
			daLyric = ['Não', 'Existem', 'Letras', 'Nyehehehehehehehhe'];


		for (i in 0...daLyric.length) {
			var daText:FlxText = new FlxText(overlaySuporte.x,playListbotao.y + playListbotao.height , thumbtocandoagora.width, daLyric[i], 15);
			daText.setFormat(LangUtil.getFont("hiraginoSans"), 14, 0xffffff, CENTER);
			daText.y += daText.height*i;
			daText.antialiasing=true;
			//daText.setBorderStyle(OUTLINE, 0xffffff, 3, 10);
			daText.alpha = 0;
			daText.ID = i;
			textGroup.add(daText);
		}
		
		if (reShow)
			showLyrics();
		
	}

	private function showLyrics()
	{
		FlxTween.tween(playListbotao, {alpha: 0.5}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(letrasbotao, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});
		tweenItens(false);
		isLetras = true;
		textGroup.visible = true;
		menuItems.visible=false;
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.alpha = 0;
		});
		textGroup.forEach(function(spr:FlxText)
		{
			FlxTween.tween(spr, {alpha: 1}, 0.3, {ease: FlxEase.linear});
		});
	}

	var canChange:Bool = true;
	private function tweenItens(visible)
	{
		canChange = false;
		if (visible)
		{
			FlxTween.tween(thumbtocandoagora, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});
			FlxTween.tween(tocandoagorasuporte, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});
			FlxTween.tween(tocandoagora, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut, onComplete:function(twn:FlxTween)
				{
					overlaySuporte.visible = false;
					canChange = true;
				}});
			optionTextsArray.forEach(function(spr:FlxText)
				{
					FlxTween.tween(spr, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
				});
			checkboxArray.forEach(function(spr:CheckboxThingie)
				{
					FlxTween.tween(spr, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
				});
		}else
		{
			overlaySuporte.visible = true;
			FlxTween.tween(thumbtocandoagora, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(tocandoagorasuporte, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(tocandoagora, {alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete:function(twn:FlxTween)
				{
					canChange = true;
				}});
			optionTextsArray.forEach(function(spr:FlxText)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				});
			checkboxArray.forEach(function(spr:CheckboxThingie)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				});
		}
	}

	private function showPlaylist()
	{
		FlxTween.tween(playListbotao, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(letrasbotao, {alpha: 0.5}, 0.5, {ease: FlxEase.quartInOut});
		tweenItens(true);
		isLetras = false;
		textGroup.visible = false;
		menuItems.visible=true;
		
		textGroup.forEach(function(spr:FlxText)
		{
			spr.alpha = 0;
		});

		menuItems.forEach(function(spr:FlxSprite)
		{
			FlxTween.tween(spr, {alpha: 1}, 0.3, {ease: FlxEase.quadInOut});
		});
	}
}

class Queue
{
	private var list:Array<String>;
	public var len:Int = 0;

	public function new (){
		list = [];
		len = 0;
	}
    
	public function queue(key:String):Void
	{
		if (!this.list.contains(key)){
			this.list.push(key); //Em teoria, o push é rapido
			this.len++;
		}
	}

	public function get_by_index(index:Int = 0){
		return this.list[index];
	}

	public function dequeue(key:String):Void
	{
		this.list.remove(key); //Mas a remoção é lenta.
		this.len--;
	}

	public function remove_keys(key:String):Void
	{
		Paths.clear_memory_by_key(key, true);
		this.dequeue(key);
	}	

}