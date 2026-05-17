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


from libqtile.lazy import lazy

import settings as V


@lazy.function
def toggle_gaps(qtile_obj: Qtile) -> None:
    """Approximate XMonad spacing toggles by changing layout margins."""
    V.gap_enabled = not V.gap_enabled
    margin = V.gaps_value if V.gap_enabled else 0
    for group in qtile_obj.groups:
        for lay in getattr(group, "layouts", []):
            if hasattr(lay, "margin"):
                lay.margin = margin
            if hasattr(lay, "single_margin"):
                lay.single_margin = 0
            if hasattr(lay, "margin_on_single"):
                lay.margin_on_single = 0
    try:
        qtile_obj.current_group.layout_all()
    except Exception:
        pass
