package tester

import bt "../brc_term/src"
import brc_common "../brc_term/src/brc_common"
import "core:fmt"
import "core:time"

main :: proc() {

	init_settings: brc_common.TerminalSettings = {
		enable_ctrl_c = true,
	}

	size, error := bt.initialize(init_settings)
	if error != .NONE do panic(fmt.tprint(error))
	defer bt.deinitialize()

	bt.enable_mouse()
	defer bt.disable_mouse()

	// simple_test()
	frame_rate_test()
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

	for {
		duration := time.diff(start, time.now())
		if duration > time.Second * 10 do break

		bt.start_frame()
		bt.clear_screen()

		seconds := time.duration_seconds(duration)
		bt.write(fmt.tprint(f64(frames) / seconds))
		bt.end_frame()
		frames += 1
		free_all(context.temp_allocator)
	}
}

