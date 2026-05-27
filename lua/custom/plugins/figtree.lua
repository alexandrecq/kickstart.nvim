return {
  {
    url = "sso://googler@user/jackcogdill/nvim-figtree",
    name = "figtree",
    keys = {
      {
        '<leader>hh',
        function()
          require('figtree').toggle()
        end,
        desc = '[H]g status tree (Figtree)',
      },
    },
    opts = {
      ui = {
        border = 'rounded',
        size = { width = 0.9, height = 0.9 },
      },
    },
  },
}
