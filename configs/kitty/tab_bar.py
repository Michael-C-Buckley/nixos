"""
Based Largely on: https://github.com/megalithic/dotfiles/blob/817939c310b6e63f3995e20ede8e05d4edba3460/config/kitty/tab_bar.py
Adapted for my own use, may be drifting over time
"""
from datetime import datetime, timezone

from kitty.fast_data_types import Screen
from kitty.rgb import Color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)
from kitty.utils import color_as_int

timer_id = None

RIGHT_MARGIN = 1
REFRESH_TIME = 15

bat_text_color = as_rgb(0x999F93)
clock_color = as_rgb(0x7FBBB3)
sep_color = as_rgb(0x999F93)
utc_color = as_rgb(color_as_int(Color(113, 115, 116)))


def calc_draw_spaces(*args) -> int:
    length = 0
    for i in args:
        if not isinstance(i, str):
            i = str(i)
        length += len(i)
    return length


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    draw_title(draw_data, screen, tab, index)
    trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
    max_title_length -= trailing_spaces
    extra = screen.cursor.x - before - max_title_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")
    if trailing_spaces:
        screen.draw(" " * trailing_spaces)
    end = screen.cursor.x
    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = 0
    return end

def _draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return 0

    draw_attributed_string(Formatter.reset, screen)

    clock = datetime.now().strftime("%H:%M")
    utc = datetime.now(timezone.utc).strftime(" (UTC %H:%M)")

    cells = []

    cells.append((clock_color, clock))
    cells.append((utc_color, utc))

    right_status_length = RIGHT_MARGIN
    for cell in cells:
        right_status_length += len(str(cell[1]))

    draw_spaces = screen.columns - screen.cursor.x - right_status_length

    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    screen.cursor.fg = 0
    for color, status in cells:
        screen.cursor.fg = color  # as_rgb(color_as_int(color))
        screen.draw(status)
    screen.cursor.bg = 0

    if screen.columns - screen.cursor.x > right_status_length:
        screen.cursor.x = screen.columns - right_status_length

    return screen.cursor.x


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:

    _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    _draw_right_status(
        screen,
        is_last,
    )

    return screen.cursor.x
