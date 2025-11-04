#!/bin/bash

source env/bin/activate

# FIXME: This could be automated once this issue is solved: https://github.com/godotengine/godot/issues/86604
# For now, run the following command manually from the root of the project
# godot project.godot --headless --doctool scripts/docs/build/og --gdscript-docs res://addons/input_remapper

# gen intermediate rst files
env/bin/python3 ./scripts/make_rst.py --color -l en build/og -o build/gen

# gen html files with sphinx
env/bin/sphinx-build -M html build/gen build/html -c .

deactivate

