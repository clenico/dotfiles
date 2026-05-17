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


import re


from libqtile.config import (
    DropDown,
    Match,
    ScratchPad,
)

from floating import fullscreen_dropdown, thirdscreen_dropdown
from settings import *  # noqa
import settings as V


scratchpads = ScratchPad(
    V.ws_scratchpad_name,
    [
        DropDown(
            "dropdown-terminal",
            f"{V.my_terminal} -name dropdown-terminal -e tmux",
            x=0.0,
            y=0.0,
            width=1.0,
            height=0.50,
            opacity=1.0,
            on_focus_lost_hide=False,
            warp_pointer=False,
            match=Match(wm_instance_class="dropdown-terminal"),
        ),
        thirdscreen_dropdown(
            "floating-terminal",
            f"{V.my_terminal} -name floating-terminal -e tmux",
            Match(wm_instance_class="floating-terminal"),
        ),
        thirdscreen_dropdown(
            "pavucontrol", "pavucontrol", Match(wm_class="Pavucontrol")
        ),
        fullscreen_dropdown(
            "xfce4-appfinder", "xfce4-appfinder", Match(wm_class="xfce4-appfinder")
        ),
        fullscreen_dropdown(
            "note-scratchpad",
            "emacsclient --alternate-editor='' --no-wait --create-frame "
            "--frame-parameters='(quote (name . \"note-emacs\"))'",
            Match(title="note-emacs"),
        ),
        fullscreen_dropdown("torrent", "qbittorrent", Match(wm_class="qBittorrent")),
        thirdscreen_dropdown(
            "pomodoro", "gnome-pomodoro", Match(wm_class="Gnome-pomodoro")
        ),
        fullscreen_dropdown("obsidian", "obsidian", Match(wm_class="obsidian")),
        # The XMonad keymap referenced a discord scratchpad but did not define it.
        thirdscreen_dropdown(
            "discord", "discord", Match(wm_class=re.compile(r"^(discord|Discord)$"))
        ),
    ],
    single=False,
)
