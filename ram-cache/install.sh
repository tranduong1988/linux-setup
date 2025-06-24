#!/bin/sh

mkdir -p ~/.local/bin
cp browser-sync.sh ~/.local/bin
cp browser-cache.sh ~/.local/bin
chmod +x ~/.local/bin/browser-sync.sh 
chmod +x ~/.local/bin/browser-cache.sh


mkdir -p ~/.config/systemd/user
cp browser-profile@.service ~/.config/systemd/user
cp browser-cache@.service ~/.config/systemd/user

systemctl --user enable browser-profile@google-chrome.service
systemctl --user enable browser-cache@google-chrome.service

# systemctl --user enable browser-profile@BraveSoftware.service
# systemctl --user enable browser-cache@BraveSoftware.service