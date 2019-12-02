#!/usr/bin/env bash

# Imports
source ./_shared/consts.sh
source ./_shared/logger.sh
source ./_shared/download.sh
source ./stars/star1.sh 0

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

run_program() {
	OPCODE=$1
	INUM1=$2
	INUM2=$3
	IRES=$4

	LNUM1=${MEMORY[$INUM1]}
	LNUM2=${MEMORY[$INUM2]}
	LRES=${MEMORY[$IRES]}

	VNUM1=${MEMORY[$LNUM1]}
	VNUM2=${MEMORY[$LNUM2]}

	if [ $OPCODE -eq 1 ]; then
		VRES=$(($VNUM1 + $VNUM2))
		# info "adding $VNUM1 + $VNUM2 = $VRES"
		MEMORY[$LRES]=$VRES
	elif [ $OPCODE -eq 2 ]; then
		VRES=$(($VNUM1 * $VNUM2))
		# info "multi $VNUM1 * $VNUM2 = $VRES"
		MEMORY[$LRES]=$VRES
	else
		fatal "Unknown opcode $OPCODE"
	fi

	# declare -p MEMORY
}

run_all_programs() {
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

	run_all_programs

	VRES0=${CODES[0]}
	info "Program done; Value of pos(0) = '$VRES0'"
}

case "$1" in
	"run") run_main;;
esac
