from __future__ import annotations

from libqtile.config import Key, Screen
from libqtile.lazy import lazy
from libqtile.core.manager import Qtile

from settings import *  # noqa
from const import mod, shift


def _screen_index_by_x(qtile: Qtile, pos: int) -> int:
    screens: list[tuple[int, Screen]] = sorted(
        enumerate(qtile.screens),
        key=lambda item: item[1].x,
    )
    return screens[pos][0]


@lazy.function
def focus_screen_by_x(qtile: Qtile, pos: int) -> None:
    qtile.focus_screen(_screen_index_by_x(qtile, pos))


@lazy.function
def move_window_to_screen_by_x(qtile: Qtile, pos: int) -> None:
    if qtile.current_window:
        qtile.current_window.toscreen(_screen_index_by_x(qtile, pos))


def screen_shortcuts() -> list[Key]:
    keys: list[Key] = []

    for key_name, pos in zip(["a", "z", "e"], [0, 1, 2]):
        keys.extend(
            [
                Key(
                    [mod],
                    key_name,
                    focus_screen_by_x(pos),
                ),
                Key(
                    [mod, shift],
                    key_name,
                    move_window_to_screen_by_x(pos),
                ),
            ]
        )

    return keys


keys_screens = screen_shortcuts()
