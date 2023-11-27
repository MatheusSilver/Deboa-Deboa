package modifiers;

class ModifiersManager
{
    public static var currentModifierID:Int;
        //ID --- NOME --- DESC
    public static var allModifiers:Array<Dynamic> = [
        [0, "modifier 1", "faz coisas"], 
        [1, "modifier 2", "faz outras coisas"],
        [2, "modifier 3", "faz mais coisas ainda 😱"]
    ];

    public function setModifier(newModifierID:Int)
    {
        if(newModifierID < 0)
            trace('modifier invalido!');
            return;
        currentModifierID = newModifierID;
        trace('novo modifier é: ${allModifiers[newModifierID][1]}');
    }

    public static function getIdByName(modifierName:String):Int
    {
        for (i in 0...allModifiers.length)
        {
            if(allModifiers[i][1]==modifierName)
            {
                return allModifiers[i][0];
            }
        }
        return -1;
    }

    public static function getNameById(modifierID:Int):String
    {
        for (i in 0...allModifiers.length)
            {
                if(allModifiers[i][0]==modifierID)
                {
                    return allModifiers[i][1];
                }
            }
        return "";
    }

    public static function getAllProperties(deQual:Int):Modifier
    {
        if(deQual < 0)
            trace('modifier invalido!');
            return null;
        var propriedades:Modifier = new Modifier(allModifiers[deQual][0], allModifiers[deQual][1], allModifiers[deQual][2]);
        return propriedades;
    }

    public static function loadModifier()
    {
        // dps faço
    }

}