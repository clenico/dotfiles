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


from libqtile.config import (
    Key,
    KeyChord,
)
from libqtile.lazy import lazy

from settings import *  # noqa
import settings as V

from utils.ws_zapping import next_non_empty_group, prev_non_empty_group
from utils.toggle_gaps import toggle_gaps
from utils.minimize import minimize_current, restore_last_minimized
from utils.layouts import (
    set_layout,
    layout_call,
    promote_to_master,
    focus_master,
    toggle_floating,
    sink_all,
    kill_all,
    kill_all_and_remove_group,
    toggle_group_fullscreen,
    move_float_keep_focus,
    resize_float_keep_focus,
)
from utils.resize import smart_master_resize
from utils.dynamic_ws import create_or_go_dynamic_ws, move_window_to_dynamic_ws
from const import mod, alt, ctrl, shift, mod3
from shortcuts.M_v_ import keys_M_v_
from shortcuts.M_o_ import keys_M_o_
from shortcuts.M_space_ import key_M_space_
from shortcuts.workspaces import keys_workspaces
from shortcuts.screens import keys_screens
import os

keys: list[Key | KeyChord] = []
keys.extend(keys_M_v_)
keys.extend(keys_M_o_)
keys.extend(key_M_space_)
keys.extend(keys_workspaces)
keys.extend(keys_screens)

# Direct shortcuts
keys.extend(
    [
        # Key([mod], "a", ),
        # Key([mod, shift], "a", ),
        # Key([mod, ctrl], "a", ),
        # Key([mod], "b", ),
        # Key([mod, shift], "b", ),
        # Key([mod, ctrl], "b", ),
        Key(
            [mod],
            "c",
            lazy.group[V.ws_scratchpad_name].dropdown_toggle("xfce4-appfinder"),
            desc="XFCE4 appfinder",
        ),
        Key(
            [mod],
            "d",
            lazy.spawn(
                "rofi -show run -modi run -theme ~/.config/rofi/config_monokai.rasi"
            ),
            desc="Rofi application launcher",
        ),
        Key(
            [mod, shift],
            "d",
            lazy.spawn(
                "rofi -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/config_launchpad.rasi"
            ),
            desc="Rofi application launcher with icons",
        ),
        Key([mod, ctrl], "d", lazy.spawn("rofi -show window")),
        # Key([mod, shift], "e", ),
        Key(
            [mod],
            "f",
            toggle_group_fullscreen(),
            desc="Toggle fullscreen for current group",
        ),
        Key([mod], "h", layout_call("left", "previous"), desc="Move focus left"),
        Key(
            [mod, shift],
            "h",
            layout_call("swap_left", "shuffle_left"),
            desc="Move window left",
        ),
        Key(
            [mod, ctrl],
            "h",
            smart_master_resize("shrink"),
        ),
        # Key([alt, ctrl], "h", lazy.spawn("clipit"), desc="Spawn clipboard manager"),
        # Key([mod], "i", ),
        Key(
            [mod, shift],
            "i",
            sink_all,
            desc="Sink all floating windows in current group",
        ),
        Key([mod], "j", layout_call("down", "next"), desc="Move focus down"),
        Key(
            [mod, shift],
            "j",
            layout_call("shuffle_down", "swap_down"),
            desc="Move window down",
        ),
        Key([mod], "k", layout_call("up", "previous"), desc="Move focus up"),
        Key(
            [mod, shift],
            "k",
            layout_call("shuffle_up", "swap_up"),
            desc="Move window up",
        ),
        Key([mod], "l", layout_call("right", "next"), desc="Move focus right"),
        Key(
            [mod, shift],
            "l",
            layout_call("swap_right", "shuffle_right"),
            desc="Move window right",
        ),
        Key(
            [mod, ctrl],
            "l",
            smart_master_resize("grow"),
        ),
        Key([mod], "m", focus_master, desc="Focus master window"),
        # Key([mod, shift], "m", ),
        Key([mod, ctrl], "m", promote_to_master),
        Key([mod], "n", lazy.group.next_window(), desc="Focus next window"),
        # Key([mod, shift], "n", ),
        Key(
            [mod, ctrl],
            "o",
            lazy.screen.toggle_group(),
            desc="Toggle current group and previous group",
        ),
        Key([mod], "p", lazy.group.prev_window(), desc="Focus previous window"),
        # Key([mod, shift], "p", ),
        Key([mod, shift], "q", lazy.window.kill(), desc="Kill focused window"),
        # Key([mod], "r", ),
        # Key([mod, shift], "r", ),
        Key([mod, ctrl], "r", lazy.restart(), desc="Reload Qtile config"),
        # Key([mod], "s", ),
        Key(
            [mod, shift],
            "s",
            lazy.spawn("flameshot gui --clipboard"),
            desc="Take screenshot with Flameshot",
        ),
        Key([mod], "u", lazy.spawn(V.my_terminal), desc="Open terminal"),
        Key(
            [mod],
            "ugrave",
            lazy.group[V.ws_scratchpad_name].dropdown_toggle("obsidian"),
            desc="Toggle Obsidian scratchpad",
        ),
        Key(
            [mod, ctrl],
            "x",
            lazy.spawn(os.path.expanduser("~/MyScripts/nsp_manager.py --key firefox")),
            desc="Open Firefox calendar in floating window",
        ),  # TODO improve
        Key([mod], "semicolon", toggle_gaps, desc="Toggle gaps"),
        Key([mod], "Return", lazy.spawn(V.my_terminal), desc="Open terminal"),
        Key(
            [mod],
            "asciitilde",
            lazy.group[V.ws_scratchpad_name].dropdown_toggle("dropdown-terminal"),
            desc="Toggle dropdown terminal",
        ),
        Key([mod], "comma", toggle_floating, desc="Toggle floating"),
        # Key([mod, ctrl], "mu", ),
        Key(
            [mod],
            "dollar",
            lazy.group[V.ws_scratchpad_name].dropdown_toggle("note-scratchpad"),
            desc="Toggle note scratchpad",
        ),  # FIXME do not stay tiled
        # Key([mod, ctrl], "dollar", ),
        # Key( [mod], "colon", ),
        # Key( [mod, ctrl], "colon", ),
        Key(
            [mod],
            "equal",
            lazy.group[V.ws_scratchpad_name].dropdown_toggle("floating-terminal"),
            desc="Toggle floating terminal",
        ),
        # Key([mod, ctrl], "equal", ),
        Key(
            [mod],
            "minus",
            create_or_go_dynamic_ws,
            desc="Create or go to dynamic workspace",
        ),
        Key(
            [mod, shift],
            "minus",
            move_window_to_dynamic_ws,
            desc="Move window to dynamic workspace",
        ),
        # Key([mod, ctrl], "minus", ),
    ]
)

