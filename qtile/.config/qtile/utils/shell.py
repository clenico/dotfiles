import os
import subprocess


def spawn_shell(cmd: str, cwd: str | None = None) -> None:
    """Spawn via /bin/sh; used where XMonad's spawn relied on shell syntax."""
    subprocess.Popen(cmd, shell=True, cwd=os.path.expanduser(cwd) if cwd else None)
