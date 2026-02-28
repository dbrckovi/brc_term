#+feature dynamic-literals

package brc_common

import "core:fmt"
import "core:strings"
import "core:sys/posix"
// import "core:terminal"

KEY_CODE_ESC :: "\x1b"
KEY_CODE_DELETE :: "\x7f"
KEY_CODE_BACKSPACE :: "\x08"
KEY_CODE_TAB :: "\x09"
KEY_CODE_NULL :: "\x00"
KEY_CODE_SPACE :: "\x20"

rune_to_key := map[rune]Key {
	'A' = .A,
	'B' = .B,
	'C' = .C,
	'D' = .D,
	'E' = .E,
	'F' = .F,
	'G' = .G,
	'H' = .H,
	'I' = .I,
	'J' = .J,
	'K' = .K,
	'L' = .L,
	'M' = .M,
	'N' = .N,
	'O' = .O,
	'P' = .P,
	'Q' = .Q,
	'R' = .R,
	'S' = .S,
	'T' = .T,
	'U' = .U,
	'V' = .V,
	'W' = .W,
	'X' = .X,
	'Y' = .Y,
	'Z' = .Z,
}

// Defines settings for terminal initialization
TerminalInitializationSettings :: struct {
	enable_ctrl_c: bool,
}

TerminalState :: struct {
	initialized:      bool,
	protocol:         EventProtocol,
	original_termios: posix.termios, // state of terminal before initialization
	frame_builder:    strings.Builder, // String builder which builds a string of ansi sequences for each frame
	frame_started:    bool, // Indicates that frame has been started.
	last_fg_color:    [3]u8,
	last_bg_color:    [3]u8,
}

EventProtocol :: enum {
	None,
	Ansi,
	Kitty,
	WindowsConsole,
}

InputEvent :: union {
	KeyboardEvent,
	MouseEvent,
	ResizeEvent,
}

KeyboardEvent :: struct {
	key:        Key,
	buffer:     InputBuffer,
	control:    bool,
	shift:      bool,
	is_letter:  bool,
	is_graphic: bool,
}

MouseEvent :: struct {
	dummy_mouse: int,
}

ResizeEvent :: struct {
	dummy_resize: int,
}

Key :: enum {
	None,
	Esc,
	Backspace,
	Tab,
	Space,
	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
	I,
	J,
	K,
	L,
	M,
	N,
	O,
	P,
	Q,
	R,
	S,
	T,
	U,
	V,
	W,
	X,
	Y,
	Z,
}

InputBuffer :: struct {
	data:   [512]byte,
	length: int,
}

to_string :: proc {
	keyboard_event_to_string,
}

keyboard_event_to_string :: proc(
	event: ^KeyboardEvent,
	allocator := context.temp_allocator,
) -> string {
	builder, err := strings.builder_make(allocator)
	if err != nil do panic("Can't create string builder")

	strings.write_string(&builder, fmt.tprintfln("Key: %v\r", event.key))
	strings.write_string(&builder, fmt.tprintfln("Control: %v\r", event.control))
	strings.write_string(&builder, fmt.tprintfln("Shift: %v\r", event.shift))
	strings.write_string(&builder, fmt.tprintfln("Is letter: %v\r", event.is_letter))
	strings.write_string(&builder, fmt.tprintfln("Is graphic: %v\r", event.is_graphic))
	strings.write_string(
		&builder,
		fmt.tprintfln("Bytes hex: %x\r", event.buffer.data[:event.buffer.length]),
	)
	strings.write_string(
		&builder,
		fmt.tprintfln("Text: %s\r", event.buffer.data[:event.buffer.length]),
	)

	return strings.to_string(builder)
}

