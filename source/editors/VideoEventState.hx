package editors;

/*
"Seu Madruga Will Go On"
NÃO! NÃO!
Nã-nam-nã-nã-nam-nã-nam-nã-nã
NÃO! NÃO!

AAAAAhhhh! Pam-na-nã-nam-nã-nam!
NÃO! NÃO!


Pô-papa-Pô-papaaaaa...

AHH! AH-ah AAAAAHHH!

Essaaa ca-ca-ca-caveira
Siiiiiiiiiiiguinifica
PÊÊÊÊriiiiigooooooooo!

PêÊÊêêrigoooo!
BAaaaaaaaHHHH Baaanndeeiira
Deeee piiiiii raaaa taaaa! ?


( Aotóh )


Que
QUEM-QUEM
QUEM-QUEM-QUEêêêêêÊÊÊMMM


Rá-rá-rá-ra ró-ró-róóóó
Taaammm-DÚúúúúúúú!

Taaammm-DÚúúúúúúu!
Tam-Dam DÚ-dííííííhhh! (HoouuÚÚ)


AAAAnuncio No Cemiterioooo!
NÃO! -NÃO! -NÃO! -NÃO!
NÃO NÃO NÃO NÃO NÃO!

Essa caveira significa
Prê-Prê-Prê-Ri-goooooooo!


NÃO! NÃO!
Nã-nam-nã-nã-nam-nã-nam-nã-nã
NÃO! NÃO!

AAAAAhhhh! Pam-na-nã-nam-nã-nam!
NÃO! NÃO!


Pô-papa-Pô-papaaaaa...

AHH! AH-ah AAAAAHHH!

Essaaa ca-ca-ca-caveira
Siiiiiiiiiiiguinifica
PÊÊÊÊriiiiigooooooooo!

PêÊÊêêrigoooo!
BAaaaaaaaHHHH Baaanndeeiira
Deeee piiiiii raaaa taaaa! ?


Pêri-pêri-pêriiiiiii pêêêriiiiiggooooo!
Pêêêêêêrigo! (4x)
*/

// Na real nem sei se isso vai ser usado, mas se quiserem rosbarem para algum outro projeto eu permito
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import lime.utils.Assets;
import PlayState;
import haxe.Json;
import lime.system.Clipboard;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxObject;
import MP4Handler;
import flixel.util.FlxColor;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;

using StringTools;

class VideoEventState extends MusicBeatState 
{
	private var camVideo:FlxCamera;
	private var camBotoes:FlxCamera;
	var caminho:String = 'assets/videos/'; // Esse caminho só vai até a pasta base, caso quiser colocar um vídeo em outra pasta o caminho no editor deverá ser "nomedapasta/nomedovideo.formatodovideo"
	var curselected:Int = 1;
	var savemode:FlxText;

	var result:String;
	var _file:FileReference;

	// DADOS
	
	// A partir daqui dados de todos os video players
	var nomedovideo:String = "AnimacoesJogaveis/fest.webm"; //anti crashing moment -yep
	var x:String = "0"; //yep
	var y:String = "0";//yep
	var zoom:String = "1"; //yep
	// A partir daqui video player do dav
	var audiovolume:String = "1"; //yep
	var muteplayaudio:String = "false"; //yep
	var endingsong1:String = "false"; //nop
	// A partir daqui webm video player do Silver
	var chromakey:Float = 0; // Isso aqui só serve pros dados da exportação.
	var layering:Float = 0; //yep
	// cabô

	// MP4
	public static var videoSpr:FlxSprite;
	public static var video:MP4Handler;
	var letext:FlxText;
	public static var mp4playing:Bool = false;
	public static var mp4paused:Bool = false;

	// Botões
	var play:FlxUIButton;
	var pause:FlxUIButton;
	var nome:FlxUIInputText;
	var mpa:FlxUIButton;
	var export:FlxUIButton;
	var audiovol:FlxUIInputText;
	var xpos:FlxUIInputText;
	var ypos:FlxUIInputText;
	var zoombt:FlxUIInputText;
	var layer:FlxUIInputText;
	var endingsong:FlxUIButton;

	var b1:Bool = false;
	var helloimcristianoronaldo:Bool = false;

	// Exportação
	var input:String;
	var output:String;

	public static var instance:editors.VideoEventState;

