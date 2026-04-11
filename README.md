# dotfiles
Configuration files and scripts for my development environment.

## What's included

| File / Directory         | Description                                              |
|:-------------------------|:---------------------------------------------------------|
| `.config/nvim/init.lua`  | Neovim config with lazy.nvim, LSP, treesitter, telescope |
| `.vimrc`                 | Shared vim/nvim settings, keymaps, and OpenIDE bindings  |
| `.tmux.conf`             | Tmux config with vi keys and prefix Ctrl+A               |
| `.zshrc`                 | Zsh config with oh-my-zsh, vi-mode, SDKMAN, NVM, pnpm   |
| `.zshenv`                | Zsh environment (Flutter SDK path)                       |
| `.bashrc`                | Bash config with vi mode, SDKMAN, NVM                    |
| `.gitconfig`             | Git user config and core settings                        |
| `.config/git/ignore`     | Global gitignore                                         |
| `.Xmodmap`               | X keyboard mapping (Insert key fix)                      |
| `.emacs`                 | Emacs config with evil mode (legacy)                     |
| `.vim/`                  | Pathogen plugins and color schemes (used by plain vim)   |
| `bin/`                   | Helper scripts (wdtmux, oivim, tmux tools, OpenIDE, setup-csharp-lsp) |

## Neovim

Primary editor. Sources `.vimrc` for base settings, then layers on modern plugins via lazy.nvim.

### Plugins

| Plugin                   | Purpose                                    |
|:-------------------------|:-------------------------------------------|
| nvim-treesitter          | Syntax highlighting and indentation        |
| nvim-lspconfig           | LSP support (ts_ls)                        |
| mason.nvim               | LSP/tool installer (with Crashdummyy registry for roslyn) |
| roslyn.nvim              | C# LSP via Microsoft's Roslyn Language Server |
| nvim-cmp                 | Autocompletion (LSP, buffer, path, snippets) |
| telescope.nvim           | Fuzzy finder for files, grep, and buffers  |
| gruvbox.nvim             | Color scheme with transparent mode         |
| lualine.nvim             | Status line                                |
| gitsigns.nvim            | Git signs in the gutter                    |
| indent-blankline.nvim    | Indent guides                              |
| vim-dadbod-ui            | Database UI and SQL completion             |
| render-markdown.nvim     | Inline markdown rendering                  |
| copilot.vim              | GitHub Copilot (inline ghost-text completion) |
| claudecode.nvim          | Claude Code IDE integration (reuses `claude` CLI auth, diff review) |
| nerdtree                 | File explorer                              |
| vim-fugitive             | Git commands                               |
| vim-visual-multi         | Multiple cursors                           |
| delimitMate              | Auto-close brackets/quotes                 |
| LuaSnip                  | Snippet engine                             |

### Keybindings (Neovim-specific)

| Keyboard shortcut                         | Description                                     |
|:------------------------------------------|:------------------------------------------------|
| **LSP**                                   |                                                 |
| gd                                        | Go to definition                                |
| gr                                        | Find references                                 |
| K                                         | Hover documentation                             |
| ,rn                                       | Rename symbol                                   |
| ,ca                                       | Code action                                     |
| [d                                        | Previous diagnostic                             |
| ]d                                        | Next diagnostic                                 |
|                                           |                                                 |
| **Telescope**                             |                                                 |
| Ctrl+p                                    | Find files                                      |
| Ctrl+g                                    | Live grep                                       |
| ,fb                                       | Find buffers                                    |
|                                           |                                                 |
| **Build / Test**                          |                                                 |
| ,b                                        | Build project (auto-detects dotnet/npm/make)    |
| ,t                                        | Run tests (auto-detects dotnet/npm/pytest)      |
|                                           |                                                 |
| **Database (vim-dadbod)**                 |                                                 |
| ,db                                       | Toggle DB UI                                    |
| F5 (in SQL buffer)                        | Execute query                                   |
|                                           |                                                 |
| **Copilot (insert mode)**                 |                                                 |
| Ctrl+j                                    | Accept suggestion                               |
| Alt+n                                     | Next suggestion                                 |
| Alt+p                                     | Previous suggestion                             |
| Alt+m                                     | Request a suggestion on demand                  |
| Alt+d                                     | Dismiss current suggestion                      |
|                                           |                                                 |
| **Claude Code (claudecode.nvim)**         |                                                 |
| ,ac                                       | Toggle Claude window                            |
| ,af                                       | Focus Claude window                             |
| ,ar                                       | Resume a previous Claude session                |
| ,aC                                       | Continue most recent Claude session             |
| ,ab                                       | Add current buffer to Claude's context          |
| ,as (visual mode)                         | Send selection to Claude                        |
| ,as (in nvim-tree)                        | Add file under cursor to Claude                 |
| ,aa                                       | Accept proposed diff                            |
| ,ad                                       | Deny proposed diff                              |

## Vim / Shared Keybindings

These keybindings are defined in `.vimrc` and work in both vim and nvim. Leader key is `,`.

