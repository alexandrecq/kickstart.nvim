# Neovim Keybinds Reference

> **Legend:** `<leader>` = Space &nbsp;|&nbsp; **[C]** = custom &nbsp;|&nbsp; **[K]** = kickstart/built-in

---

## Core Editing

### File & Session

| Key | Action | Source |
|-----|--------|--------|
| `<leader>w` | Write current buffer | [C] |
| `<leader>q` | Quit | [C] |
| `<leader>qa` | Quit all | [C] |
| `<leader>ms` | Save session + quit all (`:mksession!` then `:xa`) | [C] |
| `<leader>pv` | Open netrw file explorer (`:Ex`) | [C] |
| `<leader>f` | Format buffer (conform.nvim, manual — no format-on-save) | [C] |

### Motion & Scrolling

| Key | Action | Source |
|-----|--------|--------|
| `0` | Go to first non-blank character (remapped from `^`) | [C] |
| `<C-d>` | Scroll down half-page, keep cursor centered | [C] |
| `<C-u>` | Scroll up half-page, keep cursor centered | [C] |
| `n` | Next search match (centered) | [C] |
| `N` | Previous search match (centered) | [C] |
| `<Esc>` (normal) | Clear search highlights | [K] |

### Clipboard & Registers

*Note: System clipboard (`+` register) and Neovim unnamed register are independent.*

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>y` | n/v | [Y]ank to system clipboard (takes a motion) | [C] |
| `<leader>Y` | n | [Y]ank line to system clipboard | [C] |
| `<leader>p` | n/v | [P]aste from system clipboard (after cursor) | [C] |
| `<leader>P` | n/v | [P]aste from system clipboard (before cursor) | [C] |
| `<leader>v` | visual | [V]oid paste (paste without clobbering yank register) | [C] |
| `<leader>d` | n/v | [D]elete into void register (don't overwrite yank) | [C] |

### Visual Mode Line Movement

| Key | Action | Source |
|-----|--------|--------|
| `J` (visual) | Move selected lines down | [C] |
| `K` (visual) | Move selected lines up | [C] |

---

## Windows & Tabs

### Window Focus

| Key | Action | Source |
|-----|--------|--------|
| `<M-h>` | Focus left window | [C] |
| `<M-l>` | Focus right window | [C] |
| `<M-j>` | Focus lower window | [C] |
| `<M-k>` | Focus upper window | [C] |
| `<C-j>` | Focus lower window | [K] |
| `<C-k>` | Focus upper window | [K] |

### Tabs

| Key | Action | Source |
|-----|--------|--------|
| `<C-h>` | Previous tab | [C] |
| `<C-l>` | Next tab | [C] |
| `<leader>tn` | New tab | [C] |
| `<leader>te` | Edit file in new tab (opens prompt in current dir) | [C] |
| `<leader>tm` | Move tab (prompts for position) | [C] |
| `<leader>tt` | Go to tab number (prompts) | [C] |
| `<leader>tr` | First tab | [C] |
| `<leader>tl` | Last tab | [C] |

### Terminal

| Key | Action | Source |
|-----|--------|--------|
| `<Esc><Esc>` (terminal) | Exit terminal mode (alternative to `<C-\><C-n>`) | [K] |

---

## LSP

*These mappings are buffer-local and active only when an LSP server is attached.*

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `grn` | n | Rename symbol | [K] |
| `gra` | n/x | Code action | [K] |
| `grr` | n | References (Telescope) | [K] |
| `gri` | n | Go to implementation (Telescope) | [K] |
| `grd` | n | Go to definition (Telescope) | [K] |
| `grD` | n | Go to declaration (e.g. C header) | [K] |
| `gO` | n | Document symbols (Telescope) | [K] |
| `gW` | n | Workspace symbols (Telescope) | [K] |
| `grt` | n | Go to type definition (Telescope) | [K] |
| `<leader>th` | n | Toggle inlay hints | [K] |
| `<C-t>` | n | Jump back after go-to-def (built-in tag stack) | vim |

### Diagnostics

| Key | Action | Source |
|-----|--------|--------|
| `[d` | Previous diagnostic (auto-opens float) | [K] |
| `]d` | Next diagnostic (auto-opens float) | [K] |
| `<leader>de` | Show diagnostic in float | [K] |
| `<leader>dq` | Send diagnostics to quickfix list | [K] |

> **Note:** Virtual text and automatic diagnostic floating windows are enabled. Use `[d` and `]d` to navigate and read error messages instantly.

---

## Telescope

### Search (global)

| Key | Action | Source |
|-----|--------|--------|
| `<leader>sf` | Find files | [K] |
| `<leader>sc` | Search commands | [K] |
| `<leader>sH` | Find files under `~/` | [C] |
| `<leader>sg` | Live grep (project-wide) | [K] |
| `<leader>sw` | Grep word under cursor | [K] |
| `<leader>ps` | Grep with prompt (project search) | [C] |
| `<leader>s/` | Live grep in open buffers only | [K] |
| `<leader>sd` | Search diagnostics | [K] |
| `<leader>sh` | Search help tags | [K] |
| `<leader>sk` | Search keymaps | [K] |
| `<leader>ss` | Select Telescope picker | [K] |
| `<leader>sr` | Resume last Telescope session | [K] |
| `<leader>s.` | Recent files | [K] |
| `<leader>sn` | Search Neovim config files | [K] |
| `<leader>b` | Search open [B]uffers | [K] |
| `<leader>/` | Fuzzy search in current buffer | [K] |

### Inside Telescope picker (built-in)

| Key | Mode | Action |
|-----|------|--------|
| `<C-Enter>` | insert | Fuzzy refine current results |
| `<C-/>` | insert | Show all picker keymaps |
| `?` | normal | Show all picker keymaps |
| `<C-u>` / `<C-d>` | insert | Scroll preview |
| `<C-x>` | insert | Open in horizontal split |
| `<C-v>` | insert | Open in vertical split |
| `<C-t>` | insert | Open in new tab |
| `<Esc>` | insert | Close picker |

---

## Git

### Fugitive (`:Git` wrapper)

| Key | Action | Source |
|-----|--------|--------|
| `<leader>gg` | Open fugitive status window | [C] |
| `<leader>gc` | Git commit | [C] |
| `<leader>gd` | Diff current file vs index (`:Gdiffsplit`) | [C] |
| `<leader>gl` | Git log (compact, `--oneline`) | [C] |
| `<leader>gb` | Git blame (full file) | [C] |
| `<leader>gp` | Git push | [C] |
| `<leader>gP` | Git pull | [C] |

#### Inside fugitive status window (built-in)

| Key | Action |
|-----|--------|
| `r` | Refresh status window |
| `s` | Stage file/hunk |
| `u` | Unstage file/hunk |
| `=` | Toggle inline diff |
| `cc` | Commit |
| `ca` | Amend commit |
| `dd` | Diff file |
| `X` | Discard change |
| `g?` | Show help |
| `q` | Close |

### Telescope + Git

| Key | Action | Source |
|-----|--------|--------|
| `<leader>gf` | Git files (Telescope) | [C] |
| `<leader>gs` | Git status (Telescope) | [C] |

### Gitsigns (hunk-level operations)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `]c` | n | Next hunk | [K] |
| `[c` | n | Previous hunk | [K] |
| `ghs` | n/v | Stage hunk | [K] |
| `ghr` | n/v | Reset hunk (discard) | [K] |
| `ghS` | n | Stage entire buffer | [K] |
| `ghR` | n | Reset entire buffer | [K] |
| `ghu` | n | Undo stage hunk | [K] |
| `ghp` | n | Preview hunk inline | [K] |
| `ghb` | n | Blame current line (popup) | [K] |
| `ghd` | n | Diff against index | [K] |
| `ghD` | n | Diff against last commit | [K] |
| `<leader>tb` | n | Toggle inline blame | [K] |
| `<leader>tD` | n | Toggle show deleted lines | [K] |

---

## Neo-tree (File Explorer)

| Key | Action | Source |
|-----|--------|--------|
| `<leader>nt` | Toggle Neo-tree | [C] |

#### Inside Neo-tree (custom window mappings)

| Key | Action | Source |
|-----|--------|--------|
| `h` / `-` / `..` / `<BS>` | Navigate up to parent dir | [C] |
| `l` / `<CR>` | Open file or expand dir | [C] |
| `<C-t>` | Open in new tab | [C] |
| `\` | Close Neo-tree window | [C] |

#### Inside Neo-tree (built-in reminders)

| Key | Action |
|-----|--------|
| `a` | Add file (append `/` for directory) |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy to clipboard |
| `p` | Paste from clipboard |
| `R` | Refresh |
| `H` | Toggle hidden files |
| `?` | Show help |
| `q` | Close |

---

## Harpoon

| Key | Action | Source |
|-----|--------|--------|
| `<leader>a` | Add current file to harpoon list | [C] |
| `<leader>e` | Toggle harpoon quick menu (editable list) | [C] |
| `<leader>0-9` | Jump to harpoon file 0-9 | [C] |

---

## Undotree

| Key | Action | Source |
|-----|--------|--------|
| `<leader>u` | Toggle Undotree panel | [C] |

#### Inside Undotree (built-in)

| Key | Action |
|-----|--------|
| `J` / `K` | Move to older/newer state |
| `<CR>` | Revert to selected state |
| `p` | Preview diff |
| `q` | Close |

---

## Markdown

### Browser Preview (`markdown-preview.nvim`)

| Key | Action | Source |
|-----|--------|--------|
| `<leader>mo` | Open markdown preview in browser | [C] |
| `<leader>mt` | Toggle markdown preview for current buffer | [C] |
| `<leader>mc` | Close markdown preview | [C] |

### In-Editor Rendering (`render-markdown.nvim`)

`render-markdown.nvim` is disabled by default. Use `<leader>rm` to toggle it on.

| Key | Action | Source |
|-----|--------|--------|
| `<leader>rm` | Toggle Render Markdown. | [C] |

---

## Completion (blink.cmp — `default` preset)

*Active in insert mode when the completion menu is open.*

| Key | Action |
|-----|--------|
| `<C-y>` | Accept selected completion |
| `<C-space>` | Open menu / open docs if menu open |
| `<C-n>` / `<Down>` | Select next item |
| `<C-p>` / `<Up>` | Select previous item |
| `<C-e>` | Close/hide menu |
| `<C-k>` | Toggle signature help |
| `<Tab>` / `<S-Tab>` | Move forward/backward in snippet expansion |

---

## Debug (nvim-dap)

| Key | Action | Source |
|-----|--------|--------|
| `<F5>` | Start / Continue | [K] |
| `<F1>` | Step Into | [K] |
| `<F2>` | Step Over | [K] |
| `<F3>` | Step Out | [K] |
| `<F7>` | Toggle DAP UI | [K] |
| `<leader>b` | Toggle breakpoint | [K] |
| `<leader>B` | Set conditional breakpoint | [K] |

---

## mini.surround (text surrounding)

*No custom binds — uses `mini.surround` defaults.*

These are multi-key mappings. `s` by itself is still Vim's normal substitute command, so you need to type the full sequence such as `sa`, `sd`, or `sr`.

For `sd`, `sr`, `sf`, `sF`, `sh`, and `sn`, place the cursor inside or on the surrounding you want to target.

| Key | Action | Example |
|-----|--------|---------|
| `sa{motion}{char}` | Add surround around a motion/textobject | `saiw)` → surround inner word with `( word )` |
| `sd{char}` | Delete nearest matching surround under cursor | `sd'` → remove surrounding quotes |
| `sr{old}{new}` | Replace one surround with another | `sr)'` → replace surrounding `()` with quotes |
| `sf{char}` | Find surround (forward) | |
| `sF{char}` | Find surround (backward) | |
| `sh{char}` | Highlight matching surround briefly | |
| `sn{char}` | Update search to next matching surround | |

