================================================================================
UNICODE DRAWING CHARACTERS REFERENCE
================================================================================
A comprehensive collection of box-drawing, block elements, and progress bar
characters for terminal UIs, TUIs, and text-based graphics.
================================================================================

TABLE OF CONTENTS
-----------------
1. Box Drawing - Light (Straight)
2. Box Drawing - Heavy (Thick Straight)
3. Box Drawing - Double
4. Box Drawing - Rounded (Light)
5. Box Drawing - Mixed Styles
6. Block Elements - Solid Shading
7. Block Elements - Partial Vertical
8. Block Elements - Partial Horizontal
9. Block Elements - Quadrants
10. Progress Bar / Graph Elements
11. Arc and Diagonal Elements
12. Special Connectors
13. Braille Patterns
14. Example Usage Patterns
15. Ideas

================================================================================
1. BOX DRAWING - LIGHT (STRAIGHT)
================================================================================

Full Example Box:
┌─┬─┐
│ │ │
├─┼─┤
│ │ │
└─┴─┘

Characters:
-----------
Corners:
  ┌  U+250C  Top-left corner
  ┐  U+2510  Top-right corner
  └  U+2514  Bottom-left corner
  ┘  U+2518  Bottom-right corner

Lines:
  ─  U+2500  Horizontal line
  │  U+2502  Vertical line

T-junctions:
  ┬  U+252C  Down
  ┴  U+2534  Up
  ├  U+251C  Right
  ┤  U+2524  Left

Cross:
  ┼  U+253C  Cross/intersection

Copy-paste set: ┌ ┐ └ ┘ ─ │ ┬ ┴ ├ ┤ ┼

================================================================================
2. BOX DRAWING - HEAVY (THICK STRAIGHT)
================================================================================

Full Example Box:
┏━┳━┓
┃ ┃ ┃
┣━╋━┫
┃ ┃ ┃
┗━┻━┛

Characters:
-----------
Corners:
  ┏  U+250F  Top-left corner
  ┓  U+2513  Top-right corner
  ┗  U+2517  Bottom-left corner
  ┛  U+251B  Bottom-right corner

Lines:
  ━  U+2501  Horizontal line
  ┃  U+2503  Vertical line

T-junctions:
  ┳  U+2533  Down
  ┻  U+253B  Up
  ┣  U+2523  Right
  ┫  U+252B  Left

Cross:
  ╋  U+254B  Cross/intersection

Copy-paste set: ┏ ┓ ┗ ┛ ━ ┃ ┳ ┻ ┣ ┫ ╋

================================================================================
3. BOX DRAWING - DOUBLE
================================================================================

Full Example Box:
╔═╦═╗
║ ║ ║
╠═╬═╣
║ ║ ║
╚═╩═╝

Characters:
-----------
Corners:
  ╔  U+2554  Top-left corner
  ╗  U+2557  Top-right corner
  ╚  U+255A  Bottom-left corner
  ╝  U+255D  Bottom-right corner

Lines:
  ═  U+2550  Horizontal line
  ║  U+2551  Vertical line

T-junctions:
  ╦  U+2566  Down
  ╩  U+2569  Up
  ╠  U+2560  Right
  ╣  U+2563  Left

Cross:
  ╬  U+256C  Cross/intersection

Copy-paste set: ╔ ╗ ╚ ╝ ═ ║ ╦ ╩ ╠ ╣ ╬

================================================================================
4. BOX DRAWING - ROUNDED (LIGHT)
================================================================================

Full Example Box:
╭─┬─╮
│ │ │
├─┼─┤
│ │ │
╰─┴─╯

Characters:
-----------
Corners (ROUNDED):
  ╭  U+256D  Top-left corner (rounded)
  ╮  U+256E  Top-right corner (rounded)
  ╰  U+256F  Bottom-left corner (rounded)
  ╯  U+2570  Bottom-right corner (rounded)

Lines:
  ─  U+2500  Horizontal line (same as light)
  │  U+2502  Vertical line (same as light)

T-junctions:
  ┬  U+252C  Down (same as light)
  ┴  U+2534  Up (same as light)
  ├  U+251C  Right (same as light)
  ┤  U+2524  Left (same as light)

Cross:
  ┼  U+253C  Cross (same as light)

Copy-paste set: ╭ ╮ ╰ ╯ ─ │ ┬ ┴ ├ ┤ ┼

Note: This is what btop uses for its rounded corners!

================================================================================
5. BOX DRAWING - MIXED STYLES
================================================================================

