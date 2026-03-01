package brc_term

import bc "brc_common"
import "core:strings"
import "core:sys/posix"

@(private)
_ts: bc.TerminalState = {}

initialize :: proc {
	initialize_default,
	initialize_with_settings,
}

// Initializes the terminal with default settings
// @returns size of the terminal (x=width, y=height)
initialize_default :: proc() -> ([2]uint, bc.Error) {
	settings: bc.TerminalInitializationSettings = {
		enable_ctrl_c = true,
	}

	return initialize_with_settings(settings)
}

// Initializes the terminal with specific settings
// @returns size of the terminal (x=width, y=height)
initialize_with_settings :: proc(
	settings: bc.TerminalInitializationSettings,
) -> (
	[2]uint,
	bc.Error,
) {
	ret: [2]uint

	if _ts.initialized do return ret, .TERMINAL_ALREADY_INITIALIZED

	state, get_state_ok := get_terminal_state()
	if !get_state_ok do return ret, .GET_TERMINAL_STATE_FAILED
	_ts.original_termios = state

	set_state_error := init_terminal_state(settings)
	if set_state_error != .NONE do return ret, set_state_error

	size, size_error := get_terminal_size()
	if size_error != .NONE do return ret, size_error
	ret = size

	strings.builder_init(&_ts.frame_builder)
	_ts.protocol = .Ansi
	_ts.initialized = true

	return ret, .NONE
}

// returns current termina state and other various information
get_terminal_info :: proc() -> bc.TerminalState {
	return _ts
}

// Deinitializes the terminal
deinitialize :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	reset_terminal_state() or_return
	_ts.protocol = .None
	_ts.original_termios = {}
	_ts.initialized = false
	return .NONE
}

