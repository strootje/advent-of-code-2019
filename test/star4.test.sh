#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./stars/star4.sh 0

# Variables
# -none-

test_RunSearchForOutcome_ExpectedOutcome_IsFound() {
	# Arrange
	DATA=$1
	EXP=$2
	get_codes $TMPDIR/day2

	# Act
	run_search_for_output $DATA

	# Assert
	if [ $ANWSER -ne $EXP ]; then
		fatal "Result does not match $EXP instead is $ANWSER"
	fi
}

run_main() {
    INITIAL_NOUN=12
    INITIAL_VERB=2
    DATA1=3654868
	info "- test_RunSearchForOutcome_ExpectedOutcome_IsFound $DATA1 1202"
    test_RunSearchForOutcome_ExpectedOutcome_IsFound $DATA1 1202
	
    INITIAL_NOUN=70
    INITIAL_VERB=14
    DATA2=19690720
	info "- test_RunSearchForOutcome_ExpectedOutcome_IsFound $DATA2 7014"
    test_RunSearchForOutcome_ExpectedOutcome_IsFound $DATA2 7014
}

case "$1" in
	"run") run_main;;
esac
