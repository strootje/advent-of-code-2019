#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./_shared/download.sh
. ./stars/star5.sh 0

# Variables
LOGLVL=$LVLDEBUG
INPUT_URL="https://adventofcode.com/2019/day/3/input"

calculate_length() {
	LINE_BEGIN_X=$1
	LINE_BEGIN_Z=$2
	LINE_FINAL_X=$3
	LINE_FINAL_Z=$4

	DIFF_X_=$((LINE_BEGIN_X - LINE_FINAL_X))
	DIFF_Z_=$((LINE_BEGIN_Z - LINE_FINAL_Z))
	DIFF_X=${DIFF_X_##-}
	DIFF_Z=${DIFF_Z_##-}
	trace "DIFF_X:'$DIFF_X'	DIFF_Z:'$DIFF_Z'"

	LENGTH=$((DIFF_X + DIFF_Z))
	echo $LENGTH
}

calculate_closests_intersection_by_steps_to_start() {
	WIRE1_COLOR=$(validate_wire "$1")
	WIRE2_COLOR=$(validate_wire "$2")

	WIRE1_INDEX=${WIRES[$WIRE1_COLOR]}
	WIRE2_INDEX=${WIRES[$WIRE2_COLOR]}

	WIRE1_LINES=${WIRE_LINES[$WIRE1_INDEX]}
	WIRE2_LINES=${WIRE_LINES[$WIRE2_INDEX]}

	INTERSECTION_DISTANCE=0

	WIRE1_STEPS=0
	WIRE2_STEPS=0

	WIRE1_INDEX=0
	while [ "$INTERSECTION_DISTANCE" -eq 0 ] && [ "$WIRE1_INDEX" -lt $WIRE1_LINES ]; do
		WIRE1_BEGIN_X=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "x1")
		WIRE1_BEGIN_Z=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "z1")
		WIRE1_FINAL_X=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "x2")
		WIRE1_FINAL_Z=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "z2")

		WIRE1_LENGTH=$(calculate_length "$WIRE1_BEGIN_X" "$WIRE1_BEGIN_Z" "$WIRE1_FINAL_X" "$WIRE1_FINAL_Z")
		WIRE1_STEPS=$((WIRE1_STEPS + WIRE1_LENGTH))
		debug "Adding length to 1 '$WIRE1_LENGTH'	Total: '$WIRE1_STEPS'"
		
		WIRE2_INDEX=0
		WIRE2_STEPS=0
		while [ "$INTERSECTION_DISTANCE" -eq 0 ] && [ "$WIRE2_INDEX" -lt $WIRE2_LINES ]; do
			debug "Checking Wire '$WIRE1_COLOR':'$WIRE1_INDEX' to '$WIRE2_COLOR':'$WIRE2_INDEX'"
			WIRE2_BEGIN_X=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "x1")
			WIRE2_BEGIN_Z=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "z1")
			WIRE2_FINAL_X=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "x2")
			WIRE2_FINAL_Z=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "z2")
			
			WIRE2_LENGTH=$(calculate_length "$WIRE2_BEGIN_X" "$WIRE2_BEGIN_Z" "$WIRE2_FINAL_X" "$WIRE2_FINAL_Z")
			WIRE2_STEPS=$((WIRE2_STEPS + WIRE2_LENGTH))
			debug "Adding length to 2 '$WIRE2_LENGTH'	Total: '$WIRE2_STEPS'"

			INTERSECTION=$(calculate_intersection "$WIRE1_BEGIN_X" "$WIRE1_BEGIN_Z" "$WIRE1_FINAL_X" "$WIRE1_FINAL_Z" "$WIRE2_BEGIN_X" "$WIRE2_BEGIN_Z" "$WIRE2_FINAL_X" "$WIRE2_FINAL_Z")
			INTERSECT_X=${INTERSECTION%%,*}
			INTERSECT_Z=${INTERSECTION##*,}

			if [ -n "$INTERSECTION" ]; then
				debug "Intersection at ($INTERSECT_X, $INTERSECT_Z)"
				INTERSECTION_DISTANCE=1

				WIRE1_STEPS=$((WIRE1_STEPS - WIRE1_LENGTH))
				WIRE2_STEPS=$((WIRE2_STEPS - WIRE2_LENGTH))

				WIRE1_INTERSECT_LENGTH=$(calculate_length "$WIRE1_BEGIN_X" "$WIRE1_BEGIN_Z" "$INTERSECT_X" "$INTERSECT_Z")
				WIRE1_STEPS=$((WIRE1_STEPS + WIRE1_INTERSECT_LENGTH))
				debug "Adding length to 1 '$WIRE1_INTERSECT_LENGTH'	Total: '$WIRE1_STEPS'"
				
				WIRE2_INTERSECT_LENGTH=$(calculate_length "$WIRE2_BEGIN_X" "$WIRE2_BEGIN_Z" "$INTERSECT_X" "$INTERSECT_Z")
				WIRE2_STEPS=$((WIRE2_STEPS + WIRE2_INTERSECT_LENGTH))
				debug "Adding length to 2 '$WIRE2_INTERSECT_LENGTH'	Total: '$WIRE2_STEPS'"
			fi

			WIRE2_INDEX=$((WIRE2_INDEX + 1))
		done

		WIRE1_INDEX=$((WIRE1_INDEX + 1))
	done

	if [ "$INTERSECTION_DISTANCE" -ne 0 ]; then
		STEPS=$((WIRE1_STEPS + WIRE2_STEPS))
		echo "$STEPS"
	else
		debug "DISTANCE: '$INTERSECTION_DISTANCE'"
		fatal "Unable to find intersecting lines"
	fi
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day3" "$INPUT_URL")
	reset_vars

	info "Setting starting point to (0,0)"
	set_start_pos 0 0

	RAW="$(cat "$INPUT_FILE")"
	info "Loading wires into memory"
	get_raw_wires "$RAW"

	DISTANCE=$(calculate_closests_intersection_by_steps_to_start "RED" "GREEN")
	info "Distance='$DISTANCE'"
}

case "$1" in
	"run") run_main;;
esac
