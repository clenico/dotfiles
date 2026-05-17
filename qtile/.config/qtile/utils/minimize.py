from __future__ import annotations
from typing import (
    Callable,
    TypeAlias,
    TYPE_CHECKING,
)

if TYPE_CHECKING:
    from libqtile.widget.base import _Widget
    from libqtile.backend.base import Window
    from libqtile.core.manager import Qtile

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]


from libqtile.lazy import lazy

from settings import *  # noqa


_minimized_stack: list[int] = []


@lazy.function
def minimize_current(qtile_obj: Qtile) -> None:
    win: Window | None = qtile_obj.current_window
    if not win:
        return
    _minimized_stack.append(win.wid)
    if hasattr(win, "toggle_minimize"):
        win.toggle_minimize()
    try:
        qtile_obj.current_group.prev_window()
    except Exception:
        pass


@lazy.function
def restore_last_minimized(qtile_obj: Qtile) -> None:
    while _minimized_stack:
        wid = _minimized_stack.pop()
        for group in qtile_obj.groups:
            for win in group.windows:
                if getattr(win, "wid", None) == wid:
                    if getattr(win, "minimized", False) and hasattr(
                        win, "toggle_minimize"
                    ):
                        win.toggle_minimize()
                    group.toscreen()
                    try:
                        win.focus(warp=True)
                    except Exception:
                        pass
                    return
