#!/bin/sh

apk update
apk upgrade

apk --no-cache add mysql-client

curl https://sh.rustup.rs -sSf | sh
rustup update
rustup component add rls rust-analysis rust-src

emacs --daemon
emacsclient -e '(kill-emacs)'
