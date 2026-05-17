from __future__ import annotations

from typing import TYPE_CHECKING, Callable, TypeAlias, cast

if TYPE_CHECKING:
    from libqtile.core.manager import Qtile
    from libqtile.widget.base import _Widget
    from libqtile.widget.groupbox import GroupBox as _GroupBox

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]

from libqtile import bar, widget

GroupBox = cast("type[_GroupBox]", widget.GroupBox)
# from __future__ import annotations
# from typing import Callable, TypeAlias, TYPE_CHECKING

# if TYPE_CHECKING:
#     from libqtile.widget.base import _Widget
#     from libqtile.core.manager import Qtile

#     QtileFunc: TypeAlias = Callable[[Qtile], None]
#     WidgetList: TypeAlias = list[_Widget]


# from libqtile import bar, widget

# TODO add tasklist


def init_widgets(with_systray: bool = False) -> WidgetList:
    widgets: WidgetList = [
        GroupBox(
            highlight_method="block",
            # Active workspace (currently focused)
            active="#ffffff",  # bright white text
            # Inactive workspaces
            inactive="#7f8490",  # soft gray
            # Current screen + current group (most important)
            this_current_screen_border="#ffcc00",  # vivid yellow
            # Current screen, inactive group
            this_screen_border="#00d7ff",  # bright cyan
            # Other monitor, currently active there
            other_current_screen_border="#ff66cc",  # vivid pink
            # Other monitor, inactive
            other_screen_border="#5c6370",  # muted gray-blue
            # Urgent window
            urgent_border="#ff3333",  # strong red
            disable_drag=True,
            hide_unused=True,
        ),
        widget.Spacer(length=8),
        widget.Prompt(),
        widget.CurrentLayout(),
        # widget.PulseVolume(
        #     fmt="V {}",
        #     foreground="#51afef",
        # ),
        # widget.TextBox("|", foreground="#bbc2cf"),
        # widget.Battery(
        #     format="B {percent:2.0%}",
        #     charge_char="C",
        #     discharge_char="D",
        #     full_char="F",
        #     foreground="#bbc2cf",
        # ),
        # widget.TextBox("|", foreground="#bbc2cf"),
        # widget.Net(
        #     format="{interface}: {down} ↓ {up} ↑",
        #     interface="auto",
        #     foreground="#51afef",
        # ),
        # widget.TextBox("|", foreground="#bbc2cf"),
        # widget.CPU(
        #     format="Cpu {load_percent:3.0f}%",
        #     foreground="#51afef",
        # ),
        # widget.TextBox("|", foreground="#bbc2cf"),
        # widget.Memory(
        #     format="Mem {MemPercent}%",
        #     foreground="#ecbe7b",
        # ),
        # widget.TextBox("|", foreground="#bbc2cf"),
        # widget.DF(
        #     partition="/",
        #     format="/ {uf}{m}",
        #     foreground="#ff6c6b",
        # ),
        widget.Spacer(length=bar.STRETCH),
        widget.Clock(
            format="%Y/%m/%d %H:%M",
            foreground="#51afef",
        ),
    ]

    if with_systray:
        widgets.append(widget.TextBox("|", foreground="#bbc2cf"))
        widgets.append(widget.Systray())

    return widgets
