package brc_term

import "brc_ansi"
import bc "brc_common"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:sys/posix"
import "core:time"

@(private)
_ts: bc.TerminalState = {}

initialize :: proc {
	initialize_default,
	initialize_with_settings,
}

// Initializes the terminal with default settings
// @returns size of the terminal (x=width, y=height)
initialize_default :: proc() -> ([2]int, bc.Error) {
	settings: bc.TerminalInitializationSettings = {
		enable_ctrl_c       = true,
		synchronized_output = true, //Reportedly reduces flickering and artifacts but I'm yet to notice the difference
		fps_limit           = 120,
	}

	return initialize_with_settings(settings)
}

// Initializes the terminal with specific settings
// @returns size of the terminal (x=width, y=height)
initialize_with_settings :: proc(
	settings: bc.TerminalInitializationSettings,
) -> (
	[2]int,
	bc.Error,
) {
	ret: [2]int

	if _ts.initialized do return ret, .TERMINAL_ALREADY_INITIALIZED
	_ts.synchronized_output = settings.synchronized_output

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
	_ts.fps_limit = settings.fps_limit
	_ts.initialized = true

	return ret, .NONE
}

// Clears buffers of the last frame and enables drawing/output operations
start_frame :: proc() -> ([2]int, bc.Error) {
	if !_ts.initialized do return {0, 0}, .TERMINAL_NOT_INITIALIZED
	if _ts.frame_started do return {0, 0}, .FRAME_ALREADY_STARTED
	strings.builder_reset(&_ts.frame_builder)

	if _ts.synchronized_output {
		brc_ansi.mark_synchronized_output_start(&_ts.frame_builder)
	}

	_ts.frame_started = true

	size, error := get_terminal_size()
	if error == .NONE {
		_ts.size = size
	}

	return _ts.size, error
}

// Sends frame buffer to the stdout (screen) and disables drawing/output operations
end_frame :: proc() -> bc.Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return .FRAME_NOT_STARTED

	if _ts.synchronized_output {
		brc_ansi.mark_synchronized_output_end(&_ts.frame_builder)
	}

	fmt.print(strings.to_string(_ts.frame_builder))
	os.flush(os.stdout)
	_ts.frame_started = false

	if _ts.fps_limit > 0 {
		min_frame_ns := time.Second / time.Duration(_ts.fps_limit)
		elapsed := time.diff(_ts.last_frame_time, time.now())
		remaining := min_frame_ns - elapsed
		if remaining > 0 {
			time.sleep(remaining)
		}
	}

	_ts.last_frame_time = time.now()
	return .NONE
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

