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
        this.setGraphicSize(Std.int(player.members[0].width*player.members.length+10), FlxG.height*3);
        this.visible = false;
        this.oppacity = oppacity; //Caso alguem queira fazer isso variar a gosto do player
        this.strum_to_follow = player;
    }

    public override function update(elapsed:Float){
        if (this.x != this.strum_to_follow.members[2].x-5) this.x = this.strum_to_follow.members[2].x -5;
        if (this.visible != this.strum_to_follow.members[0].visible) this.visible = this.strum_to_follow.members[0].visible;
        if (strum_to_follow.members[0].alpha > this.oppacity) this.alpha = this.oppacity else this.alpha = strum_to_follow.members[0].alpha;
    }
    
}