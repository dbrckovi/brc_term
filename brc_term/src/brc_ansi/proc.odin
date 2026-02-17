package brc_ansi

import "core:fmt"
import "core:strings"
import "core:terminal/ansi"

//TODO: Check if color is supported and translate to color depth (terminal.color_enabled and terminal.color_depth)

// Sends ANSI code to terminal which enables mouse support
enable_mouse_direct :: proc() {
	fmt.print(ANY_EVENT + "h", SGR_MOUSE + "h")
}

// Sends ANSI code to terminal which disables mouse support
disable_mouse_direct :: proc() {
	fmt.print(ANY_EVENT + "l", SGR_MOUSE + "l")
}

clear_screen :: proc(sb: ^strings.Builder) {
	strings.write_string(sb, ansi.CSI + "H" + ansi.CSI + "2J")
}

clear_screen_direct :: proc() {
	fmt.print(ansi.CSI + "H" + ansi.CSI + "2J")
}

// Creates ansi sequence for moving cursor to specified location and adds it to string builder
// X - horizontal 0-based coordinate
// Y - vertical 0-based coordinate
set_cursor_position :: proc(sb: ^strings.Builder, x, y: uint) {
	strings.write_string(sb, ansi.CSI)
	strings.write_uint(sb, y + 1)
	strings.write_rune(sb, ';')
	strings.write_uint(sb, x + 1)
	strings.write_string(sb, ansi.CUP)
}

show_cursor :: proc(sb: ^strings.Builder) {
	strings.write_string(sb, ansi.CSI)
	strings.write_string(sb, ansi.DECTCEM_SHOW)
}

show_cursor_direct :: proc() {
	fmt.print(ansi.CSI + ansi.DECTCEM_SHOW)
}

hide_cursor :: proc(sb: ^strings.Builder) {
	strings.write_string(sb, ansi.CSI)
	strings.write_string(sb, ansi.DECTCEM_HIDE)
}

hide_cursor_direct :: proc() {
	fmt.print(ansi.CSI + ansi.DECTCEM_HIDE)
}

// Creates ansi sequence for setting foreground or background color and adds it to string builder
set_color :: proc(sb: ^strings.Builder, color: [3]u8, foreground: bool) {
	strings.write_string(sb, ansi.CSI)
	strings.write_string(sb, ansi.FG_COLOR if foreground else ansi.BG_COLOR)
	strings.write_string(sb, ";" + TRUE_COLOR + ";")
	strings.write_uint(sb, cast(uint)color.r)
	strings.write_rune(sb, ';')
	strings.write_uint(sb, cast(uint)color.g)
	strings.write_rune(sb, ';')
	strings.write_uint(sb, cast(uint)color.b)
	strings.write_string(sb, ansi.SGR)
}

// Writes a rune to string builder
write_rune :: proc(sb: ^strings.Builder, r: rune) {
	strings.write_rune(sb, r)
}

// Writes a string to string builder
write :: proc(sb: ^strings.Builder, s: string) {
	strings.write_string(sb, s)
}

