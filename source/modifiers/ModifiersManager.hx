package modifiers;

import flixel.FlxG;

class ModifiersManager
{
    public static var currentDesafio:Int = null;
    public static var currentAjudante:Int = null;
        //TIPO --- NOME --- DESC
    public static var allModifiers:Array<Dynamic> = [
        [0, "modifier 1", "faz coisas"], 
        [0, "modifier 2", "faz outras coisas"],
        [1, "modifier 3", "te ajuda em algo sla"]
    ];
    // TIPO 0 = DESAFIOS
    // TIPO 1 = AJUDANTES

    public function setModifier(newModifierID:Int)
    {
        if(newModifierID < 0)
            trace('modifier invalido!');
            return;
        switch (getTypeById(newModifierID))
        {
            case 0:
                currentDesafio = newModifierID;
            case 1:
                currentAjudante = newModifierID;
        }
        FlxG.save.data.currentDesafio = currentDesafio;
        FlxG.save.data.currentAjudante = currentAjudante;
        trace('novo modifier adicionado: ${allModifiers[newModifierID][1]}');
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
        var propriedades:Modifier = new Modifier(allModifiers[deQual][0], allModifiers[deQual][1], allModifiers[deQual][2]);
        return propriedades;
    }

    public static function loadModifier()
    {
        if(FlxG.save.data != null) {
			if(FlxG.save.data.currentDesafio != null && FlxG.save.data.currentAjudante != null) {
                currentDesafio = FlxG.save.data.currentDesafio;
                currentAjudante = FlxG.save.data.currentAjudante;
			}
		}
    }

}