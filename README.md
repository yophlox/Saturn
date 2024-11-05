# Saturn

A w.i.p. modding framework for HaxeFlixel games.

I don't plan on doing much with this besides prolly adding hscript stuffs lol

```
haxelib git saturn https://github.com/yophlox/Saturn.git
```

# Features
- Mods are loaded in order of priority, so if you want a mod to override another mod, it should be loaded after the mod it overrides.
- You can override assets from the base game.

### Documentation

# Mod.json template

```json
{
    "id": "mod-name",
    "name": "Mod Name",
    "version": "1.0.0",
    "author": "you!",
    "description": "Desc here!",
    "priority": 1
}
```

make sure the id is the same as the folder name.