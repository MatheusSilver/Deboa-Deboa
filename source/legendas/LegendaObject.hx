package legendas;

import Paths;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import ClientPrefs;
import flixel.FlxState;

class LegendaObject extends FlxSpriteGroup {

    var fundo:FlxSprite;
    var fundoGraphic:String;
    var texto:FlxSprite;
    var textoGraphic:String;
    var legendPath:String;
    public var index:Int = 0;
    public var newIndex:Int = 0;

    public function new(textoLocation:String, fundoLocation:String, legendPath:String, parent:FlxState, index:Int) {
        super();

        this.index = index;
        this.legendPath = legendPath;
        fundo = new FlxSprite(0,0);
        texto = new FlxSprite(0,0);
        var algum:Bool = false;
        if(fundoLocation != null && fundoLocation != "") {
            fundo.loadGraphic(Paths.image(legendPath+fundoLocation));
            fundoGraphic = fundoLocation;
            fundo.updateHitbox();
            this.add(fundo);
            algum = true;
        }

        if(textoLocation != null && textoLocation != "") {
            texto.loadGraphic(Paths.image(legendPath+textoLocation));
            textoGraphic = textoLocation;
            texto.updateHitbox();
            this.add(texto);
            algum = true;
        }

        if(algum)
            parent.add(this);
            return;

        LegendaManager.instance.removeLegenda(this.index);
    }

    public function updateLegenda(novoTexto:String, novoFundo:String) {
        var algum:Bool = false;

        if(novoFundo != null && novoFundo != "") {
            if(novoFundo != fundoGraphic) {
                fundo.loadGraphic(Paths.image(legendPath+novoFundo));
                fundoGraphic = novoFundo;
                fundo.updateHitbox();
            }
            algum = true;
        }
        
        if(novoTexto != null && novoTexto != "") {
            if(novoTexto != textoGraphic) {
                texto.loadGraphic(Paths.image(legendPath+novoTexto));
                textoGraphic = novoTexto;
                texto.updateHitbox();
            }
            algum = true;
        }

        this.alpha = ClientPrefs.opacidadeLegendas;

        if(algum)
            return;

        LegendaManager.instance.removeLegenda(this.index);
    }

    public function updatePos() {
        if(LegendaManager.instance.defaultSpacing == 0) {
            if(ClientPrefs.downScroll) {
                this.y = -350+(LegendaManager.instance.downScrollOffset);
            } else {
                this.y = 0;
            }
        } else {
            if(index <= 2){
                if(ClientPrefs.downScroll) {
                    this.y = ((-350+(LegendaManager.instance.downScrollOffset))+(LegendaManager.instance.defaultSpacing*(newIndex)));
                } else {
                    this.y = (0-(64*(newIndex)));
                }
            } else {
                if(!ClientPrefs.downScroll) {
                    this.y = ((-350+(LegendaManager.instance.downScrollOffset))+(LegendaManager.instance.defaultSpacing*(newIndex-2)));
                } else {
                    this.y = (0-(LegendaManager.instance.defaultSpacing*(newIndex-2)));
                }  
            }
        }
    }
}