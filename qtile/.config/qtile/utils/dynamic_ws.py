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


from libqtile.lazy import lazy

from settings import *  # noqa


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
