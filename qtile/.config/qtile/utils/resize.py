from __future__ import annotations
from typing import (
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


from libqtile.lazy import lazy

from settings import *  # noqa


@lazy.function
def smart_master_resize(qtile_obj: Qtile, direction: str) -> None:
    lay: Layout = qtile_obj.current_layout
    win = qtile_obj.current_window

    if not win:
        return

    # Only handle layouts with master/stack semantics.
    clients = getattr(lay, "clients", None)

    if not clients:
        return

    clients = list(clients)

    if not clients:
        return

    master = clients[0]
    is_master = win == master

    if direction == "grow":
        # Grow focused side.
        method_names = (
            ("grow", "increase_ratio", "grow_main")
            if is_master
            else ("shrink", "decrease_ratio", "shrink_main")
        )

    elif direction == "shrink":
        # Shrink focused side.
        method_names = (
            ("shrink", "decrease_ratio", "shrink_main")
            if is_master
            else ("grow", "increase_ratio", "grow_main")
        )

    else:
        return

    for method_name in method_names:
        fn = getattr(lay, method_name, None)

        if callable(fn):
            fn()

            try:
                qtile_obj.current_group.layout_all()
            except Exception:
                pass

            return
