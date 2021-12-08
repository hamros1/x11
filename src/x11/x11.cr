@[Link("X11")]
lib LibX11
	alias Pointer = LibC::Char*
	alias Status = Int32

	alias Bool = Int32
	True = 1
	False = 0

	alias QueueMode = Int32

	QueuedAlready = 0
	QueuedAfterReading = 1
	QueuedAfterFlush = 2

	alias Window = LibC::ULong
	alias Drawable = LibC::ULong
	alias Font = LibC::ULong
	alias Pixmap = LibC::ULong
	alias Cursor = LibC::ULong
	alias Colormap = LibC::ULong
	alias GContext = LibC::ULong
	alias KeySym = LibC::ULong
	alias KeyCode = LibC::UChar

	NoEventMask = 0
	KeyPressMask = (1<<0)
	KeyReleaseMask = (1<<1)
	ButtonPressMask = (1<<2)
	ButtonReleaseMask = (1<<3)
	EnterWindowMask = (1<<4)
	LeaveWindowMask = (1<<5)
	PointerMotionMask = (1<<6)
	PointerMotionHintMask = (1<<7)
	Button1MotionMask = (1<<8)
	Button2Motionmask = (1<<9)
	Button3MotionMask = (1<<10)
	Button4MotionMask = (1<<11)
	Button5MotionMask = (1<<12)
	ButtonMotionMask = (1<<13)
	KeymapStateMask = (1<<14)
	ExposureMask = (1<<15)
	VisibilityChange = (1<<16)
	StructureNotifiyMask = (1<<17)
	ResizeRedirectMask = (1<<18)
	SubstructureNotifyMask = (1<<19)
	SubstructureRedirectMask = (1<<20)
	FocusChangeMask = (1<<21)
	PropertyChangeMask = (1<<22)
	ColormapChangeMask = (1<<23)
	OwnerGrabButtonMask = (1<<24)

	KeyPress = 2
	KeyRelease = 3
	ButtonPress = 4
	ButtonRelease = 5
	MotionNotify = 6
	EnterNotify = 7
	LeaveNotify = 8
	FocusIn = 9
	FocusOut = 10
	KeymapNotify = 11
	Expose = 12
	GraphicsExpose = 13
	NoExpose = 14
	VisibilityNotify = 15
	CreateNotify = 16
	DestroyNotify = 17
	UnmapNotify = 18
	MapNotify = 19
	MapRequest = 20
	RaparentNotify = 21
	ConfigureNotify = 22
	ConfigureRequest = 23
	GravityNotify = 24
	ResizeRequest = 25
	CirculateNotify = 26
	CirculateRequest = 27
	PropertyNotify = 28
	SelectionClear = 29
	SelectionRequest = 30
	SelectionNotify = 31
	ColormapNotify = 32
	ClientMessage = 33
	MappingNotify = 34
	GenericEvent = 35
	LASTEVENT = 36

	ShiftMask = (1<<0)
	LockMask = (1<<1)
	ControlMask = (1<<2)
	Mod1Mask = (1<<3)
	Mod2Mask = (1<<4)
	Mod3Mask = (1<<5)
	Mod4Mask = (1<<6)
	Mod5Mask = (1<<7)

	ShiftMapIndex = 0
	LockMapIndex = 1
	ControlMapIndex = 2
	Mod1MapIndex = 3
	Mod2MapIndex = 4
	Mod4MapIndex = 5
	Mod5MapIndex = 6

	Button1Mask = (1<<8)
	Button2Mask = (1<<9)
	Botton3Mask = (1<<10)
	Button4Mask = (1<<11)
	Button5Mask = (1<<12)

	AnyModifer = (1<<15)

	Button1 = 1
	Button2 = 2
	Button3 = 3
	Button4 = 4
	Button5 = 5

	NotifyNormal = 0
	NotifyGrab = 1
	NotifyUngrab = 2
	NotifyWhileGrabbed = 3

	NotifyHint = 1

	NotifyAncestor = 0
	NotifyVirtual = 1
	NotifyInferior = 2
	NotifyNonlinear = 3
	NotifyNonlinearVirtual = 4
	NotifyPointer = 5
	NotifyPointerRoot = 6
	NotifyDetailNone = 7

	VisibilityUnobscured = 0
	VisibilityPartiallyObscured = 1
	VisiblityFullyObscured = 2

	PlaceOnTop = 0
	PlaceOnBottom = 1

	FamilyInternet = 0
	FamilyDECnet = 1
	FamilyChaos = 2
	FamilyInternet6 = 6

	FamilyServerInterpreted = 5

	PropertyNewValue = 0
	PropertyDelete = 1

	ColormapUninstalled = 0
	ColormapInstalled = 1

	GrabModeSync = 0
	GrabModeAsync = 1

	GrabSuccess = 0
	AlreadyGrabbed = 1
	GrabInvalidTime = 2
	GrabNotViewable = 3
	GrabFrozen = 4

	AsyncPointer = 0
	SyncPointer = 1
	ReplayPointer = 2
	AsyncKeyboard = 3
	SyncKeyboard = 4
	ReplayKeyboard = 5
	AsyncBoth = 6
	SyncBoth = 7

	Success = 0
	BadRequest = 1
	BadValue = 2
	BadWindow = 3
	BadPixmap = 4
	BadAtom = 5
	BadCursor = 6
	BadFont = 7
	BadMatch = 8
	BadDrawable = 9
	BadAccess = 10
	BadAlloc = 11
	BadColor = 12
	BadGC = 13
	BadIDChoice = 14
	BadName = 15
	BadLength = 16
	BadImplementation = 17
	FirstExtensionError = 128
	LastExtensionError = 255

	InputOutput = 1
	InputOnly = 2

	CWBackPixmap = (1<<0)
	CWBackPixel = (1<<1)
	CWBorderPixmap = (1<<2)
	CWBorderPixel = (1<<3)
	CWBitGravity = (1<<4)
	CWWinGravity = (1<<5)
	CWBackingStore = (1<<6)
	CWBackingPlanes = (1<<7)
	CWBackingPixel = (1<<8)
	CWOverrideDirect = (1<<9)
	CWSaveUnder = (1<<10)
	CWEventMask = (1<<11)
	CWDontPropagate = (1<<12)
	CWColormap = (1<<13)
	CWCursor = (1<<14)

	CWX = (1<<0)
	CWY = (1<<1)
	CWWidth = (1<<2)
	CWHeight = (1<<3)
	CWBorderWidth = (1<<4)
	CWSibling = (1<<5)
	CWStackMode = (1<<6)

	ForgetGravity = 0
	NorthWestGravity = 1
	NorthGravity = 2
	NorthEastGravity = 3
	WestGravity = 4
	CenterGravity = 5
	EastGravity = 6
	SouthWestGravity = 7
	SouthGravity = 8
	SouthEastGravity = 9
	StaticGravity = 10

	UnmapGravity = 0

	NotUseful = 0
	WhenMapped = 1
	Always = 2

	IsUnmapped = 0
	IsUnviewable = 1
	IsViewable = 2

	SetModeInsert = 0
	SetModeDelete = 1

	DestroyAll = 0
	RetainPermanent = 1
	RetainTemporary = 2

	Above = 0
	Below = 1
	TopIf = 2
	BottomIf = 3
	Opposite = 4

	RaiseLowest = 0
	LowerHighest = 1

	PropModeReplace = 0
	PropModePrepend = 1
	PropModeAppend = 2

	GXclear = 0x0
	GXand = 0x1
	GXandReverse = 0x2
	GXcopy = 0x3
	GXandInverted = 0x4
	GXnoop = 0x5
	GXxor = 0x6
	GXor = 0x7
	GXnor = 0x8
	GXequiv = 0x9
	GXinvert = 0xa
	GXorReverse = 0xb
	GXcopyInverted = 0xc
	GXorInverted = 0xd
	GXnand = 0xe
	GXset = 0xf

	LineSolid = 0
	LineOnOffDash = 1
	LineDoubleDash = 2

	CapNotLast = 0
	CapButt = 1
	CapRound = 2
	CapProjecting = 3

	JoinMiter = 0
	JoinRound = 1
	JoinBevel = 2

	FillSolid = 0
	FillTiled = 1
	FillStippled = 2
	FillOpaqueStippled = 3

	EvenOddRule = 0
	WindingRule = 1

	ClipByChildren = 0
	IncludeInferiors = 1

	Unsorted = 0
	YSorted = 1
	YXSorted = 2
	YXBanded = 3

	CoordModeOrigin = 0
	CoordModePrevious = 1

	Complex = 0
	Nonconvex = 1
	Convex = 2

	ArcChord = 0
	ArcPieSlice = 1

	GCFunction = (1<<0)
	GCPlaneMask = (1<<1)
	GCForeground = (1<<2)
	GCBackground = (1<<3)
	GCLineWidth = (1<<4)
	GCLineStyle = (1<<5)
	GCCapStyle = (1<<6)
	GCJoinStyle = (1<<7)
	GCFillStyle = (1<<8)
	GCFillRule = (1<<9)
	GCTile = (1<<10)
	GCStipple = (1<<11)
	GCTileStipXOrigin = (1<<12)
	GCTileStipYOrigin = (1<<13)
	GCFont = (1<<14)
	GCSubwindowMode = (1<<15)
	GCGraphicsExposures = (1<<16)
	GCClipXOrigin = (1<<17)
	GCClipYOrigin = (1<<18)
	GCClipMask = (1<<19)
	GCDashOffset = (1<<20)
	GCDashList = (1<<21)
	GCArcMode = (1<<22)
	GCLastBit = 22

	FontLeftToRight = 0
	FontRightToLeft = 1
	FontChange = 255

	XYBitmap = 0
	XYPixmap = 1
	ZPixmap = 2

	AllocNone = 0
	AllocAll = 1

	DoRed = (1<<0)
	DoGreen = (1<<1)
	DoBlue = (1<<2)

	CursorShape = 0
	TileShape = 1
	StippleShape = 2

	AutoRepeatModeOff = 0
	AutoRepeatModeOn = 1
	AutoRepeatModeDefault = 2

	LedModeOff = 0
	LedModeOn = 1

	KBKeyClikcPercent = (1<<0)
	KBBellPercent = (1<<1)
	KBBellPitch = (1<<2)
	KBBellDuration = (1<<3)
	KBLed = (1<<4)
	KBLedMode = (1<<5)
	KBKey = (1<<6)
	KBAutoRepeatMode = (1<<7)

	MappingSuccess = 0
	MappingBusy = 1
	MappingFailed = 2

	MappingModifier = 0
	MappingKeyboard = 1
	MappingPointer = 2

	DontPreferBlanking = 0
	PreferBlanking = 1
	DefaultBlanking = 2

	DisableScreenSaver = 0
	DisableScreenInterval = 0

	DontAllowExposures = 0
	AllowExposures = 1
	DefaultExposures = 2

	ScreenSaverReset = 0
	ScreenSaverActive = 1

	HostInsert = 0
	HostDelete = 1

	EnableAccess = 1
	DisableAccess = 0

	StaticGray = 0
	GrayScale = 1
	StaticColor = 2
	PseudoColor = 3
	TrueColor = 4
	DirectColor = 5

	LSBFirst = 0
	MSBFirst = 1

	struct ExtData
		number : LibC::Int
		next : ExtData*
		free_private : (ExtData* -> LibC::Int)
		private_data : Pointer
	end

	struct ExtCodes
		extension : LibC::Int
		major_opcode : LibC::Int
		first_event : LibC::Int
		first_error : LibC::Int
	end

	struct PixmapFormatValues
		depth : LibC::Int
		bits_per_pixel : LibC::Int
		scanline_pad : LibC::Int
	end

	struct GCValues
		function : LibC::Int
		plane_mask : LibC::ULong
		foreground : LibC::ULong
		background : LibC::ULong
		line_width : LibC::Int
		line_style : LibC::Int
		cap_style : LibC::Int

		join_style : LibC::Int
		fill_style : LibC::Int

		fill_rule : LibC::Int
		arc_mode : LibC::Int
		tile : Pixmap
		stipple : Pixmap
		ts_x_origin : LibC::Int
		ts_y_origin : LibC::Int
		font : Font
		subwindow_mode : LibC::Int
		graphics_exposures : Bool
		clip_x_origin : LibC::Int
		clip_y_origin : LibC::Int
		clip_mask : Pixmap
		dash_offset : LibC::Int
		dashes : LibC::Char
	end

	struct GC
		ext_data : ExtData*
		gid : GContext
	end

	struct Visual
		ext_data : ExtData*
		visualid : LibC::ULong
		c_class : LibC::Int
		red_mask, green_mask, blue_mask : LibC::ULong
		bits_per_rgb : LibC::Int
		map_entries : LibC::Int
	end

	struct Depth
		depth : LibC::Int
		nvisuals : LibC::Int
		visuals : Visual*
	end

	struct Screen
		ext_data : ExtData*
		display : Display*
		root : Window
		width, height : LibC::Int
		mwidth, mheight : LibC::Int
		ndepths : LibC::Int
		depths : Depth*
		root_depth : LibC::Int
		root_visual : Visual*
		default_gc : GC
		cmap : Colormap
		white_pixel : LibC::ULong
		black_pixel : LibC::ULong
		max_maps, min_maps : LibC::Int
		backing_store : LibC::Int
		save_unders : Bool
		root_input_mask : LibC::Long
	end

	struct ScreenFormat
		ext_data : ExtData*
		depth : LibC::Int
		bits_per_pixel : LibC::Int
		scanline_pad : LibC::Int
	end

	struct SetWindowAttributes
		background_pixmap : Pixmap
		background_pixel : LibC::ULong
		border_pixmap : Pixmap
		border_pixel : LibC::ULong
		bit_gravity : LibC::Int
		win_gravity : LibC::Int
		backing_store : LibC::Int
		backing_planes : LibC::ULong
		backing_pixel : LibC::ULong
		save_under : Bool
		event_mask : LibC::Long
		do_not_propagate_mask : LibC::Long
		override_direct : Bool
		colormap : Colormap
		cursor : Cursor
	end

	struct WindowAttributes
		x, y : LibC::Int
		width, height : LibC::Int
		border_width : LibC::Int
		depth : LibC::Int
		visual : Visual*
		root : Window
		c_class : LibC::Int
		bit_gravity : LibC::Int
		win_gravity : LibC::Int
		backing_store : LibC::Int
		backing_planes : LibC::ULong
		backing_pixel : LibC::ULong
		save_under : Bool
		colormap : Colormap
		map_installed : Bool
		map_state : LibC::Int
		all_event_masks : LibC::Long
		your_event_mask : LibC::Long
		do_not_propagate_mask : LibC::Long
		override_direct : Bool
		screen : Screen*
	end

	struct HostAddress
		family : LibC::Int
		length : LibC::Int
		address : LibC::Char*
	end

	struct ServerInterpretedAddress
		typelength : LibC::Int
		valuelength : LibC::Int
		type : LibC::Char*
		value : LibC::Char*
	end

	struct Image
		width, height : LibC::Int
		xoffset : LibC::Int
		format : LibC::Int
		data : LibC::Char*
		byte_order : LibC::Int
		bitmap_unit : LibC::Int
		bitmap_bit_order : LibC::Int
		bitmap_pad : LibC::Int
		depth : LibC::Int
		bytes_per_line : LibC::Int
		bits_per_pixel : LibC::Int
		red_mask, green_mask, blue_mask : LibC::ULong
		obdata : Pointer
		f : ImageFuncs
	end

	struct ImageFuncs
		create_image : (Display*, Visual*, LibC::UInt, LibC::Int, LibC::Int, LibC::Char*, LibC::UInt, LibC::UInt, LibC::Int, LibC::Int -> Image*)
		destroy_image : (Image* -> LibC::Int)
		get_pixel : (Image*, LibC::Int, LibC::Int -> LibC::ULong)
		put_pixel : (Image*, LibC::Int, LibC::Int, LibC::ULong -> LibC::Int)
		sub_image : (Image*, LibC::Int, LibC::Int, LibC::UInt, LibC::UInt -> Image*)
		add_pixel : (Image*, LibC::Long -> LibC::Int)
	end

	struct WindowChanges
		x, y : LibC::Int
		width, height : LibC::Int
		border_width : LibC::Int
		sibling : Window
		stack_mode : LibC::Int
	end

	struct Color
		pixel : LibC::ULong
		red, green, blue : LibC::UShort
		flags : LibC::Char
		pad : LibC::Char
	end

	struct Segment
		x1, y1, x2, y2 : LibC::Short
	end

	struct Point
		x, y : LibC::Short
	end

	struct Rectangle
		x, y : LibC::Short
		width, height : LibC::UShort
	end

	struct Arc
		x, y : LibC::Short
		width, height : LibC::UShort
		angle1, angle2 : LibC::Short
	end

	struct KeyboardControl
		key_click_percent : LibC::Int
		bell_percent : LibC::Int
		bell_pitch : LibC::Int
		bell_duration : LibC::Int
		led : LibC::Int
		led_mode : LibC::Int
		key : LibC::Int
		auto_repeat_mode : LibC::Int
	end

	struct KeyboardState
		key_click_percent : LibC::Int
		bell_percent : LibC::Int
		bell_pitch, bell_duration : LibC::UInt
		led_mask : LibC::ULong
		global_auto_repeat : LibC::Int
		auto_repeats : LibC::Char[32]
	end

	struct TimeCoord
		time : LibC::ULong
		x, y : LibC::Short
	end

	struct ModifierKeymap
		max_keypermod : LibC::Int
		modifiermap : KeyCode
	end

	type Private = Pointer
	type RmHashBucketRec = Pointer

	struct Display
		ext_data : ExtData*
		private1 : LibC::Char*
		fd : LibC::Int
		private2 : LibC::Int
		proto_major_version : LibC::Int
		proto_minor_version : LibC::Int
		vendor : LibC::Char*
		private3 : LibC::ULong
		private4 : LibC::ULong
		private5 : LibC::ULong
		private6 : LibC::Int
		resource_alloc : Display* -> LibC::ULong
		byte_order : LibC::Int
		bitmap_unit : LibC::Int
		bitmap_pad : LibC::Int
		bitmap_bit_order : LibC::Int
		nformats : LibC::Int
		pixmap_format : ScreenFormat*
		private8 : LibC::Int
		release : LibC::Int
		private9, private10 : LibC::Char*
			qlen : LibC::Int
		last_request_read : LibC::ULong
		request : LibC::ULong
		private11 : Pointer
		private12 : Pointer
		private13 : Pointer
		private14 : Pointer
		max_request_size : LibC::UInt
		db : LibC::Char*
		private15 : Display* -> LibC::Int
		display_name : LibC::Char*
		default_screen : LibC::Int
		nscreens : LibC::Int
		screens : Screen*
		motion_buffer : LibC::ULong
		private16 : LibC::ULong
		min_keycode : LibC::Int
		max_keycode : LibC::Int
		private17 : Pointer
		private18 : Pointer
		private19 : LibC::Int
		xdefaults : LibC::Char*
	end

	struct KeyEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		root : Window
		subwindow : Window
		time : LibC::ULong
		x, y : LibC::Int
		x_root, y_root : LibC::Int
		state : LibC::UInt
		keycode : LibC::UInt
		same_screen : Bool
	end

	struct ButtonEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		root : Window
		subwindow : Window
		time : LibC::ULong
		x, y : LibC::Int
		x_root, y_root : LibC::Int
		state : LibC::UInt
		button : LibC::UInt
		same_screen : Bool
	end

	alias ButtonPressedEvent = ButtonEvent
	alias ButtonReleasedEvent = ButtonEvent

	struct MotionEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		root : Window
		subwindow : Window
		time : LibC::ULong
		x, y : LibC::Int
		x_root, y_root : LibC::Int
		state : LibC::UInt
		is_hint : LibC::Char
		same_screen : Bool
	end

	struct CrossingEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		root : Window
		subwindow : Window
		time : LibC::ULong
		x, y : LibC::Int
		x_root, y_root : LibC::Int
		mode : LibC::Int
		detail : LibC::Int
		same_screen : Bool
		focus : Bool
		state : LibC::UInt
	end

	alias EnterWindowEvent = CrossingEvent
	alias LeaveWindowEvent = CrossingEvent

	struct FocusChangeEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		mode : LibC::Int
		detail : LibC::Int
	end

	alias FocusInEvent = FocusChangeEvent
	alias FocusOutEvent = FocusChangeEvent

	struct KeymapEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		key_vector : LibC::Char[32]
	end

	struct ExposeEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		x, y : LibC::Int
		width, height : LibC::Int
		count : LibC::Int
	end

	struct GraphicsExposeEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		drawable : Drawable
		x, y : LibC::Int
		width, height : LibC::Int
		count : LibC::Int
		major_code : LibC::Int
		minor_code : LibC::Int
	end

	struct NoExposeEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		drawable : Drawable
		major_code : LibC::Int
		minor_code : LibC::Int
	end

	struct VisibilityEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		state : LibC::Int
	end 

	struct CreateWindowEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		parent : Window
		window : Window
		x, y : LibC::Int
		width, height : LibC::Int
		border_width : LibC::Int
		override_direct : Bool
	end

	struct DestroyWindowEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
	end

	struct UnmapEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
		from_configure : Bool
	end

	struct MapEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
		override_direct : Bool
	end

	struct MapRequestEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		parent : Window
		window : Window
	end

	struct ReparentEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
		parent : Window
		x, y : LibC::Int
		override_direct : Bool
	end

	struct ConfigureEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
		x, y : LibC::Int
		width, height : LibC::Int
		border_width : LibC::Int
		above : Window
		override_direct : Bool
	end

	struct GravityEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
		x, y : LibC::Int
	end

	struct ResizeRequestEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		width, height : LibC::Int
	end

	struct ConfigureRequestEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		parent : Window
		window : Window
		x, y : LibC::Int
		width, height : LibC::Int
		border_width : LibC::Int
		above : Window
		detail : LibC::Int
		value_mask : LibC::ULong
	end

	struct CirculateEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		event : Window
		window : Window
		place : LibC::Int
	end

	struct CirculateRequestEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		parent : Window
		window : Window 
		place : LibC::Int
	end

	struct PropertyEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		widnow : Window
		atom : LibC::ULong
		time : LibC::ULong
		state : LibC::Int
	end

	struct SelectionClearEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		selection : LibC::ULong
		time : LibC::ULong
	end

	struct SelectionRequestEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		owner : Window
		requestor : Window
		selection : LibC::ULong
		target : LibC::ULong
		property : LibC::ULong
		time : LibC::ULong
	end

	struct SelectionEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		requestor : Window
		selection : LibC::ULong
		target : LibC::ULong
		property : LibC::ULong
		time : LibC::ULong
	end

	union ClientMessageEvent_Data
		b : LibC::Char[20]
		s : LibC::Short[10]
		l : LibC::Long[5]
	end

	struct ColormapEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		colormap : Colormap
		c_new : Bool
		state : LibC::Int
	end

	struct ClientMessageEvent 
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		message_type : LibC::ULong
		format : LibC::Int
		data : ClientMessageEvent_Data
	end 

	struct MappingEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
		request : LibC::Int
		first_keycode : LibC::Int
		count : LibC::Int
	end

	struct ErrorEvent
		type : LibC::Int
		display : Display*
		resourceid : LibC::ULong
		serial : LibC::ULong
		error_code : LibC::ULong
		request_code : LibC::ULong
		minor_code : LibC::Char
	end

	struct AnyEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		window : Window
	end

	struct GenericEvent
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		extension : LibC::Int
		evtype : LibC::Int
	end

	struct GenericEventCookie
		type : LibC::Int
		serial : LibC::ULong
		send_event : Bool
		display : Display*
		extension : LibC::Int
		evtype : LibC::Int
		cookie : LibC::UInt
		data : Void*
	end

	struct Event
		type : LibC::Int
		xany : AnyEvent
		xkey : AnyEvent
		xbutton : ButtonEvent
		xmotion : MotionEvent
		xcrossing : CrossingEvent
		xfocus : FocusChangeEvent
		xexpose : ExposeEvent
		xgraphicsexpose : GraphicsExposeEvent
		xnoexpose : NoExposeEvent
		xvisibility : VisibilityEvent
		xcreatewindow : CreateWindowEvent
		xdestroywindow : DestroyWindowEvent
		xunmap : UnmapEvent
		xmap : MapEvent
		xmaprequest : MapRequestEvent
		xreparent : ReparentEvent
		xconfigure : ConfigureEvent
		xgravity : GravityEvent
		xresizerequest : ResizeRequestEvent
		xconfigurerequest : ConfigureRequestEvent
		xcirculate : CirculateRequestEvent
		xcirculaterequest : CirculateRequestEvent
		xproperty : PropertyEvent
		xselectionclear : SelectionClearEvent
		xselectionrequest : SelectionRequestEvent
		xselection : SelectionEvent
		xcolormap : ColormapEvent
		xclient : ClientMessageEvent
		xmapping : MappingEvent
		xerror : ErrorEvent
		xkeymap : KeymapEvent
		xgeneric : GenericEvent
		xcookie : GenericEventCookie
		pad : LibC::Long[24]
	end

	struct CharStruct
		lbearing : LibC::Short
		rbearing : LibC::Short
		width : LibC::Short
		ascent : LibC::Short
		descent : LibC::Short
		attributes : LibC::UShort
	end

	struct FontProp
		name : LibC::ULong
		card32 : LibC::ULong
	end

	struct FontStruct
		ext_data : ExtData*
		fid : Font
		direction : LibC::UInt
		min_char_or_byte2 : LibC::UInt
		max_char_or_byte2 : LibC::UInt
		min_byte1 : LibC::UInt
		max_byte1 : LibC::UInt
		all_chars_exist : Bool
		default_char : LibC::UInt
		n_properties : LibC::Int
		properties : FontProp*
		min_bounds : CharStruct
		max_bounds : CharStruct
		per_char : CharStruct*
		ascent : LibC::Int
		descent : LibC::Int
	end

	struct TextItem
		chars : LibC::Char*
		nchars : LibC::Int
		delta : LibC::Int
		font : Font
	end

	struct Char2b
		byte1 : LibC::UChar
		byte2 : LibC::UChar
	end

	struct TextItem16
		chars : Char2b*
		nchars : LibC::Int
		delta : LibC::Int
		font : Font
	end

	union EDataObject
		display : Display*
		gc : GC,
		visual : Visual*
		screen : Screen*
		pixmap_foramt : ScreenFormat*
		font : FontStruct*
	end

	struct FontSetExtents
		max_ink_extent : Rectangle
		max_logical_extent : Rectangle
	end

	NRequiredCharSet = "requiredCharSet"
	NQueryOrientation = "queryOrientation"
	NBaseFontName = "baseFontName"
	NomAutomatic = "omAutomatic"
	NMissingCharSet = "missingCharSet"
	NDefaultString = "defaultString"
	NOrientation = "orientation"
	NDirectionalDependentDrawing = "directionalDependentDrawing"
	NContextualDrawing = "contextualDrawing"
	NFontInfo = "fontInfo"

	struct OMCharSetList
		charset_count : LibC::Int
		charset_list : LibC::Char**
	end

	enum Orientation
		OMOrientation_LTR_TTB
		OMOrientation_RTL_TTB
		OMOrientation_TTB_LTR
		OMOrientation_TTB_RTL
		OMOrientation_Context
	end

	struct OMFontInfo
		num_font : LibC::Int
		font_struct_list : FontStruct**
		font_name_list : LibC::Char**
	end

	alias IM = Pointer*
	alias IC = Pointer*

	alias IMProc = IM, Pointer, Pointer -> NoReturn

	alias ICProc = IC, Pointer, Pointer -> Bool

	alias IDProc = Display*, Pointer, Pointer -> NoReturn

	struct IMStyles
		count_styles : LibC::UShort
		supported_styles : IMStyle*
	end

	enum IMStyle
		IMPreeditArea = 0x0001
		IMPreeditCallbacks = 0x0002
		IMPreeditPosition = 0x0004
		IMPreeditNothing = 0x0008
		IMPreeditNone = 0x0010
		IMStatusArea = 0x0100
		IMStatusCallbacks = 0x0200
		IMStatusNothing = 0x0400
		IMStatusNone = 0x0800
	end

	NVaNestedList = "XNVaNestedList"
	NQueryInputStyle = "queryInputStyle"
	NClientWindow = "clientWindow"
	NInputStyle = "inputStyle"
	NFocusWindow = "focusWindow"
	NResourceName = "resourceName"
	NResourceClass = "resourceClass"
	NGeometryCallback = "geometryCallback"
	NDestroyCallback = "destroyCallback"
	NFilterEvents = "filterEvents"
	NPreeditStartCallback = "preeditStartCallBack"
	NPreeditDoneCallback = "preeditDoneCallback"
	NPreeditDrawCallback = "preeditDrawCallback"
	NPreeditCaretCallback = "preeditCaretCallback"
	NPreeditStateNotifyCallback = "preeditStateNotifyCallback"
	NPreeditAttributes = "preeditAttributes"
	NStatusStartCallback = "statusStartCallback"
	NStatusDoneCallback = "statusDoneCallback"
	NStatusDrawCallback = "statusDrawCallback"
	NStatusAttributes = "statusAttributes"
	NArea = "area"
	NAreaNeeded = "areaNeeded"
	NSpotLocation = "spotLocation"
	NColormap = "colorMap"
	NStdColormap = "stdColormap"
	NForeground = "foreground"
	NBackground = "background"
	NBackgroundPixmap = "backgroundPixmap"
	NFontSet = "fontSet"
	NLineSpace = "lineSpace"
	NCursor = "cursor"
	
	NQueryIMValuesList = "queryIMValuesList"
	NQueryICValuesList = "queryICValuesList"
	NVisiblePosition = "visiblePosition"
	NR6PreeditCallback = "r6PreeditCallback"
	NStringConversionCallback = "stringConversionCallback"
	NStringConversion = "stringConversion"
	NResetState = "resetState"
	NHotKey = "hotKey"
	NHotKeyState = "hotKeyState"
	NPreeditState = "preeditState"
	NSeparatorofNestedList = "separatorofNestedList"

	BufferOverflow = -1
	LookupNone = 1
	LookupChars = 2
	LookupKeySym = 3
	LookupBoth = 4

	VaNestedList = Void*

	struct IMCallback
		client_data : Pointer
		callback : ICProc
	end

	enum IMFeedback
		IMReverse = 1_i64
		IMUnderline = (1<<1)
		IMHighlight = (1<<2)
		IMPrimary = (1<<5)
		IMSecondary = (1<<6)
		IMTertiary = (1<<7)
		IMVisibleToForward = (1<<8)
		IMVisibleToBackword = (1<<9)
		IMVisibleToCenter = (1<<10)
	end

	struct IMText
		length : LibC::UShort
		feedback : IMFeedback*
		encoding_is_wchar : Bool
	end

	enum IMPreeditState
		IMPreeditUnKnown = 0
		IMPreeditEnable = 1
		IMPreeditDisable = (1<<1)
	end

	struct IMPreeditStateNotifyCallbackStruct
		state : IMPreeditState
	end

	enum IMStringConversionFeedback
		IMStringConversionLeftEdge = 0x00000001
		IMStringConversionRightEdge = 0x00000002
		IMStringConversionTopEdge = 0x00000004
		IMStringCOnversionBottomEdge = 0x00000008
		IMStringConversionConcealed = 0x00000010
		IMStringCovnersionWrapped = 0x00000020
	end

	struct IMStringConversionText
		length : LibC::UShort
		feedback : IMStringConversionFeedback*
		encoding_is_wchar : Bool
	end

	alias IMStringConversionPosition = LibC::UShort

	enum IMStringConversionType
		IMStringConversionBuffer = 0x0001
		IMStringConversionLine = 0x0002
		IMStringConversionWord = 0x0003
		IMStringCOnversionchar = 0x0004
	end

	enum IMStringConversionOperation
		IMStringConversionSubstitute = 0x0001
		IMStringConversionRetrieval = 0x0002
	end

	enum IMCaretDirection
		IMForwardChar
		IMBackwardChar
		IMForwardWord
		IMBackwardWord
		IMCaretUp
		IMCaretDown
		IMNextLine
		IMPreviousLine
		IMLineStart
		IMLineEnd
		IMAbsolutePosition
		IMDontChange
	end

	struct IMStringConversionCallbackStruct
		position : IMStringConversionPosition
		direction : IMCaretDirection
		operation : IMStringConversionOperation
		factor : LibC::UShort
		text : IMStringConversionText*
	end

	struct IMPreeditDdrawCallbackStruct
		caret : LibC::Int
		chg_first : LibC::Int
		chg_length : LibC::Int
		text : IMText*
	end

	enum IMCaretStyle
		IMIsInvisible
		IMIsPrimary
		IMIsSecondary
	end

	struct IMPreeditCaretCallbackStruct
		position : LibC::Int
		direction : IMCaretDirection
		style = IMCaretStyle
	end

	enum IMStatusDataType
		IMTextType
		IMBitmapType
	end

	union IMStatusCallbackStruct_Data
		text : IMText*
		bitmap : Pixmap
	end

	struct IMStatusCallbackStruct
		type : IMStatusDataTye
		data : IMStatusCallbackStruct_Data
	end
	
	struct IMHotKeyTrigger
		keysym : KeySym
		modifier : LibC::Int
		modifier_mask : LibC::Int
	end

	struct IMHotKeyTriggers
		num_hot_key : LibC::Int
		key : IMHotKeyTrigger*
	end

	IMHotKeyStateOn = (0x0001_i64)
	IMHotKeyStateOff = (0x001_i64)

	struct IMValuesList
		count_values : LibC::UShort
		supported_values : LibC::Char**
	end

	fun load_query_font = XLoadQueryFont(x0 : Display*, x1 : LibC::Char*) : FontStruct
	fun query_font = XQueryFont(x0 : Display*, x1 : LibC::ULong) : FontStruct
	fun get_motion_events = XTimeCoord(x0 : Display*, x1 : Window, x2 : LibC::ULong, x3 : LibC::ULong, x4 : LibC::Int*) : TimeCoord
	fun delete_modifier_map_entry = XDeleteModifierMapEntry(x0 : Display*, x1 : LibC::UInt, x2 : LibC::Int) : ModifierKeymap
	fun get_modifier_mapping = XModifierKeymap(x0 : Display*) : ModifierKeymap*
	fun insert_modifiermap_entry = XModifierKeymap(x0 : XModifierKeymap*) : XModifierKeymap*
	fun get_modifier_mapping = XGetModifierMapping(x0 : Display*) : ModifierKeymap*
		fun new_modifiermap = XNewModifierMap(x0 : LibC::Int) : ModifierKeymap*
		fun create_image = XCreateImage(x0 : Display*, x1 : Visual*, x2 : LibC::UInt, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Char*, x6 : LibC::UInt, x7 : LibC::UInt, x8 : LibC::Int, x9 : LibC::Int) : Image*
		fun init_image = XInitImage(x0 : Image*) : LibC::Int
	fun get_image = XGetImage(x0 : Display*, x1 : Drawable, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt, x6 : LibC::ULong, x10 : LibC::Int) : Image*
		fun get_sub_image = XGetSubImage(x0 : Display*, x1 : Drawable, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt, x6 : LibC::ULong, x7 : LibC::Int, x8 : Image*, x9 : LibC::Int, x10 : LibC::Int) : Image*
		fun open_display = XOpenDisplay(x0 : LibC::Char*) : Display*
		fun rm_initialize = XrmInitialize(x0 : Void) : Void
		fun fetch_bytes = XFetchBytes(x0 : Display*, x1 : LibC::Int*) : LibC::Char*
		fun fetch_buffer = XFetchBuffer(x0 : Display*, x1 : LibC::Int*, x2 : LibC::Int) : LibC::Char*
		fun display_name = XDisplayName(x0 : LibC::Char*) : LibC::Char* 
		fun get_default = XGetDefault(x0  : Display*, x1 : LibC::Char*, x2 : LibC::Char*) : LibC::Char*
		fun keysym_to_string = XKeysymToString(x0 : Display*, x1 : LibC::Char*) : LibC::Char*
		fun intern_atom = XInternAtom(x0 : Display*, x1 : LibC::Char*, x2 : Bool) : Atom
		fun intern_atoms = XInternAtoms(x0 : Display*, x1 : LibC::Char*, x2 : Bool) : Status
		fun copy_colormap_and_free = XCopyColormapAndFree(x0 : Display*, x1 : Colormap) : Colormap
	fun create_colormap = XCreateColormap(x0 : Display*, x1 : Window, x2 : Visual*, x3 : LibC::Int) : Colormap
	fun create_pixmap_cursor = XCreatePixmapCursor(x0 : Display*, x1 : Pixmap, x2 : Pixmap, x3 : Color*, x4 : Color*, x5 : LibC::Int, x6 : LibC::Int) : Cursor
	fun create_glyph_cursor = XCreateGlyphCursor(x0 : Display*, x1 : Font, x2 : Font, x3 : LibC::UInt, x4 : LibC::UInt, x5 : Color*, x6 : Color*) : Cursor
	fun create_font_cursor = XCreateFontCursor(x0 : Display*, x1 : LibC::Int) : Cursor
	fun load_font = XLoadFont(x0 : Display*, x1 : LibC::UInt) : Font
	fun create_gc = XCreateGC(x0 : Display*, x1 : Drawable, x2 : LibC::ULong, x3 : GCValues*) : GC
	fun flush_gc = XFlushGC(x0 : Display*, x1 : GC) : Void
	fun create_pixmap = XCreatePixmap(x0 : Display*, x1 : Drawable, x2 : LibC::UInt, x3 : LibC::UInt, x4 : LibC::UInt) : Pixmap
	fun create_bitmap_from_data = XCreateBitmapFromData(x0 : Display*, x1 : Drawable, x2 : LibC::Char*, x3 : LibC::UInt, x4 : LibC::UInt) : Pixmap
	fun create_pixmap_from_bitmap_data = XCreatePixmapFromBitmapData(x0 : Display*, x1 : Drawable, x2 : LibC::Char*, x3 : LibC::UInt, x4 : LibC::UInt, x5 : LibC::ULong, x6 : LibC::ULong, x7 : LibC::UInt) : Pixmap
	fun create_simple_window = XCreateSimpleWindow(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt, x6 : LibC::UInt, x7 : LibC::ULong, x8 : LibC::ULong) : Window
	fun get_selection_owner = XGetSelectionOwner(x0 : Display*, x1 : LibC::ULong) : Window
	fun create_window = XCreateWindow(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt, x6 : LibC::UInt, x7 : LibC::Int, x8 : LibC::UInt, x9 : Visual*, x10 : LibC::ULong, x11 : SetWindowAttributes*) : Window
	fun list_installed_colormaps = XListInstalledColormaps(x0 : Display*, x1 : Window, x2 : LibC::Int*) : Colormap*
		fun default_colormap = XDefaultColormap(x0 : Display*, x1 : LibC::Int) : Colormap
	fun default_colormap_of_screen = XDefaultColormapOfScreen(x0 : Screen*) : Colormap
	fun display_of_screen = XDisplayOfScreen(x0 : Screen*) : Display*
		fun screen_of_display = XScreenOfDisplay(x0 : Display*, x1 : LibC::Int) : Screen*
		fun default_screen_of_display = XDefaultScreenOfDisplay(x0 : Display*) : Screen*
		fun default_screen = XDefaultScreen(x0 : Display*) : LibC::Int
	fun define_cursor = XDefineCursor(x0 : Display*, x1 : Window, x2 : Cursor) : LibC::Int
	fun delete_property = XDeleteProperty(x0 : Display*, x1 : Window, x2 : LibC::ULong) : LibC::Int
	fun destroy_window = XDestroyWindow(x0 : Display*, x1 : Window) : LibC::Int
	fun destroy_subwindows = XDestroySubwindows(x0 : Display*, x1 : Window) : LibC::Int
	fun does_backing_store = XDoesBackingStore(x0 : Screen*) : LibC::Int
	fun does_save_unders = XDoesSaveUnders(x0 : Screen*) : Bool
	fun disable_access_control = XDisableAccessControl(x0 : Display*) : LibC::Int
	fun display_cells = XDisplayCells(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun display_height = XDisplayHeight(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun display_height_mm = XDisplayHeightMM(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun display_keycodes = XDisplayKeycodes(x0 : Display*, x1 : LibC::Int*, x2 : LibC::Int*) : LibC::Int
	fun display_planes = XDisplayPlanes(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun display_width = XDisplayWidth(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun display_width_mm = XDisplayWidthMM(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun draw_line = XDrawLine(x0 : Display*, x1 : Drawable, x2 : GC, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::Int) : LibC::Int
	fun draw_lines = XDrawLines(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Point*, x4 : LibC::Int, x5 : LibC::Int) : LibC::Int
	fun draw_point = XDrawPoint(x0 : Display*, x1 : Drawable, x2 : GC, x3 : LibC::Int, x4 : LibC::Int) : LibC::Int
	fun draw_points = XDrawPoints(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Point*, x4 : LibC::Int, x5 : LibC::Int) : LibC::Int
	fun draw_rectangle = XDrawRectange(x0 : Display*, x1 : Drawable, x2 : GC, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::UInt, x6 : LibC::UInt) : LibC::Int
	fun draw_rectangles = XDrawRectangles(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Rectangle*, x4 : LibC::Int) : LibC::Int
	fun draw_segments = XDrawSegments(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Segment, x4 : LibC::Int) : LibC::Int
	fun draw_string = XDrawString(x0 : Display*, x1 : Drawable, x2 : GC, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Char*, x6 : LibC::Int) : LibC::Int
	fun draw_text = XDrawText(x0 : Display*, x1 : Drawable, x2 : GC, x3 : LibC::Int, x4 : LibC::Int, x5 : TextItem, x6 : LibC::Int) : LibC::Int
	fun fill_polygon = XFillPolygon(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Point*, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::Int) : LibC::Int
	fun fill_rectangle = XFillRectangle(x0 : Display*, x1 : Drawable, x2 : GC, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::UInt, x6 : LibC::UInt) : LibC::Int
	fun fill_rectangles = XFillRectangles(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Rectangle*, x4 : LibC::Int) : LibC::Int
	fun flush = XFlush(x0 : Display*) : LibC::Int
	fun force_screen_saver = XForceScreenSaver(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun free = XFree(x0 : Void*) : LibC::Int
	fun free_colormap = XFreeColormap(x0 : Display*, x1 : Colormap) : LibC::Int
	fun free_colors = XFreeColors(x0 : Display*, x1 : Colormap, x2 : LibC::ULong*, x3 : LibC::Int, x4 : LibC::ULong) : LibC::Int
	fun free_cursor = XFreeCursor(x0 : Display*, x1 : Cursor) : LibC::Int
	fun free_font = XFreeFont(x0 : Display*, x1 : FontStruct*) : LibC::Int
	fun free_modifermap = XFreeModifiermap(x0 : ModifierKeymap*) : LibC::Int
	fun free_pixmap = XFreePixmap(x0 : Display*, x1 : Pixmap) : LibC::Int
	fun geometry = XGeometry(x0 : Display*, x1 : LibC::Int, x2 : LibC::Char*, x3 : LibC::Char*, x4 : LibC::UInt, x5 : LibC::UInt, x6 : LibC::UInt, x7 : LibC::Int, x8 : LibC::Int, x9 : LibC::Int*, x10 : LibC::Int*, x11 : LibC::Int*, x12 : LibC::Int*) : LibC::Int
	fun get_error_database_text = XGetErrorDatabaseText(x0 : Display*, x1 : LibC::Char*, x2 : LibC::Char*, x3 : LibC::Char*, x4 : LibC::Char*, x5 : LibC::Int) : LibC::Int
	fun get_error_text = XGetErrorText(x0 : Display*, x1 : LibC::Int, x2 : LibC::Char*, x3 : LibC::Int) : LibC::Int
	fun get_gc_values = XGetGCValues(x0 : Display*, x1 : GC, x2 : LibC::ULong, x3 : GCValues*) : LibC::Int
	fun get_geometry = XGetGeometry(x0 : Display*, x1 : Drawable, x2 : Window*, x3 : LibC::Int*, x4 : LibC::Int*, x5 : LibC::UInt*, x6 : LibC::UInt*, x7 : LibC::UInt*, x8 : LibC::UInt*) : LibC::Int
	fun get_input_focus = XGetInputFocus(x0 : Display*, x1 : Window*, x2 : LibC::Int) : LibC::Int
	fun get_keyboard_control = XGetKeyboardControl(x0 : Display*, x1 : KeyboardState*) : LibC::Int
	fun get_pointer_control = XGetPointerControl(x0 : Display*, x1 : LibC::Int*, x2 : LibC::Int*, x3 : LibC::Int*) : LibC::Int
	fun get_pointer_mapping = XGetPointerMapping(x0 : Display*, x1 : LibC::UChar*, x2 : LibC::Int) : LibC::Int
	fun get_screen_saver = XGetScreenSaver(x0 : Display*, x1 : LibC::Int*, x2 : LibC::Int*, x3 : LibC::Int*, x4 : LibC::Int*) : LibC::Int
	fun get_transient_for_hint = XGetTransientForHint(x0 : Display*, x1 : Window, x2 : Window*) : LibC::Int
	fun get_window_attributes = XGetWindowAttributes(x0 : Display*, x1 : Window, x2 : WindowAttributes*) : LibC::Int
	fun grab_button = XGrabButton(x0 : Display*, x1 : LibC::UInt, x2 : LibC::UInt, x3 : Window, x4 : Bool, x5 : LibC::UInt, x6 : LibC::Int, x7 : LibC::Int, x8 : Window, x9 : Cursor) : LibC::Int
	fun grab_key = XGrabKey(x0 : Display*, x1 : LibC::Int, x2 : LibC::UInt, x3 : Window, x4 : Bool, x5 : LibC::Int, x6 : LibC::Int) : LibC::Int
	fun grab_server = XGrabServer(x0 : Display*) : LibC::Int
	fun height_mm_of_screen = XHeightMMOfScreen(x0 : Display*) : LibC::Int
	fun height_of_screen = XHeightOfScreen(x0 : Screen*) : LibC::Int
	fun image_byte_order = XImageByteOrder(x0 : Display*) : LibC::Int
	fun install_colormap = XInstallColormap(x0 : Display*, x1 : Colormap) : LibC::Int
	fun keysym_to_keycode = XKeySymToKeycode(x0 : Display*, x1 : KeySym) : KeyCode
	fun kill_client = XKillClient(x0 : Display*, x1 : LibC::ULong) : LibC::Int
	fun lookup_color = XLookupColor(x0 : Display*, x1 : Colormap, x2 : LibC::Char*, x3 : Color*, x4 : Color*) : LibC::Int
	fun lower_window = XLowerWindow(x0 : Display*, x1 : Window) : LibC::Int
	fun map_raised = XMapRaised(x0 : Display*, x1 : Window) : LibC::Int
	fun map_sub_windows = XMapSubwindows(x0 : Display*, x1 : Window) : LibC::Int
	fun map_window = XMapWindow(x0 : Display*, x1 : Window) : LibC::Int
	fun mask_event = XMaskEvent(x0 : Display*, x1 : LibC::Long, x2 : Event*) : LibC::Int
	fun max_cmaps_of_screen = XMaxCmapsOfScreen(x0 : Screen*) : LibC::Int
	fun min_cmaps_of_screen = XMinCmapsOfScreen(x0 : Screen*) : LibC::Int
	fun move_resize_window = XMoveResizeWindow(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt) : LibC::Int
	fun move_window = XMoveWindow(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::Int) : LibC::Int
	fun next_event = XNextEvent(x0 : Display*, x1 : Event*) : LibC::Int
	fun no_op = XNoOp(x0 : Display*) : LibC::Int
	fun parse_color = XParseColor(x0 : Display*, x1 : Colormap, x2 : LibC::Char*, x3 : Color*) : LibC::Int
	fun parse_geometry = XParseGeometry(x0 : LibC::Char*, x1 : LibC::Int*, x2 : LibC::Int*, x3 : LibC::UInt*, x4 : LibC::UInt*) : LibC::Int
	fun peek_event = XPeekEvent(x0 : Display*, x1 : Event*) : LibC::Int
	fun pending = XPending(x0 : Display*) : LibC::Int
	fun planes_of_screen = XPlanesOfScreen(x0 : Screen*) : LibC::Int
	fun protocol_revision = XProtocolRevision(x0 : Display*) : LibC::Int
	fun protocol_version = XProtocolVersion(x0 : Display*) : LibC::Int
	fun put_back_event = XPutBackEvent(x0 : Display*, x1 : Event*) : LibC::Int
	fun put_image = XPutImage(x0 : Display*, x1 : Drawable, x2 : GC, x3 : Image*, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::Int, x7 : LibC::Int, x8 : LibC::UInt, x9 : LibC::UInt) : LibC::Int
	fun q_length = XQLength(x0 : Display*) : LibC::Int
	fun default_depth = XDefaultDepth(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun default_depth_of_screen = XDefaultDepthOfScreen(x0 : Screen*) : LibC::Int
	fun root_window = XRootWindow(x0 : Display*, x1 : LibC::Int) : Window
	fun default_root_window = XDefaultRootWindow(x0 : Display*) : Window
	fun root_window_of_screen = XRootWindowOfScreen(x0 : Screen*) : Window
	fun default_visual = XDefaultVisual(x0 : Display*, x1 : LibC::Int) : Visual*
		fun default_visual_of_screen = XDefaultVisualOfScreen(x0 : Screen*) : Visual*
		fun default_gc = XDefaultGC(x0 : Display*, x1 : LibC::Int) : GC
	fun black_pixel = XBlackPixel(x0 : Display*, x1 : LibC::Int) : LibC::ULong
	fun white_pixel = XWhitePixel(x0 : Display*, x1 : LibC::Int) : LibC::ULong
	fun all_planes = XAllPlanes() : LibC::ULong
	fun black_pixel_of_screen = XBlackPixelOfScreen(x0 : Screen*) : LibC::ULong
	fun white_pixel_of_screen = XWhitePixelOfScreen(x0 : Screen*) : LibC::ULong
	fun next_request = XNextRequest(x0 : Display*) : LibC::ULong
	fun last_known_request_processed = XLastKnownRequestProcessed(x0 : Display*) : LibC::ULong
	fun server_vendor = XServerVendor(x0 : Display*) : LibC::Char*
		fun display_string = XDisplayString(x0 : Display*) : LibC::Char*
		fun defualt_gc_of_screen = XDefaultGCOfScreen(x0 : Screen*) : GC
	fun event_mask_of_screen = XEventMaskOfScreen(x0 : Screen*) : LibC::Long
	fun screen_number_of_screen = XScreenNumberOfScreen(x0 : Screen*) : LibC::Int
	fun list_pixmap_format_values = XListPixmapFormats(x0 : Display*, x1 : LibC::Int*) : PixmapFormatValues*
		fun list_depths = XListDepths(x0 : Display*, x1 : LibC::Int, x2 : LibC::Int*) : LibC::Int*
		fun reconfigure_wm_window = XReconfigureWMWindow(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::UInt, x4 : WindowChanges*) : LibC::Int
	fun iconify_window = XIconifyWindow(x0 : Display*, x1 : Window, x2 : LibC::Int) : LibC::Int
	fun withdraw_window = XWithdrawWindow(x0 : Display*, x1 : Window, x2 : LibC::Int) : LibC::Int
	fun activate_screen_saver = XActivateScreenSaver(x0 : Display*) : LibC::Int
	fun add_host = XAddHost(x0 : Display*, x1 : HostAddress*) : LibC::Int
	fun add_hosts = XAddHosts(x0 : Display*, 1x : HostAddress*, LibC::Int) : LibC::Int
	fun add_to_extension_list : XAddToExtensionList(x0 : ExtData**, x2 : ExtData*) : LibC::Int
	fun add_to_save_set : XAddToSaveSet(x0 : Display*, x1 : Window) : LibC::Int
	fun alloc_color : XAllocColor (x0 : Display*, x1 : Colormap, x2 : Color*) : Status
	fun alloc_color_cells = XAllocColorCells(x0 : Display*, x1 : Colormap, x2 : Bool, x3 : LibC::ULong*, x4 : LibC::Int, x5 : LibC::ULong*, x6 : LibC::Int) : Status
	fun alloc_color_planes = XAllocColorPlanes(x0 : Display*, x1 : Colormap, x2 : Bool, x3 : LibC::ULong*, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::Int, x7 : LibC::Int, x8 : LibC::ULong*, x9 : LibC::ULong*, x10 : LibC::ULong*) : Status
	fun alloc_named_color = XAllocNamedColor(x0 : Display*, x1 : Colormap, x2 : LibC::Char*, x3 : Color*, x4 : Color*) : Status
	fun allow_events = XAllowEvents(x0 : Display*, x1 : LibC::Int, x2 : TLibC::ULong) : LibC::Int
	fun auto_repeat_off = XAutoRepeatOff(x0 : Display*) : LibC::Int
	fun auto_repeat_on = XAutoRepeatOn(x0 : Display*) : LibC::Int
	fun bell = XBell(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun cells_of_screen = XCellsOfScreen(x0 : Screen*) : LibC::Int
	fun change_activate_pointer_grab = XChangeActivatePointerGrab(x0 : Display*, x1 : LibC::UInt, x2 : Cursor, x3 : LibC::ULong) : LibC::Int
	fun change_gc = XChangeGC(x0 : Display*, x1 : GC, x2 : LibC::ULong, x3 : GCValues*) : LibC::Int
	fun change_keyboard_control = XChangeKeyboardControl(x0 : Display*, x1 : LibC::ULong, x2 : KeyboardControl*) : LibC::Int
	fun change_keyboard_mapping = XChangeKeyboardMapping(x0 : Display*, x1 : LibC::Int, x2 : LibC::Int, x3 : KeySym*, x4 : LibC::Int) : LibC::Int
	fun change_pointer_control = XChangePointerControl(x0 : Display*, x1 : Bool, x2 : Bool, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Int) : LibC::Int
	fun change_property = XChangeProperty(x0 : Display*, x1 : Window, x2 : Atom, x3 : Atom, x4 : LibC::Int, x5 : LibC::Int) : LibC::Int
	fun change_save_set = XChangeSaveSet(x0 : Display*, x1 : Window, x3 : LibC::Int) : LibC::Int
	fun change_window_attributes = XChangeWindowAttributes(x0 : Display*, x1 : Window, x2 : LibC::ULong, x3 : SetWindowAttributes*) : LibC::Int
	fun check_if_event = XCheckIfEvent(x0 : Display*, x1 : Event*, x2 : Display*, Event*,  Pointer -> Bool, x3 : Pointer)
	fun check_mask_event = XCheckMaskEvent(x0 : Display*, x1 : LibC::Long, x2 : Event*) : Bool
	fun check_typed_event = XCheckTypedEvent(x0 : Display*, x1 : LibC::Int, x2 : Event*) : Bool
	fun check_typed_window_event = XCheckTypedWindowEvent(x0 : Display*, x1 : LibC::Int, x2 : Event*) : Bool
	fun check_window_event = XCheckWindowEvent(x0 : Display*, x1 : Window, x2 : LibC::Long, x3 : Event*) : Bool
	fun set_foreground = XSetForeground(x0 : Display*, x1 : GC, x2 : LibC::ULong) : LibC::Int
	fun query_tree = XQueryTree(x0 : Display*, x1 : Window, x2 : Window*, x3 : Window* x4 : Window**, x5 : UInt*) : Status
	fun raise_window = XRaiseWindow(x0 : Display*, x1 : Window) : LibC::Int
	fun rebind_keysym = XRebindKeysym(x0 : Display*, x1 : KeySym, x2 : KeySym*, x3 : LibC::Int, x4 : LibC::UChar*, x5 : LibC::Int) : LibC::Int
	fun recolor_cursor = XRecolorCursor(x0 : Display*, x1 : Cursor, x2 : Color*, x3 : Color*) : LibC::Int
	fun refresh_keyboard_mapping = XRefreshKeyboardMapping(x0 : MappingEvent) : LibC::Int
	fun remove_from_save_set = XRemoveFromSaveSet(x0 : Display*, x1 : Window) : LibC::Int
	fun remove_host = XRemoveHost(x0 : Display*, x1 : HostAddress) : LibC::Int
	fun remove_hosts = XRemoveHosts(x0 : Display*, x1 : HostAddress, x2 : LibC::Int) : LibC::Int
	fun reparent_window = XReparentWindow(x0 : Display*, x1 : Window, x2 : Window, x3 : LibC::Int, x4 : LibC::Int) : LibC::Int
	fun reset_screensaver = XResetScreenSaver(x0 : Display*) : LibC::Int
	fun resize_window = XResizeWindow(x0 : Display*, x1 : Window, x2 : LibC::UInt, x3 : LibC::UInt) : LibC::Int
	fun restack_windows = XRestackWindows(x0 : Display*, x1 : Window*, x2 : LibC::Int) : LibC::Int
	fun rotate_buffers = XRotateBuffers(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun screen_count = XScreenCount(x0 : Display*) : LibC::Int
	fun select_input = XSelectInput(x0 : Display*, x1 : Window, x2 : LibC::Long) : LibC::Int
	fun send_event = XSendEvent(x0 : Display*, x1 : Window, x2 : Bool, x3 : LibC::Long, x4 : Event*) : Status
	fun set_access_mode = XSetAccessMode(x0 : Display*, x1 : GC, x2 : LibC::Int) : LibC::Int
	fun set_access_control = XSetAccessControl(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun set_arc_mode = XSetArcMode(x0 : Display*, x1 : GC, x2 : LibC::Int) : LibC::Int
	fun set_background = XSetBackground(x0 : Display*, x1 : GC, x2 : LibC::ULong) : LibC::Int
	fun set_clip_mask = XSetClipMask(x0 : Display*, x1 : GC, x2 : Pixmap) : LibC::Int
	fun set_clip_origin = XSetClipOrigin(x0 : Display*, x1 : GC, x2 : LibC::Int, x3 : LibC::Int) : LibC::Int
	fun set_clip_rectangles = XSetClipRectangles(x0 : Display*, x1 : GC, x2 : LibC::Int, x3 : LibC::Int, x4 : Rectangle, x5 : LibC::Int, x6 : LibC::Int) : LibC::Int
	fun set_close_down_mode = XSetCloseDownMode(x0 : Display*, x1 : LibC::Int) : LibC::Int
	fun set_dashes = XSetDashes(x0 : Display*, x1 : GC, x2 : LibC::Int, x3 : LibC::Char*, x4 : LibC::Int) : LibC::Int
	fun set_fill_rule = XSetFillRule(x0 : Display*, x1 : GC, x2 : LibC::Int) : LibC::Int
	fun set_fill_style = XSetFillStyle(x0 : Display*, x1 : GC, x2 : LibC::Int) : LibC::Int
	fun set_font = XSetFont(x0 : Display*, x1 : GC, x2 : Font) : LibC::Int
	fun set_function = XSetFunction(x0 : Display*, x1 : GC, x2 : LibC::Int) : LibC::Int
	fun set_graphics_exposures = XSetGraphicsExposures(x0 : Display*, x1 : GC, x2 : Bool) : LibC::Int
	fun set_icon_name = XSetIconName(x0 : Display*, x1 : Window, x2 : LibC::Char*) : LibC::Int
	fun set_input_focus = XSetInputFocus(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::ULong) : LibC::Int
	fun set_line_attributes = XSetLineAttributes(x0 : Display*, x1 : GC, x2 : LibC::UInt, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Int) : LibC::Int
	fun set_modifier_mapping = XSetModifierMapping(x0 : Display*, x1 : ModifierKeymap*) : LibC::Int
	fun set_plane_mask = XSetPlaneMask(x0 : Display*, x1 : GC, x2 : LibC::ULong) : LibC::Int
	fun set_pointer_mapping = XSetPointerMapping(x0 : Display*, x1 : LibC::UChar*, x2 : LibC::Int) : LibC::Int
	fun set_screen_saver = XSetScreenSaver(x0 : Display*, x1 : LibC::Int, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::Int) : LibC::Int
	fun set_selection_owner = XSetSelectionOwner(x0 : Display*, x1 : Atom, x2 : x3 : Window, x4 : LibC::ULong) : LibC::Int
	fun set_state = XXSetState(x0 : Display*, x1 : GC, x2 : LibC::ULong, x3 : LibC::ULong, x4 : LibC::Int, x5 : LibC::ULong) : LibC::Int
	fun set_stipple = XSetStipple(x0 : Display*, x1 : GC, x2 : Pixmap) : LibC::Int
	fun set_subwindow_mode = XSetSubwindowMode(x0 : Display*, x1 : GC, x2 : LibC::Int) : LibC::Int
	fun set_ts_origin = XSetTSOrigin(x0 : Display*, x1 : GC, x2 : LibC::Int, x3 : LibC::Int) : LibC::Int
	fun set_tile = XSetTile(x0 : Display*, x1 : GC, x2 : Pixmap) : LibC::Int
	fun set_window_background = XSetWindowBackground(x0 : Display*, x1 : Window, x2 : LibC::ULong) : LibC::Int
	fun set_window_background_pixmap = XSetWindowBackgroundPixmap(x0 : Display*, x1 : Window, x2 : Pixmap) : LibC::Int
	fun set_window_border = XSetWindowBorder(x0 : Display*, x1 : Window, x2 : LibC::ULong) : LibC::Int
	fun set_window_border_pixmap = XSetWindowBorderPixmap(x0 : Display*, x1 : Window, x2 : Pixmap) : LibC::Int
	fun set_window_border_width = XSetWindowBorderWidth(x0 : Display*, x1 : Window, x2 : LibC::UInt) : LibC::Int
	fun set_window_colormap = XSetWindowColormap(x0 : Display*, x1 : Window, x2 : Colormap) : LibC::Int
	fun store_buffer = XStoreBuffer(x0 : Display*, x1 : LibC::Char*, x2 : LibC::Int, x3 : LibC::Int) : LibC::Int
	fun store_bytes = XStoreBytes(x0 : Display*, x1 : LibC::Char*, x2 : LibC::Int) : LibC::Int
	fun store_color = XStoreColor(x0 : Display*, x1 : Colormap, x2 : Color*) : LibC::Int
	fun store_colors = XStoreColors(x0 : Display*, x1 : Colormap, x2 : Color*, x3 : LibC::Int) : LibC::Int
	fun store_name = XStoreName(x0 : Display*, x1 : Window, x2 : LibC::Char*) : LibC::Int
	fun store_named_color = XStoreNamedColor(x0 : Display*, x1 : Colormap, x2 : LibC::Char*, x3 : LibC::ULong, x4 : LibC::Int) : LibC::Int
	fun sync = XSync(x0 : Display*, x1 : Bool) : LibC::Int
	fun text_extents = XTextExtents(x0 : FontStruct*, x1 : LibC::Char*, x2 : LibC::Int, x3 : LibC::Int*, x4 : LibC::Int*, x5 : LibC::Int*, x6 : CharStruct*) : LibC::Int
	fun text_extents_16 = XTextExtents16(x0 : FontStruct*, x1 : Char2b*, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Int, x6 : CharStruct*) : LibC::Int
	fun text_width = XTextWidth(x0 : FontStruct*, x1 : LibC::Char*, x2 : LibC::Int) : LibC::Int
	fun text_width_16 = XTextWidth16(x0 : FontStruct*, x1 : Cahr2b*, x2 : Libc::Int) : LibC::Int
	fun translate_coordinates = XTranslateCoordinates(x0 : Display*, x1 : Window, x2 : Window, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::Int*, x6 : LibC::Int*, x7 : Window*) : Bool
	fun undefine_cursor = XUndefineCursor(x0 : Display*, x1 : Window) : LibC::Int
	fun ungrab_button = XUngrabButton(x0 : Display*, x1 : LibC::UInt, x2 : LibC::UInt, x3 : Window) : LibC::Int
	fun ungrab_key = XUngrabKey(x0 : Display*, x1 : LibC::Int, x2 : LibC::UInt, x3 : Window) : LibC::Int
	fun ungrab_keyboard = XUngrabKeyboard(x0 : Display*, x1 : LibC::ULong) : LibC::Int
	fun ungrab_pointer = XUngrabPointer(x0 : Display*, x1 : LibC::ULong) : LibC::Int
	fun uninstall_colormap = XUninstallColormap(x0 : Display*, x1 : Colormap) : LibC::Int
	fun unload_font = XUnloadFont(x0 : Display*, x1 : Font) : LibC::Int
	fun unmap_subwindows = XUnmapSubwindows(x0 : Display*, x1 : Window) : LibC::Int
	fun unmap_window = XUnmapWindow(x0 : Display*, x1 : Window) : LibC::Int
	fun vendor_release = XVendorRelease(x0 : Display*) : LibC::Int
	fun warp_pointer = XWarpPointer(x0 : Display*, x1 : Window, x2 : Window, x3 : LibC::Int, x4 : LibC::Int, x5 : LibC::UInt, x6 : LibC::UInt, x7 : LibC::Int, x8 : LibC::Int) : LibC::Int
	fun width_mm_of_screen = XWidthMMOfScreen(x0 : Screen* ) : LibC::Int
	fun width_of_screen = XWidthOfScreen(x0 : Screen*) : LibC::Int
	fun window_event = XWindowEvent(x0 : Display*, x1 : Window, x2 : LibC::Long, x3 : Event*) : LibC::Int
	fun write_bitmap_file = XWriteBitmapFile(x0 : Display*, x1 : LibC::Char*, x2 : Pixmap, x3 : LibC::UInt, x4 : LibC::UInt, x5 : LibC::Int, x6 : LibC::Int) : LibC::Int
	fun set_authorization = XSetAuthorization(x0 : LibC::Char*, x1 : LibC::Int, x2 : LibC::Char*, x3 : LibC::Int) : Void
	fun get_event_data = XGetEventData(x0 : Display*, x1 : GenericEventCookie) : Bool
	fun free_event_data = XFreeEventData(x0 : Display*, x1 : GenericEventCookie*) : Void
	fun circulate_subwindows = XCirculateSubwindows(x0 : Display*, x1 : Window, x2 : LibC::Int) : LibC::Int
	fun circulate_subwindows_down = XCirculateSubwindowsDown(x0 : Display*, x1 : Window) : LibC::Int
	fun circulate_subwindows_up = XCirculateSubwindowsUp(x0 : Display*, x1 : Window) : LibC::Int
	fun clear_area = XClearArea(x0 : Display*, x1 : Window, x2 : LibC::Int, x3 : LibC::Int, x4 : LibC::UInt, x5 : LibC::UInt, x6 : Bool) : LibC::Int
	fun clear_window = XClearWindow(x0 : Display*, x1 : Window) : LibC::Int
	fun close_display = XCloseDisplay(x0 : Display*) : LibC::Int
	fun configure_window = XConfigureWindow(x0 : Display*, x1 : Window, x2 : LibC::UInt, x3 : WindowChanges*) : LibC::Int
	fun connection_number = XConnectionNumber(x0 : Display*) : LibC::Int
	fun convert_selection = XConvertSelection(x0 : Display*, x1 : LibC::ULong, x2 : LibC::ULong, x3 : LibC::ULong, x4 : Window, x5 : LibC::ULong) : LibC::Int
	fun copy_area = XCopyArea(x0 : Display*, x1 : Drawable, x2 : Drawable, x3 : GC, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::UInt, x7 : LibC::UInt, x8 : LibC::Int, x9 : LibC::Int) : LibC::Int
	fun copy_gc = XCopyGC(x0 : Display*, x1 : GC, x2 : LibC::ULong, x3 : GC) : LibC::Int
	fun copy_plane = XCopyPlane(x0 : Display*, x1 : Drawable, x2 : Drawable, x3 : GC, x4 : LibC::Int, x5 : LibC::Int, x6 : LibC::UInt, x7 : LibC::UInt, x8 : LibC::Int, x9 : LibC::Int, x10 : LibC::ULong) : LibC::Int
	fun close_im : XCloseIM(x0 : IM) : LibC::Int
	fun get_im_values : XGetIMValues(x0 : IM) : LibC::Char*
	fun set_im_values : XSetIMValues(x0 : IM) : LibC::Char*
	fun display_of_im : XDisplayOfIM(x0 : IM) : Display*
	fun locale_of_im : XLocaleOfIM(x0 : IM) : LibC::Char*
	fun create_ic : XCreateIC(x0 : IC) : IC
	fun destroy_ic : XDestroyIC(x0 : IC) : Void
	fun set_ic_focus : XSetICFocus(x0 : IC) : Void
	fun unset_ic_focus : XUnsetICFocus(x0 : IC) : Void
	fun utf8_reset_ic : Xutf8ResetIC(x0 : IC) : LibC::Char*
	fun set_ic_values : XSetICValues(x0 : IC) : LibC::Char*
	fun get_ic_values : XGetICValues(x0 : IC) : LibC::Char*
	fun filter_event : XFilterEvent(x0 : Event*, x1 : Window) : Bool
	fun utf8_lookup_string(x0 : IC, x1 : KeyPressedEvent*, x2 : LibC::Char*, x3 : LibC::Int, x4 : KeySym*, LibC::Int*) : LibC::Int
	alias ConnectionWatchProc = Display*, Pointer, LibC::Int, Bool, Pointer* -> NoReturn
	fun internal_connection_numbers : XInternalConnectionNumbers(x0 : Display*, x1 : LibC::Int**, x2 : LibC::Int*) : LibC::Int
	fun process_internal_connection : XProcessInternalConnection(x0 : Display*, x1 : LibC::Int) : Void
	fun add_connection_watch : XAddConnectionWatch(x0 : Display*, x1 : ConnectionWatchProc, x2 : Pointer) : LibC::Int
	fun remove_connection_watch : XRemoveConnectionWatch(x0 : Display*, x1 : ConnectionWatchProc, x2 : Pointer) : Void
	fun set_size_hints : XSetSizeHints(x0 : Display*, x1 : Window, x2 : x3 : SizeHints*, x4 : Atom) : LibC::Int
	fun set_wm_hints : XSetWMHints(x0 : Display*, x1 : Window, x2 : WMHints*) : LibC::Int
	fun set_zoom_hints : XSetZoomHints(x0 : Display*, x1 : Window, x2 : SizeHints*) : LibC::Int
	fun set_normal_hints : XSetNormalHints(x0 : Display*, x1 : Window, x2 : SizeHints*) : LibC::Int
	fun set_icon_sizes : XSetIconSizes(x0 : Display*, x1 : Window, x2 : IconSize*) : LibC::Int
	fun set_command : XSetCommand(x0 : Display*, x1 : Window, x2 : LibC::Char**, x3 : LibC::Int) : LibC::Int
	fun set_standard_properties : XSetStandardProperties(x0 : Display*, x1 : Window, x2 : LibC::Char*, x3 : LibC::Char*, x4 : Pixmap, x5 : LibC::Char**, x6 : LibC::Int, x7 : SizeHints*) : LibC::Int
	fun set_transient_for_hint : XSetTransientForHint(x0 : Display*, x1 : Window, x2 : Window) : LibC::Int
	fun set_class_hint : XSetClassHint(x0 : Display*, x1 : Window, x2 : ClassHint*) : LibC::Int
end
