package editors;

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
import Videos.MP4Sprite;
import flixel.util.FlxColor;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
using StringTools;

class VideoEventState extends MusicBeatState {
    private var camVideo:FlxCamera;
    private var camBotoes:FlxCamera;
    var caminho:String = 'assets/videos/';
    var curselected:Int = 1;
    var savemode:FlxText;
    var result:String;
    var _file:FileReference;

    // DADOS
    var nomedovideo:String = "AnimacoesJogaveis/fest.mp";
    var x:String = "0";
    var y:String = "0";
    var zoom:String = "1";
    var audiovolume:String = "1";
    var muteplayaudio:String = "false";
    var endingsong1:String = "false";

    // MP4
    public static var video:MP4Sprite;
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

    override function create() {
        FlxG.sound.music.stop();
        Main.mouse_allowed = true;
        instance = this;

        savemode = new FlxText(50, FlxG.height - 100, FlxG.width - 100, "< VIDEO PLAYER MP4 (dav) >", 24);
        add(savemode);

        caminho = 'assets/videos/' + nomedovideo;

        camVideo = new FlxCamera();
        camVideo.bgColor.alpha = 0;
        camBotoes = new FlxCamera();
        camBotoes.bgColor.alpha = 0;

        FlxG.cameras.add(camVideo, false);
        FlxG.cameras.add(camBotoes, false);

        letext = new FlxText(50, FlxG.height - 100, FlxG.width - 100, "", 32);
        letext.alpha = 0;
        add(letext);

        video = new MP4Sprite(0,0,EDITOR);
        video.canSkip = false;

        video.visible = true;
        video.cameras = [camVideo];

        video.scale.x = video.scale.y = Std.parseFloat(zoom);

        // Botões
        play = createButton(1145 * 0.75, 100, "Testar video", onPlayClick);
        pause = createButton(1145 * 0.75, 170, "Pausar video", onPauseClick);
        mpa = createButton(1145 * 0.75, 302, "Mute play audio", onMutePlayAudioClick);
        export = createButton(1145 * 0.75, 434, "Exportar", onExportClick);
        audiovol = createInputText(858, 390, "Vol. do audio", 24);
        nome = createInputText(858, 250, "Nome do video", 24);
        xpos = createInputText(1145 * 0.5, play.y, "X", 24);
        ypos = createInputText(1145 * 0.5, pause.y, "Y", 24);
        zoombt = createInputText(1145 * 0.5, nome.y, "Zoom", 24);
        layer = createInputText(1145 * 0.5, mpa.y, "Camada", 24);
        endingsong = createButton(1145 * 0.5, audiovol.y, "endingsong1?", onEndingsongClick);

        super.create();
    }

    function createButton(x:Float, y:Float, label:String, callback:Void->Void):FlxUIButton {
        var button:FlxUIButton = new FlxUIButton(x, y, label, callback);
        button.cameras = [camBotoes];
        button.setLabelFormat("VCR OSD Mono",24,FlxColor.BLACK,"center");
        button.resize(210,60);
        add(button);
        return button;
    }

    function createInputText(x:Float, y:Float, label:String, size:Int):FlxUIInputText {
        var inputText:FlxUIInputText = new FlxUIInputText(10, 10, 210, label, size);
        inputText.cameras = [camBotoes];
        inputText.x = x;
        inputText.y = y;
        add(inputText);
        return inputText;
    }

    function onPlayClick() {
        if(nome.text != "Nome do video") {
            trace("clicou no play");
            trace(nomedovideo);
            nomedovideo = nome.text;
            audiovolume = audiovol.text;
            video.x = Std.parseFloat(xpos.text);
            x = xpos.text;
            video.y = Std.parseFloat(ypos.text);
            y = ypos.text;
            video.scale.x = video.scale.y = Std.parseFloat(zoombt.text);
            zoom = zoombt.text;
            caminho = "assets/videos/" + nome.text;

            if(Assets.exists(caminho)) {
                if (mp4playing) {
                    video.queronaoviver = true;
                    video.pausarvideo1(true);
                    mp4playing = false;
                    mp4paused = true;
                    remove(video);
                }
                add(video);
                video.playMP4(caminho);
                mp4playing = true;
            } else {
                FlxG.log.error("O vídeo não existe e não foi possível tocar");
            }
        }
    }

    function onPauseClick() {
        if (mp4playing) {
            video.queronaoviver = true;
            video.pausarvideo1(true);
            mp4playing = false;
            mp4paused = true;
        }
    }

    function onMutePlayAudioClick() {
        if(b1) {
            b1 = false;
            muteplayaudio = "false";
            mpa.setLabelFormat("VCR OSD Mono",24,FlxColor.RED,"center");
        } else if(!b1){
            b1 = true;
            muteplayaudio = "true";
            mpa.setLabelFormat("VCR OSD Mono",24,FlxColor.GREEN,"center");
        }
    }

    function onExportClick() {
        if(nome.text != "Nome do video") {
            nomedovideo = nome.text;
            audiovolume = audiovol.text;
            video.x = Std.parseFloat(xpos.text);
            x = xpos.text;
            video.y = Std.parseFloat(ypos.text);
            y = ypos.text;
            video.scale.x = video.scale.y = Std.parseFloat(zoombt.text);
            zoom = zoombt.text; 
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
            }
        }
    }

    function onEndingsongClick() {
        if(helloimcristianoronaldo) {
            helloimcristianoronaldo = false;
            endingsong1 = "false";
            endingsong.setLabelFormat("VCR OSD Mono",24,FlxColor.RED,"center");
        } else if(!helloimcristianoronaldo){
            helloimcristianoronaldo = true;
            endingsong1 = "true";
            endingsong.setLabelFormat("VCR OSD Mono",24,FlxColor.GREEN,"center");
        }
    }

    function onSaveComplete(_):Void {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.notice("Successfully saved LEVEL DATA.");
    }

    function onSaveCancel(_):Void {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
    }

    function onSaveError(_):Void {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.error("Problem saving Level data");
    }

    override function update(elapsed:Float) {
        if(curselected < 1) curselected = 2;
        if(curselected > 2) curselected = 1;
        if(FlxG.keys.justPressed.Q) {
            curselected--;
        }
        if(FlxG.keys.justPressed.R) {
            curselected++;
        }
        if(FlxG.keys.justPressed.H) {
            camBotoes.visible = !camBotoes.visible;
        }
        if(FlxG.keys.justPressed.ESCAPE) {
            FlxG.sound.music.play();
            video.stop();
            MusicBeatState.switchState(new MainMenuStateMobile());
        }
        
        switch(curselected) {
            case 1:
                savemode.text = "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER MP4 (dav) >\nesconder hud: H";
            case 2:
                savemode.text = "modo de exportacao (trocar com Q-R)\n< VIDEO PLAYER MP4 (silver) >\nesconder hud: H";
        }
        super.update(elapsed);
    }
}