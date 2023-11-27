package modifiers;

class Modifier
{
    public var id:Int;
    public var name:String;
    public var description:String;

    public function new(id:Int, name:String, description:String) {
        this.id = id;
        this.name = name;
        this.description = description;
    }
}