#!/bin/bash
#
# Allows you to find your local files.
#
# NOTE: this script use `locate` instead of `find` for better
# performance. Thus, be careful to not forget to update your database
# for `mlocate`.

set -e

path="/home/$USER/.screenlayout/"
target=$(ls $path | rofi -dmenu -width 90 -i -p "Find:")
"$path$target"
