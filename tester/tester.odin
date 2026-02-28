package tester

import bt "../brc_term/src"
import brc_common "../brc_term/src/brc_common"
import "core:fmt"
import "core:strings"
import "core:time"

main :: proc() {

	init_settings: brc_common.TerminalInitializationSettings = {
		enable_ctrl_c = true,
	}

	size, error := bt.initialize(init_settings)
	if error != .NONE do panic(fmt.tprint(error))
	defer bt.deinitialize()

	bt.enable_mouse()
	defer bt.disable_mouse()

	// simple_test()
	// frame_rate_test()
	blocking_input_test()
	// non_blocking_input_test()
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

	for {
		duration := time.diff(start, time.now())
		if duration > time.Second * 10 do break

		size, error := bt.start_frame()
		if error != {} do panic(fmt.tprint(error))
		// bt.clear_screen()

		for x: uint = 0; x < size.x; x += 1 {
			for y: uint = 0; y < size.y; y += 1 {
				bt.set_fg_color({u8(255 - x), u8(255 - y), u8(x + y)})
				bt.write_rune('.')
			}
		}

		bt.set_cursor_position(0, 0)
		seconds := time.duration_seconds(duration)
		bt.write(fmt.tprint(f64(frames) / seconds))
		bt.set_cursor_position(20, 0)
		bt.write(fmt.tprint(size))

		bt.end_frame()

		input, input_error := bt.get_input()
		if input_error != .NONE {
			panic(fmt.tprint(input_error))
		}

		if input != nil {
			break
		}

		frames += 1
		free_all(context.temp_allocator)
	}

	bt.show_cursor()
}

blocking_input_test :: proc() {
	for {
		bt.start_frame()
		defer bt.end_frame()

		input, err := bt.wait_input()
		bt.clear_screen()

		if err != .NONE {
			panic(fmt.tprint("Input error", err))
		}

		if kb, ok := input.(brc_common.KeyboardEvent); ok {
			bt.write(brc_common.to_string(&kb))
			bt.write("\r\n")

			if (kb.key == .Esc) {
				bt.write("\r\n")
				bt.write("Program exit")
				bt.write("\r\n")
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

