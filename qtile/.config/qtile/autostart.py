from __future__ import annotations


from pathlib import Path


from libqtile import hook
from utils.shell import spawn_shell

from settings import *  # noqa


@hook.subscribe.startup_once
def startup_once() -> None:
    home = Path.home()
    spawn_shell(f"{home}/MyScripts/autostart.sh > {home}/.output/autostart.sh")

    # spawnOnOnce approximations. dgroups_app_rules above move the first matching
    # windows to the intended groups/scratchpad.
    # for cmd in [
    #     my_file_manager,
    #     "firefox",
    #     "emacs",
    #     "surf https://web.whatsapp.com/",
    #     "messenger-nativefier",
    #     "discord",
    #     "gnome-pomodoro",
    #     "skypeforlinux",
    # ]:
    #     _spawn_shell(cmd)
