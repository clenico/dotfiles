#!/bin/bash

have() { type "$1" > /dev/null 2>&1; }

# Manage kdeconnect
if have kdeconnect-indicator;then
    kdeconnect-indicator &
fi

# Manage Bluetooth
if have blueman-applet;then
    blueman-applet &
fi

# Authentication agent
if have lxpolkit;then
    lxpolkit &
fi

if have zotero; then
    zotero &
fi

if have thunderbird;then
    thunderbird &
fi


if have compton; then
    compton -b --config ~/.config/compton/compton.conf &
fi

if have dunst; then
    dunst &
fi

if have feh; then
    feh --no-fehbg --bg-center `wallpaper.py` &
fi

if have unclutter; then
    unclutter --ignore-scrolling --jitter 2 &
fi

if have volumeicon; then
    volumeicon &
fi

if have nm-applet; then
    nm-applet &
fi

if have libinput-gestures-setup; then
    libinput-gestures-setup start
fi


if have flameshot; then
    flameshot &
fi

if have diodon; then
    diodon &
fi

if have emacs; then
    emacs --daemon --with-x-toolkit=lucid &
fi


