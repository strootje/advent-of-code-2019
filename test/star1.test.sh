#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star1.sh 0

# Variables
# -none-

test_CalculateFuel_Mass_IsFuel() {
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

run_main() {
	info "- test_CalculateFuel_Mass_IsFuel 12 2"
	test_CalculateFuel_Mass_IsFuel 12 2

	info "- test_CalculateFuel_Mass_IsFuel 14 2"
	test_CalculateFuel_Mass_IsFuel 14 2

	info "- test_CalculateFuel_Mass_IsFuel 1969 654"
	test_CalculateFuel_Mass_IsFuel 1969 654

	info "- test_CalculateFuel_Mass_IsFuel 100756 33583"
	test_CalculateFuel_Mass_IsFuel 100756 33583
}

case "$1" in
	"run") run_main;;
esac
