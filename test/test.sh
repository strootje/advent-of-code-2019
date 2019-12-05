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
		# shellcheck disable=SC1090
		. "$test" run

		# FUNCS=("$(declare -F)")
		# for func in "${FUNCS[@]}"; do
		# 	NAME=${func}
		# 	echo "$NAME"
		# done
	done
}

case "$1" in
	"run") run_main;;
esac