Light Vertical + Heavy Horizontal:
┍━┯━┑
│ │ │
┝━┿━┥
│ │ │
┕━┷━┙

Characters:
  ┍  U+250D  Top-left
  ┑  U+2511  Top-right
  ┕  U+2515  Bottom-left
  ┙  U+2519  Bottom-right
  ┯  U+252F  T-down
  ┷  U+2537  T-up
  ┝  U+251D  T-right
  ┥  U+2525  T-left
  ┿  U+253F  Cross

Copy-paste set: ┍ ┑ ┕ ┙ ┯ ┷ ┝ ┥ ┿

Heavy Vertical + Light Horizontal:
┎─┰─┒
┃ ┃ ┃
┠─╂─┨
┃ ┃ ┃
┖─┸─┚

Characters:
  ┎  U+250E  Top-left
  ┒  U+2512  Top-right
  ┖  U+2516  Bottom-left
  ┚  U+251A  Bottom-right
  ┰  U+2530  T-down
  ┸  U+2538  T-up
  ┠  U+2520  T-right
  ┨  U+2528  T-left
  ╂  U+2542  Cross

Copy-paste set: ┎ ┒ ┖ ┚ ┰ ┸ ┠ ┨ ╂

================================================================================
6. BOX DRAWING - DOUBLE/SINGLE MIXED STYLES
================================================================================

Double Horizontal + Single Vertical:
╒═╤═╕
│ │ │
╞═╪═╡
│ │ │
╘═╧═╛

Characters:
  ╒  U+2552  Top-left
  ╕  U+2555  Top-right
  ╘  U+2558  Bottom-left
  ╛  U+255B  Bottom-right
  ╤  U+2564  T-down
  ╧  U+2567  T-up
  ╞  U+255E  T-right
  ╡  U+2561  T-left
  ╪  U+256A  Cross

--------------------------------------------------------------------------------

Double Vertical + Single Horizontal:
╓─╥─╖
║ ║ ║
╟─╫─╢
║ ║ ║
╙─╨─╜

Characters:
  ╓  U+2553  Top-left
  ╖  U+2556  Top-right
  ╙  U+2559  Bottom-left
  ╜  U+255C  Bottom-right
  ╥  U+2565  T-down
  ╨  U+2568  T-up
  ╟  U+255F  T-right
  ╢  U+2562  T-left
  ╫  U+256B  Cross


================================================================================
6. BLOCK ELEMENTS - SOLID SHADING
================================================================================

Full Blocks (density levels):
█ ▓ ▒ ░

Characters:
  █  U+2588  Full block (100% solid)
  ▓  U+2593  Dark shade (75%)
  ▒  U+2592  Medium shade (50%)
  ░  U+2591  Light shade (25%)

Copy-paste set: █ ▓ ▒ ░

Example usage:
Progress bar: ████▓▓▒▒░░░░

================================================================================
7. BLOCK ELEMENTS - PARTIAL VERTICAL
================================================================================

Left-aligned blocks (8 levels):
█ ▉ ▊ ▋ ▌ ▍ ▎ ▏

Characters:
  █  U+2588  Full block (8/8)
  ▉  U+2589  7/8 block
  ▊  U+258A  6/8 block (3/4)
  ▋  U+258B  5/8 block
  ▌  U+258C  4/8 block (1/2)
  ▍  U+258D  3/8 block
  ▎  U+258E  2/8 block (1/4)
  ▏  U+258F  1/8 block

Right-aligned blocks:
  ▐  U+2590  Right half block
  ▕  U+2595  Right 1/8 block

Copy-paste set: █ ▉ ▊ ▋ ▌ ▍ ▎ ▏ ▐ ▕

Example usage:
Horizontal progress: ▏▎▍▌▋▊▉█

================================================================================
8. BLOCK ELEMENTS - PARTIAL HORIZONTAL
================================================================================

Lower blocks (8 levels, bottom-up):
▁ ▂ ▃ ▄ ▅ ▆ ▇ █

Characters:
  ▁  U+2581  1/8 block
  ▂  U+2582  2/8 block (1/4)
  ▃  U+2583  3/8 block
  ▄  U+2584  4/8 block (1/2)
  ▅  U+2585  5/8 block
  ▆  U+2586  6/8 block (3/4)
  ▇  U+2587  7/8 block
  █  U+2588  8/8 block (full)

Upper blocks:
  ▔  U+2594  Upper 1/8 block
  ▀  U+2580  Upper half block

Copy-paste set: ▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▔ ▀

Example usage:
Bar chart: ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁
Waveform:  ▄▀▄▀▄▀

