from datetime import datetime
import subprocess

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


def to_clipboard(value: str):
    subprocess.run(
        ["xclip", "-selection", "clipboard"],
        input=value,
        text=True,
        check=True,
    )

    subprocess.run(
        ["notify-send", "Clipboard", f"Copied: {value}"],
        check=False,
    )


@lazy.function
def clip_datetime_stamp(qtile: Qtile):
    stamp = datetime.now().strftime("%y%m%d%H%M%S")
    to_clipboard(stamp)


@lazy.function
def clip_date(qtile: Qtile):
    stamp = datetime.now().strftime("%y%m%d")
    to_clipboard(stamp)
