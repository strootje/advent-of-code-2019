#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./_shared/download.sh

# Variables
LOGLVL=$LVLTRACE
INPUT_URL="https://adventofcode.com/2019/day/1/input"

declare -a WIRE_NAMES=("RED" "GREEN" "YELLOW")
declare -A WIRES=()
declare -a WIRE_LINES=()
declare -a WIRE_LINE_X1=()
declare -a WIRE_LINE_Z1=()
START_X=0
START_Z=0

new_wire_name() {
	NUM_WIRES=${#WIRES[@]}
	echo "${WIRE_NAMES[$NUM_WIRES]}"
}

reset_vars() {
	WIRES=()
	WIRE_LINES=()
	WIRE_LINE_X1=()
	WIRE_LINE_Z1=()
	START_X=0
	START_Z=0
}

set_start_pos() {
	START_X=$1
	START_Z=$2
}

get_raw_wires() {
	RAW=$1

	IFS=","
	while read -r wire; do
		WIRE_NAME=$(new_wire_name)
		WIRE_INDEX=${#WIRES[@]}
		debug "Adding wire '$WIRE_NAME' at index '$WIRE_INDEX'"
		WIRES[$WIRE_NAME]=${#WIRES[@]}
		WIRE_LINES[$WIRE_INDEX]=0

		PREV_X=$START_X
		PREV_Z=$START_Z

		# shellcheck disable=SC2068
		for move in ${wire[@]}; do
			MOVE_DIR=${move:0:1}
			MOVE_STEPS=${move:1}
			trace "Handling move '$move' -> dir: '$MOVE_DIR' steps: '$MOVE_STEPS'"

			NEW_X=$PREV_X
			NEW_Z=$PREV_Z

			if [ "$MOVE_DIR" == "U" ]; then
				NEW_Z=$((NEW_Z + MOVE_STEPS))
			elif [ "$MOVE_DIR" == "D" ]; then
				NEW_Z=$((NEW_Z - MOVE_STEPS))
			elif [ "$MOVE_DIR" == "L" ]; then
				NEW_X=$((NEW_X + MOVE_STEPS))
			elif [ "$MOVE_DIR" == "R" ]; then
				NEW_X=$((NEW_X - MOVE_STEPS))
			else
				fatal "Unknown move dir '$MOVE_DIR'"
			fi

			WIRE_LINE_X1[${#WIRE_LINE_X1[@]}]=$NEW_X
			WIRE_LINE_Z1[${#WIRE_LINE_Z1[@]}]=$NEW_Z

			CUR_LINES=${WIRE_LINES[$WIRE_INDEX]}
			WIRE_LINES[$WIRE_INDEX]=$((CUR_LINES + 1))

			PREV_X=$NEW_X
			PREV_Z=$NEW_Z
		done

	done <<< "$RAW"
	unset IFS
}

validate_wire() {
	WIRE_NAME=$1

	if [ -z "${WIRES[$WIRE_NAME]}" ]; then
		fatal "Wire '$WIRE_NAME' does not exist"
	fi

	echo "$WIRE_NAME"
}

validate_wire_line() {
	WIRE_COLOR=$(validate_wire "$1")
	LINE_INDEX=$2

	WIRE_INDEX=${WIRES[$WIRE_COLOR]}
	LINES_RANGE=${WIRE_LINES[$WIRE_INDEX]}

	if [ "$LINE_INDEX" -lt 0 ] || [ "$LINE_INDEX" -ge $LINES_RANGE ]; then
		fatal "Line '$LINES_RANGE' for wire '$WIRE_COLOR' does not exists; only '$LINES_RANGE' lines found"
	fi

	echo "$LINE_INDEX"
}

calculate_manhattan() {
	BEGIN_X=$1
	BEGIN_Z=$2
	FINAL_X=$3
	FINAL_Z=$4

	DIFF_X=$((BEGIN_X - FINAL_X))
	DIFF_Z=$((BEGIN_Z - FINAL_Z))
	LINE_LENGTH=$((DIFF_X + DIFF_Z))
	LINE_LENGTH_ABS=${LINE_LENGTH##-}

	echo "$LINE_LENGTH_ABS"
}

get_wire_offset() {
	WIRE_COLOR=$(validate_wire "$1")
	WIRE_INDEX=${WIRES[$WIRE_COLOR]}

	WIRE_OFFSET=0
	if [ "$WIRE_INDEX" -gt 0 ]; then
		# shellcheck disable=SC2068
		for range in ${WIRE_LINES[@]:0:$WIRE_INDEX}; do
			WIRE_OFFSET=$((WIRE_OFFSET + range))
		done
	fi

	echo "$WIRE_OFFSET"
}

get_wire_line_stat() {
	WIRE_COLOR=$(validate_wire "$1")
	LINE_INDEX=$(validate_wire_line "$WIRE_COLOR" "$2")
	LINE_STAT=$3

	WIRE_INDEX=${WIRES[$WIRE_COLOR]}
	LINES_RANGE=${WIRE_LINES[$WIRE_INDEX]}
	LINE_OFFSET=$(get_wire_offset "$WIRE_COLOR")

	WIRE_LINE_INDEX=$((LINE_OFFSET + LINE_INDEX))
	if [ "$LINE_STAT" == "x1" ]; then
		if [ "$LINE_INDEX" -eq 0 ]; then
			echo 0
		else
			WIRE_LINE_INDEX=$((WIRE_LINE_INDEX - 1))
			echo ${WIRE_LINE_X1[$WIRE_LINE_INDEX]}
		fi
	elif [ "$LINE_STAT" == "x2" ]; then
		echo ${WIRE_LINE_X1[$WIRE_LINE_INDEX]}
	elif [ "$LINE_STAT" == "z1" ]; then
		if [ "$LINE_INDEX" -eq 0 ]; then
			echo 0
		else
			WIRE_LINE_INDEX=$((WIRE_LINE_INDEX - 1))
			echo ${WIRE_LINE_Z1[$WIRE_LINE_INDEX]}
		fi
	elif [ "$LINE_STAT" == "z2" ]; then
		echo ${WIRE_LINE_Z1[$WIRE_LINE_INDEX]}
	else
		fatal "LineStat '$LINE_STAT' not implemented"
	fi
}

debug_line() {
	WIRE_COLOR=$(validate_wire "$1")
	LINE_INDEX=$(validate_wire_line "$WIRE_COLOR" "$2")

	BEGIN_X=$(get_wire_line_stat "$WIRE_COLOR" "$LINE_INDEX" "x1")
	BEGIN_Z=$(get_wire_line_stat "$WIRE_COLOR" "$LINE_INDEX" "z1")
	FINAL_X=$(get_wire_line_stat "$WIRE_COLOR" "$LINE_INDEX" "x2")
	FINAL_Z=$(get_wire_line_stat "$WIRE_COLOR" "$LINE_INDEX" "z2")

	LINE_LENGTH=$(calculate_manhattan "$BEGIN_X" "$BEGIN_Z" "$FINAL_X" "$FINAL_Z")

	debug "Wire '$WIRE_COLOR', Line '$LINE_INDEX', From ($BEGIN_X, $BEGIN_Z), To ($FINAL_X, $FINAL_Z), ManhattanLength: '$LINE_LENGTH'"
}

calculate_intersection() {
	WIRE1_BEGIN_X=$1
	WIRE1_BEGIN_Z=$2
	WIRE1_FINAL_X=$3
	WIRE1_FINAL_Z=$4

	WIRE2_BEGIN_X=$5
	WIRE2_BEGIN_Z=$6
	WIRE2_FINAL_X=$7
	WIRE2_FINAL_Z=$8

	WIRE1_A=$((WIRE1_FINAL_Z - WIRE1_BEGIN_Z))
	WIRE1_B=$((WIRE1_FINAL_X - WIRE1_BEGIN_X))
	WIRE1_C=$(((WIRE1_A * WIRE1_BEGIN_X) + (WIRE1_B * WIRE1_BEGIN_Z)))

	WIRE2_A=$((WIRE2_FINAL_Z - WIRE2_BEGIN_Z))
	WIRE2_B=$((WIRE2_FINAL_X - WIRE2_BEGIN_X))
	WIRE2_C=$(((WIRE2_A * WIRE2_BEGIN_X) + (WIRE2_B * WIRE2_BEGIN_Z)))

	DELTA=$(((WIRE1_A * WIRE2_B) - (WIRE2_A * WIRE1_B)))

	if [ "$DELTA" -eq 0 ]; then
		echo ""
	else
		INTERSECT_X=$((((WIRE2_B * WIRE1_C) - (WIRE1_B * WIRE2_C)) / DELTA))
		INTERSECT_Z=$((((WIRE1_A * WIRE2_C) - (WIRE2_A * WIRE1_C)) / DELTA))
		echo "$INTERSECT_X,$INTERSECT_Z"
	fi
}

calculate_closests_intersection_to_start() {
	WIRE1_COLOR=$(validate_wire "$1")
	WIRE2_COLOR=$(validate_wire "$2")

	WIRE1_INDEX=${WIRES[$WIRE1_COLOR]}
	WIRE2_INDEX=${WIRES[$WIRE2_COLOR]}

	WIRE1_LINES=${WIRE_LINES[$WIRE1_INDEX]}
	WIRE2_LINES=${WIRE_LINES[$WIRE2_INDEX]}

	INTERSECTION_DISTANCE=0

	WIRE1_INDEX=0
	while [ "$WIRE1_INDEX" -lt $WIRE1_LINES ]; do
		WIRE1_BEGIN_X=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "x1")
		WIRE1_BEGIN_Z=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "z1")
		WIRE1_FINAL_X=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "x2")
		WIRE1_FINAL_Z=$(get_wire_line_stat "$WIRE1_COLOR" "$WIRE1_INDEX" "z2")

		WIRE2_INDEX=0
		while [ "$WIRE2_INDEX" -lt $WIRE2_LINES ]; do
			trace "Checking Wire '$WIRE1_COLOR':'$WIRE1_INDEX' to '$WIRE2_COLOR':'$WIRE2_INDEX'"
			WIRE2_BEGIN_X=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "x1")
			WIRE2_BEGIN_Z=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "z1")
			WIRE2_FINAL_X=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "x2")
			WIRE2_FINAL_Z=$(get_wire_line_stat "$WIRE2_COLOR" "$WIRE2_INDEX" "z2")

			INTERSECTION=$(calculate_intersection "$WIRE1_BEGIN_X" "$WIRE1_BEGIN_Z" "$WIRE1_FINAL_X" "$WIRE1_FINAL_Z" "$WIRE2_BEGIN_X" "$WIRE2_BEGIN_Z" "$WIRE2_FINAL_X" "$WIRE2_FINAL_Z")
			INTERSECT_X=${INTERSECTION%%,*}
			INTERSECT_Z=${INTERSECTION##*,}

			if [ -z "$INTERSECTION" ]; then
				DISTANCE_TO_START=$(calculate_manhattan "$INTERSECT_X" "$INTERSECT_Z" "$START_X" "$START_Z")

				if [ "$INTERSECTION_DISTANCE" -eq 0 ] || [ "$DISTANCE_TO_START" -lt "$INTERSECTION_DISTANCE" ]; then
					INTERSECTION_DISTANCE=$DISTANCE_TO_START
				fi
			fi

			WIRE2_INDEX=$((WIRE2_INDEX + 1))
		done

		WIRE1_INDEX=$((WIRE1_INDEX + 1))
	done

	if [ "$INTERSECTION_DISTANCE" -ne 0 ]; then
		echo "$INTERSECTION_DISTANCE"
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

	DISTANCE=$(calculate_closests_intersection_to_start "RED" "GREEN")
	info "Distance='$DISTANCE'"
}

case "$1" in
	"run") run_main;;
esac
