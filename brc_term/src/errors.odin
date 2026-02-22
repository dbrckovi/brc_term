package brc_term

Error :: enum {
	NONE, // No error
	TERMINAL_ALREADY_INITIALIZED, // Terminal can't be initialized again
	TERMINAL_NOT_INITIALIZED, // Terminal must be initialized before this procedure can be called
	GET_WINDOW_SIZE_FAILED, // Failed to get window size
	GET_TERMINAL_STATE_FAILED, // Failed to get terminal state
	SET_TERMINAL_STATE_FAILED, // Failed to set terminal state
	NOT_IMPLEMENTED, // Operation is not yet implemented
	FRAME_NOT_STARTED, // Frame must be started before operation can be called
	FRAME_ALREADY_STARTED, // Frame may not be started before previous frame ended
	INVALID_WHILE_FRAME_STARTED, // Operation may not be called if frame is started
	OS_READ_FAILED, // Occurs when os.read returns an error. TODO: replace
	ALLOCATION_ERROR, // Occurs when some allocation fails. TODO: replace
}

