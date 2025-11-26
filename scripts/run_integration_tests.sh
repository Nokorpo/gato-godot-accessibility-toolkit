#!/usr/bin/env bash
set -e


## Stores an environment variable so it can be used from a later step in Github Actions
function store_env_var {
	if [ "$#" -ne 2 ]; then
		echo "Error: 'store_env_var' function called with $# arguments." >&2
		echo "The function should be called with 2 arguments, a key and its value." >&2
		exit 1
	fi
	echo "Storing $1=$2 in GITHUB_ENV" >&2
	if [ -n "$GITHUB_ENV" ]; then
		echo "$1=$2" >> $GITHUB_ENV
	else
		echo "GITHUB_ENV is not set. Is this script running locally?" >&2
	fi
}

function get_total_tests {
	if (( $# != 1 )); then
		echo "Error: 'get_total_tests' function called with $# arguments." >&2
		echo "The function should be called with 1 arguments, the log file from the test execution." >&2
		exit 1
	fi
	grep -E "^Tests" "$1" | awk '{print $2}'
}

function get_errors {
	if (( $# != 1 )); then
		echo "Error: 'get_errors' function called with $# arguments." >&2
		echo "The function should be called with 1 arguments, the log file to filter errors from." >&2
		exit 1
	fi
	ERRORS=$(grep -E "^(Failing Tests|Risky)" "$1" | awk -F '[ ]{2,}' '{ sum += $2; } END { print sum; }')
	if ! [[ "$ERRORS" =~ ^[0-9]+$ ]]; then
		 ERRORS=0
	fi
	echo "$ERRORS"	
}

function run {
	echo "--- GODOT IMPORT ---"
	godot --import --headless > build_log.txt 2>&1
	IMPORT_RESULT="$?"

	if [ $IMPORT_RESULT -eq 0 ]; then
		echo "--- TEST SETUP ---"
		echo "Copying default Gato Input Remapper config"
		mkdir -p "$home_dir/.local/share/godot/app_userdata/Godot Accessibility Toolkit/"
		cp "./scripts/default_input.data" "$home_dir/.local/share/godot/app_userdata/Godot Accessibility Toolkit/"

		echo "--- RUN TESTS ---"
		godot --headless -s addons/gut/gut_cmdln.gd --path $PWD -glog=1 -gexit | tee log.txt

		echo "--- GET RESULTS ---"
		ERRORS="$(get_errors "log.txt")"
		TOTAL="$(get_total_tests "log.txt")"
		MESSAGE="Integration tests execution found $ERRORS errors :no_entry:. Total tests run: $TOTAL"
		if [ "$ERRORS" -gt "0" ]; then
			store_env_var "SHOULD_SEND_DISCORD_MESSAGE" "true"
		fi

	else
		echo "Godot import failed"
		cat build_log.txt
		MESSAGE="Project import failed. Could not run tests."
		store_env_var "SHOULD_SEND_DISCORD_MESSAGE" "true"
	fi

	echo "Run finished with message: $MESSAGE" >&2
	store_env_var "DISCORD_MESSAGE" "$MESSAGE"
}

home_dir="$HOME"
function main {
	if [ -n "$GITHUB_WORKSPACE" ]; then
		home_dir="$GITHUB_WORKSPACE"
	fi
	run
}

main
