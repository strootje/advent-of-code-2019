#!/usr/bin/env bash

# Imports
source ./_shared/logger.sh
source ./stars/star4.sh 0

# Variables
# -none-

test_RunAllPrograms_WithData_WorksOut() {
	# Arrange
	DATA=$1
	EXP=$2
	parse_codes $DATA

	# Act
	run_all_programs

	# Assert
	if [ ${MEMORY[0]} -ne $EXP ]; then
		fatal "Result does not match $EXP instead is ${MEMORY[0]}"
	fi
}

run_main() {
	DATA1="1,9,10,3,2,3,11,0,99,30,40,50"
	info "test_RunAllPrograms_WithData_WorksOut '$DATA1' 3500"
	test_RunAllPrograms_WithData_WorksOut $DATA1 3500
}

case "$1" in
	"run") run_main;;
esac
