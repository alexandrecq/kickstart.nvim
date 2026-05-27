return {
  {
    "mhinz/vim-signify",
    init = function()
      -- Configure vim-signify to ONLY run on Mercurial (hg/Fig) repos
      vim.g.signify_vcs_list = { 'hg' }
      vim.g.signify_sign_change = '~'
      vim.g.signify_sign_delete = '_'
      vim.g.signify_sign_delete_first_line = '‾'
    end,
  },
}
