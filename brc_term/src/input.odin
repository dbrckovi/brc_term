package brc_term

import bc "brc_common"
import "core:strings"
import ansi "core:terminal/ansi"
import "core:unicode"
import utf "core:unicode/utf8"

get_input :: proc() -> (event: bc.InputEvent, error: Error) {
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

wait_input :: proc() -> (event: bc.InputEvent, error: Error) {
	if !_ts.initialized do return {}, .TERMINAL_NOT_INITIALIZED

	input, err := read_raw_blocking()

	if err != .NONE {
		return nil, err
	}

	//TODO: detect screen change
	return decode_input(&input)
}

@(private)
decode_input :: proc(input: ^bc.InputBuffer) -> (event: bc.InputEvent, error: Error) {
	switch _ts.protocol {
	case .Ansi:
		return decode_input_ansi(input)
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
decode_input_ansi :: proc(input: ^bc.InputBuffer) -> (event: bc.InputEvent, error: Error) {
	if input.length == 0 {
		return nil, .NONE
	} else {
		event: bc.KeyboardEvent
		event.buffer = input^

		using input

		char, _ := utf.decode_rune_in_bytes(input.data[:input.length])

		/*
			TODO: rewrite this like this:
			 - handle escape and ANSI sequences separately (first byte)
			 - handle control characters separately (report them as letters with Control modifier)
			 - handle everything else with utf functions
		*/

		if unicode.is_letter(char) {
			event.key = bc.rune_to_key[unicode.to_upper(char)] or_else .None
			event.shift = unicode.is_upper(char)
			event.is_letter = true
		} else if unicode.is_graphic(char) {
			event.key = .None
			event.is_graphic = true
		}

		// this is full of some legacy crap
		if length == 1 {

			char, _ := utf.decode_rune_in_bytes(input.data[:input.length])

			if unicode.is_letter(char) {
				// event.key = bc.rune_to_key[unicode.to_upper(char)] or_else .None
				// event.shift = unicode.is_upper(char)
			} else {
				switch string(data[:1]) {
				case bc.KEY_CODE_ESC:
					event.key = .Esc
				case bc.KEY_CODE_DELETE:
					event.key = .Backspace
				case bc.KEY_CODE_BACKSPACE:
					event.key = .Backspace
					event.control = true
				case bc.KEY_CODE_TAB:
					event.key = .Tab
				case bc.KEY_CODE_SPACE:
					event.key = .Space
				case bc.KEY_CODE_NULL:
					event.key = .Space
					event.control = true
				}
			}
		}

		return event, .NONE
	}
}

@(private)
decode_input_kitty :: proc(input: ^bc.InputBuffer) -> (event: bc.InputEvent, error: Error) {
	panic("Kitty protocol not implemented")
}

@(private)
decode_input_windows_console :: proc(
	input: ^bc.InputBuffer,
) -> (
	event: bc.InputEvent,
	error: Error,
) {
	panic("WindowsConsole protocol not implemented")
}

