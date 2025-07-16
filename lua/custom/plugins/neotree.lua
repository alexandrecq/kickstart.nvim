return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<leader>nt", "<Cmd>Neotree toggle<CR>", desc = "[N]eo [T]ree" },
    },
    opts = {
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
          ["\\"] = "close_window", -- upstream addition
        }
      },
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files by default
          hide_dotfiles = false,
          hide_gitignored = false,
        }
      }
    }
  },
}
