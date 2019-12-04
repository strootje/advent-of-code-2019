#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh
. ./stars/star5.sh 0

# Variables
# -none-

test_CalculateClosestIntersectionToStart() {
	# Arrange
	RAWDATA=$1
	EXPECTED_DISTANCE=$2
	reset_vars
	set_start_pos 0 0
	get_raw_wires "$RAWDATA"

	# Act
	RESULT=$(calculate_closests_intersection_to_start "RED" "GREEN")

	# Assert
	if [ "$RESULT" -ne "$EXPECTED_DISTANCE" ]; then
		fatal "Distance does not equel $EXPECTED_DISTANCE"
	fi
}

run_main() {
	DATA1="R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83"
	info "- test_CalculateClosestIntersectionToStart \$DATA1 159"
	test_CalculateClosestIntersectionToStart "$DATA1" "159"

	DATA2="R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
	info "- test_CalculateClosestIntersectionToStart \$DATA2 135"
	test_CalculateClosestIntersectionToStart "$DATA2" "135"
}

case "$1" in
	"run") run_main;;
esac
