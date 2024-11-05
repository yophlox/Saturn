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

## Mod.json

```json
{
    "id": "example-mod",
    "name": "Example Mod",
    "description": "An example mod for Saturn."
}
```

make sure the id is the same as the folder name.