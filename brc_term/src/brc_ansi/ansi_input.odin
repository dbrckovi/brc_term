package brc_ansi

import bc "../brc_common"
import "core:fmt"
import "core:strings"
import "core:terminal/ansi"
import "core:unicode"
import utf "core:unicode/utf8"

decode_input_ansi :: proc(input: ^bc.InputBuffer) -> (event: bc.InputEvent, error: bc.Error) {
	if input.length == 0 {
		return nil, .NONE
	} else {
		if string(input.data[:1]) == ansi.ESC && input.length > 1 {
			return decode_ansi_escape_sequence(input)
		} else {
			return decode_ansi_key(input)
		}
	}
}

decode_ansi_escape_sequence :: proc(
	input: ^bc.InputBuffer,
) -> (
	event: bc.InputEvent,
	error: bc.Error,
) {

	/*
	TODO: change this. This is only so that esc works
	Detect if it's a keyboard or mouse sequence (or something else, if there is something else)
	*/

	if input.length == 1 {
		return bc.KeyboardEvent{key = .Esc, buffer = input^}, .NONE
	} else {
		return bc.KeyboardEvent{buffer = input^, is_escape_sequence = true}, .NONE //not necessarily a keyboard event
	}

	/*
	TODO: These are in enum and should be handled here:
	Arrow_Left,
	Arrow_Right,
	Arrow_Up,
	Arrow_Down,
	Page_Up,
	Page_Down,
	Home,
	End,
	Insert,
	Delete,
	F1,
	F2,
	F3,
	F4,
	F5,
	F6,
	F7,
	F8,
	F9,
	F10,
	F11,
	F12,
	*/

	return nil, .NONE
}

// decodes everything that is not an ascii escape sequence
decode_ansi_key :: proc(input: ^bc.InputBuffer) -> (event: bc.KeyboardEvent, error: bc.Error) {
	event.buffer = input^

	char, _ := utf.decode_rune_in_bytes(input.data[:input.length])

	event.rune = char
	event.key = bc.rune_to_key[unicode.to_upper(char)] or_else .None
	event.holding_shift = unicode.is_upper(char)
	event.is_letter = unicode.is_letter(char)
	event.is_graphic = unicode.is_graphic(char)
	event.is_digit = unicode.is_digit(char)
	event.is_number = unicode.is_number(char)
	event.is_printable = unicode.is_print(char)
	event.is_control = unicode.is_control(char)
	event.is_space = unicode.is_space(char)
	event.is_punctuation = unicode.is_punct(char)
	event.is_symbol = unicode.is_symbol(char)

	if event.is_control {
		/*
			ASCII control characters (0-31) are mapped everywhere seemingly willy-nilly
			Some are mapped to real keys (backspace, tab, etc),
			but others are mapped as combination of Ctrl + some other key
		*/
		event.key = bc.single_key_control_code[char] or_else .None

		if event.key == .None {
			event.key = bc.key_with_control_code[char] or_else .None
			if event.key != .None {
				event.holding_control = true
			}
		}
	}


	// if unicode.is_letter(char) {
	// 	event.key = bc.rune_to_key[unicode.to_upper(char)] or_else .None
	// 	event.shift = unicode.is_upper(char)
	// 	event.is_letter = true
	// } else if unicode.is_graphic(char) {
	// 	event.key = .None
	// 	event.is_graphic = true
	// }

	// this is full of some legacy crap
	// if input.length == 1 {

	// 	char, _ := utf.decode_rune_in_bytes(input.data[:input.length])

	// 	if unicode.is_letter(char) {
	// 		// event.key = bc.rune_to_key[unicode.to_upper(char)] or_else .None
	// 		// event.shift = unicode.is_upper(char)
	// 	} else {
	// 		switch string(input.data[:1]) {
	// 		case bc.KEY_CODE_ESC:
	// 			event.key = .Esc
	// 		case bc.KEY_CODE_DELETE:
	// 			event.key = .Backspace
	// 		case bc.KEY_CODE_BACKSPACE:
	// 			event.key = .Backspace
	// 			event.control = true
	// 		case bc.KEY_CODE_TAB:
	// 			event.key = .Tab
	// 		case bc.KEY_CODE_SPACE:
	// 			event.key = .Space
	// 		case bc.KEY_CODE_NULL:
	// 			event.key = .Space
	// 			event.control = true
	// 		}
	// 	}
	// }

	return event, .NONE
}

