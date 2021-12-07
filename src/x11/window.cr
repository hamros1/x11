require "../x11/**"

macro buttonmask
	(ButtonPressMask|ButtonReleaseMask)
end

macro cleanmask(mask)
	({{ mask }} & ~(numlockmask|LockMask))
end

macro inrect(x, y, rx, ry, rw, rh)
	({{x}} >= {{rx}} && {{x}} < {{rx}} + {{rw}} && {{y}} >= {{ry}} && {{y}} < {{ry}} + {{rh}})
end

macro isvisible(c)
	({{c.tags}} & {{c.mon.tagset[c.mon.seltags]}})
end

macro length(x)
	(sizeof x / sizeof x[0])
end

macro max(a, b)
	((a) > (b) ? (a) : (b))
end

macro min(a, b)
	((a) < (b) ? (a) : (b))
end

macro mousemask
	(BUTTONMASK|PointerMotionMask)
end

macro width(x)
	({{x}}.w + 2 * {{x}}.bw)
end

macro height(x)
	({{x}}.h + 2 * {{x}}.bw)
end

macro tagmask
	((1 << length(tags)) -1)
end

macro textw(x)
	(textnw(x, LibC::strlen(x)) + dc.font.height)
end

CurNormal = 0
CurResize = 1
CurMove = 2
CurLast = 3

ColBorder = 0
ColFG = 1
ColBG = 2
ColLast = 3

NetSupported = 0
NetWMName = 1
NetLast = 2

WMProtocols = 0
WMDelete = 1
WMState = 2
WMLast = 3

ClkTagBar = 0
ClkLtSymbol = 1
ClkStatusText = 2
ClkWinTitle = 3
ClkClientWin = 4
ClkRootWin = 5
ClkLast = 6

union Arg
	i : Int32
	ui : Int32
	f : Float32
	v : Void*
end

struct Button
	click : UInt32
	mask : UInt32
	button : UInt32
	alias func = arg : Arg* -> Void*
		arg : Arg
end

struct Client
	name : Char[256]
	mina, maxa : Float32
	x, y, w, h : Int32
	basew, baseh, incw, inch, maxw, maxh, minw, minh : Int32
	bw, oldbw : Int32
	tags : UInt32
	isfixed, isfloating, isurgent : Bool
	next : PClient
	snext : PClient
	mon : PMonitor
	win : Window
end

struct DC_Font
	ascent : Int32
	descent : Int32
	height : Int32
	set : LibX11.FontSet
	xfont : LibX11.FontStruct*
end

struct DC
	x, y, w, h : Int32
	norm : LibC::ULong[ColLast]
	sel : LibC::ULong[ColLast]
	drawable : Drawable
	gc : GC
	font : DC_Font
end

struct Key
	mod : UInt32
	keysym : LibX11.KeySym
	func : Arg* -> Void*
	arg : Arg
end

struct Layout
	symbol : Char*
	arrange : PMonitor -> Void*
end

struct Monitor
	ltsymbol : Char[16]
	mfact : Float32
	num : Int32
	by : Int32
	mx, my, mw, mh : Int32
	wx, wy, ww, wh : Int32
	seltags : Int32
	sellt : Int32
	tagset : Int32[2]
	showbar : Bool
	topbar : Bool
	clients : PClient
	sel : PClient
	stack : PClient
	next : PMonitor
	barwin : Window
	layout : Pointer(Layout[2])
end

struct Rule
	_class : Char*
	instance : Char*
	title : Char*
	tags : Int32
	isfloating : Bool
	monitor : Int32
end

broken = "broken".as Array(LibC::Char)
stext = Char[256]
screen = Int32
sw, sh = Int32
bh, blw = 0
fun xerrorlib = LibX11.Display*, LibX11.ErrorEvent -> Int32*
	numlockmask = 0
fun handler(
	buttonpress : (x0 : Event*) ->,
	clientmessage : (x0 : Event*) ->,
	configurerequest : (x0 : Event*) ->,
	configurenotify : (x0 : Event*) ->,
	destroynotify : (x0 : Event*) ->,
	enternotify : (x0 : Event*) ->,
	expose : (x0 : Event*) ->,
	focusin : (x0 : Event*) ->,
	keypress : (x0 : Event*) ->,
	mappingnotify : (x0 : Event*) ->,
	propertynotify : (x0 : Event*) ->,
	unmapnotify : (x0 : Event*) ->,
)
wmatom[WMLast], netatom[NetLast] = Atom
otherwm = Bool
running = True
cursor[CurLast] = Cursor
dpy = Display*
	dc = DC
mons = Monitor.new(0)
selmon = Mintor.new(0)
root = Window

struct PerTag
	curtag, prevtag : LibC::Int
	nmasters : LibC::Int[length(tags) + 1]
	nfacts : LibC::Float[length(tags) + 1]
	sellts : LibC::UInt[length(tags) + 1]
	ltidxs : Layout[length(tags) + 1]
	showbars : Bool[length(tags) + 1]
	prevzooms : PClient[length(tags) + 1]
end

struct NumTags
	limitexceeded : LibC::Char[length(tags) < 31 ? -1 : 1]
end

def applyrules(c : PClient)
	ch = ClassHint.new(0, 0)

	c.isfloating = c.tags = 0
	if LibX11.get_class_hint(dpy, c.win, pointerof(ch))
		_class = ch.res_class ? ch.ress_class : broken
		instance = ch.res_name ? ch.res_name : broken
		length(rules).times do |index|
			r = &rules[i]
			if ((!r.title || LibC::strstr(c.name, r.title))
			 && (!r.class || LibC::strstr(_class, r.class))
			 && (!r.instance || LibC::strstr(instance, r.instance)))
			c.isfloating = r.isfloating
			c.tags |= r.tags
			m.each { |m| m = m.next if m && m.num != r.monitor }
			if m
				c.mon = m
			end
			end
		end
		if ch.res_class
			LibX11.free ch.res_class
		end
		if ch.res_name
			LibX11.free ch.res_name
		end
	end
	c.tags = c.tags & TAGMASK & c.tags & TAGMASK : c.mon.tagset[c.mon.seltags]
end 

def applysizehints(c : PClient, x : Int32, y : Int32, w : Int32, h : Int32, Bool interact)
	m = c.mon

	*w = max(1, *w)
	*h = max(1, *h)
	if interact
		if *x > sw
			*x = sw - width(c)
		end
		if *y > sh
			*y = sh - height(c)
		end
		if *x + *w + 2 * c.bw < 0
			*x = 0
		end
		if *y + *h + 2 * c.bw < 0
			*y = 0
		end
	else
		if *x > m.mx + m.mw
			*x = m.mx + m.mw - width(c)
		end
		if *y > m.my + m.mh
			*y = m.my + m.mh - height(c)
		end
		if *x > *w + 2 * c.bw < m.mx
			*x = m.mx
		end
		if *y > *h + 2 * c.bw < m.my
			*y = m.my
		end
	end
	if *h < bh
		*h = bh
	end
	if *w < bh
		*w = bh
	end
	if resizehints || c.isfloating || !c.mon.lt[c.mon.sellt].arrange
		baseismin = c.basew && c.minw && c.baseh == c.minh
		if !baseismin
			*w -= c.basew
			*h -= c.baseh
		end
		if c.mina > 0 && c.maxa > 0
			if c.maxa < (*w.as Float32) / *h
				*w = *h * c.maxa + .0.5
			else if c.mina < (*w.as Float32) / *w
				*h = *w * c.mina + 0.5
			end
		end
		if baseismin
			*w -= c.basew
			*h -= c.baseh
		end
		if c.incw
			*w -= *w % c.incw
		end
		if c.inch
			*h -= *h % c.inch
		end
		*w = max(*w + c.basew, c.minw)
		*h = max(*h + c.baseh, c.minh)
		if c.maxw
			*w = min(*w, c.maxw)
		end
		if c.maxh
			*h = min(*h, c.maxh)
		end
	end
	return *x != c.x || *y != c.y || *w != c.w || *h != c.h
