import colors

follow_mouse_focus = "click_or_drag_only"
focus_on_window_activation: str = "focus"
bring_front_click: bool = False
cursor_warp: bool = True  # Follow the focus and center the mouse on change
floats_kept_above: bool = True
auto_fullscreen: bool = False
auto_minimize: bool = True
reconfigure_screens: bool = True
focus_previous_on_window_remove: bool = False

active: str = colors.blue
active_warn: str = colors.red
inactive: str = colors.base02
focus_color: str = colors.green
unfocus_color: str = colors.base02

wmname: str = "LG3D"  # old Java compatibility

ws_default_names: list[str] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
ws_scratchpad_name: str = "NSP"

gaps_value: int = 15
gap_enabled: bool = False

border_width: int = 3

my_terminal: str = "urxvt"
my_file_manager: str = "nautilus"

float_classes: list[str] = [
    "Arandr",
    "Galculator",
    "Pavucontrol",
    "Catfish",
    "qt5ct",
    "Blueman-manager",
    "Hamster",
    "Zenity",
]

float_titles: list[str] = [
    "Downloads",
    "Save As...",
    "capture",
    "1 Reminder",
    "Bitwarden",
]
fullscreen_classes: list[str] = ["Xfce4-appfinder"]
