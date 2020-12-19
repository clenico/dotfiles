#!/usr/bin/env bash
if [ "$#" -lt 2 ]; then
    echo "Illegal number of parameters"
    exit
fi

screenshot_type=$1
isEditName=$2
location=$3

date=$(date "+%Y-%m-%d-%H:%M:%S")

tmp="/tmp/imgTmp";

if [[ $location == "" ]];
then
    location="."
fi


if [[ $screenshot_type == "zone" ]];then
    if [[ $isEditName == "yes" ]];then
            flameshot gui -r > $tmp
            content=$(cat $tmp)
            if [[ $content == "screenshot failed" ]];then
                echo "succeed"
            else
                name=$(zenity --entry --text "Save as" --entry-text "$date") && cp $tmp $location/$name.png
            fi
    elif [[ $isEditName == "no" ]];then
        flameshot gui -p $location
    fi

elif [[ $screenshot_type == "screen" ]];then
    if [[ $isEditName == "yes" ]];then
        flameshot screen -r > $tmp
        if [[ $content == "screenshot failed" ]];then
            echo "screenshot failed"
        else
            name=$(zenity --entry --text "Save as" --entry-text "$date") && cp $tmp $location/$name.png
        fi
    elif [[ $isEditName == "no" ]];then
        flameshot screen -p $location
    fi

elif [[ $screenshot_type == "full" ]];then
    if [[ $isEditName == "yes" ]];then
        scrot '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f /tmp/imgTmp'
        name=$(zenity --entry --text "Save as" --entry-text "$date") && cp $tmp $location/$name.png
    elif [[ $isEditName == "no" ]];then
        scrot '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f ~/Pictures/Screenshots/Full/' && notify-send -t 2000 'Screenshot saved at ~/Pictures/Screenshots/Full/'
    fi

elif [[ $screenshot_type == "window" ]];then
    if [[ $isEditName == "yes" ]];then
        scrot '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f /tmp/imgTmp'
        name=$(zenity --entry --text "Save as" --entry-text "$date") && cp $tmp $location/$name.png
    elif [[ $isEditName == "no" ]];then
        scrot '%Y-%m-%d-%H-%M-%S.png' -u -e 'mv $f ~/Pictures/Screenshots/Windows/' && notify-send -t 2000 'Screenshot saved at ~/Pictures/Screenshots/Windows/':
    fi
fi