| Keyboard shortcut                         | Description                                     |
|:------------------------------------------|:------------------------------------------------|
| **Navigation**                            |                                                 |
| h/j/k/l                                   | Navigate left/down/up/right                     |
| w / e / b / ge                            | Word navigation (next/end/prev/prev-end)        |
| $ / _                                     | End of line / first character in line            |
| Ctrl+d / Ctrl+u                           | Half page down / up                             |
| { / }                                     | Previous / next empty line                      |
| gg / G                                    | Top / bottom of file                            |
| % / ''                                    | Matching bracket / last cursor position         |
| Ctrl+o / Ctrl+i                           | Backward / forward in cursor history            |
| [SPACE]                                   | Search                                          |
| q[SPACE] / q/                             | Clear search                                    |
| Ctrl+q                                    | Clear search highlight                          |
| * / #                                     | Search forward / backward for word under cursor |
| n / N                                     | Next / previous search hit                      |
| zz                                        | Center page on cursor                           |
|                                           |                                                 |
| **Windows / Tabs**                        |                                                 |
| Ctrl+w, v                                 | Vertical split                                  |
| Ctrl+w, s                                 | Horizontal split                                |
| Ctrl+w, h/j/k/l                           | Navigate between splits                         |
| Ctrl+w, \                                 | Zoom into current split                         |
| Ctrl+w, =                                 | Equalize split sizes                            |
| Ctrl+w, [ARROW]                           | Resize split in direction                       |
| Ctrl+w, t                                 | New tab                                         |
| Ctrl+w, e                                 | Close tab                                       |
| Ctrl+w, u                                 | Next tab                                        |
| Alt+[NUM] / yy[NUM]                       | Go to tab [NUM]                                 |
|                                           |                                                 |
| **File explorer (NERDTree)**              |                                                 |
| Ctrl+k, Ctrl+b                            | Toggle NERDTree                                 |
| Ctrl+k, Ctrl+h                            | Focus NERDTree                                  |
| Ctrl+k, Ctrl+f                            | Reveal current file in NERDTree                 |
|                                           |                                                 |
| **Selection**                             |                                                 |
| v[MOTION]                                 | Visual select (vw, v4w, viw, vi{, vap, etc.)   |
| Ctrl+v                                    | Block select                                    |
| vaj                                       | Select to last character in line                |
| vak                                       | Select from first to last position in line      |
| val                                       | Select from first to last character in line     |
|                                           |                                                 |
| **Editing**                               |                                                 |
| ,d                                        | Delete without yanking                          |
| ,p                                        | Replace selection without yanking               |
| p / u / Ctrl+r                            | Paste / undo / redo                             |
| Ctrl+l                                    | Append semicolon to end of line                 |
| Ctrl+k                                    | Jump to end of line and enter insert mode       |
| Ctrl+f,[NUM]                              | Wrap in {} from line end, indent NUM lines down |
| jj                                        | Escape (in insert mode)                         |
| F10                                       | Toggle paste mode                               |
|                                           |                                                 |
| **Multi-cursor**                          |                                                 |
| Ctrl+n                                    | Start/extend multi-cursor on word under cursor  |
| Ctrl+x                                    | Skip current match                              |
| Ctrl+p                                    | Go back one match                               |
|                                           |                                                 |
| **Other**                                 |                                                 |
| Ctrl+s                                    | Save                                            |
| Ctrl+Shift+s                              | Save all                                        |
| Ctrl+x, Ctrl+x                            | Quit                                            |
| "+y                                       | Yank to X clipboard                             |
| "+p                                       | Paste from X clipboard                          |
| q[key] ... q                              | Record macro into [key]                         |
| @[key]                                    | Play macro from [key]                           |
| [NUM]@[key]                               | Play macro NUM times                            |

## Tmux

Prefix is `Ctrl+A`. Start with `tmux` or use `wdtmux` to create/attach a session named after the current directory.

| Keyboard shortcut                         | Description                                     |
|:------------------------------------------|:------------------------------------------------|
| **Panes**                                 |                                                 |
| Ctrl+A, "                                 | Split horizontally                              |
| Ctrl+A, %                                 | Split vertically                                |
| Ctrl+A, r                                 | Split horizontally (small)                      |
| Ctrl+A, t                                 | Split vertically (small)                        |
| Ctrl+A, h/j/k/l                           | Navigate panes                                  |
| Ctrl+A, x                                 | Close pane                                      |
| Ctrl+A, z                                 | Toggle zoom on active pane                      |
| Ctrl+A, b                                 | Toggle zoom on other pane                       |
| Ctrl+A, H/J/K/L                           | Resize pane in direction                        |
|                                           |                                                 |
| **Windows**                               |                                                 |
| Ctrl+A, c                                 | New window                                      |
| Ctrl+A, [0-9]                             | Select window by number                         |
| Ctrl+A, o                                 | Toggle last window                              |
| Ctrl+A, + / -                             | Next / previous window                          |
| Ctrl+A, w                                 | Choose between open windows                     |
|                                           |                                                 |
| **Sessions**                              |                                                 |
| Ctrl+A, s                                 | Choose between running sessions                 |
| Ctrl+A, d                                 | Detach from session                             |
|                                           |                                                 |
| **Copy mode (vi keys)**                   |                                                 |
| Ctrl+A, v                                 | Enter copy mode                                 |
| v                                         | Start selection                                 |
| y                                         | Yank selection                                  |
| Ctrl+A, p                                 | Paste from tmux buffer                          |
| Ctrl+A, y                                 | Copy tmux buffer to X clipboard                 |
|                                           |                                                 |
| **Commands**                              |                                                 |
| set synchronize-panes on/off              | Type in all panes at once                       |

## Zsh

Uses oh-my-zsh with `robbyrussell` theme and plugins: `git`, `vi-mode`, `history-substring-search`.

Key features:
- `vim` is aliased to `nvim`
- Vi keybindings in the shell
- Caps Lock mapped to Escape (X11 only)
- Dotnet CLI completion
- SDKMAN, NVM, and pnpm configured
- `mkcd [dir]` - create directory and cd into it
- `wdtmux` - tmux session per working directory

## OpenIDE

Legacy IDE integration bindings available in `.vimrc` (prefixed with `yy` or `Alt`). See `.vimrc` for the full list.
