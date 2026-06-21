## Steps to generate html

Generate Godot xml definitions with (this process is manual for now):

```bash
godot --headless --doctool scripts/docs/build/xml --gdscript-docs res://addons/input_remapper 
godot --headless --doctool scripts/docs/build/xml --gdscript-docs res://addons/gato_screen_filters 
godot --headless --doctool scripts/docs/build/xml --gdscript-docs res://addons/gato_tts
```

Then use Godot's `make_rst.py` (we have a custom version that skips private methods and variables) to generate the `*.rst` files.

```bash
python make_rst.py docs/build/xml --output docs/sources/api
```

Then finally run sphinx to generate the html:

```bash
make clean html
```

