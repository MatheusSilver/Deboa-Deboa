package modifiers;

class Modifier
{
    public var type:Int;
    public var name:String;
    public var description:String;
    public var naoPodeJunto:Array<Int>;
    public var multiplier:Float;

    public function new(type:Int, name:String, description:String, naoPodeJunto:Array<Int>, multiplier:Float) {
        this.type = type;
        this.name = name;
        this.description = description;
        this.naoPodeJunto = naoPodeJunto;
        this.multiplier = multiplier;
    }
}