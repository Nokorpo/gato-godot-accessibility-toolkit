#!/usr/bin/env bash
set -e

SMOKE_TEST_FILE="./modules/tests/smoke_test.gd"
EXCLUSIONS=()

function print_usage() {
	cat >&2 <<HEREDOC
NAME
	$0 - run smoke tests in Godot

SYNOPSIS
	$0 [-e EXCLUSION_FILE] ...

DESCRIPTION
	Runs the smoke test script. It takes an optional -e file with a list of excluded files as an argument. Excluded files won't be executed in the smoke test.
	Remaining arguments will be treated as more file paths. They will be added to the list of the excluded files.

EXAMPLES
	$0 -e ./excluded.txt
	$0 "res://scene1.tscn" "res://scene2.tscn"
HEREDOC
}

function parse_arguments {
	while getopts ":he:" opt; do
		case $opt in
			h) # display help
				print_usage
				exit 0
				;;
			e) # read exclusions file
				if [ -z "${OPTARG}"]; then
					printf "yes"
				fi
				read_exclusions_from_file "${OPTARG}"
				;;
			*) # parse extra arguments
				echo "${OPTARG}" >&2
				EXCLUSIONS+=("${OPTARG}")
				;;
			\?)
				echo "Error: Invalid option -$OPTARG"
				print_usage
				exit 1
				;;
			:)
				echo "Error: Option -$OPTARG requires an argument."
				print_usage
				exit 1
				;;
		esac
	done
	shift $(( OPTIND - 1 ))
	EXCLUSIONS+=$*
}

## Reads excluded file list from the file passed with the -e option
function read_exclusions_from_file {
	EXCLUSIONS=()
	while IFS= read -r line; do
		EXCLUSIONS+=("$line")
	done < "$1"
}

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

## Filters error messages that we don't care about
function filter_not_useful_errors {
	if [ "$#" -ne 1 ]; then
		echo "Error: 'filter_not_useful_errors' function called with $# arguments." >&2
		echo "The function should be called with 1 arguments, the log file to filter errors from." >&2
		exit 1
	fi
	grep "ERROR" "$1" |\
	grep -v 'ERROR: Condition "!is_inside_tree\(\)'
	#grep -vE "(leaked|still in use)" |\
	#grep -vE '(Parameter "m" is null|RID allocations)' |\
}

## Filters warning messages that we don't care about
function filter_not_useful_warnings {
	if (( $# != 1 )); then
		echo "Error: 'filter_not_useful_warnings' function called with $# arguments." >&2
		echo "The function should be called with 1 arguments, the log file to filter warnings from." >&2
		exit 1
	fi
	grep "WARNING" "$1" | grep -vE "(leaked|still in use)"
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
		chmod +x "$SMOKE_TEST_FILE"
		godot --headless -s "$SMOKE_TEST_FILE" -- $(echo "${EXCLUSIONS[*]}") 2>&1 | tee log.txt

		echo "--- GET RESULTS ---"
		ERRORS="$(filter_not_useful_errors "log.txt" | wc -l)"
		WARNINGS="$(filter_not_useful_warnings "log.txt" | wc -l)"
		MESSAGE="Smoke test execution found $ERRORS errors :no_entry: and $WARNINGS warnings :warning:"
		if [ "$ERRORS" -gt "0" -o "$WARNINGS" -gt "0" ]; then
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
	if [ "$#" -gt "0" ]; then
		parse_arguments $*
	fi
	if [ -n "$GITHUB_WORKSPACE" ]; then
		home_dir="$GITHUB_WORKSPACE"
	fi

	run
}

main $*
