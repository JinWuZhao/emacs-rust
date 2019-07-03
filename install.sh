#!/bin/sh

pacman -Syu --noconfirm

pacman -S --noconfirm cmake
pacman -S --noconfirm gdb

pacman -Scc --noconfirm

mkdir /usr/local/rust
export RUSTUP_HOME=/usr/local/rust/rustup
export CARGO_HOME=/usr/local/rust/cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
source $CARGO_HOME/env
rustup update stable
rustup component add rls rust-analysis rust-src rustfmt
chmod -R 777 /usr/local/rust

curl -o /root/.emacs.d/custom/awesome-tab.el https://raw.githubusercontent.com/manateelazycat/awesome-tab/master/awesome-tab.el

emacs --daemon
emacsclient -e '(kill-emacs)'
