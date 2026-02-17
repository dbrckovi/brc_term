package brc_term

import "brc_common"
import "core:c"
import "core:sys/linux"
import "core:sys/posix"

// gets various flags which define terminal behaviour
@(private)
get_terminal_state :: proc() -> (posix.termios, bool) {
	termstate: posix.termios
	ok := posix.tcgetattr(posix.STDIN_FILENO, &termstate) == .OK
	return termstate, ok
}

// sets terminal to a state suitable for TUI
@(private)
init_terminal_state :: proc(settings: brc_common.TerminalInitializationSettings) -> Error {
	previous_state, get_state_ok := get_terminal_state()
	if !get_state_ok do return .GET_TERMINAL_STATE_FAILED

	new_state: posix.termios
	new_state = previous_state

	if settings.enable_ctrl_c do new_state.c_lflag += {.ISIG}
	else do new_state.c_lflag -= {.ISIG}

	new_state.c_lflag -= {.ECHO, .ICANON, .IEXTEN}
	new_state.c_iflag -= {.ICRNL, .IXON}
	new_state.c_oflag -= {.OPOST}
	new_state.c_iflag -= {.BRKINT, .INPCK, .ISTRIP}
	new_state.c_cflag |= {.CS8}

	if posix.tcsetattr(posix.STDIN_FILENO, .TCSAFLUSH, &new_state) != .OK {
		return .SET_TERMINAL_STATE_FAILED
	}
	return .NONE
}

// reverts terminal to a state it was before it was initialized
@(private)
reset_terminal_state :: proc() -> Error {
	if !_ts.initialized do return .TERMINAL_NOT_INITIALIZED

	if posix.tcsetattr(posix.STDIN_FILENO, .TCSAFLUSH, &_ts.original_termios) != .OK {
		return .SET_TERMINAL_STATE_FAILED
	}
	return .NONE
}

// gets current width and height of terminal buffer (x = width, y = height) in characters
get_terminal_size :: proc() -> ([2]u32, Error) {
	ret: [2]u32

	winsize :: struct {
		ws_row, ws_col:       c.ushort,
		ws_xpixel, ws_ypixel: c.ushort,
	}

	w: winsize
	if linux.ioctl(linux.STDOUT_FILENO, linux.TIOCGWINSZ, cast(uintptr)&w) != 0 {
		return ret, .GET_WINDOW_SIZE_FAILED
	}

	ret.x = u32(w.ws_col)
	ret.y = u32(w.ws_row)
	return ret, .NONE
}

