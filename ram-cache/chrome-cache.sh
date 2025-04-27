#!/bin/sh

link=google-chrome
volatile=/dev/shm/cache-google-chrome-$USER

IFS=
set -efu

cd ~/.cache

if [ ! -r $volatile ]; then
	mkdir -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
	# mv $link $static
	rm -rf $link
	ln -s $volatile $link
fi
