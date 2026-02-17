package brc_ansi

import "core:fmt"
// import "core:terminal"
import "core:terminal/ansi"

// ANSI ESCAPE CODE WIKI:
// https://en.wikipedia.org/wiki/ANSI_escape_code

ANY_EVENT :: ansi.CSI + "?1003"
SGR_MOUSE :: ansi.CSI + "?1006"

TRUE_COLOR :: "2"

