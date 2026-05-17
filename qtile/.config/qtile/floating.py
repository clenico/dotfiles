from libqtile.config import DropDown, Match

__all__ = ["thirdscreen_dropdown", "fullscreen_dropdown"]


def thirdscreen_dropdown(name: str, cmd: str, match: Match | None = None) -> DropDown:
    return DropDown(
        name,
        cmd,
        x=0.05,
        y=0.05,
        width=0.90,
        height=0.90,
        opacity=1.0,
        on_focus_lost_hide=False,
        warp_pointer=False,
        match=match,
    )


def fullscreen_dropdown(name: str, cmd: str, match: Match | None = None) -> DropDown:
    return DropDown(
        name,
        cmd,
        x=0.0,
        y=0.0,
        width=1.0,
        height=1.0,
        opacity=1.0,
        on_focus_lost_hide=False,
        warp_pointer=False,
        match=match,
    )
