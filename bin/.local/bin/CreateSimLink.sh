#!/usr/bin/env bash

#Usage : CreateSimLink.sh ~/OneDrive

directories=(Org Notes "Pictures/Wallpaper" TFE)
for directory in ${directories[@]}; do
    link="$HOME/$directory"
if [ -L $link ];then
    echo "$link already exists"
else
    ln -s $1"/$directory" $link
    echo $1"/$directory -> ""$link created"
fi
done