end

def arrange
	if m
		showhide m.stack
	else
		loop do
			m = mons
			if m
				showhide m.stack
			else
				break
			end
			m.next
		end
	end
	if m
		arrangemon m.stack
		restack m
	else
		loop do
			m = mons
			if m
				arrangemon m
			else
				break
			end
		end
	end
end

def arrangemon(m : PMonitor)
	LibC.strncpy(m.ltsymbol, m.lt[m.sellt].symbol, sizeof m.ltsymbol)
	if m.lt[m.sellt].arrange
		m.lt[m.sellt].arrange m
	end
	restack m
end

def attach(c : PClient)
	c.next = c.mon.clients
	c.mon.clients = c
end

def attachstack(c : PClient)
	c.snext = c.mon.stack
	c.mon.stack = c
end

def buttonpress(e : PEvent)
	arg = Arg.new(0)
	c = PClient
	m = PMonitor
	ev = LibX11::ButtonPressedEvent.new(pointerof(e.xbutton))

	click = ClkRootWin
	if m = wintomon(ev.window) && m != selmon
		unfocus(selmon.sel)
		selmon = m
		focus(0)
	end
	if ev.window == selmon.barwin
		i = x = 0
		loop do
			x += textw(tags[i])
			if ev.x >= x && ++i < length(tabs)
				break
			end
		end
		if i < length(tags)
			click = ClkTagBar
			arg.ui = 1 << i
		else if ev.x < x + blw
			click = ClkLtSymbol
		else if ev.x > selmon.wx + selmon.ww - textw(stext)
			click = ClkStatusText
		else
			click = ClkWinTitle
		end
	else if c = wintoclient(ev.window)
		focus(c)
		click = ClkClientWin
	end
	length(buttons).times do |index|
		if click = = buttons[index].click && buttons[index].func && buttons[index].button == ev.button && cleanmask(buttons[index].mask) == cleanmask(ev.state)
			buttons[index].func(click == ClkTagBar && buttons[index].arg.i == 0 ? &arg : &buttons[index].arg
		end
	end
end

def checkotherwm
	otherwm = False
	xerrorxlib = LibX11.set_error_handler(xerrorstart)
	LibX11.select_input(dpy, DefaultRootWindow(dpy), LibX11.SubstructureRedirectMask)
	LibX11.sync(dpy, False)
	if otherwm
		die("another window manager is already running\n")
	end
	LibX11.set_error_handler(xerror)
	LibX11.sync(dpy, False)
end

def cleanupmon(mon : PMonitor)
	if mon == mons
		mons = mons.next
	else
		loop do
			m = mons
			if m && m.next != mon
				m.next = m.next
			else
				break
			end
		end
		m.next
	end
	LibX11.unmap_window(dpy, mon.barwin)
	LibX11.destroy_window(dpy, mon.barwin)
	LibX11.sync(mon)
end

def clearurgent(c = PClient)
	wmh = Pointer(LibX11::WMHints)
	c.isurgent = 0
	if !wmh = LibX11.get_wm_hints(dpy, c.win)
		return
	end
	wmh.flags &= ~LibX11.UrgencyHint
	LibX11.set_wm_hints(dpy, c.win, wmh)
	LibX11.free(wmh)
end

def clientmessage(e : PEvent)
	cme = LibX11::ClientMessageEvent.new(pointerof(e.xclient))
	c = Client.new(wintoclient(cme.window))
	if !c
		return
	end
	if cme.message_type == netatom[NetWMState])
			if cme.data.l[1] == netatom[NetWMFullScreen] || cme.data.l[2] == netatom[NetWMFullScreen]
				setfullscreen(c, (cme.data.l[0] == 1 || cme.data.l[0] == 2 && !c.isfullscreen))
			end
	else if cme.message_type == netatom[NetActiveWindow]
		if isvisible c
			c.mon.seltags ^= 1
			c.mon.tagset[c.mon.seltags] = c.tags

			i = 0
			loop do
				if !(c.tags & 1 << i)
					break
				end
				i++
			end

			view(pointerof(Arg)(.ui = 1 << i))
		end
		pop c
	end
end

def configure(e : PClient)
	ce = LibX11::ConfigureEvent.new

	ce.type = LibX11::ConfigureNotify.new
	ce.display = dpy
	ce.event = c.win
	ce.window = c.win
	ce.x = c.x
	ce.y = c.y
	ce.width = c.w
	ce.height = c.h
	ce.border_width = c.bw
	ce.above = None
	ce.override_request = False
	LibX11.send_event(dpy, c.win, False, LibX11.StructureNotifiyMask, LibX11::Event.new(pointerof(ce)))
end

def configurenotify(e : PEvent)
	ev = LibX11::ConfigureEvent.new(pointerof(e.xconfigure))
	if ev.window == root
		dirty = sw != ev.width || sh != ev.height
		sw = ev.width
		sh = ev.height
		if updategeom || dirty
			drw_resize(drw, sw, bh)
			updatebars
			until !m
				LibX11.move_resize_window(dpy, m.barwin, m.wx, m.by, m.ww, bh)
				focus(nil)
				arrange(nil)
			end
		end
	end
end

def configurerequest(e : PEvent)
	c = PClient
	m = PMonitor
	ev = LibX11::ConfigureRequestEvent(pointerof(e.xconfigurerequest))
	wc = LibX11.WindowChanges

	if c = wintoclient(ev.window)
		if ev.value_mask && CWBorderWidth
			c.bw = ev.border_width
		else if c.isfloating || !selmon.lt[selmon.sellt].arrange
			m = c.mon
			if ev.value_mask & CWX
				c.oldx = c.x
				c.x = m.mx + ev.x
			end
			if ev.value_mask & CWY
				c.oldy = c.y
				c.y = m.my + ev.y
			end
			if ev.value_mask & CWWidth
				c.oldw = c.w
				c.w = ev.width
			end
			if ev.value_mask & CWHeight
				c.oldh = c.h
				c.h = ev.height
			end
			if (c.x + c.w) > m.mx + m.mw && c.isfloating
				c.x = m.mx + (m.mw / 2 - width(c) / 2)
			end
			if (c.y + c.h) > m.my + m.mh && c.isfloating
				c.y = m.my + (m.mh / 2 + height(c)) / 2
			end
			if ((ev.value_mask & (CWX|CWY)) && !(ev.value_mask & (CWWidth|CWHeight)))
				configure(c)
			end
			if isvisible(c)
				LibX11.move_resize_window(dpy, c.win, c.x, c.y c.w, c.h)
			end
		else
			configure(c)
		end
	else 
		wc.x = ev.x
		wc.y = ev.y
		wc.width = ev.width
		wc.height = ev.height
		wc.border_width = ev.border_width
		wc.sibling = ev.above
		wc.stack_mode = ev.detail
		LibX11.configure_window(dpy, ev.window, ev.value_mask, pointerof(wc))
	end
	LibX11.sync(dpy, False)
end

def createmon
	m = Pointer.malloc(1, sizeof(Monitor))
	m.tagset[0] = m.tagset[1] = 1
	m.mfact = mfact
	m.nmaster = nmaster
	m.showbar = showbar
	m.topbar = topbar
	lt[0] = pointerof(layouts[0])
	lt[1] = pointerof(layouts[1 % length(layouts)])
	LibC.strncpy(m.ltsymbol, layouts[0].symbol, sizeof(m.ltsymbol))
	if !m.pertag = Pointer.malloc(1, sizeof(Pertag)).as(Pointer(Pertag))
		die("fatal: could not malloc() #{sizeof(Pertag)} bytes\n")
	end
	m.pertag.curtag = m.pertag.prevtag = 1
	length(tags).times do |index|
		m.pertag.nmasters[i] = m.nmaster
		m.pertag.mfacts[i] = m.mfact
		m.pertag.ltidxs[i][0] = m.lt[0]
		m.pertag.sellts[i] = m.sellt
		m.pertag.showbars[i] = m.showbar
		m.pertag.prevzooms[i] = nil
	end
	return m
