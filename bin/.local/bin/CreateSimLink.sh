#!/usr/bin/env bash

#Usage : CreateSimLink.sh ~/OneDrive

directories=(Org Notes)
for directory in ${directories[@]}; do
    link="$HOME/$directory"
if [ -L $link ];then
    echo "$link already exists"
else
    ln -s $1"/$location" $link
    echo "$link created"
fi
done
