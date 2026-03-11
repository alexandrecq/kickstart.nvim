# Neovim Config — Notes for Claude

## Project Overview

This config started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and has been refactored and extended. The `master` branch tracks the upstream kickstart repo; personal changes live on the `custom` branch.

## Structure

- `lua/core/` — options, keymaps, autocmds (split out from kickstart's monolithic init.lua)
- `lua/plugins/` — plugin specs grouped by category (essentials, lsp, completion, ui, telescope)
- `lua/custom/` — personal overrides and extra plugins, kept separate from kickstart base
- `lua/kickstart/` — original kickstart plugin files, largely unmodified

## Python Tooling

Two tools, no overlap:

- **Pyright** — LSP features: hover, completion, go-to-def, type checking
- **Ruff** — linting diagnostics and formatting (replaces pylsp, pyflakes, black)

pylsp was intentionally removed to eliminate duplicate diagnostics (Ruff's F-rules overlapped with pyflakes).

### Ruff Configuration

Ruff settings live in `lua/plugins/lsp.lua` in two places to keep the config self-contained:

1. **LSP server settings** (`servers.ruff.init_options.settings`) — controls linting diagnostics
2. **Formatter args** (`opts.formatters.ruff_format.prepend_args`) — controls `ruff format`

Both must use the same `line-length` value (currently 120). If you change one, change the other.

Active lint rules:
- `E501` enabled — Line too long (flagged beyond 120 chars)
- `W391` ignored — Blank line at end of file

## User Preferences

- **Comments**: Always include plenty of comments, especially for non-obvious things like lint rule codes (e.g. `E501`, `W391`). This config is not edited frequently so comments are important for context.
- **Manual formatting**: Format on save is disabled. Use `<leader>f` to format manually.
- **Self-contained**: Keep all config within this repo. Avoid relying on files outside `~/.config/nvim` (e.g. no separate `~/.config/ruff/ruff.toml`).