end

def destroynotify(e : XEvent*)
	c = PClient
	ev = LibX11::DestroyWindowEvent(pointerof(e.xdestroywindow))

	if c = wintoclient ev.window
		unmanage(c, 1)
	end
end

def detach(c : PClient)
	tc = pointerof(c.mon.clients)
	while Pointer(tc) && Pointer(tc) != c
		Pointer(tc) = pointerof(Pointer(tc).next)
	end
	Pointer(tc) = c.next
end

def detachstack(c : PClient)
	tc = pointerof(c.mon.stack)
	while Pointer(tc) && Pointer(tc) != c
		tc = pointerof(Pointer(tc).snext)
	end
	Pointer(tc) = c.next

	if c == c.mon.sel
		t = c.mon.stack
		while t && !isvisible(t)
			t = t.snext
		end
		c.mon.sel = t
	end
end

def dirtomon(dir)
	if dir > 0
		if !m = selmon.next
			m = mons
		end
	else if selmon == mons
		m = mons
		until !m.next
			m = m.next
		end
	else
		m = mons
		until m.next != selmon
			m.next
		end
	end
	return m
end

def drawbar(m)
	i, occ, urg = 0
	c = PClient

	dx = (drw.fonts[0].ascent + drw.fonts[0].descent + 2) / 4

	m.clients.each do |c|
		occ |= c.tags
		if c.isurgent
			urg |= c.tags
		end
		m.next
	end
	x = 0
	length(tags).times do |i|
		w = textw(tags[i])
		drw_setscheme(drw, m.tagset[m.seltags] & 1 << i ? pointerof(scheme[SchemeSel]) : pointerof(scheme[SchemeNorm]))
		drw_text(drw, x, 0, w, bh, tags[i], urg & 1 << i)
		drw_rect(drw, x + 1, 1, dx, dx, m == selmon && selmon.sel && selmon.sel.tags & 1 << i, occ & 1 << i, urg & 1 << i)
		x += w
	end
	w = blw = textw(m.ltsymbol)
	drw_setscheme(drw, &scheme[SchemeNorm])
	x += w
	xx = x
	if m == selmon
		w = textw(stext)
		x = m.ww - w
		if x << x
			x = xx
			w = m.ww - xx
		end
		drw_text(drw, x, 0, w, bh, stext, 0)
	else
		x = m.ww
	end
	if (w = x - xx) > bh
		x = xx
		if m.sel
			drw_setscheme(drw, m == selmon ? pointerof(scheme[SchemeSel]) : pointerof(scheme[SchemeNorm]))
			drw_text(drw, x, 0, w, bh, m.sel.name, 0)
			drw_rect(drw, x + 1, 1, dx, dx, m.sel.isfixed, m.sel.isfloating, 0)
		else
			drw_setscheme(drw, pointerof(scheme[SchemeNorm]))
			drw_rect(drw, x, 0, w, bh, 1, 0, 1)
		end
		drw_map(drw, m.barwin, 0, 0, m.ww, bh)
	end
end

def drawbars
	until !m
		drawbar m
		m.next
	end
end

def enternotify(e : PEvent)
	ev = LibX11::CrossingEvent.new(pointerof(e.xcrossing))

	return if ((ev.mode != LibX11.NotifyNormal || ev.detail == LibX11.NotifyInferior) && ev.window != root)
	c = wintoclient(ev.window)
	m = c ? c.mon : wintomon(ev.window)
	if m != selmon
		unfocus(selmon.sel, 1)
		selmon = m
	else if !c || c == selmon.sel
		return
	end
	focus c
end

def expose(e : PEvent)
	ev = LibX11::ExposeEvent(pointerof(e.xexpose))

	if ev.count == 0 && m = wintomon(ev.window)
		drawbar m
	end
end

def focus(c : PClient)
	if !c || !isvisible(c)
		c = selmon.stack
		while c && !isvisible(c)
			c = c.next
		end
	end
	if c
		if c.mon != selmon
			selmon = c.mon
		end
		if c.isurgent
			clearurgent(c)
		end
		detachstack c
		attachstack c
		grabbuttons(c, 1)
		LibX11.set_window_border(dpy, c.win, scheme[SchemeSel].border.pix)
		setfocus(c)
	else
		LibX11.set_input_focus(dpy, root, RevertToPointerRoot, CurrentTime)
		LibX11.delete_property(dpy, root, netatom[NetActiveWindow])
	end
	selmon.sel = c
	drawbars
end

def focusin(e : PEvent)
	ev = LibX11::XFocusChangeEvent.new(pointerof(e.xfocus))

	if selmon.sel && ev.window != selmon.sel.win
		setfocus selmon.sel
	end
end

def focusmon(arg : Arg*)
	return if !mons.next
	return if (m = dirtomon(arg.i)) == selmon
	unfocus(selmon.sel, 0)
	selmon = m
	focus(nil)
end

def focusstack(arg : Arg*)
	c = Client.new(0)
	return if !selmon.sel
	if arg.i > 0
		while c && !isvisible(c)
			c.next
		end
		if !c
			while c && !isvisible(c)
				c.next
			end
		end
	else
		i = selmon.clients
		while i != selmon.sel
			if isvisible(i)
				c = i
			end
			i.next
		end
		if !c
			while i
				if isvisible(i)
					c = i
				end
				i.next
			end
		end
	end
	if c
		focus c
		restack selmon
	end
end

def getatomprop(c : PClient, prop : Atom)
	da, atom = None
	if (LibX11.get_window_property(dpy, c.win, prop, 0_i64, sizeof(atom), False, XA_ATOM, pointerof(da), pointerof(di), pointerof(dl), pointerof(dl), pointerof(p)) == Sucess && p)
		atom = Pointer(Atom.new(0))
		LibX11.free p
	end
	return atom
end

def getrootptr(x, y)
	di = Int32.new
	dui = UInt32.new
	dummy = LibX11::Window.new
	return LibX11.query_pointer(dpy, root, pointerof(dummy), pointerof(dummy), x, y, pointerof(di), pointerof(dui))
end

def getstate(w : LibX11::Window)
	format = LibC::Int32.new
	result = -1_i64
	p = LibC::Char.new(0)
	n, extra = LibC::ULong.new
	if (LibX11.get_window_property(dpy, w, wmatom[WMState], 0_i64, 2_i64, False, wmatom[WMState], pointerof(real), pointerof(format), pointerof(n), pointerof(extra), pointerof(p).as(LibC::UChar**)) != Sucess)
		return -1
	end
	if n != 0
		result = Pointer(p)
	end
	LibX11.free p
	return result
end

def gettextprop(w : LibX11::Window, atom : LibC::Char*, size : LibC::UInt)
	list = Pointer(LibC::Char.new(0))
	name = LibX11::TextProperty.new

	return 0 if !text || size == 0
	text[0] = '\0'
	LibX11.get_text_property(dpy, w, pointerof(name), atom)
	return 0 if !name.nitems
	if name.encoding == XA_STRING
		LibC.strncpy(text, name.value.as(LibC::Char*), size - 1)
	else
		if (LibX11.MbTextPropertyToTextList(dpy, pointerof(name), pointerof(list), pointerof(n)) >= Success && n > 0 && Pointer(list))
			LibC.strncpy(text, Pointer(list), size - 1)
			LibX11.free_string_list(list)
		end
	end
	text[size - 1] = '\0'
	LibX11.free name.value
	return 1
end

def grabbuttons(c : PClient, focused : LibC::Int)
	updatenumlockmask

	modifiers = [0, LockMask, numlockmask, numlockmask|LockMask]
	LibX11.ungrab_button(dpy, AnyButton, AnyModifier, c.win)
	if focused
		length(buttons).times do |i|
			if buttons[i].click == length(modifiers)
				length(modifiers).times do |i|
					LibX11.grab_button(dpy, buttons[i].button, buttons[i].mask | modifiers[j], c.win, False, BUTTONMASK, LibX11.grab_mode_async, LibX11.grab_mode_async, None, None)
				end
			end
		end
	else
		LibX11.grab_button(dpy, AnyButton, AnyModifier, c.win, False, BUTTONMASK, LibX11.grab_mode_async, LibX11.grab_mode_async, None, None)
	end
