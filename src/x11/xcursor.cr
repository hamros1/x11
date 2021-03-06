XCURSOR_CURSOR_POINTER = 0
XCURSOR_CURSOR_RESIZE_HORIZONTAL = 1
XCURSOR_CURSOR_RESIZE_VERTICAL = 2
XCURSOR_CURSOR_TOP_LEFT_CORNER = 3
XCURSOR_CURSOR_TOP_RIGHT_CORNER = 4
XCURSOR_CURSOR_BOTTOM_LEFT_CORNER = 5
XCURSOR_CURSOR_BOTTOM_RIGHT_CORNER = 6
XCURSOR_CURSOR_WATCH = 7
XCURSOR_CURSOR_MOVE = 8
XCURSOR_CURSOR_MAX = 9

fun xcursor_load_cursors(x0 : Void) : Void
fun xcursor_get_cursor(x0 : xcursor_cursor_t) : xcb_cursor_t
fun xcursor_set_root_cursor(x0 : LibC::Int32) : Void
