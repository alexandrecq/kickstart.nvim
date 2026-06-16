return {
  {
    url = "sso://googler@user/tylersaunders/telescope-fig.nvim",
    name = "telescope-fig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { '<leader>hs', '<cmd>Telescope fig status<CR>', desc = '[H]g [S]tatus (Telescope)' },
      { '<leader>hx', '<cmd>Telescope fig xl<CR>', desc = '[H]g [X]l tree (Telescope)' },
      {
        '<leader>hc',
        function()
          require('custom.fig').telescope_current_cl()
        end,
        desc = '[H]g files in [C]urrent CL (Telescope)',
      },
    },
    config = function()
      pcall(require("telescope").load_extension, "fig")
    end,
  },
}
