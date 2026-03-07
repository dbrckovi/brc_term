#+feature dynamic-literals

package brc_common

import "core:fmt"
import "core:strings"
import "core:sys/posix"
import "core:time"

// These are control characters ASCII table
// I renamed them based on function they have in this library

// ASCII control codes which are mapped to real keys
single_key_control_code := map[rune]Key {
	'\x1b' = .Esc,
	'\x7f' = .Backspace,
	'\x09' = .Tab,
	'\x0d' = .Enter,
}

// ASCII control codes which are mapped to Ctrl+Key
key_with_control_code := map[rune]Key {
	'\x01' = .A,
	'\x02' = .B,
	'\x03' = .C,
	'\x04' = .D,
	'\x05' = .E,
	'\x06' = .F,
	'\x07' = .G,
	'\x0a' = .J,
	'\x0b' = .K,
	'\x0c' = .L,
	'\x0e' = .N,
	'\x0f' = .O,
	'\x10' = .P,
	'\x11' = .Q,
	'\x12' = .R,
	'\x13' = .S,
	'\x14' = .T,
	'\x15' = .U,
	'\x16' = .V,
	'\x17' = .W,
	'\x18' = .X,
	'\x19' = .Y,
	'\x1a' = .Z,
	'\x1f' = .Slash,
	'\x08' = .Backspace,
	'\x00' = .Space,
}

rune_to_key := map[rune]Key {
	'A'  = .A,
	'B'  = .B,
	'C'  = .C,
	'D'  = .D,
	'E'  = .E,
	'F'  = .F,
	'G'  = .G,
	'H'  = .H,
	'I'  = .I,
	'J'  = .J,
	'K'  = .K,
	'L'  = .L,
	'M'  = .M,
	'N'  = .N,
	'O'  = .O,
	'P'  = .P,
	'Q'  = .Q,
	'R'  = .R,
	'S'  = .S,
	'T'  = .T,
	'U'  = .U,
	'V'  = .V,
	'W'  = .W,
	'X'  = .X,
	'Y'  = .Y,
	'Z'  = .Z,
	'0'  = .Number0,
	'1'  = .Number1,
	'2'  = .Number2,
	'3'  = .Number3,
	'4'  = .Number4,
	'5'  = .Number5,
	'6'  = .Number6,
	'7'  = .Number7,
	'8'  = .Number8,
	'9'  = .Number9,
	'/'  = .Slash,
	'\\' = .Backslash,
	':'  = .Colon,
	';'  = .Semicolon,
	'\'' = .Single_Quote,
	'\"' = .Double_Quote,
	'.'  = .Period,
	' '  = .Space,
	'*'  = .Asterisk,
	'`'  = .Backtick,
	'$'  = .Dollar,
	'€'  = .Euro,
	'!'  = .Exclamation,
	'#'  = .Hash,
	'%'  = .Percent,
	'&'  = .Ampersand,
	'_'  = .Underscore,
	'^'  = .Caret,
	','  = .Comma,
	'|'  = .Pipe,
	'@'  = .At,
	'~'  = .Tilde,
	'<'  = .Less_Than,
	'>'  = .Greater_Than,
	'?'  = .Question_Mark,
	'-'  = .Minus,
	'+'  = .Plus,
	'='  = .Equal,
	'('  = .Open_Bracket,
	')'  = .Close_Bracket,
	'{'  = .Open_Curly_Bracket,
	'}'  = .Close_Curly_Bracket,
	'['  = .Open_Square_Bracket,
	']'  = .Close_Square_Bracket,
}

// Defines settings for terminal initialization
TerminalInitializationSettings :: struct {
	enable_ctrl_c:       bool,
	synchronized_output: bool,
	fps_limit:           uint, //recommended value is monitor's refresh rate or slightly higher
}

TerminalState :: struct {
	initialized:         bool,
	protocol:            EventProtocol,
	original_termios:    posix.termios, // state of terminal before initialization
	frame_builder:       strings.Builder, // String builder which builds a string of ansi sequences for each frame
	frame_started:       bool, // Indicates that frame has been started.
	last_fg_color:       [3]u8,
	last_bg_color:       [3]u8,
	synchronized_output: bool, // Reportedly reduces flickering and artifacts but I'm yet to notice the difference
	size:                [2]uint, // Size of the terminal. Updated when get_terminal_size is called
	fps_limit:           uint, // if this is > 0 end_frame will block until enough time has passed since start_frame to approximate this number
	last_frame_time:     time.Time,
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
	key:                Key,
	rune:               rune,
	buffer:             InputBuffer,
	holding_control:    bool,
	holding_shift:      bool,
	is_escape_sequence: bool,
	//TODO: Remove or mark these because they are not reliable for diacritics
	is_digit:           bool,
	is_number:          bool,
	is_graphic:         bool,
	is_letter:          bool,
	is_printable:       bool,
	is_control:         bool,
	is_space:           bool,
	is_punctuation:     bool,
	is_symbol:          bool,
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
	Enter,
	Slash,
	Backslash,
	Colon,
	Semicolon,
	Single_Quote,
	Double_Quote,
	Period,
	Asterisk,
	Backtick,
	Dollar,
	Euro,
	Exclamation,
	Hash,
	Percent,
	Ampersand,
	Underscore,
	Caret,
	Comma,
	Pipe,
	At,
	Tilde,
	Less_Than,
	Greater_Than,
	Question_Mark,
	Minus,
	Plus,
	Equal,
	Open_Bracket,
	Close_Bracket,
	Open_Curly_Bracket,
	Close_Curly_Bracket,
	Open_Square_Bracket,
	Close_Square_Bracket,
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
	Number0,
	Number1,
	Number2,
	Number3,
	Number4,
	Number5,
	Number6,
	Number7,
	Number8,
	Number9,
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
	Unrecognized, // Used for printable characters that are not in the enum because they are not on default keyboards. Usually a diacritic of some sort
}

InputBuffer :: struct {
	data:   [512]byte,
	length: int,
}

