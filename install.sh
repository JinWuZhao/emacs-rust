#!/bin/sh

pacman -Syu --noconfirm

pacman -S --noconfirm cmake
pacman -S --noconfirm gdb
pacman -S --noconfirm adobe-source-han-sans-cn-fonts
pacman -S --noconfirm adobe-source-han-sans-tw-fonts

pacman -Scc --noconfirm

mkdir /usr/local/rust
export RUSTUP_HOME=/usr/local/rust/rustup
export CARGO_HOME=/usr/local/rust/cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
source $CARGO_HOME/env
rustup update stable
rustup component add rls rust-analysis rust-src rustfmt
chmod -R 777 /usr/local/rust

emacs --daemon
emacsclient -e '(kill-emacs)'
