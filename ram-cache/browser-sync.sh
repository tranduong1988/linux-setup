#!/bin/sh

static=static-$1
link=$1
volatile=/dev/shm/profile-$1-$USER

IFS=
set -efu

cd ~/.config

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

# if [ -e $link/.unpacked ]; then
# 	rsync -av --delete --exclude .unpacked ./$link/ ./$static/
# else
# 	rsync -av ./$static/ ./$link/
# 	touch $link/.unpacked
# fi

if [ -e "$link/.unpacked" ]; then
	rsync -av --delete \
		--exclude '.unpacked' \
		--exclude 'Default/Service Worker/' \
		"./$link/" "./$static/"
else
	rsync -av \
		--exclude 'Default/Service Worker/' \
		"./$static/" "./$link/"
	touch "$link/.unpacked"
fi