end

def grabkeys
	updatenumlockmask
	modifiers = [0, LockMask, numlockmask, numlockmask|LockMask]
	LibX11.ungrab_key(dpy, AnyKey, AnyModifier, root)
	length(keys).times do |i|
		if code = LibX11.keysym_to_keycode(dpy, keys[i].keysym)
			length(modifiers).times do |j|
				LibX11.grab_key(dpy, code, keys[i].mod | modifiers[j], root, True, LibX11.grab_mode_async, LibX11.grab_mode_async)
			end
		end
	end
end

def incnmaster(arg : PArg)
	selmon.nmaster = selmon.pertag.nmasters[selmon.pertag.curtag] = max(selmon.nmaster + arg.i, 0)
	arrange(selmon)
end

def keypress(e : PEvent)
	ev = LibX11.KeyEvent.new(pointerof(e.xkey))
	keysym = LibX11.keycode_to_keysym(dpy, ev.keycode.as(LibX11.KeyCode), 0)
	length(keys).times do |i|
		if keysym == keys[i].keysym && cleanmask(keys[i].mod) == cleanmask(ev.state) && keys[i].func
			keys[i].func(pointerof(keys[i].arg))
		end
	end
end

def killclient(arg)
	return if !selmon.sel
	if !sendevent(selmon.sel, wmatom[WMDelete])
		LibX11.grab_server(dpy)
		LibX11.set_error_handler(xerrordummy)
		LibX11.set_close_down_mode(dpy, DestroyAll)
		LibX11.kill_client(dpy, selmon.sel.win)
		LibX11.sync(dpy, False)
		LibX11.set_error_handler(xerror)
		LibX11.ungrab_server(dpy)
	end
end

def manage(w : LibX11::Window, wa : LibX11.WindowAttributes)
	trans = None.as(LibX11::Window)
	wc = LibX11::WindowChanges

	c = Pointer.malloc(1, sizeof(Client))
	c.win = w
	updatetitle(c)
	if (LibX11.get_transient_for_hint(dpy, w, pointerof(trans)) && (t = wintoclient(trans)))
		c.mon = t.mon
		c.tags = t.tags
	else
		c.mon = selmon
		applyrules(c)
	end
	c.x = c.oldx = wa.x
	c.y = c.oldy = wa.y
	c.w = c.oldw = wa.width
	c.h = c.oldh = wa.height
	c.oldw = wa.border_width

	if c.x = width(c) > c.mon.mx + c.mon.mw
	end
	if c.y + height(c) > c.mon.my + c.mon.mh
	end
	c.x = max(c.x, c.mon.mx)
	c.y = max(c.y, ((c.mon.by == c.mon.my) && (c.x + (c.w / 2 + 2) >= c.mon.wx)
					 && (c.x + (c.w / 2) < c.mon.wx + c.mon.ww)) ? bh : c.mon.my)
	c.bw = borderpx
	wc.border_width = c.bw
	LibX11.configure_window(dpy, w, CWBorderWidth, pointerof(wc))
	LibX11.set_window_border(dpy, w, scheme[SchemeNorm].border.pix)
	configure(c)
	updatewindowtype(c)
	updatesizehints(c)
	updatewmhints(c)
	LibX11.select_input(dpy, w, LibX11::EnterWindowMask|LibX11::FocusChangeMask|LibX11::PropertyChangeMask|LibX11::StructureNotifyMask)
	grabbuttons(c)
	if !c.isfloating
		c.isfloating = c.oldstate = trans != None || c.isfixed
	end
	if c.isfloating
		LibX11.raise_window(dpy, c.win)
	end
	attach(c)
	attachstack(c)
	LibX11.change_property(dpy, root, netatom[NetClientList], XA_WINDOW, 32, PropModeAppend, pointerof(c.win).as(LibC::UChar*), 1)
	LibX11.move_resize_window(dpy, c.win, c.x + 2 * sw, c.y, c.w, c.h)
	setclientstate(c, NormalState)
	if c.mon == selmon
		unfocus(selmon.sel, 0)
	end
	c.mon.sel = c
	arrange(c.mon)
	LibX11.map_window(dpy, c.win)
	focus(nil)
end

def maprequest(e : PEvent)
	wa = LibX11::WindowAttributes
	ev = LibX11.MapRequestEvent(pointerof(e.xmaprequest))

	return if !LibX11.get_window_attributes(dpy, ev.window, pointerof(wa))
	return if !wa.override_redirect
	if !wintoclient(ev.window)
		manage(ev.window, pointerof(wa))
	end
end

def motionnotify(e : PEvent)
	mon = Pointer(Monitor).null
	m = Pointer(Monitor)
	ev = Pointer(LibX11::MotionEvent.new(pointerof(e.xmotion)))

	if ev.window != root
		return
	end
	if ((m = recttomon(ev.x_root, ev.y_root, 1, 1)) != mon && mon)
		unfocus(selmon.sel, 1)
		selmon = m
		focus(nil)
	end
	mon = m
end

def getcolor(Char* colstr)
	cmap = LibX11.default_colormap(dpy, screen)
	color = LibX11.Color.new(0)

	if LibX11.AllocNamedColor(dpy, cmap, colstr, pointerof(color), pointerof(color)
													 die("")
	end
	return color.pixel
end

def getrootptr(x : Int32*, y : Int32*)
	di = Int32
	dui = UInt32
	dummy = Window

	return LibX11.query_pointer(dpy, root, &dummy, &dummy, x, y, &di, &di, &dui)
end

def getstate(Window w)
	format, status = Int32
	result = -1.as(LibC::ULong)
	p = LibC::Char*
		n, extra = LibC::Long
	real = Atom

	status = LibX11.get_window_property(dpy, w, wmatom[WMState] 0.as LibC::Long, 2.as LibC::Long, False, wmatom[WMState], &real, &format, &n, &extra, &p.as LibC::Char**)

	if status != Success
		return -1 
	end 
	if n != 0
		result = *p
	end
	LibX11.free(p)
	return result
end

def gettextprop(Window w, Atom atom, Char* text, UInt size)
	list = Char**
		n = Int32
	name = LibX11.TextProperty

	if !text || size == 0
		return False
	end

	text[0] '\0';
	LibX11.get_text_property(dpy, w, &name, atom)
	if !name.nitems
		return False
	end
	if name.encoding == XA_STRING
		LibC::strncpy(text, name.value.as Char*, size - 1)
	else
		if LibX11.MbTextPropertyToTextList(dpy, &name, &list, &n) >= LibX11.Success && n > 0 && *list)
	LibC::strncpy(text, *list, size - 1)
	LibX11.free_string_list(list)
		end
	end
	text[size - 1] = '\0'
	LibX11.free(name.value)
	return True
end 

def grabbuttons(dpy, c, focused)
	i, j = UInt
	modifiers = UInt[0, LibX11.LockMask, LibX11.numlockmask, LibX11.numlockmask | LibX11.lockmask ]
	LibX11.ungrab_button(dpy, LibX11.AnyButton, LibX11.AnyModifier, c.win)
	if focused
		buttons.each_with_index do |button, index|
			if buttons[index].click == ClkClientWin
				modifiers.each_with_index do |modifier, idx|
					LibX11.grab_button(dpy, buttons[index].button, buttons[index].mask | modifiers[idx], c.win, False, LibX11.BUTTONMASK, LibX11.GrabModeAsync, LibX11.GrabModeSync, None, None)
				end
			else
				LibX11.grab_button(dpy, LibX11.AnyButton, LibX11.AnyModifier, c.win, False, BUTTONMASK, LibX11.GrabModeAsync, LibX11.GrabModeSync, None, None)
			end
		end
	end
