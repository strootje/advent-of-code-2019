#!/usr/bin/env bash

# Imports
source ./_shared/logger.sh

# Variables
INPUT_URL="https://adventofcode.com/2019/day/1/input"

run_main() {
	info "Downloading input file"
	INPUT_FILE=$(download "day1" "$INPUT_URL")
}

case "$1" in
	"run") run_main;;
esac
