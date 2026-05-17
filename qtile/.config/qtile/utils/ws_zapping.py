from __future__ import annotations
from typing import (
    Callable,
    TypeAlias,
    TYPE_CHECKING,
)

if TYPE_CHECKING:
    from libqtile.group import _Group
    from libqtile.widget.base import _Widget
    from libqtile.core.manager import Qtile

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]


from libqtile.lazy import lazy

import settings as V


@lazy.function
def next_non_empty_group(qtile_obj: Qtile) -> None:
    groups: list[_Group] = [
        g for g in qtile_obj.groups if g.name != V.ws_scratchpad_name
    ]

    if not groups:
        return

    current = qtile_obj.current_group
    start = groups.index(current) if current in groups else 0

    for offset in range(1, len(groups) + 1):
        group = groups[(start + offset) % len(groups)]

        if group.windows and not group.screen:
            group.toscreen()
            return


@lazy.function
def prev_non_empty_group(qtile_obj: Qtile) -> None:
    groups: list[_Group] = [
        g for g in qtile_obj.groups if g.name != V.ws_scratchpad_name
    ]

    if not groups:
        return

    current = qtile_obj.current_group
    start = groups.index(current) if current in groups else 0

    for offset in range(1, len(groups) + 1):
        group = groups[(start - offset) % len(groups)]

        if group.windows and not group.screen:
            group.toscreen()
            return
