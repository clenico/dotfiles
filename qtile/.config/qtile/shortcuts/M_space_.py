from const import mod


from libqtile.config import (
    Key,
    KeyChord,
)

from settings import *  # noqa

from utils.layouts import set_layout

key_M_space_ = [
    KeyChord(
        [mod],
        "space",
        [
            Key([], "a", set_layout("Tall")),
            Key([], "k", set_layout("Tall_little")),
            Key([], "s", set_layout("Spiral")),
            Key([], "t", set_layout("Tabs")),
        ],
        name="layout",
    )
]
