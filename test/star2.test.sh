#!/usr/bin/env bash

# Imports
source ./_shared/logger.sh
source ./stars/star2.sh 0

# Variables
# -none-

test_CalculateFuelRecursive_Mass_IsFuel() {
	# Arrange
	MASS=$1
	FUEL=$2

	# Act
	RESULT=$(calculate_fuel_recursive $MASS)

	# Assert
	if [ $RESULT -ne $FUEL ]; then
		fatal "Fuel does not equel $FUEL"
	fi
}

run_main() {
	info "test_CalculateFuelRecursive_Mass_IsFuel 14 2"
	test_CalculateFuelRecursive_Mass_IsFuel 14 2

	info "test_CalculateFuelRecursive_Mass_IsFuel 1969 966"
	test_CalculateFuelRecursive_Mass_IsFuel 1969 966

	info "test_CalculateFuelRecursive_Mass_IsFuel 100756 50346"
	test_CalculateFuelRecursive_Mass_IsFuel 100756 50346
}

case "$1" in
	"run") run_main;;
esac
