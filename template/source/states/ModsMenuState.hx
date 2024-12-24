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
	var daMods:FlxTypedGroup<ModCard>;
	var description:FlxText;
	var curSelected:Int = 0;
	var camFollow:FlxObject;
	var mods:Array<Saturn>;
	var bg:FlxSprite;

	override function create() {
		super.create();
		
		mods = ModLoader.getInstance().getMods();

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		add(bg);

		if (mods == null || mods.length == 0) {
			var noModsText = new FlxText(0, 0, FlxG.width, "No mods found!", 32);
			noModsText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
			noModsText.screenCenter();
			add(noModsText);
			return;
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		daMods = new FlxTypedGroup<ModCard>();
		add(daMods);

		for (i in 0...mods.length) {
			var card = new ModCard(0, 60 + (i * 160), mods[i]);
			card.ID = i;
			daMods.add(card);
		}

		description = new FlxText(20, FlxG.height - 60, FlxG.width - 40, '', 24);
		description.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT);
		description.scrollFactor.set();
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

		daMods.forEach(function(card:ModCard) {
			card.alpha = mods[card.ID].isEnabled() ? 1 : 0.6;
			if (card.ID == curSelected)
				camFollow.y = card.y;
		});

		description.text = mods[curSelected].description;
		description.screenCenter(X);
	}
}

class ModCard extends FlxSprite {
	public var mod:Saturn;
	public var ID:Int = 0;
	public var nameText:FlxText;
	public var authorText:FlxText;
	public var thumbnail:FlxSprite;
	
	public function new(x:Float, y:Float, mod:Saturn) {
		super(x, y);
		this.mod = mod;
		
		makeGraphic(FlxG.width - 40, 150, 0x33FFFFFF);
		x = 20;

		thumbnail = new FlxSprite(x + 10, y + 10);
		try {
			thumbnail.loadGraphic(Paths.image('mods/${mod.id}/${mod.thumbnail}'));
		} catch(e) {
			thumbnail.loadGraphic(Paths.image('menu/unknownMod'));
		}
		thumbnail.setGraphicSize(130, 130);
		thumbnail.updateHitbox();

		nameText = new FlxText(x + 150, y + 10, 0, mod.name, 32);
		nameText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		
		authorText = new FlxText(x + 150, y + 50, 0, 'by ${mod.author}', 24);
		authorText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.GRAY, LEFT);
	}

	override function draw() {
		super.draw();
		thumbnail.draw();
		nameText.draw();
		authorText.draw();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		thumbnail.update(elapsed);
		nameText.update(elapsed);
		authorText.update(elapsed);
	}
}
