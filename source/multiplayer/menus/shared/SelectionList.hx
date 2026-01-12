package multiplayer.menus.shared;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class SelectionList
{
	public var value:Int;
	var list:Array<Dynamic>;
	var reference:String;

    var instance:Dynamic;

    public function new(variable:Dynamic, instance:Dynamic)
	{
		reference = variable[0];
        this.instance = instance;
		value = Reflect.getProperty(instance, reference);
		list = Reflect.getProperty(instance, variable[1]);
	}

	public function clickEsquerda()
	{
		if(value-1 >= 0)
			{
				value--;
			}
			else
			{
				value = list.length-1;
			}
		save();

	}

	public function clickDireita()
	{
		if(value+1 < list.length)
			{
				value++;
			}
			else
			{
				value = 0;
			}
		save();
	}

	public function getNameOfValue(): String {
		return tirarAcentos(list[value][0].toLowerCase());
	}

	public function getIdOfValue(): String {
		return tirarAcentos(list[value][2].toLowerCase());
	}

	public function getRawValue(): Dynamic {
		return list[value];
	}

	public dynamic function onChange() {}

	function save()
	{
		Reflect.setProperty(instance, reference, value);
		onChange();
	}

	function tirarAcentos(value:String):String {
		var comAcento = "áàãâäéèêëíìîïóòõôöúùûüçÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇ";
		var semAcento = "aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC";
		var result = value;

		for (i in 0...comAcento.length) {
			result = StringTools.replace(result, comAcento.charAt(i), semAcento.charAt(i));
		}

		return result;
	}


}