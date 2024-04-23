-- Custom keymaps:
--
local options_noremap = { noremap = true }
-- vim.cmd('source path/to/file.vim')
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit NVim' })
vim.keymap.set('n', '<leader>qa', ':qa<CR>', { desc = '[Q]uit [A]ll' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[W]rite current buffer' })
vim.keymap.set('n', '<leader>eb', ':sp ~/.bashrc<CR>', { desc = '[E]dit [B]ash' })
vim.keymap.set('n', '<leader>ms', ':mksession!<CR> :xa<CR>', { desc = '[M]ake [S]ession' })
vim.keymap.set('i', 'jk', '<Esc>', options_noremap)
vim.keymap.set('n', '0', '^', options_noremap)
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex) -- Explore directory, is this useful?
-- Tabs:
vim.keymap.set('n', '<leader>tr', ':tabr<CR>', { desc = '[T]ab fi[R]st' })
vim.keymap.set('n', '<leader>tl', ':tabl<CR>', { desc = '[T]ab [L]ast' })
vim.keymap.set('n', '<C-h>', ':tabp<CR>', { desc = 'Move to left tab' })
vim.keymap.set('n', '<C-l>', ':tabn<CR>', { desc = 'Move to right tab' })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew' })
vim.keymap.set('n', '<leader>te', ':tabedit <C-r>=expand("%:p:h")<CR>/',
  { desc = '[T]ab [E]dit' })
vim.keymap.set('n', '<leader>tm', ':tabmove ', { desc = '[T]ab [M]ove' })
vim.keymap.set('n', '<leader>tt', ':tabnext ', { desc = '[T]o [T]ab number' })
vim.keymap.set('n', '<leader>nt', '<Cmd>Neotree toggle<CR>', { desc = '[N]eo [T]ree' })