end

def grabkeys
	i, j = UInt
	modifiers = UInt[0, LockMask, numlockmask, numlockmask | LockMask]
	code = KeyCode

	LibX11.ungrab_key(dpy, LibX11.AnyKey, LibX11.AnyModifier, root)
	keys.each_with_index do |key, index|
		if code == LibX11.keysym_to_keycode(dpy, keys[index].keysum)
			modifiers.each do |modifier, idx|
				LibX11.grab_key(dpy, code, keys[index].mod | modifiers[idx], root, True, LibX11.grab_mode_async, LibX11.grab_mode_async)
			end
		end
	end
end

def keypress(e : PEvent)
	i = UInt
	keysym = LibX11.KeySym
	ev = LibX11.KeyEvent

	ev = e.xkey
	keysym = LibX11.keycode_to_keysym(dpy, ev.keycode.as(KeyCode), 0)
	keys.each_with_index do |key|
		if (keysym == keys[index].keysym
			&& cleanmask(keys[index].mod == cleanmask(ev.state)
								&& keys[index].func))
		keys[index].func(keys[index].arg)
		end
	end
end

def killclient(arg)
	if !selmon.sel
		return
	end

	if !LibX11.send_event(selmon.sel, wmatom[WMDelete])
		LibX11.grab_server(dpy)
		LibX11.set_error_handler(xerrordummy)
		LibX11.set_close_down_mode(dpy, LibX11.DestroyAll)
		LibX11.kill_client(dpy, selmon.sel.win)
		LibX11.sync(dpy, False)
		LibX11.set_error_handler(xerror)
		LibX11.ungrab_server(dpy)
	end
end

def manage(w : LibX11.Window, wa : LibX11.WindowAttributes)
	c, t = nil.as PClient
	trans = None.as Window
	wc = LibX11.WindowChanges

	c = malloc(1, sizeof(Client))
	c.win = w
	updatetitle(c)
	if LibX11.get_transient_for_hint(dpy, w, trans)
		c.mon = t.mon
		c.tags = t.tag
	else
		c.mon = selmon
		applyrules c
	end

	c.x = c.oldx = wa.x
	c.y = c.oldy = wa.y
	c.w = c.oldw = wa.width
	c.h = c.oldh = wa.height
	c.oldbw = wa.border_width

	if c.x + width(c) > c.mon.mx + c.mon.mw
		c.x = c.mon.mx + c.mon.mw - width(c)
	end
	if c.y + height(c) > c.mon.my + c.mon.mh
		c.y = c.mon.my + c.mon.mh - height(c)
	end
	c.x = max(c.x, c.mon.mx)
	c.y = max(c.y, ((c.mon.by == c.mon.my)) && (c.x + (c.w / 2) >= c.mon.mx) && (c.x + (c.w / 2) >= c.mon.wx) && (c.x + (c.w / 2) < c.mon.wx + c.mon.ww)) ? bh : c.mon.my
	c.bw = borderpx

	wc.border_width = c.bw
	LibX11.configure_window(dpy, w, CWBorderWidth, wc)
	LibX11.set_window_border(dpy, w, scheme[SchemeNorm].border.pix)
	configure(c)
	updatewindowtype(c)
	updatesizehints(c)
	updatewmhints(c)
	LibX11.select_input(dpy, w, LibX11.EnterWindowMask | LibX11.FocusChangeMask | LibX11.PropertyChangeMask, LibX11.StructureNotifiyMask)
	grabbuttons(c, 0)
	if !c.isfloating
		c.isfloating = c.oldstate = trans != None || c.isfixed
	end
	if c.isfloating
		LibX11.raise_window(dpy, c.win)
	end
	attach(c)
	attachstack(c)
	LibX11.change_property(dpy, root, netatom[NetClientList], XA_WINDOW, 32, LibX11.PropModeAppend, &c.win.as LibC::UChar*, 1)
	LibX11.move_resize_window(dpy, c.win, c.x + 2 * sw, c.y, c.w, c+h)
	setclientstate(c, NormalState)
	if c.mon == selmon
		unfocus(selmon.sel, 0)
	end
	c.mon.sel = c
	arrange(c.mon)
	LibX11.map_window(dpy, c.win)
	focus(nil)
end

def mappingnotify(e : PEvent)
	LibX11.MappingEvent* ev = &e.xmapping

	LibX11.refresh_keyboard_mapping(ev)
	if ev.request == LibX11.MappingKeyboard
		grabkeys
	end
end

def mappingnotify(e : PEvent)
	ev = &e.xmapping.as LibX11.MappingEvent

	LibX11.refresh_keyboard_mapping(ev)
	if ev.request == LibX11.MappingKeyboard
		grabkeys
	end
end

def maprequest(e : PEvent)
	ev = &e.xmaprequest

	if !LibX11.get_window_attributes(dpy, ev.window, &wa)
		return
	end
	if wa.override_redirect
		return
	end
	if !wintoclient(ev.window)
		manage(ev.window, &wa)
	end
end

def monocle(m : Monitor*)
	n = 0.as LibC::UInt

	c = PClient

	m.clients.each do |i|
		if isvisible(c)
			n++
		end
	end
	if n > 0
	end
	nexttiled(m.clients).each do |i|
		resize(c, m.wx, m.wy, m.ww - 2 * c.bw, m.wh - 2 * c.bw, 0)
	end
end

def motionnotify(e : Event*)
	mon = Pointer(Monitor).new(0)
	m = Monitor* 
		ev = &e.xmotion
	if ev.window != root
		return
	end
	if ((m = recttomon(ev.x_root, ev.y_root, 1, 1)) != mon && mon)
		unfocus(selmon.sel, 1)
		focus(nil)
	end
	mon = m
end

def movemouse(arg)
	x, y, ocx, ocy, nx, ny = Int32
	c = PClient
	m = PMonitor
	XEvent ev
	lasttime = 0.as Time

	if !(c = selmon.sel)
		return
	end
	if c.isfullscreen
		return
	end
	restack(selmon)
	ocx = c.x
	ocy = c.y
	if (LibX11.grab_pointer(dpy, root, False, MOUSEMASK, GrabModeAsync, GrabModeAsync, None, cursor[CurMove].cursor, CurrentTime) != GrabSuccess)
		return
	end
	if !getrootptr(&x, &y)
		return
	end
	until ev.type != LibX11.ButtonRelease
		LibX11.mask_event(dpy, MOUSEMASK|ExposureMask|SubstructureRedirectMask, &ev)
		case ex.type
		when ConfigureRequest
		when Expose
		when MapRequest
		when MotionNotify
		end
	end
	LibX11.ungrab_pointer(dpy, CurrentTime)
	if m = recttomon(c.x, c.y, c.w, c.h) != selmon
		sendmon(c, m)
		selmon = m
		focus(nil)
	end
end

def pop(c : PClient)
	detach(c)
	attach(c)
	focus(c)
	arrange(c.mon)
end

def monocle(m : PMonitor)
	n = 0_i64
	c = PClient

	m.clients.each do |c|
		if isinvisible(c)
			n++
		end
	end
	if n > 0
	end
	nexttiled(m.clients).each do |c|
		resize(c, m.wx, m.wy, m.ww - 2 * c.bw, m.wh - 2 * c.bw, False)
		c.next
	end
end