keys.extend(
    [
        Key([mod, shift], "space", set_layout("Tall"), desc="Set layout to Tall"),
        Key([mod, ctrl], "space", lazy.next_layout(), desc="Toggle between layouts"),
        Key([mod], "Delete", kill_all, desc="Kill all windows in current group"),
        Key(
            [mod, shift],
            "Delete",
            kill_all_and_remove_group,
            desc="Kill all windows and remove current group",
        ),
        Key(
            [mod, shift],
            "Escape",
            lazy.spawn("xkill"),
            desc="Kill window by clicking on it",
        ),
        Key(
            [ctrl, shift],
            "Escape",
            lazy.spawn("gnome-system-monitor"),
            desc="Open system monitor",
        ),
        Key([mod], "Tab", next_non_empty_group, desc="Switch to next non-empty group"),
        Key(
            [mod, shift],
            "Tab",
            prev_non_empty_group,
            desc="Switch to previous non-empty group",
        ),
        Key([mod3], "less", minimize_current, desc="Minimize current window"),
        Key(
            [mod3, shift],
            "less",
            restore_last_minimized,
            desc="Restore last minimized window",
        ),
        Key(
            [mod], "F1", lazy.group[V.ws_scratchpad_name].dropdown_toggle("pavucontrol")
        ),
        # Key([mod], "F3", ),
        # Key([mod], "F4", ),
        # Key( [mod, shift], "F4", ),
        # Key([mod], "F5", ),
        # Key([mod, shift], "F5", ),
        # Key([mod], "F8", ),
        Key([mod], "Home", lazy.spawn("hamster")),
        Key([mod], "End", lazy.spawn("hamster stop")),
        Key([mod], "Insert", lazy.spawn("hamster add")),
        # Floating window movement / resizing.
        Key(
            [mod],
            "Left",
            move_float_keep_focus(-80, 0),
            desc="Move floating window left",
        ),
        Key(
            [mod],
            "Up",
            move_float_keep_focus(0, -80),
            desc="Move floating window up",
        ),
        Key(
            [mod],
            "Down",
            move_float_keep_focus(0, 80),
            desc="Move floating window down",
        ),
        Key(
            [mod],
            "Right",
            move_float_keep_focus(80, 0),
            desc="Move floating window right",
        ),
        Key(
            [mod, shift],
            "Up",
            resize_float_keep_focus(0, -40),
            desc="Resize floating window up",
        ),
        Key(
            [mod, shift],
            "Left",
            resize_float_keep_focus(-40, 0),
            desc="Resize floating window left",
        ),
        Key(
            [mod, shift],
            "Down",
            resize_float_keep_focus(0, 40),
            desc="Resize floating window down",
        ),
        Key(
            [mod, shift],
            "Right",
            resize_float_keep_focus(40, 0),
            desc="Resize floating window right",
        ),
        Key(
            [mod],
            "Page_Up",
            lazy.window.resize_floating(40, 40),
            desc="Resize floating window up",
        ),
        Key(
            [mod],
            "Page_Down",
            lazy.window.resize_floating(-40, -40),
            desc="Resize floating window down",
        ),
        # Dunst bindings that were outside the M-y chord.
        Key(
            [mod3],
            "space",
            lazy.spawn("dunstctl close"),
            desc="Close current notification",
        ),
        Key(
            [ctrl, alt],
            "space",
            lazy.spawn("dunstctl close-all"),
            desc="Close all notifications",
        ),
        # Sound and brightness.
        Key(
            [],
            "XF86AudioMute",
            lazy.spawn("pactl set-sink-mute 0 toggle"),
            desc="Toggle mute",
        ),
        Key(
            [],
            "XF86AudioLowerVolume",
            lazy.spawn("pactl set-sink-volume 0 -5%"),
            desc="Decrease volume",
        ),
        Key(
            [],
            "XF86AudioRaiseVolume",
            lazy.spawn("pactl set-sink-volume 0 +5%"),
            desc="Increase volume",
        ),
        Key(
            [],
            "XF86MonBrightnessUp",
            lazy.spawn("xbacklight -inc 5"),
            desc="Increase brightness",
        ),
        Key(
            [],
            "XF86MonBrightnessDown",
            lazy.spawn("xbacklight -dec 5"),
            desc="Decrease brightness",
        ),
    ]
)