Quick sanity checks:

| Starting text | Keys | Result |
|---------------|------|--------|
| `hello` | `saiw)` | `(hello)` |
| `'hello'` with cursor on `e` | `sd'` | `hello` |
| `(hello)` with cursor on `e` | `sr)'` | `'hello'` |

## mini.ai (enhanced text objects)

*Extends built-in `i`/`a` text objects to work with more targets.*

| Example | Action |
|---------|--------|
| `va)` | Visually select around `()` |
| `yinq` | Yank inside next quote |
| `ci'` | Change inside `'` |
| `da}` | Delete around `{}` |

---

## Lazy (plugin manager)

*No custom keybinds. Open with `:Lazy`.*

| Key | Action |
|-----|--------|
| `U` | Update all plugins |
| `x` | Clean unused plugins |
| `s` | Sync (clean + install + update) |
| `I` | Install missing plugins |
| `L` | Show changelog |
| `?` / `g?` | Help |
| `q` | Close |

## Mason (LSP/tool installer)

*Open with `:Mason`.*

| Key | Action |
|-----|--------|
| `i` | Install package under cursor |
| `X` | Uninstall |
| `U` | Update all |
| `g?` | Help |
| `q` | Close |

---

## Which-key

Press `<leader>` and pause — which-key will show a popup of available next keys.
Also works with `g`, `]`, `[`, `z` etc.

Standard Neovim LSP commands are grouped under **`gr`** (LSP Actions).