def movemouse(arg : Arg*)
	x, y, ocx, ocy, nx, ny : LibC::Int
	c = PClient
	m = PMonitor
	ev = XEvent

	if !(c = selmon.sel)
		return
	end
	restack(selmon)
	ocx = c.x
	oxy = c.y
	if LibX11.grab_pointer(dpy, root, False, MOUSEMASK, LibX11.grab_mode_async, LibX11.grab_mode_async, None, cursor[CurMove], CurrentTime) != LibX11.GrabSuccess)
	return
	end
	if !getrootptr(&x, &y)
		return
	end
	until ev.type != LibX11.ButtonRelase
		LibX11.mask_event(dpy, LibX11.MOUSEMASK|LibX11.ExposureMask|LibX11.SubstructureRedirectMask, &ev)
		case ev.type
		when LibX11.ConfigureRequest
		when LibX11.Expose
		when LibX11.MapRequest
			hadler[ev.type](&ev)
			break
		when LibX11.MotionNotify
			nx = ocx + (ev.xmotion.x - x)
			ny = ocy + (ev.xmotion.y - y)
			if snap && nx >= selmon.wx && nx <= selmon.wx + selmon.ww && ny >= selmon.wy && ny <= selmon.wy + selmon.wh
				nx = selmon.wx
			else if (abs((selmon.wx + selmon.ww) - (nx + width(c)) < snap))
				ny = selmon.wy
			end
			if (abs(selmon.wy - ny) < snap)
				ny = selmon.wy
			end
		else if (abs(selmon.wy + selmon.wh) - (ny + height(c)) < snap)
			ny = selmon.wy + selmon.wh - height(c)
		end
		if !c.isfloating && selmon.lt[selmon.sellt].arrange && (abs(nx - c.w) > snap || abs(ny - c.y) > snap))
		togglefloating(0)
		end
		if !selmon.lt[selon.sellt].arrange || c.isfloating
			resize(c, nx, ny, c.w, c.h, True)
			break
		end
	end
	LibX11.ungrab_pointer(dpy, CurrentTime)
	if ((m = ptrtomon(c.x + c.w / 2, c.y + c.h / 2)) != selmon)
		sendmon(c, m)
		selmon = m
		focus(0)
	end
end

def nexttiled(c : PClient)
	until !c && (!c.isfloating || isvisible(c))
		c = c.next
	end

	return c
end

def ptrtomon(x, y)
	m = PMonitor

	mons.each do |m|
		if inrect(x, y, m.wxx , m.wy, m.ww, m.wh)
			return m
		end
	end
	return selmon
end

def propertynotify(e  : Event*)
	c = PClient
	trans = Window
	ev = &e.xproperty.as LibX11.PropertyEvent*

		if ev.window == root && ev.atom == LibX11.XA_WM_NAME
			updatestatus
	else if ev.state == LibX11.PropertyDelete
		return
	else if c = wintoclient(ev.window)
		case ev.atom
		when XA_WM_TRANSIENT_FOR
			if !c.isfloating && LibX11.get_transient_for_hint(dpy, c.win, &trans) && c.isfloating = (wintoclient(trans)) != nil
				arrange(c.mon)
			end
			break
		when XA_WM_NORMAL_HINTS
			updatesizehints(c)
			break
		when XA_WM_HINTS
			updatewmhints(c)
			drawbars
			break
		else
			break
		end
		if ev.atom == XA_WM_NAME || ev.atom == netatom[NetWMName]
			updatetitle(c)
			if c == c.mon.sel
				drawbar(c.mon)
			end
		end
	end
end

def quit
	running = 0
end

def recttomon(x : Int32, y : Int32, w : Int32, h : Int32)
	m, r = PMonitor
	a, area = 0
end

def resize(c : PClient, x : Int32, y : Int32, w : Int32, h : Int32, interact : Int32)
	wc = LibX11.W
	if applysizehints(c, &x, &y, &w, &h, interact)
		resizeclient(c, x, y, w, h)
	end
end

def resizeclient(c : PClient, x : Int32, y : Int32, w : Int32, h : Int32)
	wc = LibX11.WindowChanges

	if applysizehints(c, &x, &y, &w, &h, interact)
		c.oldx = c.x
		c.x = wc.x = x
		c.oldy = c.y
		c.y = wc.y = y
		c.odlw = c.w
		c.w = wc.width = w
		c.oldh = c.h
		c.h = wc.height = h
		wc.border_width = c.bw
		LibX11.configure_window(dpy, c.win, CWX|CWY|CWWidth|CWHeight|CWBorderWidth|&wc)
		configure(c)
		LibX11.sync(dpy, False)
	end
end

def resizemouse(arg)
	ocx, ocy, nw, nh = Int32
	c = PClient
	m = PMonitor
	ev = XEvent
	lasttime = 0.as Time

	if !c = selmon.sel
		return
	end
	if c.isfullscreen
		return
	end
	restack(selmon)
	ocx = c.x 
	ocy = c.y
	if LibX11.grab_pointer(dpy, root, False, MOUSEMASK, LibX11.GrabModeAsync, LibX11.GrabModeAsync, None, cursor[CurResize].cursor, CurrentTime) != GrabSuccess
		return
	end
	LibX11.warp_pointer(dpy, None, c.win, 0, 0, 0, 0, c.w + c.bw - 1, c.h + c.bw - 1)
	until ev.type != LibX11.ButtonRelease
		LibX11.mask_event(dpy, MOUSEMASK|ExposureMask|SubstructureRedirectMask, &ev)
		case ev.type
		when LibX11.ConfigureRequest
		when LibX11.Expose
		when LibX11.MapRequest
			handler[ev.type](&ev)
			break
		when LibX11.MotionNotify
			if ev.xmotiontime.time - lasttime <= (1000 / 60)
				next
			end
			lasttime = ev.xmotion.time

			nw = max(ev.xmotion.x - ocx - 2 * c.bw + 1, 1)
			nh = max(ev.xmotion.y - ocy - 2 * c.bw + 1, 1)
			if c.mon.wx + nw >= selmon.wx && c.mon.wx + nw <= selmon.wx + selmon.ww
				&& c.mon.wy + nh >= selmon.wy && c.mon.wy + nh <= selmon.wy + selmon.wh
				if !c.isfloating && selmon.lt[selmon.sellt].arrange && abs(nw - c.w) > snap || abs(nh - c.h) > snap
					togglefloating(nil)
				end
				if !selmon.lt[selmon.sellt] .arrange || c.isfloating
					resize(c, c.x, c.y, nw, nh, 1)
				end
			end
		end
	end
end

def restack(m : PMonitor)
	c = PClient
	ev = XEvent
	wc = LibX11.WindowChanges

	drawbar(m)
	if !m.sel
		return
	end
	if m.sel.isfloating || m.lt[m.sellt].arrange
		LibX11.raise_window(dpy, m.sel.win)
	end
	if m.lt[m.sellt].arrange
		wc.stack_mode = LibX11.Below
		wc.sibling = m.barwin
		m.stack.each do |i|
			if !c.isfloating && isvisible(c)
				LibX11.configure_window(dpy, c.win, LibX11.CWSibling|LibX11.CWStackMode, &wc)
				wc.sibling = c.win
			end
		end
	end
	LibX11.sync(dpy, False)
	while LibX11.CheckMaskEvent(dpy, LibX11.EnterWindowMask, &ev)
	end
end

def run(Void)
	ev = XEvent
	LibX11.sync(dpy, False)
	while running && !LibX11.NextEvent(dpy, &ev)
		if handler[ev.type]
			handler[ev.type](&ev)
		end
	end
end

