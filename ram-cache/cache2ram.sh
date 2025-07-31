#!/bin/bash

link=$1
volatile=/dev/shm/cache-$1-$USER

IFS=
set -efu

cd "${XDG_CACHE_HOME:-$HOME/.cache}"

if [ ! -r $volatile ]; then
	mkdir -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
	# mv $link $static
	rm -rf $link
	ln -s $volatile $link
fi
