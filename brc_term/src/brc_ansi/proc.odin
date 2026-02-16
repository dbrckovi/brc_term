package brc_ansi

import "core:fmt"
import "core:strings"
import "core:terminal/ansi"

//TODO: Check if color is supported and translate to color depth (terminal.color_enabled and terminal.color_depth)

// Sends ANSI code to terminal which enables mouse support
enable_mouse :: proc() {
	fmt.print(ANY_EVENT + "h", SGR_MOUSE + "h")
}

// Sends ANSI code to terminal which disables mouse support
disable_mouse :: proc() {
	fmt.print(ANY_EVENT + "l", SGR_MOUSE + "l")
}

clear_screen :: proc(sb: ^strings.Builder) {
	strings.write_string(sb, ansi.CSI + "H" + ansi.CSI + "2J")
}

// Creates ansi sequence fo moving cursor to specified location and adds it to string builder
// X - horizontal 0-based coordinate
// Y - vertical 0-based coordinate
set_cursor_position :: proc(sb: ^strings.Builder, x, y: uint) {
	strings.write_string(sb, ansi.CSI)
	strings.write_uint(sb, y + 1)
	strings.write_rune(sb, ';')
	strings.write_uint(sb, x + 1)
	strings.write_string(sb, ansi.CUP)
}

write_rune :: proc(sb: ^strings.Builder, r: rune) {
	strings.write_rune(sb, r)
}

write :: proc(sb: ^strings.Builder, s: string) {
	strings.write_string(sb, s)
}

