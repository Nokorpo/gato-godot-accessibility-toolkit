## Running

Run the following command in the root of the project:

```sh
godot project.godot --headless --doctool scripts/docs/build/og --gdscript-docs res://addons/input_remapper

# FIXME: In the future we need to change to this, but it doesn't work right now (see https://github.com/godotengine/godot/issues/92440):
# godot project.godot --headless --doctool scripts/docs/build/og --gdscript-docs addons/input_remapper
```

Go to the folder that contains the `build.sh` file (`scripts/docs`) and run it. This will generate the HTML docs in `./build/html/`.

## Update Godot files

This project uses a couple of scripts from the Godot documentation to avoid having to write our own. 
To download `make_rst.py` script from Godot's repo and `misc/utility/color.py`:

```sh
wget https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/doc/tools/make_rst.py > scripts/make_rst.py

mkdir -p scripts/misc/utility
wget https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/misc/utility/color.py > scripts/misc/utility/color.py
```

> **Note:** last time I ran these commands they downloaded empty files. Double check that the files were downloaded correctly or download them manually.

After downloading those files, open `make_rst.py` and remove all lines that mention the `version` module. Other common issues are lists being accessed when they are None or empty, so add these checks when necessary:

```py
if that_list != None and len(that_list) > 0:
```
