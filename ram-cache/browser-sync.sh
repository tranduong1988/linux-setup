#!/bin/sh

static=static-$1
link=$1
volatile=/dev/shm/profile-$1-$USER

IFS=
set -efu

cd "${XDG_CONFIG_HOME:-$HOME/.config}"

if [ ! -r $volatile ]; then
	mkdir -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
	if [ ! -d "$link" ]; then 
		mkdir -p $link
	fi
	mv $link $static
	ln -s $volatile $link
fi

EXCLUDES=(
  --exclude '*/Service Worker/'
  --exclude '*Cache*/'
  --exclude '*cache*/'
  --exclude '*Safe Browsing/'
  --exclude '*.log'
)

if [ -e "$link/.unpacked" ]; then
	rsync -av --delete \
		--exclude '.unpacked' \
		"${EXCLUDES[@]}" \
		"./$link/" "./$static/"
else
	rsync -av \
		"${EXCLUDES[@]}" \
		"./$static/" "./$link/"
	touch "$link/.unpacked"
fi