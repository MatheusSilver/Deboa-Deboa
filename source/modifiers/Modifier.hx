package modifiers;

class Modifier
{
    public var type:Int;
    public var name:String;
    public var description:String;
    public var naoPodeJunto:Array<Int>;

    public function new(type:Int, name:String, description:String, ?naoPodeJunto:Array<Int>) {
        this.type = type;
        this.name = name;
        this.description = description;
        this.naoPodeJunto = naoPodeJunto;
    }
}