-- Custom options:
--
vim.g.have_nerd_font = true
vim.opt.relativenumber = true

-- set completion mode
vim.opt.wildmode = { 'longest:longest', 'list', 'full' }
-- visual bell instead of beeping
-- vim.opt.visualbell = true
-- show latest command
vim.showcmd = true
-- backup: (or use undotree)
vim.opt.backup = true
vim.opt.writebackup = true
local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand '~/.config'
vim.opt.undodir = { config_home .. '/nvim/.undo//' }
vim.opt.backupdir = { config_home .. '/nvim/.backup//' }

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

