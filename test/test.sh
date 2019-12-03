#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh

# Variables
# -none-

run_main() {
	TESTS="./test/*.test.sh"

	for test in $TESTS; do
		info ""
		info "Running suite '$test'"
		# shellcheck source=test/*.test.sh
		. "$test" run
	done
}

case "$1" in
	"run") run_main;;
esac
