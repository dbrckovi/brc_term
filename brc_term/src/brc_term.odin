package brc_term

import "brc_common"
import "core:strings"
import "core:sys/posix"

@(private)
_ts: brc_common.TerminalState = {}

initialize :: proc {
	initialize_default,
	initialize_with_settings,
}

// Initializes the terminal with default settings
// @returns size of the terminal (x=width, y=height)
initialize_default :: proc() -> ([2]u32, Error) {
	settings: brc_common.TerminalInitializationSettings = {
		enable_ctrl_c = true,
	}

	return initialize_with_settings(settings)
}

// Initializes the terminal with specific settings
// @returns size of the terminal (x=width, y=height)
initialize_with_settings :: proc(
	settings: brc_common.TerminalInitializationSettings,
) -> (
	[2]u32,
	Error,
) {
	ret: [2]u32

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
	_ts.initialized = true


	return ret, .NONE
}

// Deinitializes the terminal
deinitialize :: proc() -> Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	reset_terminal_state() or_return
	_ts.original_termios = {}
	_ts.initialized = false
	return .NONE
}

