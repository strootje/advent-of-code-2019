#!/usr/bin/env bash

# Imports
source ./_shared/logger.sh

# Variables
# -none-

run_main() {
	TESTS=./test/*.test.sh

	for test in $TESTS; do
		info "Running test '$test'"
		. $test run
	done
}

case "$1" in
	"run") run_main;;
esac