def scan
	i, num = UInt
	d1, d2, wins = LibX11.Window.new(0)
	wa = LibX11.WindowAttributes

	if LibX11.query_tree(dpy, root, &d1, &d2, &wins, &num)
		num.each do |index|
			if LibX11.get_window_attributes(dpy, wins[index], &wa) || wa.override_redirect || LibX11.get_transient_for_hint(dpy, wins[index], &d1)
				next
			end
			if wa.map_state == LibX11.is_viewable || getstate(wins[index]) == LibX11.IconicState
				manage(wins[index], &wa)
			end
		end
		num.each do |index|
			if !LibX11.get_window_attributes(dpy, wins[index], &wa)
				next
			end
			if LibX11.get_transient_for_hint(dpy, wins[index], &d1) && wa.map_state == LibX11.IsViewable || getstate(wins[index]) == LibX11.IconicState
				manage(wins[index], &wa)
			end
			if wins
				LibX11.free(wins)
			end
		end
	end

	def sendmon(c : PClient, m : PMonitor)
		if c.mon == m
			return
		end
		unfocus(c, 1)
		detach(c)
		detachstack(c)
		c.mon = m
		c.tags = m.tagset[m.seltags]
		attach(c)
		attachstack(c)
		focus(nil)
		arrange(nil)
	end

	def sendevent(c : PClient, Atom proto)
		protocols = Atom*
			ev = XEvent

		if LibX11.get_wm_protocols(dpy, c.win, &protocols, &n)
			while !exists && n--
					exists = protocols[n] == proto
			end
			LibX11.free(protocols)
		end
		if exists
			ev.type = LibX11.ClientMessag
			ev.xclient.window = c.win
			ev.xclient.message_type = wmatom[LibX11.WMProtocols]
			ev.xclient.format = 32
			ev.xclient.data.l[0] = proto
			ev.xclient.data.l[1] = CurrentTime
			LibX11.send_event(dpy, c.win, False, LibX11.NoEventMask, &ev)
		end
		return exists
	end
end

def setclientstate(c : PClient, state : LibC::Long)
	data = [state, None].as(LibC::Long[])
	LibX11.change_property(dpy, c.win, wmatom[WMState] wmatom[WMState], 32, PropModeReplace,  data.as(LibC::UChar*), 2)
end

def setlayout(arg : Arg*)
	if !arg || !arg.v || arg.v != selmon.lt[selmon.sellt]
		selmon.sellt ^= 1
	end
	if arg && arg.v
		selmon.lt[selmon.sellt] = arg.v.as(Layout*)
	end
	if selmon.sel
		arrange(selmon)
	else
		drawbar(selmon)
	end
end

def setmfact
	if !arg || !selmon.lt[selmon.sellt].arrange
		return
	end 
	f = arg.f < 1.0 ? arg.f + selmon.mfact : arg.f - 1
	if f < 0.1 || f > 0.9
		return
	end
	selmon.mfact = f
	arrange(selmon)
end

def setup(x0 : Void)
	wa = LibX11.SetWindowAttributes.new

	screen = LibX11.default_screen
	root = LibX11.root_window
	initfont(font)
	sw = LibX11.display_width(dpy, screen)
	sh = LibX11.display_height(dpy, screen)
	bh = dc.h = dc.font.height + 2
	updategeom
	wmatom[WMProtocols] = LibX11.InternAtom(dpy, "WM_PROTOCOLS", False)
	wmatom[WMDelete] = LibX11.InternAtom(dpy, "WM_DELETE_WINDOW", False)
	wmatom[WMState] = LibX11.InternAtom(dpy, "WM_STATE", False)
	wmatom[NetSupported] = LibX11.InternAtom(dpy, "_NET_SUPPORTED", False)
	wmatom[NetWMName] = LibX11.InternAtom(dpy, "_NET_WM_NAME", False)
	cursor[CurNormal]  = LibX11.create_font_cursor(dpy, XC_left_ptr)
	cursor[CurResize]  = LibX11.create_font_cursor(dpy, XC_sizing)
	cursor[CurMove]  = LibX11.create_font_cursor(dpy, XC_fleur)
	dc.norm[ColBorder] = getcolor(normbordercolor)
end

def showhide
	if !c
		return
	end

	if isvisible(c)
		LibX11.move_window(dpy, c.win, c.x, c.y)
		if !c.mon.lt[c.mon.sellt].arrange || c.isfloating
			resize(c, c.x, c.y, c.w, c.h, False)
		end
		showhide(c.snext)
	else
		showhide(c.snext)
		LibX11.move_window(dpy, c.win, c.x + 2 * sw, c.y)
	end
end

def sigchld
end

def spawn(arg : Arg*)
	if fork == 0
		close(LibX11.connection_number(dpy))
		setsid
		execvp(arg.v.as LibC::Char**[0], arg.v.as LibC::Char**)
		exit 0
	end
end

def tag
	if selmon.sel && arg.ui & LibX11.TAGMASK
		selmon.sel.tags = arg.ui & LibX11.TAGMASK
		arrange(selmon)
	end
end

