package brc_term

import "brc_common"
import "core:strings"

// Returns raw string from standard input if it exists, or {} if there is nothing to read
read_string :: proc(allocator := context.temp_allocator) -> (string, Error) {
	if !_ts.initialized do return {}, .TERMINAL_NOT_INITIALIZED
	if !_ts.frame_started do return {}, .FRAME_NOT_STARTED

	can_read, poll_error := has_input()
	if poll_error != .NONE {
		return {}, poll_error
	}

	if can_read {
		input, read_error := read_raw_blocking()
		if read_error != .NONE {
			return {}, read_error
		}

		cloned, allocation_error := strings.clone(input, allocator)
		if allocation_error != .None {
			return {}, .ALLOCATION_ERROR
		}

		return cloned, .NONE
	} else {
		return {}, .NONE
	}
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

