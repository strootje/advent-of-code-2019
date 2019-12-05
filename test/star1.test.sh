#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star1.sh 0

# Variables
# -none-

run_test() {
	# Arrange
	MASS=$1
	FUEL=$2

	# Act
	RESULT=$(calculate_fuel "$MASS")

	# Assert
	if [ "$RESULT" -ne "$FUEL" ]; then
		fatal "Fuel does not equel $FUEL"
	fi
}

test_CalculateFuel_Mass12_IsFuel2() {
	run_test 12 2
}

test_CalculateFuel_Mass14_IsFuel2() {
	run_test 14 2
}

test_CalculateFuel_Mass1969_IsFuel654() {
	run_test 1969 654
}

test_CalculateFuel_Mass100756_IsFuel33583() {
	run_test 100756 33583
}
