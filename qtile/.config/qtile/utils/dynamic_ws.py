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


import subprocess
import shutil
import json


from libqtile.lazy import lazy
from libqtile import hook

from config import groups as _config_groups
from settings import *  # noqa

from const import SESSION_FILE

@lazy.function
def create_or_go_dynamic_ws(qtile_obj: Qtile) -> None:
    from libqtile.log_utils import logger

    def goto_group(name: str) -> None:
        name = name.strip()

        if not name:
            return

        if name not in qtile_obj.groups_map:
            qtile_obj.add_group(name=name,
                                persist=True)
            logger.warning("Created group: %s", name)

        qtile_obj.groups_map[name].toscreen()

    # Prefer rofi popup if available
    if shutil.which("rofi"):
        groups = "\n".join(g.name for g in qtile_obj.groups)

        result = subprocess.run(
            ["rofi", "-dmenu", "-p", "Group"],
            input=groups,
            text=True,
            capture_output=True,
        )

        goto_group(result.stdout)

    # Fallback to Qtile Prompt widget
    else:
        prompt = qtile_obj.widgets_map.get("prompt")

        if not prompt:
            logger.error("No rofi installed and no Prompt widget named 'prompt'")
            return

        prompt.start_input(
            "Group name: ",
            goto_group,
        )


@lazy.function
def move_window_to_dynamic_ws(qtile_obj: Qtile) -> None:
    from libqtile.log_utils import logger

    current_window = qtile_obj.current_window

    if current_window is None:
        logger.warning("No current window to move")
        return

    def move_to_group(name: str) -> None:
        name = name.strip()

        if not name:
            return

        if name not in qtile_obj.groups_map:
            qtile_obj.add_group(name=name,
                                persist=True)
            logger.warning("Created group: %s", name)

        current_window.togroup(name)
        qtile_obj.groups_map[name].toscreen()

        logger.warning("Moved window to group: %s", name)

    # Prefer rofi popup if available
    if shutil.which("rofi"):
        groups = "\n".join(g.name for g in qtile_obj.groups)

        result = subprocess.run(
            ["rofi", "-dmenu", "-p", "Move to group"],
            input=groups,
            text=True,
            capture_output=True,
        )

        move_to_group(result.stdout)

    # Fallback to Qtile Prompt widget
    else:
        prompt = qtile_obj.widgets_map.get("prompt")

        if not prompt:
            logger.error("No rofi installed and no Prompt widget named 'prompt'")
            return

        prompt.start_input(
            "Move to group: ",
            move_to_group,
        )

def save_session(qtile_obj: Qtile) -> None:
    from libqtile.log_utils import logger

    static_names = {g.name for g in _config_groups}
    data: dict = {"groups": [], "windows": []}

    for group in qtile_obj.groups:
        if group.name not in static_names:
            data["groups"].append(group.name)

        for window in group.windows:
            try:
                info = window.info()
                data["windows"].append({
                    "wm_class": info.get("wm_class", ""),
                    "name":     info.get("name", ""),
                    "group":    group.name,
                })
            except Exception:
                pass

    with open(SESSION_FILE, "w") as f:
        json.dump(data, f, indent=2)

    logger.warning("Session saved: %d groups, %d windows",
                   len(data["groups"]), len(data["windows"]))


def restore_groups_early() -> None:
    """
    Call from @hook.subscribe.startup — mutates the config groups list
    so dynamic groups exist before Qtile re-adopts windows.
    """
    from libqtile.config import Group
    from libqtile.log_utils import logger

    try:
        with open(SESSION_FILE) as f:
            data = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return

    existing = {g.name for g in _config_groups}
    for name in data.get("groups", []):
        if name not in existing:
            _config_groups.append(Group(name, persist=True))
            logger.warning("Restored group (early): %s", name)


def restore_windows(qtile_obj: Qtile) -> None:
    """
    Call from @hook.subscribe.startup_complete — reassigns windows
    to their saved groups using wm_class + name matching.
    """
    from libqtile.log_utils import logger

    try:
        with open(SESSION_FILE) as f:
            data = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return

    for entry in data.get("windows", []):
        target = entry["group"]
        if target not in qtile_obj.groups_map:
            logger.warning("Group not found for window: %s", target)
            continue

        for window in qtile_obj.windows_map.values():
            try:
                info = window.info()
                if (info.get("wm_class") == entry["wm_class"]
                        and info.get("name") == entry["name"]):
                    window.togroup(target)
                    logger.warning("Restored window '%s' → %s",
                                   entry["name"], target)
                    break
            except Exception:
                pass

    # Sweep up any remaining orphaned windows (no group → dump to first group)
    fallback = qtile_obj.groups[0].name
    for window in qtile_obj.windows_map.values():
        try:
            if window.group is None:
                window.togroup(fallback)
                logger.warning("Orphaned window moved to fallback group: %s", fallback)
        except Exception:
            pass




@hook.subscribe.restart
def on_restart():
    from libqtile import qtile
    save_session(qtile)


@hook.subscribe.startup
def on_startup():
    restore_groups_early()



@hook.subscribe.client_new
def on_startup_complete(_):
    from libqtile import qtile
    restore_windows(qtile)
