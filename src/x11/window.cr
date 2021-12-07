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

def movemouse(arg : PArg)
	x, y, ocx, ocy, nx, ny = 0
	c = PClient
	Monitor = PMonitor
	lasttime = 0.as(Time)

	if !c = selmon.sel
		return
	end

	if c.isfullscreen
		return
	end

	restack selmon

	ocx = c.x
	ocy = c.y
	if (LibX11.grab_pointer(dpy, root, False, MouseMask, LibX11::GrabModeAsync, LibX11::GrabModeAsync, None, cursor[CurMove].cursor, CurrentTime) != GrabSuccess)
		return
	end
	if !getrootptr(pointerof(x), pointerof(y))
		return
	end
	while
		LibX11.mask_event(dpy, LibX11::MOUSEMASK|LibX11::ExposureMask|LibX11::SubstructureRedirectMask, pointerof(ev))
		case ev.type
		when ConfigureRequest
		when Expose
		when MapRequest
			handler[ev.type] pointerof(ev)
			break
		when MotionNotify
			if ((ev.xmotion.time - lasttime) <= (1000 / 60))
				next
			end
			lasttime = ev.xmotion.time

			nx = ocx + (ev.xmotion.x - x)
			ny = ocy + (ev.xmotion.y - y)
			if (nx >= selmon.wx && nx <= selmon.wx + selmon.ww && nx <= selmon.wx + selmon.ww && ny >= selmon.wy && ny <= selmon.wy + selmon.wh)
				if (abs(selmon.wx - nx) < snap)
				else if (abs((selmon.wx + selmon.ww) - (nx + width(c))) < snap)
				end
				if (abs(selmon.wy - ny) < snap)
				else if (abs((selmon.wy + selmon.wh) - (ny + height(c))) < snap)
				end
				if (!c.isfloating && selmon.lt[selmon.sellt].arrange && (abs(nx - c.x) > snap || abs(ny - c.y) > snap))
					togglefloating(nil)
				end
			end
			if !selmon.lt[selmon.sellt].arrange || c.isfloating
				resize(c, nx, ny, c.w, c.h, 1)
			end
			if ev.type != ButtonRelease
				break
			end
		end
	end
	LibX11.ungrab_pointer(dpy, CurrenTime)
	if (m = recttomon(c.x, c.y, c.w, c.h) != selmon)
		sendmon(c, m)
		selmon = m
		focus(nil)
	end
end

def nexttiled(c : PClient)
	while c.isfloating || !isvisible(c)
		c.next
	end
	return c
end

def pop(c : PClient)
	detach c
	attach c
	focus c
	arrange c.mon
end
