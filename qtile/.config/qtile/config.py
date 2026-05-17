from __future__ import annotations


from settings import *  # noqa
from screens import screens
import hooks

from layouts import layouts, floating_layout
from mouse import mouse
from groups import groups, dgroups_app_rules
from keys import keys


screens  # needs to be imported in config.py
layouts  # needs to be imported in config.py
mouse  # needs to be imported in config.py
groups  # needs to be imported in config.py
floating_layout  # needs to be imported in config.py
dgroups_app_rules  # needs to be imported in config.py
keys  # needs to be imported in config.py
hooks


widget_defaults: dict[str, str | int] = dict(
    font="Ubuntu",
    fontsize=25,
    padding=4,
    background="#282c34",
    foreground="#bbc2cf",
)

extension_defaults = widget_defaults.copy()
