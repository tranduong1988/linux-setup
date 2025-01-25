#!/bin/sh

mkdir -p $HOME/.local/bin
cp browser-sync.sh $HOME/.local/bin
cp cache2ram.sh $HOME/.local/bin
chmod +x $HOME/.local/bin/browser-sync.sh
chmod +x $HOME/.local/bin/cache2ram.sh


mkdir -p $HOME/.config/systemd/user
cp browser-profile@.service $HOME/.config/systemd/user
cp cache2ram@.service $HOME/.config/systemd/user

systemctl --user enable browser-profile@google-chrome.service
systemctl --user enable cache2ram@google-chrome.service

# systemctl --user enable browser-profile@BraveSoftware.service
# systemctl --user enable cache2ram@BraveSoftware.service