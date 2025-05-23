To download make_rst.py script from Godot's repo:
Also requires downloading versions.py (same dir) and misc/utility/color.py.

```sh
wget https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/doc/tools/make_rst.py > scripts/make_rst.py
wget https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/version.py > version.py

mkdir -p scripts/misc/utility
wget https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/misc/utility/color.py > scripts/make_rst.py
```

Also create your own conf.py file and add it to automation/, then run it from that folder with:

```sh
sphinx-build docs/gen docs/html -c .
``