	override function create()
	{
		FlxG.sound.music.stop(); // aaaaaaa
		FlxG.mouse.visible = Main.mouse;

		instance = this;

		savemode = new FlxText(50, FlxG.height - 100, FlxG.width - 100, "< VIDEO PLAYER MP4 (dav) >", 24); // Achei cringe
		//savemode.cameras = [camBotoes]; se for isso eu vou ficar puto
		// sim, era o erro
		add(savemode);

		caminho = 'assets/videos/' + nomedovideo;
		
		camVideo = new FlxCamera();
		camVideo.bgColor.alpha = 0;
		camBotoes = new FlxCamera();
		camBotoes.bgColor.alpha = 0;

		FlxG.cameras.add(camVideo, false);
		FlxG.cameras.add(camBotoes, false);

		// Vídeos MP4 e Webm rodam via isso aqui
		letext = new FlxText(50, FlxG.height - 100, FlxG.width - 100, "", 32); // Achei cringe
		letext.alpha = 0;
		add(letext); //ESSE TROÇO CRASHA SEM ESSE MARDITO TEXTO AAAAAAAAAAAAAAA
		
		videoSpr = new FlxSprite(0, 0);
		videoSpr.visible = true;
		videoSpr.cameras = [camVideo];
		VideoStatePC.NextState = "nenhum";
		
		video = new MP4Handler();
		video.vimdoplaystatemano = true; // Não sei pra que isso serve, mas vou seguir os passos do mano davzera games
		video.canSkip = false;

		MP4Handler.iAmSobre = false;

		videoSpr.setGraphicSize(Std.int(videoSpr.width * Std.parseFloat(zoom)));

		// Botões
		play = new FlxUIButton(1145 * 0.75, 100, "Testar video", function() {
			if(nome.text != "Nome do video") {
				// traces de segurança
				// sim, por mais que eu tivesse codado o webm, eu descobri que dava pra rodar com mp4handler do dav
				trace("clicou no play");
				trace(nomedovideo);
				trace(caminho);
				nomedovideo = nome.text;
				audiovolume = audiovol.text;
				//grazadeus a partir daqui é easy peazy lemon squizy
				videoSpr.x = Std.parseFloat(xpos.text);
				x = xpos.text;
				videoSpr.y = Std.parseFloat(ypos.text);
				y = ypos.text;
				videoSpr.setGraphicSize(Std.int(videoSpr.width * Std.parseFloat(zoombt.text)));
				zoom = zoombt.text; 
				layering = Std.parseFloat(layer.text); // parsefloat aqui
				//endingsong1 = bool dentro do button
				caminho = "assets/videos/" + nome.text;

				if(Assets.exists(caminho)) {
						if (mp4playing)
						{
							video.queronaoviver = true;
							video.pausarvideo1(true);
							mp4playing = false;
							mp4paused = true;
							remove(videoSpr);
						}
						add(videoSpr);
						video.playMP4(caminho, null, videoSpr, true); // loop = bool para repetição do vídeo
						mp4playing = true;
				} else {

					FlxG.log.error("O vídeo não existe e não foi possível tocar");

				}
			}

			
		});
		play.cameras = [camBotoes];
		play.setLabelFormat("VCR OSD Mono",24,FlxColor.BLACK,"center");
		play.resize(210,60);
		add(play);

		pause = new FlxUIButton(1145 * 0.75, 170, "Pausar video", function() {
					if (mp4playing)
					{
						video.queronaoviver = true;
						video.pausarvideo1(true);
						mp4playing = false;
						mp4paused = true;
					}
		});
		pause.cameras = [camBotoes];
		pause.setLabelFormat("VCR OSD Mono",24,FlxColor.BLACK,"center");
		pause.resize(210,60);
		add(pause);

		mpa = new FlxUIButton(1145 * 0.75, 302, "Mute play audio", function() {
			// sim sim, eu passei um tempo tentando entender pq o code tava loopando
			// suicid-
			if(b1) {
				b1 = false;
				muteplayaudio = "false";
				mpa.setLabelFormat("VCR OSD Mono",24,FlxColor.RED,"center");
			} else if(!b1){
				b1 = true;
				muteplayaudio = "true";
				mpa.setLabelFormat("VCR OSD Mono",24,FlxColor.GREEN,"center");
			}
		});
		mpa.cameras = [camBotoes];
		mpa.setLabelFormat("VCR OSD Mono",24,FlxColor.BLACK,"center");
		mpa.resize(210,60);
		add(mpa);

		audiovol = new FlxUIInputText(10, 10, 210, "Vol. do audio", 24);
		audiovol.cameras = [camBotoes];
		audiovol.x = 858;
		audiovol.y = 390;
		add(audiovol);

		export = new FlxUIButton(1145 * 0.75, 434, "Exportar", function() {
			if(nome.text != "Nome do video") {
				nomedovideo = nome.text;
				audiovolume = audiovol.text;
				//grazadeus a partir daqui é easy peazy lemon squizy
				videoSpr.x = Std.parseFloat(xpos.text);
				x = xpos.text;
				videoSpr.y = Std.parseFloat(ypos.text);
				y = ypos.text;
				videoSpr.setGraphicSize(Std.int(videoSpr.width * Std.parseFloat(zoombt.text)));
				zoom = zoombt.text; 
				layering = Std.parseFloat(layer.text); // parsefloat aqui
			caminho = "assets/videos/" + nomedovideo;
			trace("fui clicado");
			trace(nomedovideo);
			input = nomedovideo;

			if(nomedovideo.contains(".mp")) {
				output = input.replace(".mp", "");
			}

			if(nomedovideo.contains(".webm")) {
				output = input.replace(".webm", "");
			}

			trace(output);

			var modo:String = savemode.text;
			switch(modo) {
			case "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER MP4 (dav) >\nesconder hud: H":
				trace("eu to chegando aqui");
				result = {
					'"video player",\n
					"${output}",\n
					"${audiovolume}",\n
					"${muteplayaudio}",\n
					"${endingsong1}"';
				}

				_file = new FileReference();
				_file.addEventListener(Event.COMPLETE, onSaveComplete);
				_file.addEventListener(Event.CANCEL, onSaveCancel);
				_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
				_file.save(result.trim(), "output.json");
				
			case "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER MP4 (silver) >\nesconder hud: H":
				result = {
					'triggerEvent("video player super legal demais", "${output}", "${x}", "${y}", "${zoom}");';
				}

				_file = new FileReference();
				_file.addEventListener(Event.COMPLETE, onSaveComplete);
				_file.addEventListener(Event.CANCEL, onSaveCancel);
				_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
				_file.save(result.trim(), "output.lua");
				
			case "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER WEBM (silver) >\nesconder hud: H":
				result = {
					'"comecarvideo",\n
					"${output},\n
					"${x}", "${y}", "${zoom}", "${chromakey}", "${layering}",\n
					"",\n
					"",\n
					""';
				}

				_file = new FileReference();
				_file.addEventListener(Event.COMPLETE, onSaveComplete);
				_file.addEventListener(Event.CANCEL, onSaveCancel);
				_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
				_file.save(result.trim(), "output.json");
			}
		}
		});
		export.cameras = [camBotoes];
		export.setLabelFormat("VCR OSD Mono",24,FlxColor.BLACK,"center");
		export.resize(210,60);
		add(export);

		nome = new FlxUIInputText(10, 10, 210, "Nome do video", 24);
		nome.cameras = [camBotoes];
		nome.x = 858;
		nome.y = 250;
		add(nome);

		xpos = new FlxUIInputText(10, 10, 210, "X", 24); // X, mas não é o vídeos rapaziada
		xpos.cameras = [camBotoes];
		xpos.x = 1145 * 0.5; //spolai, munlai
		xpos.y = play.y;
		add(xpos);

		ypos = new FlxUIInputText(10, 10, 210, "Y", 24); // Y, yay
		ypos.cameras = [camBotoes];
		ypos.x = 1145 * 0.5;
		ypos.y = pause.y;
		add(ypos);

		zoombt = new FlxUIInputText(10, 10, 210, "Zoom", 24); // Y, yay
		zoombt.cameras = [camBotoes];
		zoombt.x = 1145 * 0.5;
		zoombt.y = nome.y;
		add(zoombt); 

		layer = new FlxUIInputText(10, 10, 210, "Camada", 24); // Y, yay
		layer.cameras = [camBotoes];
		layer.x = 1145 * 0.5;
		layer.y = mpa.y;
		add(layer); 

		endingsong = new FlxUIButton(1145 * 0.5, audiovol.y, "endingsong1?", function() {
			if(helloimcristianoronaldo) {
				helloimcristianoronaldo = false;
				endingsong1 = "false";
				endingsong.setLabelFormat("VCR OSD Mono",24,FlxColor.RED,"center");
			} else if(!helloimcristianoronaldo){
				helloimcristianoronaldo = true;
				endingsong1 = "true";
				endingsong.setLabelFormat("VCR OSD Mono",24,FlxColor.GREEN,"center");
			}
		});
		endingsong.cameras = [camBotoes];
		endingsong.setLabelFormat("VCR OSD Mono",24,FlxColor.BLACK,"center");
		endingsong.resize(210,60);
		add(endingsong);


		super.create();
	}

