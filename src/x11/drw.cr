def drw_create(dpy : PDisplay, screen : Int32, root : Window, w : UInt32, h : UInt32)
	drw = Pointer.malloc(1, sizeof(Drw))
	drw.dpy = dpy
	drw.screen = screen
	drw.root = root
	drw.w = w
	drw.h = h
	drw.drawable = LibX11.create_pixmap(dpy, root, w, h, DefaultDepth(dpy, screen))
	drw.gc = LibX11.create_gc(dpy, root, 0, nil)
	drw.fontcount = 0
	LibX11.set_line_attributes(dpy, drw.gc, 1, LineSolid, CapButt, JoinMiter)

	return drw
end

def drw_resize(drw : Drw*, w : UInt32, h : UInt32)
	drw.w = w
	drw.h = h
	if drw.drawable
		LibX11.free_pixmap(drw.dpy, drw.drawable)
	end
	drw.drawable = LibX11.create_pixmap(drw.dpy, drw.root, w, h, DefaultDepth(drw.dpy, drw.screen))
end

def drw_free(drw : Drw*)
	i = 0
	while i < drw.fontcount
		drw_font_free(drw.fonts[i])
		i++
	end
	LibX11.free_pixmap(drw.dpy, drw.drawable)
	LibX11.free_gc(drw.dpy, drw.gc)
	free(drw)
end

