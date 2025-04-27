#!/bin/sh

mkdir -p ~/.local/bin
cp chrome-sync.sh ~/.local/bin
cp chrome-cache.sh ~/.local/bin


mkdir -p ~/.config/systemd/user
cp chrome-profile.service ~/.config/systemd/user
cp chrome-cache.service ~/.config/systemd/user

systemctl --user enable chrome-profile.service
systemctl --user enable chrome-cache.service