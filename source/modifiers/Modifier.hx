package modifiers;

class Modifier
{
    public var type:Int;
    public var name:String;
    public var id:String;
    public var description:String;
    public var naoPodeJunto:Array<Int>;
    public var multiplier:Float;

    public function new(type:Int, id:String, naoPodeJunto:Array<Int>, multiplier:Float) {
        this.type = type;
        this.name = Linguagem.LangUtil.getString("mod_name_"+id,"modifier");
        this.id = id;
        this.description = Linguagem.LangUtil.getString("mod_desc_"+id,"modifier");
        this.naoPodeJunto = naoPodeJunto;
        this.multiplier = multiplier;
    }
}