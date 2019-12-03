#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star3.sh 0

# Variables
# -none-

test_RunAllPrograms_WithData_WorksOut() {
	# Arrange
	DATA=$1
	EXP=$2
	parse_codes "$DATA"
	reset_memory

	# Act
	run_all_programs

	# Assert
	if [ "${MEMORY[0]}" -ne "$EXP" ]; then
		fatal "Result does not match $EXP instead is ${MEMORY[0]}"
	fi
}

run_main() {
	DATA1="1,9,10,3,2,3,11,0,99,30,40,50"
	info "- test_RunAllPrograms_WithData_WorksOut '$DATA1' 3500"
	test_RunAllPrograms_WithData_WorksOut $DATA1 3500

	DATA2="1,0,0,0,99"
	info "- test_RunAllPrograms_WithData_WorksOut '$DATA2' 2"
	test_RunAllPrograms_WithData_WorksOut $DATA2 2

	DATA3="2,3,0,3,99"
	info "- test_RunAllPrograms_WithData_WorksOut '$DATA3' 2"
	test_RunAllPrograms_WithData_WorksOut $DATA3 2

	DATA4="2,4,4,5,99,0"
	info "- test_RunAllPrograms_WithData_WorksOut '$DATA4' 2"
	test_RunAllPrograms_WithData_WorksOut $DATA4 2

	DATA5="1,1,1,4,99,5,6,0,99"
	info "- test_RunAllPrograms_WithData_WorksOut '$DATA5' 30"
	test_RunAllPrograms_WithData_WorksOut $DATA5 30
}

case "$1" in
	"run") run_main;;
esac
