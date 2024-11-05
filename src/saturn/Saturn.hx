package saturn;

import sys.FileSystem;

class Saturn {
    public var id:String;
    public var name:String;
    public var version:String;
    public var author:String;
    public var description:String;
    public var priority:Int;
    
    private var enabled:Bool;
    private var assets:Map<String, String>;
    
    public function new(metadata:Dynamic) {
        this.id = metadata.id;
        this.name = metadata.name;
        this.version = metadata.version;
        this.author = metadata.author;
        this.description = metadata.description;
        this.priority = metadata.priority != null ? metadata.priority : 0;
        
        this.enabled = !ModLoader.getInstance().isModDisabled(this.id);
        this.assets = new Map<String, String>();
    }

    public function isEnabled():Bool {
        return enabled;
    }

    public function enable():Void {
        if (!enabled) {
            enabled = true;
            ModLoader.getInstance().saveModState();
        }
    }

    public function disable():Void {
        if (enabled) {
            enabled = false;
            ModLoader.getInstance().saveModState();
        }
    }

    public function toggle():Void {
        if (enabled) disable();
        else enable();
    }
} 