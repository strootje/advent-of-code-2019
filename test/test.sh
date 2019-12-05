#!/usr/bin/env bash

# Imports
. ./_shared/logger.sh

# Variables
declare -A CALLED=()

run_main() {
	TESTS="./test/*.test.sh"

	for test in $TESTS; do
		info ""
		info "Running suite '$test'"
		# shellcheck disable=SC1090
		. "$test"

		FUNCS=$(declare -F)
		IFS=$'\n'
		while read -r declared_func; do
			FUNC_NAME=${declared_func:11}
			FUNC_NAME_TEST=${FUNC_NAME:0:5}

			IS_CALLED=${CALLED[$FUNC_NAME]}
			if [ "$FUNC_NAME_TEST" == "test_" ] && [ "$IS_CALLED" != "1" ]; then
				tmp "$FUNC_NAME"

				if $FUNC_NAME; then
					info "PASSED $FUNC_NAME"
				else
					info "FAILED $FUNC_NAME"
				fi
			fi

			CALLED[$FUNC_NAME]=1
		done <<< "$FUNCS"
		unset IFS
	done
}

case "$1" in
	"run") run_main;;
esac
