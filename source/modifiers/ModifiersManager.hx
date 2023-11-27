package modifiers;

import flixel.FlxG;

class ModifiersManager
{
    public static var currentModifiers:Array<Int>;

        //TIPO --- NOME --- DESC --- ?nao pode junto
    public static var allModifiers:Array<Dynamic> = [
        [0, "modifier 1", "faz coisas"], 
        [0, "modifier 2", "faz outras coisas", [0]],
        [1, "modifier 3", "te ajuda em algo sla"]
    ];

    // TIPO 0 = DESAFIOS
    // TIPO 1 = AJUDANTES

    public static function setModifier(newModifierID:Int)
    {
        if(newModifierID < 0)
            trace('modifier invalido!');
            return;
        if(allModifiers[newModifierID].length == 4)
        {
            for (i in 0...allModifiers[newModifierID][3])
            {
                if(currentModifiers.contains(i))
                {
                    currentModifiers.remove(i);
                    trace('removido modifier: ${allModifiers[i][1]}');
                }
            }
        }
        currentModifiers.push(newModifierID);
        FlxG.save.data.currentModifiers = currentModifiers;
        trace('novo modifier adicionado: ${allModifiers[newModifierID][1]}');
    }

    public static function removeModifier(modifierID:Int)
    {
        if(modifierID < 0)
            trace('modifier invalido!');
            return;
        if(currentModifiers.contains(modifierID))
        {
            currentModifiers.remove(modifierID);
            trace('removido modifier: ${allModifiers[modifierID][1]}');
            FlxG.save.data.currentModifiers = currentModifiers;
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
        if(deQual < 0)
            trace('modifier invalido!');
            return null;
        var propriedades:Modifier = new Modifier(allModifiers[deQual][0], allModifiers[deQual][1], allModifiers[deQual][2], allModifiers[deQual].length == 4 ? allModifiers[deQual][3] : null);
        return propriedades;
    }

    public static function loadModifier()
    {
        if(FlxG.save.data != null) {
			if(FlxG.save.data.currentModifiers != null) {
                currentModifiers = FlxG.save.data.currentModifiers;
			}
		}
    }

}