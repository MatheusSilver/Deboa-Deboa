package modifiers;

import flixel.FlxG;

class ModifiersManager
{
    public static var currentModifiers:Array<Int> = [];

        //TIPO --- NOME --- DESC --- nao pode junto
    public static var allModifiers:Array<Dynamic> = [
        [0, "modifier 1", "faz coisas", [1]], 
        [0, "modifier 2", "faz outras coisas", [0]],
        [1, "modifier 3", "te ajuda em algo sla", []]
    ];

    // TIPO 0 = DESAFIOS
    // TIPO 1 = AJUDANTES

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