def drw_font_xcreate(drw : Drw*, fontname : LibC::Char*, fontpattern : FcPattern*)
	xfont = Pointer(XftFont).null
	pattern = Pointer(FcPattern).null

	if fontname
		if (!(xfont = XftFontOpenName(drw.dpy, drw.screen, fontname)))
			puts("error, cannot load font '#{fontname}'")
			return nil
		end
		if (!(pattern = FcNameParse(fontname.as(FcChar8))
				XftFontClose(drw.dpy, xfont)
				return nil
		end
	else if fontpattern
		if (!(xfont = XftFontOpenPattern(drw.dpy, fontpattern)))
			puts("error, cannot load font pattern.")
			return nil
		end
	else
		die("no font specified")
	end

	font = Pointer.malloc(1, sizeof(Fnt))
	font.xfont = xfont
	font.pattern = pattern
	font.ascent = xfont.ascent
	font.descent = xfont.descent
	font.h = font.ascent + font.descent
	font.dpy = drw.dpy

	return font
end

def drw_font_create(drw : Drw*, fontname : Char*)
	return drw_font_xcreate(drw, fontname, nil)
end

def drw_load_fonts(drw : Drw*, fonts : Array(Char*), fontcount : LibC::SizeT)
	fontcount.times do |i|
		if drw.fontcount >= DRW_FONT_CACHE_SIZE
			die("font cache exhausted.")
		else if font == drw_font_xcreate(drw, fonts[i], nil)
			drw.fonts[drw.fontcount++] = font
		end
	end
end

def drw_font_free(font : Font*)
	if !font
		return
	end
	if font.pattern
		FcPatternDestroy(font.pattern)
	end
	XftFontClose(font.dpy, font.xfont)
	free(font)
end

def drw_clr_create(drw : Drw*, clrname : Char*)
	clr = Pointer.malloc(1, sizeof(Clr))
	if !XftColorAllocName(drw.dpy, DefaultVisual(drw.dpy, drw.screen), clrname, pointerof(clr.rgb))
		die("error, cannot allocate color '#{clrname}'")
	end
	clr.pix = clr.rgb.pixel

	return clr
end

def drw_clr_free(clr : Clr*)
	free(clr)
end

def drw_setscheme(drw : Drw*, scheme : ClrScheme*)
	drw.scheme = scheme
end

def drw_rect(drw : Drw*, x : Int32, y : Int32, w : Int32, h : Int32, filled : Int32, empty : Int32, invert : Int32)
	if !drw.scheme
		return
	end
	LibX11.set_foreground(drw.dpy, drw.gc, invert ? drw.scheme.bg.pix : drw.scheme.fg.pix)
	if filled
		LibX11.fill_rectangle(drw.dpy, drw.drawable, drw.gc, x, y, w + 1, h + 1)
	else if empty
		LibX11.draw_rectangle(drw.dpy, drw.drawable, drw.gc, x, y, w, h)
	end
end

def drw_text(drw : Drw*, x : Int32, y : Int32, w : UInt32, h : UInt32, text : Char*, invert : Int32)
	d = Pointer(XftDraw.new(0))
	utf8codepoint = 0
	charexists = 0

	if !drw.scheme || !drw.fontcount
		return 0
	end

	if (!(render = x || y || w ||  h))
		w = ~w
	else
		LibX11.set_foreground(drw.dpy, drw.gc, invert ? drw.scheme.fg.pix : drw.scheme.bg.pix)
		LibX11.fill_rectangle(drw.dpy, drw.drawable, drw.gc, x, y, w, h)
		d = XftDrawCreate(drw.dpy, drw.drawable, DefaultVisual(drw.dpy, drw.screen), DefaultColormap(drw.dpy, drw.screen))
	end
	
	curfont = drw.fonts[0]
	loop do
		utf8strlen = 0
		utf8str = text
		nextfont = nil
		while pointerof(text)
			utf8charlen = utf8idecode(text, pointerof(utf8codepoint), UTF_SIZ)
			drw.fontcount.times do |i|
				charexists = charexists || XftCharExists(drw.dpy, drw.fonts[i].xfont, utf8codepoint)
				if charexists
					if drw.fonts[i] == curfont
						utf8strlen += utf8charlen
						text += utf8charlen
					else
						nextfont = drw.fonts[i]
					end
					break
				end
			end
		end
		
		if !charexists || nextfont && nextfont != curfont
			break
		else
			charexists = 0
		end
	end
	
	if utf8strlen
		drw_font_getexts(curfont, utf8str, utf8strlen, pointerof(tex))
		len = min(utf8strlen, sizeof(buf) - 1)
		while len && (tex.w > w - drw.fonts[0].h || w < drw.fonts[0].h)
			drw_font_getexts(curfont, utf8str, len, pointerof(tex))
			len--
		end
		if len
			LibC.memcpy(buf, utf8str, len)
			buf[len] = '\0'
			if len < utf8strlen
				i = len
				while i && i > len - 3
					buf[--i] = '.'
				end
			end

			if render
				th = curfont.ascent + curfont.descent
				ty = y + (h / 2) - (th / 2) + curfont.ascent
				tx = x + (h / 2)
				XftDrawStringUtf8(d, invert ? &drw.scheme.bg.rgb : &drw.scheme.fg.rgb, curfont.xfont, tx, ty, buf.as(XftChar8*), len)
			end
			x += tex.w
			w -= tex.w
		end
		if !pointerof(text)
			break
		else if nextfont
			charexists = 0
			curfont = nextfont
		else 
			charexists = 1

			if drw.fontcount >= DRW_FONT_CACHE_SIZE
				next
			end

			fccharset = FcCharSetCreate()
			FcCharSetAddChar(fccharset, utf8codepoint)

			if !drw.fonts[0].pattern
				die("the first font in the cache must be loaded from a font string.")
			end

			fcpattern = FcPatternDuplicate(drw.fonts[0].pattern)
			FcPatternAddCharSet(fcpattern, FC_CHARSET, fccharset)
			FcPatternAddBool(fcpattern, FC_SCALABLE, FcTrue)

			FcConfigSubstitute(nil, fcpattern, FcMatchPattern)
			FcDefaultSubstitute(fcpattern)
			match = XftFOntMatch(drw.dpy, drw.screen, fcpattern, pointerof(result))

			FcCharSetDestroy(fccharset)
			FcPatternDestroy(fcpattern)

			if match
				curfont = drw_font_xcreate(drw, nil, match)
				if curfont && XftCharExists(drw.dpy, curfont.xfont, utf8codepoint)
					drw.fonts[drw.fontcount++] = curfont
				else
					drw_font_free(curfont)
					curfont = drw.fonts[0]
				end
			end
		end
	end
	if d
		XftDrawDestroy(d)
	end
end

def drw_font_getexts(font : Fnt*, text : Char*, len : UInt32, tex : Extnts*)
	XftTextExtentsUtf8(font.dpy, font.xfont, text.as(XftChar8*), len, pointerof(ext))
	tex.h = font.h
	tex.w = ext.xOff
end

def drw_font_getexts_width(font : Fnt*, text : Char*, len : UInt32)
	drw_font_getexts(font, text, len, pointerof(tex))

	return tex.w
end

def drw_cur_create(drw : Drw*, shape : Int32)
	cur = Pointer.malloc(1, sizeof(Cur))
	cur.cursor = LibX11.create_font_cursor(drw.dpy, shape)

	return cur
end

def drw_cur_free(drw : Drw*, cursor : Cur*)
	if !cursor
		return
	end

	LibX11.free_cursor(drw.dpy, cursor.cursor)
	free(cursor)
end
