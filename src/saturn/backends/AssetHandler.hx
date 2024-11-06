package saturn.backends;

import flixel.FlxG;
import sys.FileSystem;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import sys.io.File;
import openfl.display.BitmapData;
import flixel.graphics.frames.FlxAtlasFrames;

class AssetHandler {
    private static var pathCache:Map<String, String> = new Map();

    public static function clearCache():Void {
        pathCache = new Map();
    }

    public static function getPath(originalPath:String):String {
        if (pathCache.exists(originalPath)) {
            return pathCache.get(originalPath);
        }
        
        var mods = ModLoader.getInstance().getMods();
        
        for (mod in mods) {
            if (!mod.isEnabled()) continue;
            
            var assetPath = StringTools.replace(originalPath, "assets/", "");
            
            var modPath = 'mods/${mod.id}/assets/${assetPath}';
            
            trace('Checking for asset at: ${modPath}');
            
            if (FileSystem.exists(modPath)) {
                trace('Found modded asset: ${modPath}');
                pathCache.set(originalPath, modPath);
                return modPath;
            }
        }
        
        if (!StringTools.startsWith(originalPath, "assets/")) {
            originalPath = 'assets/${originalPath}';
        }
        
        trace('Using original asset: ${originalPath}');
        pathCache.set(originalPath, originalPath);
        return originalPath;
    }

    public static function getBitmapData(path:String):BitmapData {
        var finalPath = getPath(path);
        
        if (StringTools.startsWith(finalPath, "mods/")) {
            try {
                var bytes = File.getBytes(finalPath);
                return BitmapData.fromBytes(bytes);
            } catch (e) {
                trace('Error loading modded image ${finalPath}: ${e}');
                return openfl.Assets.getBitmapData(path);
            }
        }
        
        return openfl.Assets.getBitmapData(finalPath);
    }

    public static function getText(path:String):String {
        var finalPath = getPath(path);
        
        if (StringTools.startsWith(finalPath, "mods/")) {
            return File.getContent(finalPath);
        }
        
        return openfl.Assets.getText(finalPath);
    }

    public static function getSound(path:String) {
        var finalPath = getPath(path);
        
        if (StringTools.startsWith(finalPath, "mods/")) {
            return openfl.media.Sound.fromFile(finalPath);
        }
        
        return openfl.Assets.getSound(finalPath);
    }

    public static function getSparrowAtlas(path:String) {
        var xmlPath = StringTools.replace(path, ".png", ".xml");
        var texture = getBitmapData(path);
        var xml = getText(xmlPath);
        return FlxAtlasFrames.fromSparrow(texture, xml);
    }

    public static function getXML(path:String):Xml {
        return Xml.parse(getText(path));
    }

    public static function getJson(path:String):Dynamic {
        return haxe.Json.parse(getText(path));
    }
} 