package states;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;

class ImageState extends FlxState
{
	var sprite:FlxSprite;
	override public function create()
	{
		sprite = new FlxSprite(0, 0);
		sprite.loadGraphic(Paths.image('duck'));
		add(sprite);

		super.create();
	}

	override public function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(new PlayState());
        }
		super.update(elapsed);
	}
}
