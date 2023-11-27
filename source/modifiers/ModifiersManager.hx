package modifiers;

import flixel.FlxG;

class ModifiersManager
{
    public static var currentModifiers:Array<Int> = [];

        //TIPO --- NOME --- DESC --- nao pode junto
        // TIPO 0 = DESAFIOS
        // TIPO 1 = AJUDANTES

        // TODO pro Dav: fazer um modo aqui que separe os botões em sessões que possam ser
        // trocadas ou quando apertar esquerda ou direita ou também usar o bsltouch
        // deve ser separada em: 7, 7, 4 botoes respectivamente que vão dar 18
    public static var allModifiers:Array<Dynamic> = [
        [0, "Notas Random", "Nota originalmente de um lado por ser gerada em outro", [17]], 
        [0, "Notas rápidas (até demais)", "Aumenta a velocidade em que as notas aparecem", [2]],
        [0, "Notas lentas (até demais)", "Diminui a velocidade em que as notas aparecem", [1]],
        [0, "Fade-in das notas", "Aplica efeito de fade-in nas notas", [12]], 
        [0, "Fade-out das notas", "Aplica efeito de fade-out nas notas", [12]],
        [0, "Dano maior por erro", "Seja econômico em erros k", [5]],
        [0, "Instakill por erro", "Realmente não experimente errar k", [7]],
        [0, "Limite de erros", "Tenha o poder de errar 3 vezes. Caso erre mais...", [6]], //desafios acaba aqui
        [1, "Menos dano por erro", "Faz com que o health drain no erro seja menor", [8]],
        [1, "Imortalidade", "Seja imortal (mas morra sabendo que você é ruim em jogo de ritmo)", []],
        [1, "Regen de vida passivo", "NAO SEI O QUE ISSO FAZ", []], 
        [1, "Regen de vida por acertos", "A cada acerto, sua vida aumenta uma porcentagem de (inserir porcentagem)", []],//ajudantes acaba aqui
        [0, "Notas invisíveis", "Suas notas ficam totalmente invisiveis (sim, tu não vai ver nem 1 mísero pixel)", []], //micdup
        [0, "Camera mexendo", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa tá tudo girando", []],
        [0, "Camera tremendo", "aaaaaaaaaaaaaa terremotooooo", []], 
        [0, "Flip Notes", "Esquerda vira direita e etc...", []],
        [0, "Paparazzi", "Flashes na tela com certa frequência", []],
        [1, "Somente duas setas", "Cima e baixo não existem mais, apenas esquerda e direita", [0]]
    ];

    

    public static function setModifier(newModifierID:Int)
    {
        var intNaoPode:Array<Int> = allModifiers[newModifierID][3];
        for (i in intNaoPode)
        {
            if(currentModifiers.contains(i))
            {
                currentModifiers.remove(i);
                trace('removido modifier: ${allModifiers[i][1]}');
            }
        }
        currentModifiers.push(newModifierID);
        ClientPrefs.currentModifiers = currentModifiers;
        trace('novo modifier adicionado: ${allModifiers[newModifierID][1]}');
    }

    public static function removeModifier(modifierID:Int)
    {
        if(currentModifiers.contains(modifierID))
        {
            currentModifiers.remove(modifierID);
            trace('removido modifier: ${allModifiers[modifierID][1]}');
            ClientPrefs.currentModifiers = currentModifiers;
        }
    }

    public static function getIdByName(modifierName:String):Int
    {
        for (i in 0...allModifiers.length)
        {
            if(allModifiers[i][1]==modifierName)
            {
                return i;
            }
        }
        return -1;
    }

    public static function getNameById(modifierID:Int):String
    {
        for (i in 0...allModifiers.length)
            {
                if(i==modifierID)
                {
                    return allModifiers[i][1];
                }
            }
        return "";
    }
    
    public static function getDescById(modifierID:Int):String
    {
        for (i in 0...allModifiers.length)
            {
                if(i==modifierID)
                {
                    return allModifiers[i][2];
                }
            }
        return "";
    }

    public static function getTypeById(modifierID:Int):Int
    {
        for (i in 0...allModifiers.length)
            {
                if(i==modifierID)
                {
                    return allModifiers[i][0];
                }
            }
        return -1;
    }

    public static function getAllProperties(deQual:Int):Modifier
    {
        var propriedades:Modifier = new Modifier(allModifiers[deQual][0], allModifiers[deQual][1], allModifiers[deQual][2], allModifiers[deQual].length == 4 ? allModifiers[deQual][3] : null);
        return propriedades;
    }

    public static function isEnabled(qual:Int):Bool
    {
        return currentModifiers != null ? currentModifiers.contains(qual) : false;
    }

    public static function loadSave()
    {
        currentModifiers = ClientPrefs.currentModifiers;
        trace("carregando save dos modifiers");
    }

}