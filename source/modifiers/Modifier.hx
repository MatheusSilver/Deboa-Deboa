package modifiers;

class Modifier
{
    public var type:Int;
    public var name:String;
    public var description:String;

    public function new(type:Int, name:String, description:String) {
        this.type = type;
        this.name = name;
        this.description = description;
    }
}