================================================================================
9. BLOCK ELEMENTS - QUADRANTS
================================================================================

Quarter blocks:
▘ ▝ ▖ ▗

Characters:
  ▘  U+2598  Upper-left quadrant
  ▝  U+259D  Upper-right quadrant
  ▖  U+2596  Lower-left quadrant
  ▗  U+2597  Lower-right quadrant

Three-quarter blocks:
  ▛  U+259B  Upper-left + upper-right + lower-left
  ▜  U+259C  Upper-left + upper-right + lower-right
  ▙  U+2599  Upper-left + lower-left + lower-right
  ▟  U+259F  Upper-right + lower-left + lower-right

Diagonal patterns:
  ▚  U+259A  Upper-left + lower-right
  ▞  U+259E  Upper-right + lower-left

Halves (already listed above):
  ▌  U+258C  Left half
  ▐  U+2590  Right half
  ▀  U+2580  Upper half
  ▄  U+2584  Lower half

Copy-paste set: ▘ ▝ ▖ ▗ ▚ ▞ ▛ ▜ ▙ ▟ ▌ ▐ ▀ ▄

Example usage:
Pixel art, dithering patterns

================================================================================
10. PROGRESS BAR / GRAPH ELEMENTS
================================================================================

Horizontal bars (left-to-right, fine granularity):
▏▎▍▌▋▊▉█

Copy-paste: ▏▎▍▌▋▊▉█

Vertical bars (bottom-to-top, fine granularity):
▁▂▃▄▅▆▇█

Copy-paste: ▁▂▃▄▅▆▇█

Example usage patterns:
--------------------
Progress bar:     [████████▋░░░░░░░] 60%
Sparkline graph:  ▁▂▃▅▆▇█▇▆▅▃▂▁
CPU usage:        ████████░░ 80%
Volume meter:     ▁▃▅▇█
Histogram:        ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁

================================================================================
11. ARC AND DIAGONAL ELEMENTS
================================================================================

Rounded arcs:
  ╭  U+256D  Top-left arc
  ╮  U+256E  Top-right arc
  ╯  U+2570  Bottom-right arc
  ╰  U+256F  Bottom-left arc

Diagonals:
  ╱  U+2571  Light diagonal upper-right to lower-left
  ╲  U+2572  Light diagonal upper-left to lower-right
  ╳  U+2573  Light diagonal cross

ASCII diagonals (for comparison):
  /   Forward slash
  \   Backslash

Copy-paste set: ╭ ╮ ╯ ╰ ╱ ╲ ╳

Example usage:
 ╱╲
╱  ╲
╲  ╱
 ╲╱

================================================================================
12. SPECIAL CONNECTORS
================================================================================

