from __future__ import annotations
from typing import (
    Callable,
    TypeAlias,
    TYPE_CHECKING,
)

if TYPE_CHECKING:
    from libqtile.widget.base import _Widget
    from libqtile.core.manager import Qtile

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]
import os


from libqtile.config import (
    Key,
    KeyChord,
)
from libqtile.lazy import lazy

from settings import *  # noqa
import settings as V

from const import mod, shift


keys_M_o_ = [
    KeyChord(
        [mod],
        "o",
        [
            Key([], "a", lazy.spawn("audacity")),
            Key([], "b", lazy.spawn("blender")),
            Key([], "c", lazy.spawn("cura")),
            Key([], "d", lazy.spawn("discord")),
            Key(
                [],
                "e",
                lazy.spawn(
                    "emacsclient --alternate-editor='' --no-wait --create-frame --frame-parameters='(quote (name . \"scratchemacs-frame\"))'"
                ),
            ),
            Key([shift], "e", lazy.spawn("emacs")),
            Key([], "f", lazy.spawn("firefox")),
            Key([shift], "f", lazy.spawn("gufw")),
            Key([], "g", lazy.spawn("gimp")),
            Key([shift], "g", lazy.spawn("gparted")),
            Key([], "i", lazy.spawn("inkscape")),
            Key([], "h", lazy.spawn("urxvt 'htop task manager' -e htop")),
            KeyChord(
                [],
                "k",
                [
                    Key([], "r", lazy.spawn("krita")),
                    Key(
                        [],
                        "k",
                        lazy.spawn("killall screenkey &>/dev/null || screenkey &"),
                    ),
                    Key([shift], "k", lazy.spawn("killall screenkey &>/dev/null")),
                    Key([], "s", lazy.spawn("screenkey --show-settings")),
                ],
                name="screenkey-krita",
            ),
            Key([shift], "l", lazy.spawn("libreoffice")),
            KeyChord(
                [],
                "l",
                [
                    Key([], "b", lazy.spawn("libreoffice --base")),
                    Key([], "c", lazy.spawn("libreoffice --calc")),
                    Key([], "d", lazy.spawn("libreoffice --draw")),
                    Key([], "i", lazy.spawn("libreoffice --impress")),
                    Key([], "m", lazy.spawn("libreoffice --math")),
                    Key([], "w", lazy.spawn("libreoffice --writer")),
                ],
                name="libreoffice",
            ),
            Key([], "m", lazy.spawn("gnome-system-monitor")),
            Key([], "n", lazy.spawn(V.my_file_manager)),
            Key([], "p", lazy.spawn("gnome-power-statistics")),
            Key(
                [],
                "s",
                lazy.spawn(os.path.expanduser("~/MyScripts/rofi-screenlayout.sh")),
            ),
            Key([], "t", lazy.spawn("thunderbird")),
            Key([shift], "t", lazy.spawn(V.my_terminal)),
            Key([], "v", lazy.spawn("virtualbox")),
            Key([shift], "v", lazy.spawn("vlc")),
            Key([], "q", lazy.spawn("qbittorrent")),
            Key([shift], "q", lazy.spawn("qtcreator")),
            Key([], "w", lazy.spawn("kwrite")),
            Key([shift], "w", lazy.spawn("cheese")),
            Key(
                [],
                "x",
                lazy.spawn(
                    "a=$(zenity --file-selection --directory) && echo $a > /tmp/location"
                ),
            ),
            Key([], "z", lazy.spawn("filezilla")),
        ],
        name="launch",
    )
]
