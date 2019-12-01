#!/usr/bin/env bash

# Imports
source ./_shared/consts.sh

# Variables
# -none-

download() {
	SOURCE=$2
	TARGET=$TMPDIR/$1

	mkdir -p $TMPDIR
	# wget --quiet --show-progress --progress=bar --no-check-certificate --output-document=$TARGET $SOURCE
	# wget --content-on-error --output-document=$TARGET $SOURCE

	echo $TARGET
}
