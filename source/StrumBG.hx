package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class StrumBG extends FlxSprite
{
    private var strum_to_follow:FlxTypedGroup<StrumNote>;
    private var oppacity:Float;

    public function new (player:FlxTypedGroup<StrumNote>, ?oppacity:Float = 0.7){
        super(0, 0);

        this.makeGraphic(1,1, FlxColor.BLACK);
        this.setGraphicSize(1, FlxG.height*3);
        this.updateHitbox();
        this.visible = false;
        this.oppacity = oppacity; //Caso alguem queira fazer isso variar a gosto do player
        this.strum_to_follow = player;
    }

    public override function update(elapsed:Float){
        if (this.scale.x != calculate_width(strum_to_follow)){
            this.scale.x = calculate_width(strum_to_follow);
            this.updateHitbox();
        } //Código complicado só pra ter um efeitin bonitin lá na Triple Bolo.
        if (this.x != this.strum_to_follow.members[0].x) this.x = this.strum_to_follow.members[0].x;
        if (this.visible != this.strum_to_follow.members[0].visible) this.visible = this.strum_to_follow.members[0].visible;
        if (strum_to_follow.members[0].alpha > this.oppacity) this.alpha = this.oppacity else this.alpha = strum_to_follow.members[0].alpha;
    }

    private function calculate_width(items:FlxTypedGroup<StrumNote>):Float{
        return items.members[items.members.length-1].x+items.members[items.members.length-1].width-items.members[0].x;
    }
    
}