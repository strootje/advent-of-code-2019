#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./_shared/download.sh
. ./stars/star3.sh 0

# Variables
INPUT_URL="https://adventofcode.com/2019/day/2/input"
LOOKUP_VAL=19690720

run_all_programs_wtih_reset() {
	reset_memory

	PROGRAM=0
	while [ ${MEMORY[$PROGRAM]} -ne 99 ]; do
		OPCODE=${MEMORY[$PROGRAM]}
		INUM1=$(($PROGRAM + 1))
		INUM2=$(($PROGRAM + 2))
		IRES=$(($PROGRAM + 3))

		run_program $OPCODE $INUM1 $INUM2 $IRES

		PROGRAM=$(($PROGRAM + 4))
	done
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day2" "$INPUT_URL")

	get_codes $INPUT_FILE
	info "Found ($COUNT) entries"

	# fix program
	CODES[1]=12
	CODES[2]=2

	run_all_programs_wtih_reset

	VRES0=${CODES[0]}
	info "Program done; Value of pos(0) = '$VRES0'"
}

case "$1" in
	"run") run_main;;
esac
