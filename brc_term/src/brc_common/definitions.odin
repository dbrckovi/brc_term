package brc_common

import "core:strings"
import "core:sys/posix"
// import "core:terminal"

// Defines settings for terminal initialization
TerminalInitializationSettings :: struct {
	enable_ctrl_c: bool,
}

TerminalState :: struct {
	initialized:      bool,
	original_termios: posix.termios, // state of terminal before initialization
	frame_builder:    strings.Builder, // String builder which builds a string of ansi sequences for each frame
	frame_started:    bool, // Indicates that frame has been started.
	last_fg_color:    [3]u8,
	last_bg_color:    [3]u8,
	input_buffer:     [512]byte, // Receives raw input from os.read
}

