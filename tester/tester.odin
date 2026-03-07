package tester

import bt "../brc_term/src"
import bc "../brc_term/src/brc_common"
import "core:fmt"
import "core:time"

main :: proc() {

	init_settings: bc.TerminalInitializationSettings = {
		enable_ctrl_c       = true,
		synchronized_output = true, //Reportedly reduces flickering and artifacts but I'm yet to notice the difference
		fps_limit           = 200,
	}

	size, error := bt.initialize(init_settings)
	if error != .NONE do panic(fmt.tprint(error))
	defer bt.deinitialize()

	bt.enable_mouse()
	defer bt.disable_mouse()

	bt.enable_focus()
	defer bt.disable_focus()

	bt.enable_alternate_buffer()
	defer bt.disable_alternate_buffer()

	bt.clear_screen()

	demo_form()

	bt.start_frame()
	bt.write("Press any key to exit...")
	bt.end_frame()
	bt.wait_input()
}

demo_form :: proc() {
	bt.hide_cursor()
	defer bt.show_cursor()

	fps_start_time := time.now()
	frame_count: int = 0
	fps: int = 0

	keyboard_event: bc.KeyboardEvent = {}

	loop: for {
		input, input_error := bt.get_input()
		if input_error != .NONE {
			panic(fmt.tprint(input_error))
		}

		if kb, ok := input.(bc.KeyboardEvent); ok {
			#partial switch kb.key {
			case .Esc:
				break loop
			}

			keyboard_event = kb
		}

		duration := time.diff(fps_start_time, time.now())
		if duration >= time.Second {
			fps = frame_count
			fps_start_time = time.now()
			frame_count = 0
		}

		size, _ := bt.start_frame()
		bt.set_fg_color({255, 255, 255})
		bt.clear_screen()

		bt.draw_rectangle({{0, 0}, u16(size.x), u16(size.y)}, .Rounded)
		bt.draw_horizontal_line({1, size.y - 3}, uint(size.x) - 2)

		bt.set_cursor_position(0, size.y - 3)
		bt.write(bt.line_charset[.Rounded].junction_right)

		bt.set_cursor_position(size.x - 1, size.y - 3)
		bt.write(bt.line_charset[.Rounded].junction_left)

		bt.set_cursor_position(2, size.y - 2)
		bt.write(fmt.tprint("Size:", size, "FPS:", fps))

		if keyboard_event != {} {
			bt.set_cursor_position(2, 2)
			visualize_keyboard_event(&keyboard_event, {2, 1})
		}

		bt.end_frame()
		frame_count += 1

		free_all(context.temp_allocator)
	}
}

visualize_keyboard_event :: proc(event: ^bc.KeyboardEvent, location: [2]int = {0, 0}) {
	previous_color := bt.get_terminal_info().last_fg_color
	defer bt.set_fg_color(previous_color)

	color_off: [3]u8 = {80, 80, 80}
	color_on: [3]u8 = {80, 190, 255}
	color_highlight: [3]u8 = {255, 255, 190}
	color_white: [3]u8 = {255, 255, 255}

	bt.set_cursor_position(location.x, location.y)
	bt.set_fg_color(event.holding_shift ? color_on : color_off)
	bt.write("[Shift] ")

	bt.set_fg_color(event.holding_control ? color_on : color_off)
	bt.write("[Control] ")

	bt.set_fg_color(color_white)
	bt.write(fmt.tprintf("%v", event.key))

	bt.set_cursor_position(location.x, location.y + 1)
	bt.set_fg_color(color_off)
	bt.write("Rune: ")

	bt.set_fg_color(color_white)
	bt.write(fmt.tprintf("%v", event.rune))

	bt.set_cursor_position(location.x, location.y + 2)
	bt.set_fg_color(color_off)
	bt.write("Bytes (hex): ")

	bt.set_fg_color(color_white)
	bt.write(fmt.tprintf("%x", event.buffer.data[:event.buffer.length]))

	bt.set_cursor_position(location.x + 1, location.y + 4)
	bt.set_fg_color(event.is_escape_sequence ? color_highlight : color_off)
	bt.write("Escape sequence")

	bt.set_cursor_position(location.x + 1, location.y + 5)
	bt.set_fg_color(event.is_graphic ? color_highlight : color_off)
	bt.write("Graphic")

	bt.set_cursor_position(location.x + 1, location.y + 6)
	bt.set_fg_color(event.is_letter ? color_highlight : color_off)
	bt.write("Letter")

	bt.set_cursor_position(location.x + 1, location.y + 7)
	bt.set_fg_color(event.is_digit ? color_highlight : color_off)
	bt.write("Digit")

	bt.set_cursor_position(location.x + 1, location.y + 8)
	bt.set_fg_color(event.is_number ? color_highlight : color_off)
	bt.write("Number")

	bt.set_cursor_position(location.x + 1, location.y + 9)
	bt.set_fg_color(event.is_printable ? color_highlight : color_off)
	bt.write("Printable")

	bt.set_cursor_position(location.x + 1, location.y + 10)
	bt.set_fg_color(event.is_control ? color_highlight : color_off)
	bt.write("Control character")

	bt.set_cursor_position(location.x + 1, location.y + 11)
	bt.set_fg_color(event.is_space ? color_highlight : color_off)
	bt.write("Is space")

	bt.set_cursor_position(location.x + 1, location.y + 12)
	bt.set_fg_color(event.is_punctuation ? color_highlight : color_off)
	bt.write("Punctuation")

	bt.set_cursor_position(location.x + 1, location.y + 13)
	bt.set_fg_color(event.is_symbol ? color_highlight : color_off)
	bt.write("Synbol")
}

