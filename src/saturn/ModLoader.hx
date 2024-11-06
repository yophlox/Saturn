package saturn;

import flixel.FlxG;
import sys.FileSystem;
import haxe.Json;
import saturn.backends.AssetHandler;

class ModLoader {
    private static var instance:ModLoader;
    private var mods:Array<Saturn>;
    private var modsPath:String;
    private var disabledMods:Array<String>;
    
    public static function getInstance():ModLoader {
        if (instance == null) {
            instance = new ModLoader();
        }
        return instance;
    }
    
    private function new() {
        mods = [];
        disabledMods = [];
    }

    public function initializeSaveData():Void {
        if (FlxG.save.data != null && FlxG.save.data.disabledMods != null) {
            disabledMods = FlxG.save.data.disabledMods;
        } else {
            disabledMods = [];
            FlxG.save.data.disabledMods = disabledMods;
            FlxG.save.flush();
        }
    }

    public function saveModState():Void {
        disabledMods = [];
        for (mod in mods) {
            if (!mod.isEnabled()) {
                disabledMods.push(mod.id);
            }
        }
        FlxG.save.data.disabledMods = disabledMods;
        FlxG.save.flush();
        
        AssetHandler.clearCache();
    }

    public function isModDisabled(modId:String):Bool {
        return disabledMods.indexOf(modId) != -1;
    }
    
    public function loadMods(path:String):Void {
        this.modsPath = path;
        mods = [];
        
        if (!FileSystem.exists(path)) {
            trace('Mods directory not found: ${path}');
            return;
        }
        
        try {
            for (modDir in FileSystem.readDirectory(path)) {
                var modPath = '${path}/${modDir}';
                if (FileSystem.isDirectory(modPath)) {
                    loadMod(modPath);
                }
            }
            
            mods.sort((a, b) -> b.priority - a.priority);
            
            trace('Loaded ${mods.length} mods');
        } catch (e) {
            trace('Error loading mods: ${e}');
        }
    }
    
    private function loadMod(modPath:String):Void {
        var metadataPath = '${modPath}/mod.json';
        if (!FileSystem.exists(metadataPath)) {
            trace('No mod.json found in ${modPath}');
            return;
        }
        
        try {
            var metadata = Json.parse(sys.io.File.getContent(metadataPath));
            var mod = new Saturn(metadata);
            mods.push(mod);
            trace('Loaded mod: ${mod.name} (${mod.isEnabled() ? "enabled" : "disabled"})');
        } catch (e) {
            trace('Error loading mod from ${modPath}: ${e}');
        }
    }

    public function getMods():Array<Saturn> {
        return mods;
    }

    public function reloadMods():Void {
        mods = [];
        if (modsPath != null) {
            loadMods(modsPath);
        }
    }
} 