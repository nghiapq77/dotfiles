#!/bin/sh

symlink(){
    if [ -d "$2" ] || [ -f "$2" ] || [ -L "$2" ]; then
        echo "x $2 already existed, please remove first"
    else
        ln -s "$1" "$2"
        echo "Symlinked $1 to $2"
    fi
}

# .local/bin
BIN_SRC_PATH="$PWD/.local/bin"
BIN_DST_PATH="$HOME/.local/bin"
symlink "$BIN_SRC_PATH" "$BIN_DST_PATH"

# .config
CONFIG_SRC_PATH="$PWD/.config"
CONFIG_DST_PATH="$HOME/.config"
for CONFIG_SRC in "$CONFIG_SRC_PATH"/*; do
    f="$(basename -- "$CONFIG_SRC")"
    CONFIG_DST="$CONFIG_DST_PATH/$f"
    symlink "$CONFIG_SRC" "$CONFIG_DST"
done

# .local/share
SHARE_SRC_PATH="$PWD/.local/share"
SHARE_DST_PATH="$HOME/.local/share"
for SHARE_SRC in "$SHARE_SRC_PATH"/*; do
    f="$(basename -- "$SHARE_SRC")"
    SHARE_DST="$SHARE_DST_PATH/$f"
    symlink "$SHARE_SRC" "$SHARE_DST"
done
