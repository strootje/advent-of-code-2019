#!/usr/bin/env bash

# Imports
source ./_shared/consts.sh
source ./_shared/logger.sh
source ./_shared/download.sh

# Variables
INPUT_URL="https://adventofcode.com/2019/day/1/input"

calculate_fuel() {
	MASS=$1

	rounded=$(($MASS/3))
	subtracted=$(($rounded - 2))
	echo $subtracted
}

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day1" "$INPUT_URL")

	NUM=0
	FUEL=0
	while read line; do
		CALCULATED=$(calculate_fuel $line)
		FUEL=$(($FUEL + $CALCULATED))
		NUM=$(($NUM + 1))
	done < $INPUT_FILE

	info "Found ($NUM) entries with a total of ($FUEL) fuel"
}

case "$1" in
	"run") run_main;;
esac
