from __future__ import annotations
from typing import Callable, TypeAlias, TYPE_CHECKING

if TYPE_CHECKING:
    from libqtile.widget.base import _Widget
    from libqtile.core.manager import Qtile

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]


from libqtile import bar


from libqtile.config import Screen


from status_bar import init_widgets

# TODO centralise in factory
bottom_bar_size = 30
screens: list[Screen] = [
    Screen(
        bottom=bar.Bar(
            init_widgets(with_systray=True),
            bottom_bar_size,
            background="#282c34",
        )
    ),
    Screen(
        bottom=bar.Bar(
            init_widgets(),
            bottom_bar_size,
            background="#282c34",
        )
    ),
    Screen(
        bottom=bar.Bar(
            init_widgets(),
            bottom_bar_size,
            background="#282c34",
        )
    ),
]
