#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star6.sh 0

# Variables
# -none-

run_test() {
	# Arrange
	RAWDATA=$1
	EXPECTED_STEPS=$2
	reset_vars
	set_start_pos 0 0
	get_raw_wires "$RAWDATA"

	# Act
	RESULT=$(calculate_closests_intersection_by_steps_to_start "RED" "GREEN")

	# Assert
	if [ "$RESULT" -ne "$EXPECTED_STEPS" ]; then
		fatal "Steps does not equal $EXPECTED_STEPS; instead is '$RESULT'"
	fi
}

test_CalculateClosestByStepsIntersectionFromStart1_Is610() {
	DATA="R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83"
	run_test "$DATA" 610
}

test_CalculateClosestByStepsIntersectionFromStart2_Is410() {
	DATA="R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
	run_test "$DATA" 410
}
