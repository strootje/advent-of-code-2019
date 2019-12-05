#!/usr/bin/env bash

# Imports
# -none-

# Variables
LVLFATAL=0
LVLERROR=1
LVLWARNING=2
LVLINFO=3
LVLDEBUG=4
LVLTRACE=5
LOGLVL=$LVLINFO

log() {
	printf "[ %s ] %s\n" "$@" >&2
}

fatal() {
	if [ -n "$LOGLVL" ] && [ $LOGLVL -ge $LVLFATAL ]; then
		log "FATAL" "$@"
	fi

	exit 1
}

warning() {
	if [ -n "$LOGLVL" ] && [ $LOGLVL -ge $LVLERROR ]; then
		log "ERR" "$@"
	fi
}

warning() {
	if [ -n "$LOGLVL" ] && [ $LOGLVL -ge $LVLWARNING ]; then
		log "WARN" "$@"
	fi
}

info() {
	if [ -n "$LOGLVL" ] && [ $LOGLVL -ge $LVLINFO ]; then
		log "INFO" "$@"
	fi
}

debug() {
	if [ -n "$LOGLVL" ] && [ $LOGLVL -ge $LVLDEBUG ]; then
		log "DEBUG" "$@"
	fi
}

trace() {
	if [ -n "$LOGLVL" ] && [ $LOGLVL -ge $LVLTRACE ]; then
		log "TRACE" "$@"
	fi
}

trace_slow() {
	trace "$@"
	sleep 1
}
