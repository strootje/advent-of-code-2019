#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./_shared/download.sh
. ./stars/star1.sh 0

# Variables
INPUT_URL="https://adventofcode.com/2019/day/2/input"
declare -a CODES=()
declare -a MEMORY=()
COUNT=0

get_codes() {
	FILE=$1

	parse_codes $(cat $FILE)
}

parse_codes() {
	RAW=$1

	COUNT=0
	CODES=()

	IFS=","
	while read code; do
		for i in ${code[@]}; do
			CODES[$COUNT]=$i
			COUNT=$(($COUNT + 1))
		done
	done <<< $RAW
	unset IFS
}

reset_memory() {
	MEMORY=("${CODES[@]}")
}

calculate() {
	OPCODE=$1
	NUM1=$2
	NUM2=$3

	if [ $OPCODE -eq 1 ]; then
		echo $(($NUM1 + $NUM2))
	elif [ $OPCODE -eq 2 ]; then
		echo $(($NUM1 * $NUM2))
	else
		fatal "Unknown opcode $OPCODE"
	fi
}

run_program() {
	OPCODE=$1
	LNUM1=$2
	LNUM2=$3
	LRES=$4

	VNUM1=${MEMORY[$LNUM1]}
	VNUM2=${MEMORY[$LNUM2]}

	if [ $OPCODE -eq 1 ]; then
		VRES=$(calculate $OPCODE $VNUM1 $VNUM2)
		trace "ADD	{ '$VNUM1'($LNUM1) + '$VNUM2'($LNUM2) } -> '$VRES'($LRES)"
		MEMORY[$LRES]=$VRES
	elif [ $OPCODE -eq 2 ]; then
		VRES=$(calculate $OPCODE $VNUM1 $VNUM2)
		trace "MULTI	{ '$VNUM1'($LNUM1) * '$VNUM2'($LNUM2) } -> '$VRES'($LRES)"
		MEMORY[$LRES]=$VRES
	else
		fatal "Unknown opcode $OPCODE"
	fi
}

run_all_programs() {
	PROGRAM=0
	while [ ${MEMORY[$PROGRAM]} -ne 99 ]; do
		INUM1=$(($PROGRAM + 1))
		INUM2=$(($PROGRAM + 2))
		IRES=$(($PROGRAM + 3))

		OPCODE=${MEMORY[$PROGRAM]}
		LNUM1=${MEMORY[$INUM1]}
		LNUM2=${MEMORY[$INUM2]}
		LRES=${MEMORY[$IRES]}

		trace "Running program $PKEY"
		trace "===================================="
		run_program $OPCODE $LNUM1 $LNUM2 $LRES
		trace ""

		PROGRAM=$(($PROGRAM + 4))
	done
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day2" "$INPUT_URL")

	get_codes $INPUT_FILE
	info "Found ($COUNT) entries"
	reset_memory

	# fix program
	CODES[1]=12
	CODES[2]=2

	run_all_programs

	VRES0=${MEMORY[0]}
	info "Program done; Value of pos(0) = '$VRES0'"
}

case "$1" in
	"run") run_main;;
esac
