from __future__ import annotations


from libqtile.config import (
    Key,
)
from libqtile.lazy import lazy

from settings import *  # noqa
import settings as V
from const import mod, ctrl, shift


def belgian_azerty_group_keys() -> None:
    # Belgian AZERTY workspace bindings, matching the XMonad keysyms.
    keys = []
    azerty_group_keys: list[str] = [
        "ampersand",
        "eacute",
        "quotedbl",
        "apostrophe",
        "parenleft",
        "section",
        "egrave",
        "exclam",
        "ccedilla",
        "agrave",
    ]
    for group_name, key_name in zip(V.ws_default_names, azerty_group_keys):
        keys.extend(
            [
                Key([mod], key_name, lazy.group[group_name].toscreen()),
                Key(
                    [mod, shift],
                    key_name,
                    lazy.window.togroup(group_name, switch_group=True),
                ),
                Key([mod, ctrl], key_name, lazy.group[group_name].toscreen()),
            ]
        )
    return keys


keys_workspaces = belgian_azerty_group_keys()
