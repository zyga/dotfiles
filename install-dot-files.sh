#!/bin/sh
set -e

# DotFiles need to be in this directory
BASE_DIR="DotFiles"
# Don't die on filenames with spaces in them
IFS=''

# Create each standalone dotfile (dot-FILE as ~/.FILE)
for F in $HOME/$BASE_DIR/dot-*; do
    # Skip Ubuntu One synchronization conflicts
    if echo "$F" | grep -e '.u1conflict' >/dev/null; then
        continue
    fi
    # Compute the real filename
    F="$(basename "$F" | sed 's/dot-//')"
    # Set aside local file with the same name _unless_ it is a symlink we want to create already
    if [ -e "$HOME/.$F" -o -h "$HOME/.$F" ] && [ ! -h "$HOME/.$F" -o "$(readlink "$HOME/.$F")" != "$HOME/$BASE_DIR/dot-$F" ]; then
        mv -v "$HOME/.$F" "$HOME/.$F.local"
    fi
    # Create a symlink to the dotfile
    if [ ! -e "$HOME/.$F" ]; then
        ln -v -s "$HOME/$BASE_DIR/dot-$F" "$HOME/.$F"
    fi
done

# Create each dot-directory (as above but for directories)
for D in $HOME/$BASE_DIR/dirdot-*; do
    # Skip Ubuntu One synchronization conflicts
    if echo "$D" | grep -e '.u1conflict' >/dev/null; then
        continue
    fi
    # Compute the real directory name
    D="$(basename "$D" | sed 's/dirdot-//')"
    # Create the dot directory if needed
    if [ ! -d "$HOME/.$D" ]; then
        mkdir -v "$HOME/.$D"
    fi
    # Symlink each dotfile from the dotdirectory
    for F in $HOME/$BASE_DIR/dirdot-$D/*; do
        F="$(basename "$F")"
        if [ -e "$HOME/.$D/$F" -o -h "$HOME/.$D/$F" ] && [ ! -h "$HOME/.$D/$F" -o "$(readlink "$HOME/.$D/$F")" != "$HOME/$BASE_DIR/dirdot-$D/$F" ] ; then
        mv -v "$HOME/.$D/$F" "$HOME/.$D/$F.local"
        fi
        if [ ! -e "$HOME/.$D/$F" ]; then
            ln -v -s "$HOME/$BASE_DIR/dirdot-$D/$F" "$HOME/.$D/$F"
        fi
    done
done