Light stubs (lines that don't connect):
  ╴  U+2574  Left stub
  ╵  U+2575  Up stub
  ╶  U+2576  Right stub
  ╷  U+2577  Down stub

Heavy stubs:
  ╸  U+2578  Heavy left stub
  ╹  U+2579  Heavy up stub
  ╺  U+257A  Heavy right stub
  ╻  U+257B  Heavy down stub

Copy-paste light: ╴ ╵ ╶ ╷
Copy-paste heavy: ╸ ╹ ╺ ╻

Example usage:
Bullet points, partial borders, emphasis

================================================================================
13. BRAILLE PATTERNS (FOR HIGH-RESOLUTION PLOTTING)
================================================================================

Braille characters provide 2×4 pixel resolution per character cell.
Each character can represent 256 combinations (2^8).

Base pattern: ⠀  U+2800  (empty)

Sample patterns:
⠀⠁⠂⠃⠄⠅⠆⠇⡀⡁⡂⡃⡄⡅⡆⡇
⠈⠉⠊⠋⠌⠍⠎⠏⡈⡉⡊⡋⡌⡍⡎⡏
⠐⠑⠒⠓⠔⠕⠖⠗⡐⡑⡒⡓⡔⡕⡖⡗
⠘⠙⠚⠛⠜⠝⠞⠟⡘⡙⡚⡛⡜⡝⡞⡟

Range: U+2800 to U+28FF (256 patterns total)

Usage: High-resolution graphs, plots, and charts in terminal
Libraries like 'plotille' use these for plotting

Example scatter plot:
⠀⠀⠀⢀⣀⠀⠀⠀
⠀⠀⣠⠊⠀⠑⡄⠀
⠀⡰⠁⠀⠀⠀⠈⢆
⡰⠁⠀⠀⠀⠀⠀⠘

================================================================================
14. EXAMPLE USAGE PATTERNS
================================================================================

Simple Box:
╭─────────────╮
│   Content   │
╰─────────────╯

Double Border Box:
╔═════════════╗
║   Content   ║
╚═════════════╝

Progress Panel:
╭──────────────────────────╮
│ CPU  ████████░░  80%     │
│ MEM  ██████░░░░  60%     │
│ DISK ███░░░░░░░  30%     │
╰──────────────────────────╯

Graph/Chart:
╭─ Load Average ───────╮
│  ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁     │
│  ▄▀▄▀▄▀▄▀▄▀▄▀▄▀      │
╰──────────────────────╯

Nested Boxes:
╭───────────────────╮
│ ┌──────────────┐  │
│ │ Inner Box    │  │
│ └──────────────┘  │
╰───────────────────╯

Table:
┌─────┬─────┬─────┐
│ Col1│ Col2│ Col3│
├─────┼─────┼─────┤
│ A   │ B   │ C   │
│ D   │ E   │ F   │
└─────┴─────┴─────┘

Menu/List:
╭─ Options ─────╮
│ ▸ Option 1    │
│   Option 2    │
│   Option 3    │
╰───────────────╯

Status Indicators:
● ◉ ○ (circles)
■ ◼ □ (squares)
▶ ▷ (arrows)
✓ ✗ (checkmarks)

Spinner/Loading:
⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏

Horizontal Separators:
────────────────────
════════════════════
━━━━━━━━━━━━━━━━━━━━
⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

Vertical Separators:
│ ┃ ║ ┆ ┊ ╎ ╏

btop-style Panel:
╭─────────────────────────────────────╮
│ CPU [████████████████░░░░░░] 65.3%  │
│ ▁▂▃▄▅▆▇█▇▆▅▄▃▂▁▂▃▄▅▆▇█              │
│                                     │
│ Memory: 8.2GB / 16GB                │
│ ████████████░░░░░░░░░░░░            │
╰─────────────────────────────────────╯

Dashboard Layout:
╭─ System ───────╮ ╭─ Network ──────╮
│ CPU:  65% ▆▇█  │ │ Up:   ▁▂▃▄     │
│ RAM:  50% ▅▆▇  │ │ Down: ▄▅▆▇     │
│ Disk: 30% ▃▄▅  │ │ Ping: 45ms     │
╰────────────────╯ ╰────────────────╯

================================================================================
QUICK REFERENCE - MOST COMMONLY USED
================================================================================

Rounded Box (btop-style):
╭ ╮ ╰ ╯ ─ │

Light Box:
┌ ┐ └ ┘ ─ │ ┬ ┴ ├ ┤ ┼

Heavy Box:
┏ ┓ ┗ ┛ ━ ┃ ┳ ┻ ┣ ┫ ╋

Double Box:
╔ ╗ ╚ ╝ ═ ║ ╦ ╩ ╠ ╣ ╬

Progress/Graphs:
Horizontal: ▏▎▍▌▋▊▉█ and █ ▓ ▒ ░
Vertical: ▁▂▃▄▅▆▇█

Shading: █ ▓ ▒ ░


=====
IDEAS
=====

┌─┬─┐ ┏━┳━┓ ╔═╦═╗ ╭─┬─╮ ┍━┯━┑ ┎─┰─┒
│ │ │ ┃ ┃ ┃ ║ ║ ║ │ │ │ │ │ │ ┃ ┃ ┃
├─┼─┤ ┣━╋━┫ ╠═╬═╣ ├─┼─┤ ┝━┿━┥ ┠─╂─┨
│ │ │ ┃ ┃ ┃ ║ ║ ║ │ │ │ │ │ │ ┃ ┃ ┃
└─┴─┘ ┗━┻━┛ ╚═╩═╝ ╰─┴─╯ ┕━┷━┙ ┖─┸─┚

████▓▓▒▒░░░░

█████▓█▓███▓███▌
░▓▓▓▒▒▓▓▒▓▓▒▒▓▐▍
  ▒░   ▒  ▒ ▒░▕
  ░    ░


██▉██▎████


PROGRESS BARS
-------------

╭────────────╮
│ ████▒▒▒▒▒▒ │
╰────────────╯
╭────────────╮
│ ████▌      │
╰────────────╯
╭─╮╭─╮╭─╮
│▃││▅││▇│
╰─╯╰─╯╰─╯

BLA
---

┌─┬─┬─┐
│▘│ │▝│
├─┼─┼─┤
│▌│ │ │
├─┼─┼─┤
│▖│▄│▗│
└─┴─┴─┘
▖
▌
