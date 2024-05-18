package modifiers;

import cpp.abi.Abi;
import flixel.FlxG;

class ModifiersManager
{
    public static var currentModifiers:Array<Int> = [];
        //0    --- 1    --- 2              --- 3
        //TIPO --- NOME --- nao pode junto --- multiplier
        // TIPO 0 = DESAFIOS
        // TIPO 1 = AJUDANTES
    public static var allModifiers:Array<Dynamic> = [
        [0, "rand_note", [14, 16], 1.08], 
        [0, "fast_note", [2], 1.12],
        [0, "slow_note", [1], 1.16],
        [0, "fade_in_note", [11], 1.08], 
        [0, "fade_out_note", [11], 1.08],
        [0, "more_damage", [7, 6, 8], 1.04],
        [0, "instakill", [5, 7, 8], 1.16],
        [1, "less_damage", [5, 6, 8], 0.88],
        [1, "no_death", [5, 7, 6], 0.6],
        [1, "passive_regen", [], 0.75], 
        [1, "more_regen", [], 0.85],
        [0, "invisible_notes", [3, 4], 1.40],
        [0, "spin_camera", [], 1.04],
        [0, "shake_camera", [], 1.04], 
        [0, "flip_note", [0], 1.24],
        [0, "paparazzi", [], 1.02],
        [1, "only_two",  [0], 0.85],
        [1, "single_button", [], 0.7]
];

    

    public static function setModifier(newModifierID:Int)
    {
        var intNaoPode:Array<Int> = allModifiers[newModifierID][2];
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
                    return Linguagem.LangUtil.getString("mod_desc_"+allModifiers[i][1], "modifier");
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
                    return allModifiers[i][3];
                }
            }
        return 0;
    }

    public static function getAllProperties(deQual:Int):Modifier
    {
        var propriedades:Modifier = new Modifier(allModifiers[deQual][0], allModifiers[deQual][1], allModifiers[deQual][2], allModifiers[deQual][3]);
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

    public static function isUsingModifiers():Bool
    {
        return getFinalModifier() != 1;
    }
}