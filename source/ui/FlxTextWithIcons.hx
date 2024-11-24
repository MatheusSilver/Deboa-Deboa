package ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxG;
import ajustes.InputLabel;
import Linguagem.LangUtil;
import flixel.group.FlxSpriteGroup;


class FlxTextWithIcons extends FlxSpriteGroup {
    private var elements:Array<Dynamic>;
    var images:Array<FlxSprite> = [];
    var nominhos:Array<String> = [];

    public function new(content:String, font:String = "vcr") {
        super(0, 0);
        elements = [];

        parseContent(content, 50, font);

        positionElements();
    }

    private function parseContent(content:String, yPosition:Float, font:String):Void {
        var parts:Array<Dynamic> = content.split("[");
        var xOffset:Float = 0;

        for (part in parts) {
            if (part.indexOf("]") != -1) {
                var splitPart = part.split("]");
                var imagePath = splitPart[0];
                var remainingText = splitPart[1];

                var image = new FlxSprite(xOffset, 0, Paths.image(InputLabel.instance.getKeyLabelPath(imagePath)));
                //image.scale.set(1, 1);
                add(image);
                elements.push(image);
                images.push(image);
                nominhos.push(imagePath);
                image.y = image.height/4;
                //xOffset += 5;

                if (remainingText != "") {
                    var text = new FlxText(xOffset, yPosition, 0, remainingText);
                    text.setFormat(LangUtil.getFont(font), 32, 0xFFFFFF, "left");
                    add(text);
                    elements.push(text);
                    xOffset += text.width;
                }
            } else {
                var text = new FlxText(xOffset, yPosition, 0, part);
                text.setFormat(LangUtil.getFont(font), 32, 0xFFFFFF, "left");
                add(text);
                elements.push(text);
                xOffset += text.width;
            }
        }
    }

    override function update(elapsed:Float) {
        for (i in 0...images.length) {
            images[i].loadGraphic(Paths.image(InputLabel.instance.getKeyLabelPath(nominhos[i])));
            //trace(InputLabel.instance.getKeyLabelPath(nominhos[i]));
        }
    }

    private function positionElements():Void {
        var totalWidth = 0;
        for (element in elements) {
            totalWidth += element.width;
        }

        var xOffset = (FlxG.width - totalWidth) / 2;
        for (element in elements) {
            element.x = xOffset;
            xOffset += element.width;
        }
    }
}
