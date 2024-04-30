-- Custom keymaps:
--
-- General
local options_noremap = { noremap = true }
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit NVim' })
vim.keymap.set('n', '<leader>qa', ':qa<CR>', { desc = '[Q]uit [A]ll' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[W]rite current buffer' })
vim.keymap.set('n', '<leader>eb', ':sp ~/.bashrc<CR>', { desc = '[E]dit [B]ash' })
vim.keymap.set('n', '<leader>ms', ':mksession!<CR> :xa<CR>', { desc = '[M]ake [S]ession' })
vim.keymap.set('i', 'jk', '<Esc>', options_noremap)
vim.keymap.set('n', '0', '^', options_noremap)

-- Explore directory
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc= 'Explore files' }) 

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
vim.keymap.set('x', '<leader>p', "\"_dP")
-- delete into void register
vim.keymap.set('n', '<leader>d', "\"_d")
vim.keymap.set('v', '<leader>d', "\"_d")
-- yank into system clipboard
vim.keymap.set('n', '<leader>y', "\"+y")
vim.keymap.set('v', '<leader>y', "\"+y")
vim.keymap.set('n', '<leader>Y', "\"+Y")


-- Tabs:
vim.keymap.set('n', '<leader>tr', ':tabr<CR>', { desc = '[T]ab fi[R]st' })
vim.keymap.set('n', '<leader>tl', ':tabl<CR>', { desc = '[T]ab [L]ast' })
vim.keymap.set('n', '<C-h>', ':tabp<CR>', { desc = 'Move to left tab' })
vim.keymap.set('n', '<C-l>', ':tabn<CR>', { desc = 'Move to right tab' })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew' })
vim.keymap.set('n', '<leader>te', ':tabedit <C-r>=expand("%:p:h")<CR>/', { desc = '[T]ab [E]dit' })
vim.keymap.set('n', '<leader>tm', ':tabmove ', { desc = '[T]ab [M]ove' })
vim.keymap.set('n', '<leader>tt', ':tabnext ', { desc = '[T]o [T]ab number' })


--Plugins
vim.keymap.set('n', '<leader>nt', '<Cmd>Neotree toggle<CR>', { desc = '[N]eo [T]ree' })
-- vim.keymap.set("n", "<leader>u", vim.cmd.UndoTreeToggle)
-- vim.keymap.set("n", "<leader>u", '<Cmd>UndoTreeToggle<CR>')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]files' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = '[P]roject [S]earch' })

vim.keymap.set('n', '<leader>gg', vim.cmd.Git)

