#!/bin/sh

link(){
    ln -s "$1" "$2" && echo "- Symlinked $1 to $2"
}

symlink(){
    if [ $FORCE = 1 ]; then
        [ -L "$2" ] && rm "$2" && printf "\t-- Removed symlink %s\n" "$2"
        [ -d "$2" ] && rm -r "$2" && printf "\t-- Removed directory %s\n" "$2"
        link "$1" "$2"
    else
        if [ -d "$2" ] || [ -f "$2" ] || [ -L "$2" ]; then
            echo "x $2 already existed, please remove it first or use --force option"
        else
            link "$1" "$2"
        fi
    fi
}

FORCE=0
while :; do
    case $1 in
        -f|--force)
            FORCE=1
            echo "Running in FORCE mode"
            ;;
        --) # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)  # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

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
