from __future__ import annotations
from typing import (
    Callable,
    TypeAlias,
    TYPE_CHECKING,
)

if TYPE_CHECKING:
    from libqtile.group import _Group
    from libqtile.layout.base import Layout
    from libqtile.widget.base import _Widget
    from libqtile.core.manager import Qtile
    from libqtile.backend.base import Window

    QtileFunc: TypeAlias = Callable[[Qtile], None]
    WidgetList: TypeAlias = list[_Widget]

from libqtile.lazy import lazy

from settings import *  # noqa
import settings as V


def call_layout_method(qtile_obj: Qtile, method_names: list[str]) -> None:
    """Call the first available method on the current layout."""
    lay: Layout = qtile_obj.current_layout
    for method_name in method_names:
        fn = getattr(lay, method_name, None)
        if callable(fn):
            fn()
            try:
                qtile_obj.current_group.layout_all()
            except Exception:
                pass
            return


@lazy.function
def set_layout(qtile_obj: Qtile, layout_name: str) -> None:
    """Switch current group to a layout by its configured name."""
    group: _Group | None = qtile_obj.current_group
    if not group:
        return
    wanted = layout_name.lower()
    for idx, lay in enumerate(group.layouts):
        if getattr(lay, "name", "").lower() == wanted:
            if hasattr(qtile_obj, "to_layout_index"):
                qtile_obj.to_layout_index(idx)
            elif hasattr(qtile_obj, "cmd_to_layout_index"):
                qtile_obj.cmd_to_layout_index(idx)
            elif hasattr(group, "setlayout"):
                group.setlayout(lay)
            elif hasattr(group, "cmd_setlayout"):
                group.cmd_setlayout(lay)
            return


@lazy.function
def layout_call(qtile_obj: Qtile, *method_names: str) -> None:
    call_layout_method(qtile_obj, method_names)


@lazy.function
def promote_to_master(qtile_obj: Qtile) -> None:
    call_layout_method(qtile_obj, ["swap_main", "client_to_first", "shuffle_up"])


@lazy.function
def focus_master(qtile_obj: Qtile) -> None:
    group: _Group | None = qtile_obj.current_group
    if not group:
        return
    win: Window | None = None
    try:
        win = group.layout.focus_first()
    except Exception:
        pass
    if win is None and group.windows:
        win = group.windows[0]
    if win:
        try:
            group.focus(win, warp=True)
        except TypeError:
            group.focus(win)


@lazy.function
def toggle_floating(qtile_obj: Qtile) -> None:
    """XMonad toggleFloat approximation: sink if floating, else 50% x 55% top-right."""
    win: Window | None = qtile_obj.current_window
    if not win:
        return
    if getattr(win, "floating", False):
        if hasattr(win, "disable_floating"):
            win.disable_floating()
        elif hasattr(win, "toggle_floating"):
            win.toggle_floating()
        return

    screen = qtile_obj.current_screen
    width = int(screen.width * 0.50)
    height = int(screen.height * 0.55)
    x = int(screen.x + screen.width - width - screen.width * 0.01)
    y = int(screen.y + screen.height * 0.01)
    if hasattr(win, "enable_floating"):
        win.enable_floating()
    elif hasattr(win, "toggle_floating"):
        win.toggle_floating()
    if hasattr(win, "set_size_floating"):
        win.set_size_floating(width, height)
    if hasattr(win, "set_position_floating"):
        win.set_position_floating(x, y)


@lazy.function
def sink_all(qtile_obj: Qtile) -> None:
    group: _Group | None = qtile_obj.current_group
    if not group:
        return
    for win in list(group.windows):
        if getattr(win, "floating", False) and hasattr(win, "disable_floating"):
            win.disable_floating()


def _delete_group(qtile_obj: Qtile, group_name: str) -> None:
    if group_name in V.ws_default_names or group_name == V.ws_scratchpad_name:
        return
    if hasattr(qtile_obj, "delete_group"):
        qtile_obj.delete_group(group_name)
    elif hasattr(qtile_obj, "delgroup"):
        qtile_obj.delgroup(group_name)
    elif hasattr(qtile_obj, "cmd_delgroup"):
        qtile_obj.cmd_delgroup(group_name)


@lazy.function
def kill_all(qtile_obj: Qtile) -> None:
    group: _Group | None = qtile_obj.current_group
    if not group:
        return
    for win in list(group.windows):
        try:
            win.kill()
        except Exception:
            pass


@lazy.function
def kill_all_and_remove_group(qtile_obj: Qtile) -> None:
    group: _Group | None = qtile_obj.current_group
    if not group:
        return
    name = group.name
    for win in list(group.windows):
        try:
            win.kill()
        except Exception:
            pass
    _delete_group(qtile_obj, name)


# TODO move
fullscreen_groups: set[str] = set()
previous_layouts: dict[str, int] = {}


def set_bar_visible(qtile_obj: Qtile, visible: bool) -> None:
    screen = qtile_obj.current_screen

    for position in ("top", "bottom", "left", "right"):
        bar_obj = getattr(screen, position, None)
        if bar_obj:
            bar_obj.show(visible)


def get_layout_index(qtile_obj: Qtile, layout_name: str) -> int | None:
    for i, layout_obj in enumerate(qtile_obj.config.layouts):
        if layout_obj.name == layout_name:
            return i
    return None


@lazy.function
def toggle_group_fullscreen(qtile_obj: Qtile) -> None:
    group = qtile_obj.current_group

    max_index = get_layout_index(qtile_obj, "Max")
    if max_index is None:
        return

    if group.name in fullscreen_groups:
        fullscreen_groups.remove(group.name)

        old_index = previous_layouts.pop(group.name, 0)
        group.use_layout(old_index)

        set_bar_visible(qtile_obj, True)

    else:
        fullscreen_groups.add(group.name)

        previous_layouts[group.name] = group.current_layout
        group.use_layout(max_index)

        set_bar_visible(qtile_obj, False)
