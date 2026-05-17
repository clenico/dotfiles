from __future__ import annotations


from libqtile.config import (
    Key,
    KeyChord,
)
from libqtile.lazy import lazy

from settings import *  # noqa

from const import mod, shift

keys_M_v_ = [
    KeyChord(
        [mod],
        "v",
        [
            Key([], "l", lazy.spawn("i3lock && sleep 1")),
            Key([], "e", lazy.shutdown()),
            Key([], "s", lazy.spawn("i3lock && sleep 1 && systemctl suspend")),
            Key([], "h", lazy.spawn("pkexec systemctl hibernate")),
            Key([], "r", lazy.spawn("systemctl reboot")),
            Key([shift], "s", lazy.spawn("systemctl poweroff -i")),
        ],
        name="system",
    )
]
