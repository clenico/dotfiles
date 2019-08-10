#!/bin/sh
#
# Started by i3 to launch programs.

have() { type "$1" > /dev/null 2>&1; }

if have zotero; then
    zotero &
fi

if have nemo; then
    nemo &
elif have Thunar; then
    Thunar &
    Thunar &
fi

if have thunderbird;then
    thunderbird &
fi


if have compton; then
    # compton &
    :
fi

if pgrep i3 && have dunst; then
    dunst &
fi

if have emacs; then
    emacs &
fi

if have feh; then
    feh --no-fehbg --bg-center `wallpaper.py` &
fi

if have nm-applet; then
    nm-applet &
fi

if have mpd; then
    [ ! -s ~/.config/mpd/pid ] && mpd &
fi

if have unclutter; then
    unclutter --ignore-scrolling --jitter 2 &
fi

if have xbindkeys; then
    [ -f "$XDG_CONFIG_HOME/X11/xbindkeysrc" ] && xbindkeys -f "$XDG_CONFIG_HOME/X11/xbindkeysrc" &
fi


if have termite; then
    i3-msg 'workspace 1:'
    termite &
    termite &
fi

sleep 0.5

if have firefox; then
    i3-msg 'workspace 3:'
    firefox &
fi
