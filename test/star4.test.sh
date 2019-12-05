#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./stars/star4.sh 0

# Variables
# -none-

run_test() {
	# Arrange
	DATA=$1
	EXP=$2
	get_codes $TMPDIR/day2

	# Act
	run_search_for_output "$DATA"

	# Assert
	if [ $ANWSER -ne "$EXP" ]; then
		fatal "Result does not match $EXP instead is $ANWSER"
	fi
}

test_RunSearchForOutcome_ExpectedOutcome3654868_IsFoundAt1202() {
	INITIAL_NOUN=12
	INITIAL_VERB=2
	DATA=3654868
	run_test $DATA 1202
}

test_RunSearchForOutcome_ExpectedOutcome19690720_IsFoundAt7014() {
	INITIAL_NOUN=70
	INITIAL_VERB=14
	DATA=19690720
	run_test $DATA 7014
}
