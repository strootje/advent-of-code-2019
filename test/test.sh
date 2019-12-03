#!/usr/bin/env bash

# Imports
source ./_shared/logger.sh

# Variables
# -none-

run_main() {
	TESTS=./**/*.test.sh

	for test in $TESTS; do
		info "Running test '$test'"
		source $test run
	done
}

case "$1" in
	"run") run_main;;
esac
