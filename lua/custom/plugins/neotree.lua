return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["-"] = "navigate_up",
            [".."] = "navigate_up",
            ["<bs>"] = "navigate_up", -- backspace
            ["h"] = "navigate_up",
            ["l"] = "open",
            ["<cr>"] = "open",
            ["t"] = false, -- disable default 't' mapping
            ["<C-t>"] = "open_tabnew", -- open in new tab with Ctrl-t
          }
        },
        filesystem = {
          filtered_items = {
            visible = true, -- Show hidden files by default
            hide_dotfiles = false,
            hide_gitignored = false,
          }
        }
      })
    end,
  },
}
