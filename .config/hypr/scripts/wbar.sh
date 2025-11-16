#!/usr/bin/env sh

    killall waybar
    sleep 0.5
    waybar --config $HOME/.config/waybar/config --style $HOME/.config/waybar/style.css > /dev/null 2>&1 &
