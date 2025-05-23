#!/bin/bash

source env/bin/activate

# gen intermediate rst files
env/bin/python3 ./scripts/make_rst.py --color -o docs/gen -l en docs/og

# gen html files with sphinx
env/bin/sphinx-build -M html docs/gen docs/html -c .

deactivate

