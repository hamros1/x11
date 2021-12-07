struct xcb_extension_t
	name : Char*
	global_id : Int32
end

struct xcb_protocol_request_t
	count : LibC::SizeT
	ext : xcb_extension_t*
	opcode : UInt8
	isvoid : UInt8
end

XCB_REQUEST_CHECKED = (1 << 0)
XCB_REQUEST_RAW = (1 << 1)
XCB_REQUEST_DISCARD_REPLY = (1 << 2)
XCB_REQUEST_REPLY_FDS = (1 << 3)

fun xcb_send_request(x0 : xcb_connection_t, x1 : Int32 , x2 : iovec*, x3 : xcb_protocol_request_t*) : UInt32

fun xcb_send_request_with_fds(x0 : xcb_connection_t, x1 : Int32, x2 : iovec*, x3 : xcb_protocol_request_t*, x4 : UInt32, x5 : Int32*) : UInt32

fun xcb_send_request64(x0 : xcb_connection_t, x1 : Int32, x2 : iovec*, x3 : xcb_protocol_request_t*) : UInt64

fun xcb_send_request_with_fds64(x0 : xcb_connection_t*, x1 : Int32, x2 : iovec*, x3 : xcb_protocol_request_t*, x4 : UInt32, x5 : Int32*) : UInt64

fun xcb_send_fd(x0 : xcb_connection_t*, x1 : Int32) : Void

fun xcb_writev(x0 : xcb_connect_t*, x1 : iovec*, x2 : UInt64) : Int32

fun xcb_wait_for_reply(x0 : xcb_connection_t*, x1 : UInt32, x2 : xcb_generic_error_t**)

fun xcb_poll_for_reply(x0 : xcb_connection_t*, x1 : UInt32, x2 : Void**, x3 : xcb_generic_error_t**) : Int32

fun xcb_poll_for_reply64(x0 : xcb_connection_t*, x1 : UInt64, x2 : Void**, x3 : xcb_generic_error_t**) : Int32

fun xcb_get_reply_fds(x0 : xcb_connection_t*, x1 : Void*, x2 : LibC::SizeT) : Int32*

fun xcb_popcount(x0 : UInt32)

fun xcb_sumof(x0 : UInt8*, x1 : Int32) : Int32
