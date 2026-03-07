#+feature dynamic-literals
package brc_term

import bc "brc_common"
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

// Draws a rectangle. Any off-screen sections are cropped-off. Minimum size of rectangle is 2x2
draw_rectangle :: proc(rect: bc.Rectangle, line: LineStyle = .Normal) {
	left := rect.loc.x
	right := rect.loc.x + int(rect.w) - 1
	top := rect.loc.y
	bottom := rect.loc.y + int(rect.h) - 1

	if left >= _ts.size.x ||
	   right < 0 ||
	   top >= _ts.size.y ||
	   bottom < 0 ||
	   rect.w < 2 ||
	   rect.h < 2 {
		return
	}

	charset := line_charset[line]
	//top-left corner
	if left >= 0 && left < _ts.size.x && top >= 0 && top < _ts.size.y {
		set_cursor_position(left, top)
		write(charset.top_left)
	}

	//top-right corner
	if right >= 0 && right < _ts.size.x && top >= 0 && top < _ts.size.y {
		set_cursor_position(right, top)
		write(charset.top_right)
	}

	//bottom-left corner
	if left >= 0 && left < _ts.size.x && bottom >= 0 && bottom < _ts.size.y {
		set_cursor_position(left, bottom)
		write(charset.bottom_left)
	}

	//bottom-right corner
	if right >= 0 && right < _ts.size.x && bottom >= 0 && bottom < _ts.size.y {
		set_cursor_position(right, bottom)
		write(charset.bottom_right)
	}

	draw_horizontal_line(rect.loc + {1, 0}, uint(rect.w) - 2, line)
	draw_horizontal_line(rect.loc + {1, int(rect.h) - 1}, uint(rect.w) - 2, line)
	draw_vertical_line(rect.loc + {0, 1}, uint(rect.h) - 2, line)
	draw_vertical_line(rect.loc + {int(rect.w) - 1, 1}, uint(rect.h) - 2, line)
}

// Draws a horizontal line. Any off-screen sections are cropped-off
draw_horizontal_line :: proc(location: [2]int, length: uint, line: LineStyle = .Normal) {
	if length == 0 || location.x >= _ts.size.x || location.y < 0 || location.y >= _ts.size.y {
		return
	}

	start := location.x > 0 ? location.x : 0
	end := location.x + int(length) - 1
	end = end >= _ts.size.x ? _ts.size.x - 1 : end

	if start >= _ts.size.x || end < 0 {
		return
	}

	charset := line_charset[line]

	set_cursor_position(start, location.y)
	write(strings.repeat(charset.horizontal, int(end - start + 1), context.temp_allocator))
}

// Draws a vertical line. Any off-screen sections are cropped-off
draw_vertical_line :: proc(location: [2]int, length: uint, line: LineStyle = .Normal) {
	if length == 0 || location.y >= _ts.size.y || location.x < 0 || location.x >= _ts.size.x {
		return
	}

	start := location.y > 0 ? location.y : 0
	end := location.y + int(length) - 1
	end = end >= _ts.size.y ? _ts.size.y - 1 : end

	if start >= _ts.size.y || end < 0 {
		return
	}

	charset := line_charset[line]

	for y in start ..= end {
		set_cursor_position(location.x, y)
		write(charset.vertical)
	}
}

