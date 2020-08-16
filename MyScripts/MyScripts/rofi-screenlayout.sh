#!/bin/bash
#
# Allows choose the screenlayout you want. You can easily create one
# using arandr

set -e

path="/home/$USER/.screenlayout/"
target=$(ls $path | rofi -dmenu -width 90 -i -p "Screen layout")
"$path$target"
