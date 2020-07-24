#!/bin/sh
#
# Started by i3 to launch programs.


have() { type "$1" > /dev/null 2>&1; }


echo "start autostart" > /tmp/autostart_output

# Authentication agent
if have lxpolkit;then
    lxpolkit &
    echo "lxpolkit &" >> /tmp/autostart_output
fi

echo "lvl1;" >> /tmp/autostart_output
# if have zotero; then
#     zotero &
# fi

if have nautilus; then
    nautilus &
    nautilus &
    echo "nautilus &" >> /tmp/autostart_output
    echo "nautilus &" >> /tmp/autostart_output

elif have Thunar; then
    # thunar --daemon &
    Thunar &
    Thunar &
fi

if have thunderbird;then
    thunderbird &
fi

echo "lvl2;" >> /tmp/autostart_output

if have compton; then
    # compton &
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
echo "lvl3;" > /tmp/autostart_output
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
    i3-msg 'workspace 1'
    $TERMINAL &
    $TERMINAL &
fi

sleep 2

if have firefox; then
    i3-msg 'workspace 3'
    firefox &
    echo "firefox &" >> /tmp/autostart_output
fi

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

if have zeal; then
    zeal &
fi


~/MyScripts/RandomWallpaper.sh &

if have dropbox; then
    dropbox start -i &
    # HOME=~/.clouds/Dropbox/Personnal dropbox start -i &
    # HOME=~/.clouds/Dropbox/School dropbox start -i &
    # sleep 5
    # ~/MyScripts/launchDropbox.sh
fi
