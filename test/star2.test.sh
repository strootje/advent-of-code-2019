#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star2.sh 0

# Variables
# -none-

run_test() {
	# Arrange
	MASS=$1
	FUEL=$2

	# Act
	RESULT=$(calculate_fuel_recursive "$MASS")

	# Assert
	if [ "$RESULT" -ne "$FUEL" ]; then
		fatal "Fuel does not equel $FUEL"
	fi
}

test_CalculateFuelRecursive_Mass14_IsFuel2() {
	run_test 14 2
}

test_CalculateFuelRecursive_Mass1969_IsFuel966() {
	run_test 1969 966
}

test_CalculateFuelRecursive_Mass100756_IsFuel50346() {
	run_test 100756 50346
}
