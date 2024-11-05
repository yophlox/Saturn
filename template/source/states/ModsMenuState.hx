package states;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.FlxSprite;
import saturn.ModLoader;
import saturn.Saturn;

class ModsMenuState extends FlxState {
	var daMods:FlxTypedGroup<FlxText>;
	var iconArray:Array<ModIcon> = [];
	var description:FlxText;
	var curSelected:Int = 0;
    private var gridLines:FlxTypedGroup<FlxSprite>;
    var camFollow:FlxObject;
    var mods:Array<Saturn>;

	override function create() {
        super.create();
        
        mods = ModLoader.getInstance().getMods();

        if (mods == null || mods.length == 0) {
            var noModsText = new FlxText(0, 0, FlxG.width, "No mods found!", 32);
            noModsText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            noModsText.screenCenter();
            add(noModsText);
            return;
        }

        camFollow = new FlxObject(80, 0, 0, 0);
		camFollow.screenCenter(X);

        gridLines = new FlxTypedGroup<FlxSprite>();
        for (i in 0...20) {
            var hLine = new FlxSprite(0, i * 40);
            hLine.makeGraphic(FlxG.width, 1, 0x33FFFFFF);
            hLine.scrollFactor.set(0, 0);
            gridLines.add(hLine);

            var vLine = new FlxSprite(i * 40, 0);
            vLine.makeGraphic(1, FlxG.height, 0x33FFFFFF);
            vLine.scrollFactor.set(0, 0);
            gridLines.add(vLine);
        }
        add(gridLines);

        daMods = new FlxTypedGroup<FlxText>();
        add(daMods);

        for (i in 0...mods.length) {
            var text:FlxText = new FlxText(20, 60 + (i * 60), mods[i].name, 32);
            text.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            text.ID = i;
            daMods.add(text);

            var icon:ModIcon = new ModIcon(mods[i].id);
            icon.sprTracker = text;
            iconArray.push(icon);
            add(icon);
        }

        description = new FlxText(0, FlxG.height * 0.1, FlxG.width * 0.9, '', 28);
        description.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        description.screenCenter(X);
        description.scrollFactor.set();
        description.borderSize = 3;
        add(description);

        changeSelection();

        FlxG.camera.follow(camFollow, LOCKON, 0.25);
	}

	override function update(elapsed:Float) {
        super.update(elapsed);

        if (mods == null || mods.length == 0) {
            if (FlxG.keys.anyPressed([ESCAPE, BACKSPACE])) {
                FlxG.switchState(new PlayState());
            }
            return;
        }

		var up = FlxG.keys.anyJustPressed([UP, W]);
		var down = FlxG.keys.anyJustPressed([DOWN, S]);
		var accept = FlxG.keys.anyJustPressed([ENTER, Z]);
		var exit = FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]);

		if (up || down)
			changeSelection(up ? -1 : 1);

		if (exit) {
			ModLoader.getInstance().reloadMods();
			FlxG.switchState(new PlayState());
		} else if (accept) {
			var currentMod = mods[curSelected];
			currentMod.toggle();
			changeSelection();
		}
	}

	function changeSelection(change:Int = 0) {
        if (mods == null || mods.length == 0) return;
        
        curSelected = FlxMath.wrap(curSelected + change, 0, mods.length - 1);

		for (i in 0...iconArray.length)
			iconArray[i].alpha = mods[i].isEnabled() ? 1 : 0.6;

        daMods.forEach(function(txt:FlxText) {
			txt.alpha = mods[txt.ID].isEnabled() ? 1 : 0.6;
			if (txt.ID == curSelected)
				camFollow.y = txt.y;
		});

		description.text = mods[curSelected].description;
		description.screenCenter(X);
	}
}

class ModIcon extends FlxSprite {
	public var sprTracker:FlxSprite;

	public function new(modId:String) {
		super();

		try {
			loadGraphic(Paths.image('mods/${modId}/icon'));
		} catch (e:Dynamic) {
			trace('error getting mod icon: $e');
			loadGraphic(Paths.image('menu/unknownMod'));
		}
		setGraphicSize(75, 75);
		scrollFactor.set();
		updateHitbox();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);
		}
	}
}