	function onSaveComplete(_):Void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL, onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
			FlxG.log.notice("Successfully saved LEVEL DATA.");
		}

	function onSaveCancel(_):Void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL, onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
		}
	
		/**
		 * Called if there is an error while saving the gameplay recording.
		 */
		function onSaveError(_):Void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL, onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
			FlxG.log.error("Problem saving Level data");
		}

	override function update(elapsed:Float) {
		if(curselected < 1) curselected = 3;
		if(curselected > 3) curselected = 1;
		if(FlxG.keys.justPressed.Q) {
			curselected--;
		}
		if(FlxG.keys.justPressed.R) {
			curselected++;
		}
		if(FlxG.keys.justPressed.H) {
			if(camBotoes.visible) {
				camBotoes.visible = false;
			} else if(!camBotoes.visible){
				camBotoes.visible = true;
			}	
		}
		if(FlxG.keys.justPressed.ESCAPE) {
			FlxG.sound.music.play();
			video.stopVideo();
			MusicBeatState.switchState(new MainMenuStateMobile());
		}
		
		switch(curselected) {
			
			case 1:
			savemode.text = "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER MP4 (dav) >\nesconder hud: H";
			case 2:
			savemode.text = "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER MP4 (silver) >\nesconder hud: H";
			case 3:
			savemode.text = "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER WEBM (silver) >\nesconder hud: H";
		}
		super.update(elapsed);
	}
}