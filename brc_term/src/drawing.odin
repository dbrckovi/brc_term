#+feature dynamic-literals
package brc_term

import "core:strings"

STUB_LEFT :: '╴'
STUB_UP :: '╵'
STUB_RIGHT :: '╶'
STUB_DOWN :: '╷'
STUB_BOLD_LEFT :: '╸'
STUB_BOLD_UP :: '╹'
STUB_BOLD_RIGHT :: '╺'
STUB_BOLD_DOWN :: '╻'

// Enumerates line styles used by various drawing procedures
LineStyle :: enum {
	Normal, // Single line
	Bold, // Slightly thicker single line
	Double, // Double line
	Bold_Horizontal, // Vertical lines are bold
	Bold_Vertical, // Horizorntal lines are bold
	Double_Horizontal, // Horizontal lines are double
	Double_Vertical, //Vertical lines are double
	Rounded, // Single line with rounded corners
	PoorMans, // Lines represented with pipes, dashes and slashes
}

// A set of characters used for drawing inter-connecting lines, corners and junctions
LineCharSet :: struct {
	top_left:       string,
	top_right:      string,
	bottom_left:    string,
	bottom_right:   string,
	horizontal:     string,
	vertical:       string,
	junction_down:  string,
	junction_up:    string,
	junction_left:  string,
	junction_right: string,
	cross:          string,
}

// Defines character set for each LineStyle
line_charset := map[LineStyle]LineCharSet {
	.Normal = {
		top_left = "┌",
		top_right = "┐",
		bottom_left = "└",
		bottom_right = "┘",
		horizontal = "─",
		vertical = "│",
		junction_down = "┬",
		junction_up = "┴",
		junction_left = "┤",
		junction_right = "├",
		cross = "┼",
	},
	.Bold = {
		top_left = "┏",
		top_right = "┓",
		bottom_left = "┗",
		bottom_right = "┛",
		horizontal = "━",
		vertical = "┃",
		junction_down = "┳",
		junction_up = "┻",
		junction_left = "┫",
		junction_right = "┣",
		cross = "╋",
	},
	.Double = {
		top_left = "╔",
		top_right = "╗",
		bottom_left = "╚",
		bottom_right = "╝",
		horizontal = "═",
		vertical = "║",
		junction_down = "╦",
		junction_up = "╩",
		junction_left = "╣",
		junction_right = "╠",
		cross = "╬",
	},
	.Bold_Horizontal = {
		top_left = "┍",
		top_right = "┑",
		bottom_left = "┕",
		bottom_right = "┙",
		horizontal = "━",
		vertical = "│",
		junction_down = "┯",
		junction_up = "┷",
		junction_left = "┥",
		junction_right = "┝",
		cross = "┿",
	},
	.Bold_Vertical = {
		top_left = "┎",
		top_right = "┒",
		bottom_left = "┖",
		bottom_right = "┚",
		horizontal = "─",
		vertical = "┃",
		junction_down = "┰",
		junction_up = "┸",
		junction_left = "┨",
		junction_right = "┠",
		cross = "╂",
	},
	.Double_Horizontal = {
		top_left = "╒",
		top_right = "╕",
		bottom_left = "╘",
		bottom_right = "╛",
		horizontal = "═",
		vertical = "│",
		junction_down = "╤",
		junction_up = "╧",
		junction_left = "╡",
		junction_right = "╞",
		cross = "╪",
	},
	.Double_Vertical = {
		top_left = "╓",
		top_right = "╖",
		bottom_left = "╙",
		bottom_right = "╜",
		horizontal = "─",
		vertical = "║",
		junction_down = "╥",
		junction_up = "╨",
		junction_left = "╢",
		junction_right = "╟",
		cross = "╫",
	},
	.Rounded = {
		top_left = "╭",
		top_right = "╮",
		bottom_left = "╰",
		bottom_right = "╯",
		horizontal = "─",
		vertical = "│",
		junction_down = "┬",
		junction_up = "┴",
		junction_left = "┤",
		junction_right = "├",
		cross = "┼",
	},
	.PoorMans = {
		top_left = "-",
		top_right = "-",
		bottom_left = "-",
		bottom_right = "-",
		horizontal = "-",
		vertical = "|",
		junction_down = "-",
		junction_up = "-",
		junction_left = "|",
		junction_right = "|",
		cross = "+",
	},
}

// Draws a rectangle
draw_rectangle :: proc(rect: [4]uint, line: LineStyle = .Normal) {

}

// Draws a "window" wthich uses all characters in a given LineStyle character set
draw_window :: proc(loc: [2]uint, line: LineStyle = .Normal) {

	charset := line_charset[line]

	set_cursor_position(loc.x, loc.y)
	write(charset.top_left)
	write(charset.horizontal)
	write(charset.junction_down)
	write(charset.horizontal)
	write(charset.top_right)

	set_cursor_position(loc.x, loc.y + 1)
	write(charset.vertical)
	write(" ")
	write(charset.vertical)
	write(" ")
	write(charset.vertical)

	set_cursor_position(loc.x, loc.y + 2)
	write(charset.junction_right)
	write(charset.horizontal)
	write(charset.cross)
	write(charset.horizontal)
	write(charset.junction_left)

	set_cursor_position(loc.x, loc.y + 3)
	write(charset.vertical)
	write(" ")
	write(charset.vertical)
	write(" ")
	write(charset.vertical)

	set_cursor_position(loc.x, loc.y + 4)
	write(charset.bottom_left)
	write(charset.horizontal)
	write(charset.junction_up)
	write(charset.horizontal)
	write(charset.bottom_right)
}

// Draws a horizontal line. Any off-screen sections are cropped-off
draw_horizontal_line :: proc(location: [2]uint, length: uint, line: LineStyle = .Normal) {
	if length == 0 || location.x >= _ts.size.x {
		return
	}

	x_end := location.x + length - 1
	if x_end >= _ts.size.x {
		x_end = _ts.size.x - 1
	}

	charset := line_charset[line]

	set_cursor_position(location.x, location.y)
	write(strings.repeat(charset.horizontal, int(x_end - location.x + 1), context.temp_allocator))
}

// Draws a vertical line. Any off-screen sections are cropped-off
draw_vertical_line :: proc(location: [2]uint, length: uint, line: LineStyle = .Normal) {
	if length == 0 || location.y >= _ts.size.y {
		return
	}

	y_end := location.y + length - 1
	if y_end >= _ts.size.y {
		y_end = _ts.size.y - 1
	}

	charset := line_charset[line]

	for y in location.y ..= y_end {
		set_cursor_position(location.x, y)
		write(charset.vertical)
	}
}

