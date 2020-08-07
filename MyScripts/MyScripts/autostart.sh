#!/bin/sh
#
# Started by i3 to launch programs.


have() { type "$1" > /dev/null 2>&1; }



# Manage Wallpaper
if have variety;then
    variety &
fi


# Authentication agent
if have lxpolkit;then
    lxpolkit &
fi

# if have zotero; then
#     zotero &
# fi

# if have nautilus; then
#     nautilus &
#     nautilus &

# elif have Thunar; then
#     # thunar --daemon &
#     Thunar &
#     Thunar &
# fi

if have thunderbird;then
    thunderbird &
fi


if have compton; then
    compton -b --config ~/.config/compton/compton.conf &
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

# if have xbindkeys; then
#     [ -f "$XDG_CONFIG_HOME/X11/xbindkeysrc" ] && xbindkeys -f "$XDG_CONFIG_HOME/X11/xbindkeysrc" &
# fi


if have termite; then
    i3-msg 'workspace 1'
    $TERMINAL &
    $TERMINAL &
fi

sleep 2

# if have firefox; then
#     firefox &
# fi

if have clipit; then
    clipit &
fi


if have volumeicon; then
    volumeicon &
fi

if have nm-applet; then
    nm-applet &
fi

if have dunst; then
    dunst &
fi

if have onedrive; then
    onedrive --monitor &
fi

if have libinput-gestures-setup; then
    libinput-gestures-setup start
fi

# if have zeal; then
#     zeal &
# fi


~/MyScripts/RandomWallpaper.sh &

if have dropbox; then
    dropbox start -i &
    # HOME=~/.clouds/Dropbox/Personnal dropbox start -i &
    # HOME=~/.clouds/Dropbox/School dropbox start -i &
    # sleep 5
    # ~/MyScripts/launchDropbox.sh
fi
