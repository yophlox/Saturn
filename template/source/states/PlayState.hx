package states;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	private var gridLines:FlxTypedGroup<FlxSprite>;
	override public function create()
	{
        ModLoader.getInstance().initializeSaveData();
		gridLines = new FlxTypedGroup<FlxSprite>();
        for (i in 0...20) {
            var hLine = new FlxSprite(0, i * 40);
            hLine.makeGraphic(FlxG.width, 1, 0x33FFFFFF);
            hLine.scrollFactor.set(0, 0);  // Add this line
            gridLines.add(hLine);

            var vLine = new FlxSprite(i * 40, 0);
            vLine.makeGraphic(1, FlxG.height, 0x33FFFFFF);
            vLine.scrollFactor.set(0, 0);  // Add this line
            gridLines.add(vLine);
        }
        add(gridLines);

		super.create();
	}

	override public function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(new ImageState());
        }
        if (FlxG.keys.justPressed.SEVEN) {
            ModLoader.getInstance().saveModState();
            FlxG.switchState(new ModsMenuState());
        }
		super.update(elapsed);
	}
}
