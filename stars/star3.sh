#!/usr/bin/env bash

# Imports
source ./_shared/consts.sh
source ./_shared/logger.sh
source ./_shared/download.sh
source ./stars/star1.sh 0

# Variables
INPUT_URL="https://adventofcode.com/2019/day/2/input"
declare -A CODES=()
COUNT=0

get_codes() {
	FILE=$1

	IFS=","
	while read code; do
		for i in ${code[@]}; do
			CODES[$COUNT]=$i
			COUNT=$(($COUNT + 1))
		done
	done < $FILE
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day2" "$INPUT_URL")

	get_codes $INPUT_FILE
	info "Found ($COUNT) entries"

	# fix program
	CODES[1]=12
	CODES[2]=2

	PROGRAM=0
	while [ ${CODES[$PROGRAM]} -ne 99 ]; do
		OPCODE=${CODES[$PROGRAM]}

		INUM1=$(($PROGRAM + 1))
		INUM2=$(($PROGRAM + 2))
		IRES=$(($PROGRAM + 3))

		LNUM1=${CODES[$INUM1]}
		LNUM2=${CODES[$INUM2]}
		LRES=${CODES[$IRES]}

		VNUM1=${CODES[$LNUM1]}
		VNUM2=${CODES[$LNUM2]}

		if [ $OPCODE -eq 1 ]; then
			VRES=$(($VNUM1 + $VNUM2))
			info "Operation 'add': $VNUM1 + $VNUM2 = $VRES"
			CODES[$LRES]=$VRES
		elif [ $OPCODE -eq 2 ]; then
			VRES=$(($VNUM1 * $VNUM2))
			info "Operation 'mult': $VNUM1 * $VNUM2 = $VRES"
			CODES[$LRES]=$VRES
		else
			fatal "Unknown opcode $OPCODE"
		fi

		PROGRAM=$(($PROGRAM + 4))
	done

	VRES0=${CODES[0]}
	info "Program done; Value of pos(0) = '$VRES0'"
}

case "$1" in
	"run") run_main;;
esac
