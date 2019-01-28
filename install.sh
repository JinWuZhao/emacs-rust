#!/bin/sh

pacman -Syu --noconfirm

pacman -S --noconfirm mysql-client

pacman -Scc --noconfirm

curl https://sh.rustup.rs -sSf | sh -y
rustup update stable
rustup component add rls rust-analysis rust-src

emacs --daemon
emacsclient -e '(kill-emacs)'
