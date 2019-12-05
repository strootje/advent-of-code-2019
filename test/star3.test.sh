#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star3.sh 0

# Variables
# -none-

run_test() {
	# Arrange
	RAWDATA=$1
	EXP=$2
	parse_codes "$RAWDATA"
	reset_memory

	# Act
	run_all_programs

	# Assert
	if [ "${MEMORY[0]}" -ne "$EXP" ]; then
		fatal "Result does not match $EXP instead is ${MEMORY[0]}"
	fi
}

test_RunAllPrograms_WithData1_WorksOut3500() {
	DATA="1,9,10,3,2,3,11,0,99,30,40,50"
	run_test $DATA 3500
}

test_RunAllPrograms_WithData2_WorksOut2() {
	DATA="1,0,0,0,99"
	run_test $DATA 2
}

test_RunAllPrograms_WithData3_WorksOut2() {
	DATA="2,3,0,3,99"
	run_test $DATA 2
}

test_RunAllPrograms_WithData4_WorksOut2() {
	DATA="2,4,4,5,99,0"
	run_test $DATA 2
}

test_RunAllPrograms_WithData5_WorksOut30() {
	DATA="1,1,1,4,99,5,6,0,99"
	run_test $DATA 30
}
