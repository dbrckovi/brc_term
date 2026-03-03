package tester

import bt "../brc_term/src"
import brc_common "../brc_term/src/brc_common"
import "core:fmt"
import "core:strings"
import "core:time"

main :: proc() {

	init_settings: brc_common.TerminalInitializationSettings = {
		enable_ctrl_c       = true,
		synchronized_output = true,
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

	// simple_test()
	frame_rate_test()
	// blocking_input_test()
	// non_blocking_input_test()

	bt.start_frame()
	bt.write("Press any key to exit...")
	bt.end_frame()
	bt.wait_input()
}

simple_test :: proc() {
	bt.start_frame()

	bt.clear_screen()
	bt.set_cursor_position(0, 0)
	bt.write_rune('A')
	bt.set_cursor_position(3, 10)
	bt.write_rune('K')
	bt.write("aaa")
	bt.write(
		"aaa bbbb asd asd asd as da sd asd as da sda sd asd as da sda sd as das das da sda sd asdas das da sda sd as da sda sd asd as da sda sd asd as da sda sd as da sd as da s",
	)

	bt.end_frame()
}

frame_rate_test :: proc() {
	start := time.now()
	frames: int

	bt.hide_cursor()
	color_offset: u8 = 0
	line_x: uint = 0

	for {
		duration := time.diff(start, time.now())

		size, error := bt.start_frame()
		if error != {} do panic(fmt.tprint(error))
		// bt.clear_screen()

		for x: uint = 0; x < size.x; x += 1 {
			for y: uint = 0; y < size.y; y += 1 {
				bt.set_cursor_position(x, y)
				bt.set_fg_color({color_offset, 100, 100})
				bt.write_rune('.')
			}
		}

		if line_x >= size.x {
			line_x = 0
		}

		bt.set_fg_color({255, 255, 255})
		for y: uint = 0; y < size.y; y += 1 {
			bt.set_cursor_position(line_x, y)
			bt.write_rune('X')
		}

		bt.set_cursor_position(0, 0)
		bt.set_fg_color({255, 255, 255})
		seconds := time.duration_seconds(duration)
		bt.write(fmt.tprint(f64(frames) / seconds))
		bt.set_cursor_position(20, 0)
		bt.write(fmt.tprint(size))

		bt.end_frame()

		input, input_error := bt.get_input()
		if input_error != .NONE {
			panic(fmt.tprint(input_error))
		}

		if kb, ok := input.(brc_common.KeyboardEvent); ok {
			if kb.key == .Esc {
				break
			}
		}

		frames += 1
		free_all(context.temp_allocator)

		color_offset += 1
		line_x += 1
	}

	bt.show_cursor()
}

blocking_input_test :: proc() {

	bt.start_frame()
	bt.clear_screen()
	visualize_keyboard_event(&brc_common.KeyboardEvent{})
	bt.end_frame()

	for {
		bt.start_frame()
		defer bt.end_frame()

		input, err := bt.wait_input()
		bt.clear_screen()

		if err != .NONE {
			panic(fmt.tprint("Input error", err))
		}

		if kb, ok := input.(brc_common.KeyboardEvent); ok {
			visualize_keyboard_event(&kb)
			bt.write("\r\n")

			if (kb.key == .Esc) {
				break
			}

		} else {
			bt.write("Unknown event!")
			bt.write("\r\n")
		}
	}
}

non_blocking_input_test :: proc() {
	start := time.now()

	bt.hide_cursor()

	sequence: strings.Builder
	strings.builder_init(&sequence)

	for {
		duration := time.diff(start, time.now())
		if duration > time.Second * 10 do break

		size, error := bt.start_frame()
		if error != {} do panic(fmt.tprint(error))
		bt.clear_screen()

		bt.set_cursor_position(0, 0)

		input, read_error := bt.get_input()

		if input != nil {
			strings.write_string(&sequence, fmt.tprint(input))
		}

		paint_sequence(transmute([]byte)strings.to_string(sequence))
		bt.set_cursor_position(0, size.y - 1)

		seconds := time.duration_seconds(duration)
		bt.write(fmt.tprint(duration))


		bt.end_frame()
		free_all(context.temp_allocator)
	}

	bt.show_cursor()
}

paint_sequence :: proc(sequence: []byte) {
	for b in sequence {
		if b < 32 {
			bt.set_fg_color({255, 200, 150})

			switch b {
			case 0:
				bt.write("NUL ")
			case 1:
				bt.write("SOH ")
			case 2:
				bt.write("STX ")
			case 3:
				bt.write("ETX ")
			case 4:
				bt.write("EOT ")
			case 5:
				bt.write("ENQ ")
			case 6:
				bt.write("ACK ")
			case 7:
				bt.write("BEL ")
			case 8:
				bt.write("BS ")
			case 9:
				bt.write("HT ")
			case 10:
				bt.write("LF ")
			case 11:
				bt.write("VT ")
			case 12:
				bt.write("FF ")
			case 13:
				bt.write("CR ")
			case 14:
				bt.write("SO ")
			case 15:
				bt.write("SI ")
			case 16:
				bt.write("DLE ")
			case 17:
				bt.write("DC1 ")
			case 18:
				bt.write("DC2 ")
			case 19:
				bt.write("DC3 ")
			case 20:
				bt.write("DC4 ")
			case 21:
				bt.write("NAK ")
			case 22:
				bt.write("SYN ")
			case 23:
				bt.write("ETB ")
			case 24:
				bt.write("CAN ")
			case 25:
				bt.write("EM ")
			case 26:
				bt.write("SUB ")
			case 27:
				bt.write("ESC ")
			case 28:
				bt.write("FS ")
			case 29:
				bt.write("GS ")
			case 30:
				bt.write("RS ")
			case 31:
				bt.write("US ")
			}
		} else {
			bt.set_fg_color({255, 255, 255})
			bt.write(fmt.tprintf("%v ", rune(b)))
		}
	}
}

visualize_keyboard_event :: proc(event: ^brc_common.KeyboardEvent) {
	// builder, err := strings.builder_make(context.allocator)
	// if err != nil do panic("Can't create string builder")
	// defer strings.builder_destroy(&builder)
	previous_color := bt.get_terminal_info().last_fg_color
	defer bt.set_fg_color(previous_color)

	color_off: [3]u8 = {80, 80, 80}
	color_on: [3]u8 = {80, 190, 255}
	color_highlight: [3]u8 = {255, 255, 190}
	color_white: [3]u8 = {255, 255, 255}

	bt.set_fg_color(event.holding_shift ? color_on : color_off)
	bt.write("[Shift] ")

	bt.set_fg_color(event.holding_control ? color_on : color_off)
	bt.write("[Control] ")

	bt.set_fg_color(color_white)
	bt.write(fmt.tprintf("%v\r\n", event.key))

	bt.set_fg_color(color_off)
	bt.write("Rune: ")

	bt.set_fg_color(color_white)
	bt.write(fmt.tprintf("%v\r\n", event.rune))

	bt.set_fg_color(color_off)
	bt.write("Bytes (hex): ")

	bt.set_fg_color(color_white)
	bt.write(fmt.tprintf("%x\r\n", event.buffer.data[:event.buffer.length]))

	bt.write("\r\n")

	bt.set_fg_color(event.is_escape_sequence ? color_highlight : color_off)
	bt.write(" - Escape sequence\r\n")

	bt.set_fg_color(event.is_graphic ? color_highlight : color_off)
	bt.write(" - Graphic\r\n")

	bt.set_fg_color(event.is_letter ? color_highlight : color_off)
	bt.write(" - Letter\r\n")

	bt.set_fg_color(event.is_digit ? color_highlight : color_off)
	bt.write(" - Digit\r\n")

	bt.set_fg_color(event.is_number ? color_highlight : color_off)
	bt.write(" - Number\r\n")

	bt.set_fg_color(event.is_printable ? color_highlight : color_off)
	bt.write(" - Printable\r\n")

	bt.set_fg_color(event.is_control ? color_highlight : color_off)
	bt.write(" - Control character\r\n")

	bt.set_fg_color(event.is_space ? color_highlight : color_off)
	bt.write(" - Is space \r\n")

	bt.set_fg_color(event.is_punctuation ? color_highlight : color_off)
	bt.write(" - Punctuation \r\n")

	bt.set_fg_color(event.is_symbol ? color_highlight : color_off)
	bt.write(" - Synbol \r\n")

	bt.write("\r\n\r\n")
}

