package brc_term

import "brc_ansi"
import bc "brc_common"
import "core:strings"
import ansi "core:terminal/ansi"
import "core:unicode"
import utf "core:unicode/utf8"

get_input :: proc() -> (event: bc.InputEvent, error: bc.Error) {
	if !_ts.initialized do return {}, .TERMINAL_NOT_INITIALIZED

	can_read, poll_error := has_input()
	if poll_error != .NONE {
		return nil, poll_error
	}

	if can_read {
		input, read_error := read_raw_blocking()
		if read_error != .NONE {
			return nil, read_error
		}

		//TODO: detect screen change
		return decode_input(&input)} else {
		return nil, .NONE
	}
}

wait_input :: proc() -> (event: bc.InputEvent, error: bc.Error) {
	if !_ts.initialized do return {}, .TERMINAL_NOT_INITIALIZED

	input, err := read_raw_blocking()

	if err != .NONE {
		return nil, err
	}

	//TODO: detect screen change
	return decode_input(&input)
}

@(private)
decode_input :: proc(input: ^bc.InputBuffer) -> (event: bc.InputEvent, error: bc.Error) {
	switch _ts.protocol {
	case .Ansi:
		return brc_ansi.decode_input_ansi(input)
	case .Kitty:
		return decode_input_kitty(input)
	case .WindowsConsole:
		return decode_input_windows_console(input)
	case .None:
		return nil, .NONE
	}

	return nil, .NONE
}

@(private)
decode_input_kitty :: proc(input: ^bc.InputBuffer) -> (event: bc.InputEvent, error: bc.Error) {
	panic("Kitty protocol not implemented")
}

@(private)
decode_input_windows_console :: proc(
	input: ^bc.InputBuffer,
) -> (
	event: bc.InputEvent,
	error: bc.Error,
) {
	panic("WindowsConsole protocol not implemented")
}