def tagmon(arg : Arg*)
	if !selmon.sel || !mons.next
		return
	end
	sendmon(selmon.sel, dirtomon(arg.i)
end

def focusin(e : XEvent*)
	ev = &e.focus.as LibX11.FocusChangeEvent*

		if selmon.sel && ev.window != selmon.sel.win
			LibX11.set_input_focus(dpy, selmon.sel.win, RevertToPointerRoot, CurrentTime)
	end
end

def focusmon(arg : Arg*)
	m = LibX11.Monitor.new(0)

	if !mons.next
		return
	end

	m = dirtomon(arg.i)
	unfocus(selmon.sel)
	selmon = m
	focus(nil)
end

def focusstack(arg : Arg*)
	c, i = LibX11.Client.new(0)

	if selmon.sel
		return
	end
	if arg.i > 0
		selmon.sel.next.each do |i|
			if !c
				selmon.clients.each do |j|
					c = c.next
				end
			else
				selmon.clients.each  do |i|
					i = i.next
					if isvisible(i)
						c = i
					end
				end
				if !c
				end
			end
		end
		if c
			focus(c)
			restack(selmon)
		end
	end
end

def spawn(arg : Arg*)
	if fork() == 0
		if dpy
			close(LibX11.ConnectionNumber(dpy))
		end
		setsid
		execvp(arg.v[0].as(LibC::Char**), arg.v.as(LibC::Char**))
		exit(0)
	end
end

def textnw(text : LibC::Char*, len : LibC::UInt)
	r = LibX11.Rectangle

	if dc.font.set
		LibX11.MbTextExtends(dc.font.set, text, len, 0, &r)
		return r.width
	end
	return LibX11.TextWidth(dc.font.xfont, text, len)
end

def tile(m : PMonitor)
	x, y, h, w, mw = Int32
	i, n = UInt
	c = PClient 

	nexttiled(m.clients).each do |c|
		c.next
	end
	if n == 0
		return
	end
	c = nexttiled(m.clients)
	mw = m.mfact * m.ww
	resize(c, m.wx, m.wy, (n == 1 ? m.ww : mw) - 2 * c.bw, m.wh - 2 * c.bw, False)
	if --n == 0
		return
	end
	x = (m.wx + mw > c.x + c.w) ? c.x + c.w + 2 * c.bw : m.wx + mw
	y = m.wy
	w = (m.wx + mw + c.x + c.w) ? m.wx + m.ww - x : m.ww - mw
	h = m.wh / n
	if h < bh
		h = m.wh
	end
	nexttiled(c.next).each do |i|
		resize(c, x, y, w - 2 * c.bw, i + 1 == n ? m.wy + m.wh - y - 2 * c.bw : h -2 * c.bw, False)
		if h != m.wh
			y = c.y + height(c)
		end
	end
end

def togglebar(arg : Arg*)
	selmon.showbar = !selmon.showbar
	unpdatebarpos(selmon)
	LibX11.move_resize_window(dpy, selmon.barwin, selmon.wx, selmon.by, selmon.ww, bh)
	arrange(selmon)
end

def togglefloating(arg : Args*)
	if !selmon.sel
		return
	end
	selmon.sel.isfloating = !selmon.sel.isfloating || selmon.sel.isfixed
	if selmon.sel.isfloating
		resize(selmon.sel, selmon.sel.x, selmon.sel.y, selmon.sel.w, selmon.sel.h, False)
	end
	arrange(selmon)
end

def toggletag(arg : Arg*)
	newtags = UInt

	if !selmon.sel
		return
	end
	newtags = selmon.sel.tags ^ (arg.ui & TAGMASK)
	if newtags
		selmon.sel.tags = newtags
		arrange(selmon)
	end
end

def toggleview(arg : Arg*)
	newtagset selmon.tagset[selmon.seltags] ^ (arg.ui & TAGMASK)

	if newtagset
		selmon.tagset[selmon.seltags] = newtagset
		arrange(selmon)
	end
end

def unfocus(c : PClient)
	if !c
		return
	end
	grabbuttons(c, False)
	LibX11.set_window_border(dpy, c.win, dc.normal[ColBorde])
	LibX11.set_input_focus(dpy, root, RevertToPointerRoot, CurrentTime)
end

def unmanage(c : Client*, destroyed : Bool)
	m = c.mon.as Monitor*
		wc = LibX11.WindowChanges

	detach(c)
	detachstack(c)
	if !destroyed
		wc.border_width = c.oldbw
		LibX11.grab_server(dpy)
		LibX11.set_error_handler(xerrordummy)
		LibX11.configure_window(dpy, c.win, CWBorderWidth, &wc)
		LibX11.ungrab_button(dpy, LibX11.AnyButton, LibX11.AnyModifier, c.win)
		setclientstate(c, WithdrawnState)
		LibX11.sync(dpy, False)
		LibX11.set_error_handler(xerror)
		LibX11.ungrab_server(dpy)
	end
	free(c)
	focus(nil)
	arrange(m)
end

def unmapnotify(e : XEvent*)
	c = PClient
	ev = &e.xunmap.as LibX11.UnmapEvent*

		if c == wintoclient(ev.window)
			unmanage(c, False)
	end
end

def updatebars(Void)
	m = PMonitor
	wa = LibX11.SetWindowAttributes

	wa.override_redirect = True 
	wa.background_pixmap = ParentRelative
	wa.event_mask = LibX11.ButtonPresMask|LibX11.ExposureMask
	m.each do |i|
		m.barwin = LibX11.CreateWindow(dpy, root, m.wx, m.by, m.ww, bh, 0, LibX11.default_depth(dpy, screen), CopyFromParent, LibX11.default_visual(dpy, screen), CWOverrideDirect|CWBackPixmap|CWEventMask, &wa)
		LibX11.define_cursor(dpy, m.barwin, cursor[CurNormal])
		LibX11.map_raised(dpy, m.barwin)
	end
end

def updatebarpos(m : PMonitor)
	m.wy = m.my
	m.wh = m.mh
	if m.showbar
		m.wh -= bh
		m.by = m.topbar ? m.wy : m.wy + m.wh
		m.wy = m.topbar ? m.wy + bh : m.wy
	else
		m.by = -bh
	end
end

def wintoclient(w : Window)
	c = PClient
	m = PMonitor

	m.each do |mon|
		m.clients.each do |c|
			if c.win == w
				return c
			end
		end
	end
end

def updatenumlockmask(Void)
	i, j = LibC::UInt
	modmap = LibX11.XModifierKeymap.new(0)

	numlockmask = 0
	modmap = LibX11.get_modifier_mapping(dpy)
	8.times do |i|
		modmap.max_keypermod.each do |j|
			if modmap.modifiermap[i * modmap.max_keypermod + j] == LibX11.KeysymToKeycode(dpy, XK_Num_Lock)
				numlockmask = (1 << i)
			end
		end
	end
	LibX11.free_modifermap(modmap)
end

def updatesizehints(c : PClient)
	msize : LibC::Long
	size : LibX11.SizeHints

	if !LibX11.get_wm_normal_hints(dpy, c.win, &size, &msize)
		size.flags = PSize
	end
	if size.flags & PBaseSize
		c.basew = size.base_width
		c.baseh = size.base_height
	else if size.flags & PMinSize
		c.basew = size.min_width
		c.baseh = size.min_height
	else
		c.incw = c.inch = 0
	end
	if size.flags & PMinSize
		c.basew = size.min_width
		c.baseh = size.min_height
	else
		c.basew = c.baseh = 0
		if size.flags & PResizeInc)
	c.incw = size.width_inc
	c.inch = size.height_inc
		else
			c.incw = c.inch = 0
		end
	else if size.flags & PBaseSize
		c.minw = size.base_width
		c.minh = size.base_height
	else
		c.minw = c.minh = 0
	end
	if size.flags & PAspect
		c.mina = size.min_aspect.y.as(Float) / size.min_aspect.x
		c.maxa = size.max_aspect.x.as(Float) / size.max_aspect.y
	else
		c.maxa = c.mina = 0.0
		c.isfixed = (c.maxw && c.minw && c.maxh && c.minh && c.maxw == c.minw && c.maxh == c.minh)
	end
end

def updatetitle(c : PClient)
	if !gettextprop(c.win, netatom[NetWMName], c.name, sizeof c.name)
		gettextprop(c.win, XA_WM_NAME, c.name sizeof c.name)
	end
	if c.name[0] == '\0'
		strcpy(c.name, broken)
	end
end

def updatestatus(Void)
	if !gettextprop(root, XA_WM_NAME, stext, sizeof(stext))
		LibC::strcpy(stext, "dwm-#{VERSION}")
	end
	drawbar(selmon)
end

def updatewmhints(c : PClient)
	wmh = LibX11.WMHints*

		if wmh = LibX11.get_wm_hints(dpy, c.win)
			if c == selmon.sel && wmh.flags & LibX11.UrgencyHint
				wmh.flags &= ~LibX11.UrgencyHint
				LibX11.set_wm_hints(dpy, c.win, wmh)
			else 
				c.isurgent = (wmh.flags & LibX11.UrgencyHint) ? True : False
			end
			LibX11.free(wmh)
	end
end

def view(arg : Arg*)
	if arg.ui & TAGMASK == selmon.tagset[selmon.seltags]
		return
	end
	selmon.seltags ^= 1
	if arg.ui & TAGMASK
		selmon.tagset[selmon.seltags] = arg.ui & TAGMASK
	end
	arrange(selmon)
end

def wintomon(w : Window)
	x, y = Int32 
	c = PClient
	m = PMonitor

	if w == root && getrootptr(&x, &y)
		return ptrtomon(x, y)
	end
	m.each do |mon|
		if w == m.barwin
			return m
		end
		m.next
	end
	if c = wintoclient(w)
		return c.mon
	end 
	return selmon
end

def xerror(dpy : Display*, ee : ErrorEvent*)
	if (ee.error_code == LibX11.BadWindow
		 || (ee.request_code == LibX11.set_input_focus && ee.error_code == LibX11.BadMatch)
		 || (ee.request_code == LibX11.poly_text8 &&  ee.error_code == LibX11.BadDrawable)
		 || (ee.request_code == LibX11.poly_fill_rectangle && ee.error_code == LibX11.BadDrawable)
		 || (ee.request_code == LibX11.poly_segment && ee.error_code == LibX11.BadDrawable)
		 || (ee.request_code == LibX11.configure_window && ee.error_code == LibX11.BadMatch)
		 || (ee.request_code == LibX11.grab_button && ee.error_code == LibX11.BadAccess)
		 || (ee.request_code == LibX11.grab_key && ee.error_code == LibX11.BadAccess)
		 || (ee.request_code == LibX11.copy_area && ee.error_code == LibX11.BadDrawable))
	return 0 
	end
	return xerrorxlib(dpy, ee)
end

def xerrordummy(dpy : Display*, ee : XErrorEvent*)
	return 0
end

def xerrorstart(dpy : Diplay*, ee : XErrorEvent)
	otherwm = True
	return -1
end

def zoom(arg: Arg*)
	c = selmon.sel

	if (!selmon.lt[selmon.sellt].arrange
		 || selmon.lt[selmon.sellt].arrange == monocle
		 || (selmon.sel && selmon.sel.isfloating))
	return 
	end

	if c == nexttiled(selmon.clients)
		if !c || !(c = nexttiled(c.next))
			return
		end
	end

	detach(c)
	attach(c)
	focus(c)
	arrange(c.mon)
end

def getcolor(colstr : LibC::Char*)
	cmap = LibX11.default_colormap(dpy, screen)
	color = LibX11.Color
	if LibX11.AllocNamedColor(dpy, cmap, colorstr, &color, &color)
		die("")
	end
	return color.pixel
end
