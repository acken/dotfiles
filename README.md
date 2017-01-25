# dotfiles
All the configuratoin, binaries and dot files for a "clean" system

## Tmux
Start tmux either by runnin tmux. Use tmux attach to start tmux and attach to a already running session. Or use wdtmux which starts or attaches to a tmux session named by convention using current directory.

| Keyboard shortcut                         | Description                                     |
|:------------------------------------------|:------------------------------------------------|
| Ctrl+A, "                                 | Split pane horizontally                         |
| Ctrl+A, %                                 | Split pane vertically                           |
| Ctrl+A, r                                 | Split pane horizontally small                   |
| Ctrl+A, t                                 | Split pane vertically small                     |
| Ctrl+A, q                                 | Close pane                                      |
| Ctrl+A, h                                 | Select left pane                                |
| Ctrl+A, j                                 | Select pane below                               |
| Ctrl+A, k                                 | Select pane above                               |
| Ctrl+A, l                                 | Select right pane                               |
| Ctrl+A, b                                 | Toggle zoom on other pane                       |
| Ctrl+A, c                                 | Create new window (tab)                         |
| Ctrl+A, [0-9]                             | Select window                                   |
| Ctrl+A, o                                 | Toggle last window                              |
| Ctrl+A, Esc                               | Enter select mode                               |
| ---> vim keys, navigation keys            | To navigate                                     |
| ---> v                                    | Start text selection                            |
| ---> y                                    | Yank the text to tmux buffer                    |
| Ctrl+A, p                                 | Past text from tmux buffer                      |
| Ctrl+A, y                                 | Copy text from tmux buffer to xclipboard        |
| Ctrl+A, z                                 | Toggle zoom for active pane                     |
| Ctrl+A, w                                 | Choose between open windows                     |
| Ctrl+A, s                                 | Choose between running tmux sessions            |
| Ctrl+A, d                                 | Detach from a running tmux session              |

## Vim
Use oivim to start OpenIDE running vim in a terminal.

| Keyboard shortcut                         | Description                                     |
|:------------------------------------------|:------------------------------------------------|
| Navigation                                |                                                 |
| h/j/k/l                                   | Navigate left/down/up/right                     |
| w                                         | Navigate to begining of next word               |
| e                                         | Navigate to end of next word                    |
| b                                         | Navigate to beginning of previous word          |
| ge                                        | Navigate to end of previous word                |
| $                                         | Navigate to end of line                         |
| Ctrl+k                                    | Navigate to end of line and enter inster mode   |
| Ctrl+d                                    | Navigate half a page down                       |
| Ctrl+u                                    | Navigate half a page up                         |
| }                                         | Navigate down to next empty line                |
| {                                         | Navigate up to next empty line                  |
| _                                         | Navigate to first character in line             |
| g0                                        | Navigate to column 0 of line                    |
| [NUM]k                                    | Move [NUM] lines up                             |
| [NUM]j                                    | Move [NUM] lines down                           |
| [NUM]h                                    | Move [NUM] columns left                         |
| [NUM]l                                    | Move [NUM] columns right                        |
| Ctrl+k, Ctrl+b                            | Toggle NERDTree                                 |
| Ctrl+k, Ctrl+f                            | Open current file in NERDTree                   |
| Ctrl+w, s                                 | Split buffer horizontally                       |
| Ctrl+w, v                                 | Split buffer vertically                         |
| Ctrl+w, h/j/k/l                           | Navigate between buffers in a window            |
| Ctrl+w, t                                 | Open new tab                                    |
| Ctrl+w, T                                 | Open current file new tab                       |
| Ctrl+w, c                                 | Close buffer                                    |
| Alt, [NUM]                                | Open tab [NUM] (may not work in terminal)       |
| yy[NUM]                                   | Open tab [NUM]                                  |
| /                                         | Search                                          |
| Shift+[SPACE]                             | Search                                          |
| *                                         | Search forward for word under cursor            |
| #                                         | Search backward for word under cursor           |
| n                                         | Move to next hit in search                      |
| Shift+n                                   | Move to previous hit in search                  |
| Ctrl+q                                    | Clear search                                    |
|                                           |                                                 |
| Selection                                 |                                                 |
| yy                                        | Yank current line                               |
| vap                                       | Select between empty lines                      |
| vaj                                       | Select to last character in line                |
| vak                                       | Select from first to last position in line      |
| val                                       | Select from first to last character in line     |
|                                           |                                                 |
| When text is selected                     |                                                 |
| d                                         | Delete selection and yank                       |
| ,d                                        | Delete selection without yank                   |
|                                           |                                                 |
| Modification                              |                                                 |
| dd                                        | Delete line and yank line                       |
| d$                                        | Delete to end of line and yank                  |
| ,dd                                       | Delete line without yank                        |
| ,d$                                       | Delete to end of line without yank              |
| p                                         | Past previously ynaked content                  |
| r[CHAR]                                   | Add replace current character with [CHAR]       |
| Ctrl+k                                    | Add semicolon to end of line                    |

