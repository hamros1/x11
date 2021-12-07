fun x_con_init(x0 : Con*) : Void
fun x_move_win(x0 : Con*, x1 : Con*) : Void
fun x_reparent_child(x0 : Con*, x1 : Con*) : Void
fun x_reinit(x0 : Con*) : Void
fun x_con_kill(x0 : Con*) : Void
fun x_con_reframe(x0 : Con*) : Void
fun window_supports_protocol(x0 : xcb_window_t, x1 : xcb_atom_t) : Bool
fun x_window_kill(x0 : xcb_window_t, x1 : kill_window_t) : Void
fun x_draw_decoration(x0 : Con*) : Void
fun x_deco_recurse(x0 : Con*) : Void
fun x_push_node(x0 : Con*) : Void
fun x_push_changes(x0 : Con*) : Void
fun x_raise_con(x0 : Con*) : Void
fun x_set_name(x0 : Con*, x1 : LibC::Char*) : Void
fun update_shmlog_atom(x0 : Void) : Void
fun x_set_warp_to(x0 : Rect)
fun x_mask_event_mask(x0 : LibC::UInt32)
fun x_set_shape(x0 : Con*, x1 : xcb_shape_sk_t, x2 : Bool) : Void

