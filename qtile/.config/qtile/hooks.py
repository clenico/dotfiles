from __future__ import annotations


from libqtile import hook
from libqtile.backend.base import Window

import settings as V


@hook.subscribe.client_managed
def client_managed(win: Window) -> None:
    # TODO

    # Fetch the window's classes
    try:
        classes = win.get_wm_class() or []
    except Exception:
        try:
            classes = win.window.get_wm_class() or []
        except Exception:
            classes: list[str] = []
    if isinstance(classes, str):
        classes = [classes]

    if any(c in V.fullscreen_classes for c in classes):
        try:
            win.enable_fullscreen()
        except Exception:
            pass
