#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./_shared/download.sh
. ./stars/star3.sh 0

# Variables
INPUT_URL="https://adventofcode.com/2019/day/2/input"
LOOKUP_VAL=19690720
ANWSER=-1
INITIAL_NOUN=0
INITIAL_VERB=0

run_search_for_output() {
	EXPECTED=$1

	NOUN=$INITIAL_NOUN
	VERB=$INITIAL_VERB

	OUTPUT=-1
	while [ $OUTPUT -eq -1 ] && [ $NOUN -le 99 ]; do
		while [ $OUTPUT -eq -1 ] && [ $VERB -le 99 ]; do
			reset_memory
			MEMORY[1]=$NOUN
			MEMORY[2]=$VERB

			run_all_programs

			OUTCOME=${MEMORY[0]}
			debug "TRIED NOUN=$NOUN VERB=$VERB = $OUTCOME"
			if [ $OUTCOME -eq $EXPECTED ]; then
				OUTPUT=$OUTCOME
			fi

			if [ $OUTPUT -eq -1 ]; then
				VERB=$(($VERB + 1))
			fi
		done

		if [ $OUTPUT -eq -1 ]; then
			NOUN=$(($NOUN + 1))
			VERB=0
		fi
	done

	ANWSER=$(((100 * $NOUN) + $VERB))
	debug "+++++++++++++++++++++++++++++++++"
	debug "+++ FOUND at $NOUN $VERB = $ANWSER"
	debug "+++++++++++++++++++++++++++++++++"
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day2" "$INPUT_URL")

	get_codes $INPUT_FILE
	info "Found ($COUNT) entries"

	run_search_for_output $LOOKUP_VAL

	VRES0=${MEMORY[0]}
	info "Program done; Value of pos(0) = '$VRES0'"
}

case "$1" in
	"run") run_main;;
esac
