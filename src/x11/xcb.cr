lib XCB
	X_PROTOCOL = 11
	X_PROTOCOL_REVISION = 0
	X_TCP_PORT = 6000
	XCB_CONN_ERROR = 1
	XCB_CONN_CLOSED_EXT_NOTSUPPORTED = 2
	XCB_CONN_CLOSED_MEM_INSUFFICIENT = 3
	XCB_CONN_CLOSED_REQ_LEN_EXCEED = 4
	XCB_CONN_CLOSED_PARSE_ERR = 5
	XCB_CONN_CLOSED_INVALID_SCREEN = 6
	XCB_CONN_CLOSED_FDPASSING_FAILED = 7
	
	macro XCB_TYPE_PAD(t, i)
		(-(i) & sizeof t > 4 ? 3 : sizeof t - 1
	end

	type xcb_connection_ t = Void*

	struct xcb_generic_iterator_t
		data = Void*
		rem = Int32
		index = Int32
	end

	struct xcb_generic_reply_t
		response_type : UInt8
		pad0 : UInt8
		sequence : UInt16
		length : UInt32
	end

	struct xcb_generic_event_t
		response_type : UInt8
		pad0 : UInt8
		sequence : UInt16
		pad : UInt32[7]
		full_sequence : UInt32
	end

	struct xcb_raw_generic_event_t
		response_type : UInt8
		pad0 : UInt8
		sequence : UInt16
		pad : UInt32[7]
	end

	struct xcb_ge_event_t
		reponse_type : UInt8
		pad0 : UInt8
		sequence : UInt16
		length : UInt32
		event_type : UInt16
		pad1 : UInt16
		pad : UInt32
		full_sequence : UInt32
	end

	struct xcb_generic_error_t
		response_type : UInt8 
		error_code : UInt8
		sequence : UInt16
		resource_id : UInt32
		minor_code :  UInt16
		major_code : UInt8
		pad0 : UInt8
		pad : UInt32[5]
		full_sequence : UInt32
	end

	struct xcb_void_cookie_t
		sequence : UInt
	end

	XCB_NONE = 0_i64
	XCB_COPY_FROM_PARENT = 0_i64
	XCB_CURRENT_TIME = 0_i64
	XCB_NO_SYMBOL = 0_i64

	struct xcb_auth_info
		namelen : Int32
		name : Char*
		datalen : Int32
		data : Char*
	end

	fun xcb_flush(x0 : xcb_connection_t*) : Int32

	fun xcb_get_maximum_request_length(x0 : xcb_connection_t*) : UInt32

	fun xcb_prefetch_maximum_request_length(x0 : xcb_connection_t*) : Void

	fun xcb_wait_for_event(x0 : xcb_connection_t*) : xcb_generic_event_t*

	fun xcb_poll_for_event(x0 : xcb_connection_t*) : xcb_generic_event_t*

	fun xcb_poll_for_queued_event(x0 : xcb_connection_t*) : xcb_generic_event_t*

	type xcb_special_event_t = Void*

	fun xcb_poll_for_special_event(x0 : xcb_connection_t*, x1 : xcb_special_event_t*) : xcb_generic_event_t*

	fun xcb_wait_for_special_event(x0 : xcb_connection_t*, x1 : xcb_speciaĺ_event*) : xcb_generic_event_t*

	fun xcb_register_for_special_xge(x0 : xcb_connection_t*, x1 : xcb_extension_t*, x2 : UInt32, x3 : UInt32*) : xcb_special_event_t*

	fun xcb_unregister_for_special_event(x0 : xcb_connection_t*, x1 : xcb_special_event_t*) : Void

	fun xcb_request_check(x0 : xcb_connection_t*, x1 : xcb_void_cookie_t*) : xcb_generic_error_t

	fun xcb_discard_reply(x0 : xcb_connection_t*, x1 : UInt32) : Void

	fun xcb_discard_reply64(x0 : xcb_connection_t*, x1 : UInt64) : Void

	type xcb_query_extension_reply_t = Pointer(xcb_get_extension_data(x0 : xcb_connection_t*, x1 : xcb_extension_t*))

	fun xcb_prefetch_extension_data(x0 : xcb_connection_t*, x1 : xcb_extension_t*) : Void

	type xcb_setup_t = Pointer(xcb_get_setup(x0 : xcb_connection_t*)

	fun xcb_get_file_descriptor(x0 : xcb_connection_t*) : Int32

	fun xcb_connection_has_error(x0 : xcb_connection_t*) : Int32

	fun xcb_connect_to_fd(x0 : Int32, x1 : xcb_auth_info*) : xcb_connection_t*

	fun xcb_disconnect(x0 : xcb_connection_t*) : Void

	fun xcb_parse_display(x0 : Char*, x1 : Char**, x2 : Int32*, x3 : Int32*) : Int32

	fun xcb_connect(x0 : Char*, x1 : Char*) : xcb_connection_t*

	fun xcb_connect_to_display_with_auth_info(x0 : Char*, x1 : xcb_auth_info, x2 : Int32*) : xcb_connection_t*

	fun xcb_generate_id(x0 : xcb_connection_t*) : UInt32
end
