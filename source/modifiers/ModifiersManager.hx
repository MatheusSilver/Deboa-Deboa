package modifiers;

import cpp.abi.Abi;
import flixel.FlxG;

class ModifiersManager
{
    public static var currentModifiers:Array<Int> = [];

        //TIPO --- NOME --- DESC --- nao pode junto --- multiplier
        // TIPO 0 = DESAFIOS
        // TIPO 1 = AJUDANTES
    public static var allModifiers:Array<Dynamic> = [
        [0, "Notas Random", "As direções das notas mudam a cada tentativa", [14, 16], 1.08], 
        [0, "Notas Super Rápidas", "Aumenta drásticamente a velocidade da nota entre o surgimento e o alvo.", [2], 1.12],
        [0, "Notas Super Lentas", "Diminui drásticamente a velocidade da nota entre o surgimento e o alvo.", [1], 1.16],
        [0, "Fade-in das notas", "As notas são invisíveis até se aproximarem do alvo", [11], 1.08], 
        [0, "Fade-out das notas", "Notas desaparecem quando se aproximam do alvo", [11], 1.08],
        [0, "Dano maior por erro", "Erros removem mais vida que o de costume", [7, 6, 8], 1.04],
        [0, "Instakill por erro", "A música se encerra quando o combo é quebrado.", [5, 7, 8], 1.16],
        [1, "Menos dano por erro", "Erros custam menos vida que o de costume", [5, 6, 8], 0.88],
        [1, "Imortalidade", "A música não irá terminar caso sua vida chegue a zero, ou caso erre algum evento.", [5, 7, 6], 0.6],
        [1, "Regen de vida passivo", "Sua vida irá regenerar mesmo que sem acertar as notas.", [], 0.75], 
        [1, "Cura maior por acerto", "A barra de vida irá regenerar por acerto", [], 0.85],//ajudantes acaba aqui
        [0, "Notas invisíveis", "Suas notas ficam totalmente invisiveis.", [3, 4], 1.40], //micdup
        [0, "Camera girando", "O HUD ficará girando o tempo todo em uma direção", [], 1.04],
        [0, "Camera tremendo", "O HUD ficará tremendo durante a musica inteira.", [], 1.04], 
        [0, "Flip Notes", "O caminho das notas se torna o oposto do que o de costume.", [0], 1.24],
        [0, "Paparazzi", "Flashes na tela com certa frequência", [], 1.02],
        [1, "Somente duas setas", "Cima e baixo não existem mais, apenas esquerda e direita", [0], 0.85],
        [1, "Mono Botão", "Acerte todas as notas ao mesmo tempo apertando qualquer tecla", [], 0.7]
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

    public static function getMultiplierById(modifierID:Int):Float
    {
        for (i in 0...allModifiers.length)
            {
                if(i==modifierID)
                {
                    return allModifiers[i][4];
                }
            }
        return 0;
    }

    public static function getAllProperties(deQual:Int):Modifier
    {
        var propriedades:Modifier = new Modifier(allModifiers[deQual][0], allModifiers[deQual][1], allModifiers[deQual][2], allModifiers[deQual].length == 4 ? allModifiers[deQual][3] : null, allModifiers[deQual][4]);
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

    public static function getFinalModifier():Float
    {
        var multiplier_sum:Float = 1;
        var local_mul:Float = 1;
        for (modifier in 0...allModifiers.length){
            if (isEnabled(modifier)){
                local_mul = getMultiplierById(modifier);
                local_mul > 1 ? multiplier_sum += (local_mul-1) : multiplier_sum -= (1-local_mul);
            }
        }   
        trace(multiplier_sum);
        return multiplier_sum > 0.05 ? multiplier_sum : 0.05;
    }

    public static function isEnabledbyName(name:String):Bool
    {
        return isEnabled(getIdByName(name)); //Facilitar minha vida implementando cada uma dessas coisas.
    }

    public static function removerAcentos(nome:String):String
    {
        var equivalents:Array<String> = ["a", "e", "i", "o", "u", "a", "e", "i", "o", "u", "a", "o", "a", "e", "i", "o", "u", "a", "e", "i", "o", "u"];
        var accents:Array<String> = ["á", "é", "í", "ó", "ú", "â", "ê", "î", "ô", "û", "ã", "õ", "à", "è", "ì", "ò", "ù", "ä", "ë", "ï", "ö", "ü"];
        var returnVar:String = nome;
        for (i in 0...accents.length)
        {
            returnVar = returnVar.split(accents[i]).join(equivalents[i]);
        }
        return returnVar;
    }

    public static function isUsingModifiers():Bool
    {
        return getFinalModifier() != 1 ? false : true;
    }
}