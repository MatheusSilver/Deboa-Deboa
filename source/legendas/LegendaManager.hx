package legendas;

import flixel.FlxState;
import flixel.FlxG;

class LegendaManager {

    public var legendas:Array<LegendaObject> = [];
    public var legendaCamRef:String;
    public var downScrollOffset:Float = 0;
    var legendPath:String;
    var parent:FlxState;
    public static var instance:LegendaManager;

    public function new(legendaCamRef:String, parent:FlxState, legendPath:String, ?offset:Float = 0) {
        instance = this;
        this.legendaCamRef = legendaCamRef;
        this.parent = parent;
        this.legendPath = legendPath;
        this.downScrollOffset = offset;
        FlxG.watch.add(this, "legendas", "Legendas");
    }

    public function atualizarY() {
        legendas.sort((a, b) -> a.index - b.index);
        for (i in 0...legendas.length) {
            legendas[i].cameras = [Reflect.getProperty(parent, legendaCamRef)];
            legendas[i].newIndex = i;
            legendas[i].updatePos();
        }
    }

    public function addLegenda(novoTexto:String, ?fundo:String = "", id:Int) {
        if(findLegendaWithIndex(id) != null) {
            updateLegenda(id, novoTexto, fundo);
        } else {
            legendas.push(new LegendaObject(novoTexto, fundo, legendPath, parent, id));
            atualizarY();
        }
    }

    public function updateLegenda(id:Int, novoText:String, novoFundo:String) {
        findLegendaWithIndex(id).updateLegenda(novoText, novoFundo);
        atualizarY();
    }

    public function removeLegenda(id:Int) {
        var legenda:LegendaObject = findLegendaWithIndex(id);
        if(legenda == null) return;
        legendas.remove(legenda);
        parent.remove(legenda);
        atualizarY();
    }

    function findLegendaWithIndex(id:Int):LegendaObject {
        for (i in 0...legendas.length) {
            if(legendas[i].index == id) {
                return legendas[i];
            }
        }
        return null;
    }
}