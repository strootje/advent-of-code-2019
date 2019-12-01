#!/usr/bin/env bash

# Imports
# -none-

# Variables
# -none-

info() {
	printf "[ .. ] %s\n" "$@"
}

fatal() {
	info "$@"
	exit 1
}
