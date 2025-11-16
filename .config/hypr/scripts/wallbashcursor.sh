#!/usr/bin/env bash
cd $HOME/.config/hypr/wallbash/Wallbash_cursor

./src/cursor_utils.py --hypr --out-dir ./out

cp -r ./out/Bibata-* ~/.local/share/icons/

rm -r ./out