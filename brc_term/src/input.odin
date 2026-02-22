package brc_term

import "brc_common"
import "core:strings"

// Returns raw string from standard input if it exists. Not blocking
read_string :: proc() -> (string, Error) {
	if !_ts.initialized do return {}, .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return {}, .FRAME_NOT_STARTED

	return {}, .NONE
}

// Returns raw string from standard input. If it doesn't exist, blocks until something arrives
wait_string :: proc(allocator := context.temp_allocator) -> (string, Error) {
	if !_ts.initialized do return {}, .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return {}, .FRAME_NOT_STARTED

	input, err := read_raw_blocking()

	if err != .NONE {
		return {}, err
	}

	cloned, allocation_error := strings.clone(input, allocator)
	if allocation_error != .None {
		return {}, .ALLOCATION_ERROR
	}

	return cloned, .NONE
}

