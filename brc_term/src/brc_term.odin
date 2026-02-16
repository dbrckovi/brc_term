package brc_term

import "brc_ansi"
import "brc_common"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:sys/posix"

@(private)
_original_terminal_state: posix.termios = {} // state of terminal before initialization

@(private)
_frame_builder: strings.Builder // String builder which builds a string of ansi sequences for each frame

@(private)
_frame_started: bool = false // Indicates that frame has been started. TODO: Maybe not needed

initialize :: proc {
	initialize_default,
	initialize_with_settings,
}

// Initializes the terminal with default settings
// @returns size of the terminal (x=width, y=height)
initialize_default :: proc() -> ([2]u32, Error) {
	settings: brc_common.TerminalSettings = {
		enable_ctrl_c = true,
	}

	return initialize_with_settings(settings)
}

// Initializes the terminal with specific settings
// @returns size of the terminal (x=width, y=height)
initialize_with_settings :: proc(settings: brc_common.TerminalSettings) -> ([2]u32, Error) {
	ret: [2]u32

	if is_initialized() do return ret, .TERMINAL_ALREADY_INITIALIZED

	state, get_state_ok := get_terminal_state()
	if !get_state_ok do return ret, .GET_TERMINAL_STATE_FAILED
	_original_terminal_state = state

	set_state_error := init_terminal_state(settings)
	if set_state_error != .NONE do return ret, set_state_error

	size, size_error := get_terminal_size()
	if size_error != .NONE do return ret, size_error
	ret = size

	strings.builder_init(&_frame_builder)

	return ret, .NONE
}

// Deinitializes the terminal
deinitialize :: proc() -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	reset_terminal_state() or_return
	_original_terminal_state = {}
	return .NONE
}

// Clears buffers of the last frame and enables drawing/output operations
start_frame :: proc() -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if _frame_started do return .FRAME_ALREADY_STARTED
	strings.builder_reset(&_frame_builder)
	_frame_started = true
	return .NONE
}

// Sends frame buffer to the stdout (screen) and disables drawing/output operations
end_frame :: proc() -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if !_frame_started do return .FRAME_NOT_STARTED
	fmt.print(strings.to_string(_frame_builder))
	os.flush(os.stdout)
	_frame_started = false
	return .NONE
}

// Checks if terminal is initialized by checking if state has been saved
is_initialized :: proc() -> bool {
	return _original_terminal_state != {}
}

// Enables mouse support
enable_mouse :: proc() -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if _frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.enable_mouse()
	return .NONE
}

// Disables mouse support
disable_mouse :: proc() -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if _frame_started do return .INVALID_WHILE_FRAME_STARTED
	brc_ansi.disable_mouse()
	return .NONE
}

// Clears entire screen
clear_screen :: proc() -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if !_frame_started do return .FRAME_NOT_STARTED
	brc_ansi.clear_screen(&_frame_builder)
	return .NONE
}

// Moves the cursor to specified coordinates
set_cursor_position :: proc(x, y: uint) -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if !_frame_started do return .FRAME_NOT_STARTED
	brc_ansi.set_cursor_position(&_frame_builder, x, y)
	return .NONE
}

// Writes a single rune on current cursor location
write_rune :: proc(r: rune) -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if !_frame_started do return .FRAME_NOT_STARTED
	brc_ansi.write_rune(&_frame_builder, r)
	return .NONE
}

// Writes a string on current cursor location
write :: proc(s: string) -> Error {
	if !is_initialized() do return .TERMINAL_NOT_INITIALIZED
	if !_frame_started do return .FRAME_NOT_STARTED
	brc_ansi.write(&_frame_builder, s)
	return .NONE
}

