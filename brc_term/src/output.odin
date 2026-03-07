package brc_term

import "brc_ansi"
import bc "brc_common"
import "core:strings"

// Enables mouse support
enable_mouse :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.enable_mouse_direct()
	return .NONE
}

// Disables mouse support
disable_mouse :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.disable_mouse_direct()
	return .NONE
}

// Enabled focus detection
enable_focus :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.enable_focus_detection_direct()
	return .NONE
}

// Disables focus detection
disable_focus :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.disable_focus_detection_direct()
	return .NONE
}

// Creates a new buffer
enable_alternate_buffer :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.enable_alternate_buffer_direct()
	return .NONE
}

// Restores the original buffer
disable_alternate_buffer :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.disable_alternate_buffer_direct()
	return .NONE
}

// Clears entire screen
clear_screen :: proc() {
	if _ts.initialized && _ts.frame_started {
		brc_ansi.clear_screen(&_ts.frame_builder)
	} else {
		brc_ansi.clear_screen_direct()
	}
}

// Moves the cursor to specified coordinates
set_cursor_position :: proc(x, y: int) -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED
	brc_ansi.set_cursor_position(&_ts.frame_builder, x, y)
	return .NONE
}

show_cursor :: proc() {
	if _ts.initialized && _ts.frame_started {
		brc_ansi.show_cursor(&_ts.frame_builder)
	} else {
		brc_ansi.show_cursor_direct()
	}
}

hide_cursor :: proc() {
	if _ts.initialized && _ts.frame_started {
		brc_ansi.hide_cursor(&_ts.frame_builder)
	} else {
		brc_ansi.hide_cursor_direct()
	}
}


set_color :: proc(fg: [3]u8, bg: [3]u8) -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED

	if fg != _ts.last_fg_color {
		brc_ansi.set_color(&_ts.frame_builder, fg, true)
	}

	if bg != _ts.last_bg_color {
		brc_ansi.set_color(&_ts.frame_builder, bg, false)
	}

	return .NONE
}

set_fg_color :: proc(fg: [3]u8) -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED

	if fg != _ts.last_fg_color {
		brc_ansi.set_color(&_ts.frame_builder, fg, true)
	}

	return .NONE
}

set_bg_color :: proc(bg: [3]u8) -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED

	if bg != _ts.last_bg_color {
		brc_ansi.set_color(&_ts.frame_builder, bg, false)
	}

	return .NONE
}

// Writes a single rune on current cursor location
write_rune :: proc(r: rune) -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED
	brc_ansi.write_rune(&_ts.frame_builder, r)
	return .NONE
}

// Writes a string on current cursor location
write :: proc(s: string) -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED
	brc_ansi.write(&_ts.frame_builder, s)
	return .NONE
}

