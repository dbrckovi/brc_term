package brc_ansi

import "core:fmt"
// import "core:terminal"
import "core:terminal/ansi"

// ANSI ESCAPE CODE WIKI:
// https://en.wikipedia.org/wiki/ANSI_escape_code

ANY_EVENT_MOUSE :: ansi.CSI + "?1003" // captures all mouse events
SGR_MOUSE :: ansi.CSI + "?1006" // encodes mouse events with SGR
FOCUS_REPORTING :: ansi.CSI + "?1004" // detects fous got/lost
ALTERNATE_BUFFER :: ansi.CSI + "?1049" // creates an alternative buffer
SYNCHRONIZED_OUTPUT_START :: ansi.CSI + "?2026h" //Designates frame start (prevents "screen tearing")
SYNCHRONIZED_OUTPUT_END :: ansi.CSI + "?2026l" //Designates frame end (prevents "screen tearing")

//TODO: Implement bracketed paste
BRACKETED_PASTE :: ansi.CSI + "?2004" // Pasted text is encapsulated in special sequences
BRACKETED_PASTE_START :: ansi.CSI + "200~" // Designates start of pasted text
BRACKETED_PASTE_END :: ansi.CSI + "201~" // Designates end of pasted text

TRUE_COLOR :: "2"

