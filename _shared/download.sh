#!/usr/bin/env bash

# Imports
. ./_shared/consts.sh

# Variables
# -none-

download() {
	TARGET=$TMPDIR/$1

	mkdir -p $TMPDIR
	touch "$TARGET"
	# wget --quiet --show-progress --progress=bar --no-check-certificate --output-document=$TARGET $SOURCE
	# wget --content-on-error --output-document=$TARGET $SOURCE

	echo "$TARGET"
}
