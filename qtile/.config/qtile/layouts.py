from __future__ import annotations
from typing import (
    Any,
    Callable,
    TypeAlias,
    TYPE_CHECKING,
)

if TYPE_CHECKING:
    from libqtile.layout.base import Layout
    from libqtile.widget.base import _Widget
    from libqtile.core.manager import Qtile

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]

from libqtile.config import (
    Match,
)


from libqtile import layout

from settings import *  # noqa
import settings as V


layout_defaults: dict[str, Any] = dict(
    border_focus=V.focus_color,
    border_normal=V.unfocus_color,
    border_width=V.border_width,
    margin=0,
)

layouts: list[Layout] = [
    layout.MonadTall(
        name="Tall",
        ratio=0.50,
        change_ratio=0.03,
        single_margin=0,
        **layout_defaults,
    ),
    layout.MonadTall(
        name="Tall_little",
        ratio=0.25,
        change_ratio=0.03,
        single_margin=0,
        **layout_defaults,
    ),
    layout.Spiral(
        name="Spiral",
        ratio=3 / 4,
        main_pane="left",
        border_on_single=False,
        **layout_defaults,
    ),
    # Approximation of XMonad tabbed layout.
    layout.TreeTab(
        name="Tabs",
        font="Mononoki Nerd Font",
        fontsize=11,
        active_bg="#292d3e",
        inactive_bg="#3e445e",
        active_fg="#ffffff",
        inactive_fg="#d0d0d0",
        bg_color="#292d3e",
    ),
    layout.Max(name="Max", **layout_defaults),
]

floating_layout = layout.Floating(
    border_focus=V.focus_color,
    border_normal=V.unfocus_color,
    border_width=V.border_width,
    fullscreen_border_width=0,
    max_border_width=0,
    float_rules=[
        *layout.Floating.default_float_rules,
        *[Match(wm_class=c) for c in V.float_classes],
        *[Match(title=t) for t in V.float_titles],
    ],
)
