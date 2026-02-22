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
	//frame_rate_test()
	//blocking_input_test()
	non_blocking_input_test()

	// bt.clear_screen()
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
		frames += 1
		free_all(context.temp_allocator)
	}

	bt.show_cursor()
}

blocking_input_test :: proc() {
	for i in 0 ..= 9 {
		bt.start_frame()
		input, err := bt.wait_string()
		bt.write(", got: ")
		bt.write(input)
		bt.end_frame()
	}
}

non_blocking_input_test :: proc() {
	start := time.now()

	bt.hide_cursor()

	input: strings.Builder
	strings.builder_init(&input)

	for {
		duration := time.diff(start, time.now())
		if duration > time.Second * 10 do break

		size, error := bt.start_frame()
		if error != {} do panic(fmt.tprint(error))
		bt.clear_screen()

		bt.set_cursor_position(0, 0)

		s, read_error := bt.read_string(context.temp_allocator)
		if len(s) > 0 {
			strings.write_string(&input, s)
		}

		for b in transmute([]byte)strings.to_string(input) {
			bt.write(fmt.tprintf("%x ", b))
		}

		bt.set_cursor_position(0, size.y - 1)

		seconds := time.duration_seconds(duration)
		bt.write(fmt.tprint(duration))


		bt.end_frame()
		free_all(context.temp_allocator)
	}

	bt.show_cursor()
}

