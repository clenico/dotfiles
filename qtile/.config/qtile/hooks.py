from __future__ import annotations

import subprocess
import os

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


@hook.subscribe.client_killed
def focus_previous_window(client):
    """Focus the previous window in the group when a window is closed."""
    group = client.group
    if not group:
        return

    windows = group.windows
    if len(windows) < 2:
        return

    focused = group.current_window

    if focused not in windows:
        group.focus(windows[-1], warp=False)
        return

    idx = windows.index(focused)
    previous = windows[idx + 1]

    group.focus(previous, warp=False)

@hook.subscribe.startup_once
def start_once():
    subprocess.call(os.path.expanduser("~/MyScripts/autostart.sh"))

    import os
    import subprocess

    os.environ["XDG_SESSION_TYPE"] = "x11"
    os.environ.pop("WAYLAND_DISPLAY", None)
    os.environ["QT_QPA_PLATFORM"] = "xcb"
    os.environ["GDK_BACKEND"] = "x11"

    subprocess.run([
        "systemctl", "--user", "import-environment",
        "XDG_SESSION_TYPE", "DISPLAY", "QT_QPA_PLATFORM", "GDK_BACKEND"
    ])
    subprocess.run([
        "dbus-update-activation-environment", "--systemd",
        "XDG_SESSION_TYPE", "DISPLAY", "QT_QPA_PLATFORM", "GDK_BACKEND"
    ])

