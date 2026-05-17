from __future__ import annotations


from libqtile.config import (
    Group,
    ScratchPad,
    Match,
    Rule,
)

import settings as V

from scratchpads import scratchpads


groups: list[Group | ScratchPad] = [Group(name) for name in V.ws_default_names] + [
    scratchpads
]

dgroups_app_rules: list[Rule] = [
    Rule(
        Match(wm_class="Mail"),
        group="10",
    ),
]


__all__ = ["groups", "dgroups_app_rules"]
