#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh
. ./_shared/logger.sh
. ./_shared/download.sh
. ./stars/star1.sh 0

# Variables
INPUT_URL="https://adventofcode.com/2019/day/1/input"

calculate_fuel_recursive() {
	MASS=$1

	if [ $MASS -le "0" ]; then
		echo 0
	else
		FUEL=$(calculate_fuel $MASS)

		if [ $FUEL -le "0" ]; then
			echo 0
		else
			MORE=$(calculate_fuel_recursive $FUEL)
			echo $(($FUEL + $MORE))
		fi

	fi
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day1" "$INPUT_URL")

	NUM=0
	TOTAL_FUEL=0
	while read line; do
		calculate_fuel_recursive $line
		CALCULATED=$(calculate_fuel_recursive $line)
		TOTAL_FUEL=$(($TOTAL_FUEL + $CALCULATED))
		NUM=$(($NUM + 1))
	done < $INPUT_FILE

	info "Found ($NUM) entries with a total of ($TOTAL_FUEL) fuel"
}

case "$1" in
	"run") run_main;;
esac
