-- Custom keymaps:
--
-- General
local options_noremap = { noremap = true }
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit NVim' })
vim.keymap.set('n', '<leader>qa', ':qa<CR>', { desc = '[Q]uit [A]ll' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[W]rite current buffer' })
vim.keymap.set('n', '<leader>bd', ':bd', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>ms', ':mksession!<CR> :xa<CR>', { desc = '[M]ake [S]ession' })
-- vim.keymap.set('i', 'jk', '<Esc>', options_noremap)
vim.keymap.set('n', '0', '^', options_noremap)

-- Explore directory
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Explore files' })

-- move lines with J/K in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- stay centered when scrolling up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- keep search matches centered
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
-- paste without replacing yanked text (cut into void register)
vim.keymap.set('x', '<leader>v', '"_dP', { desc = '[V]oid paste (paste without overwriting register)' })
-- delete into void register
vim.keymap.set('n', '<leader>d', '"_d', { desc = '[D]elete into void register' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = '[D]elete into void register' })
-- yank into system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = '[Y]ank line to system clipboard' })
-- paste from system clipboard
vim.keymap.set('n', '<leader>p', '"+p', { desc = '[P]aste from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = '[P]aste from system clipboard (before)' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = '[P]aste from system clipboard' })
vim.keymap.set('v', '<leader>P', '"+P', { desc = '[P]aste from system clipboard (before)' })

-- Window navigation
vim.keymap.set('n', '<M-h>', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<M-l>', '<C-w>l', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<M-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<M-k>', '<C-w>k', { desc = 'Move focus to the upper window' })

-- Tabs:
vim.keymap.set('n', '<leader>tr', ':tabr<CR>', { desc = '[T]ab fi[R]st' })
vim.keymap.set('n', '<leader>tl', ':tabl<CR>', { desc = '[T]ab [L]ast' })
-- vim.keymap.set('n', '<C-h>', ':tabp<CR>', { desc = 'Move to left tab' })
-- vim.keymap.set('n', '<C-l>', ':tabn<CR>', { desc = 'Move to right tab' })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew' })
vim.keymap.set('n', '<leader>te', ':tabedit <C-r>=expand("%:p:h")<CR>/', { desc = '[T]ab [E]dit' })
vim.keymap.set('n', '<leader>tm', ':tabmove ', { desc = '[T]ab [M]ove' })
vim.keymap.set('n', '<leader>tt', ':tabnext ', { desc = '[T]o [T]ab number' })

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]files' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string { search = vim.fn.input 'Grep > ' }
end, { desc = '[P]roject [S]earch' })

-- Git (requires vim-fugitive: lua/custom/plugins/fugitive.lua)
vim.keymap.set('n', '<leader>gg', vim.cmd.Git, { desc = '[G]it status window (fugitive)' })
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = '[G]it [C]ommit' })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<CR>', { desc = '[G]it [D]iff current file vs index' })
vim.keymap.set('n', '<leader>gl', ':Git log --oneline<CR>', { desc = '[G]it [L]og (compact)' })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame (full file)' })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = '[G]it [P]ush' })
vim.keymap.set('n', '<leader>gP', ':Git pull<CR>', { desc = '[G]it [P]ull' })
