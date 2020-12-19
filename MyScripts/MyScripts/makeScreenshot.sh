#!/usr/bin/env bash
if [ "$#" -lt 2 ]; then
    echo "Illegal number of parameters"
    exit
fi

screenshot_type=$1
isEditName=$2
location=$3

date=$(date "+%Y-%m-%d-%H:%M:%S")
tmp="/tmp/imgTmp.png"

if [ -f $tmp ];then
    rm $tmp
fi


if [[ $location == "" ]];
then
    location="."
fi


if [[ $screenshot_type == "zone" ]];then
    flameshot gui -r > $tmp

elif [[ $screenshot_type == "screen" ]];then
    flameshot screen -r > $tmp

elif [[ $screenshot_type == "full" ]];then
    scrot $tmp

elif [[ $screenshot_type == "window" ]];then
    scrot $tmp -u
fi


if [ -f $tmp ];then
    :
else
    echo "$tmp file couldn't be found"
    exit
fi


content=$(tr -d '\0' < $tmp)
if [ "$content" = "screenshot failed" -o "$content" = "screenshot aborted" ];then
    echo "$content"
    exit
else
    if [[ $isEditName == "yes" ]];then
        name=$(zenity --entry --text "Save as" --entry-text "$date")
    elif [[ $isEditName == "no" ]];then
        name=$date
    fi
fi

if [ "$name" != "" -a -f $tmp ];then
    destination=$location/$name.png
    cp $tmp $destination
    notify-send "Screenshot saved at $destination" -t 2000

else
    echo "No temporary screenshot found at $tmp"
fi
