return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function(_, opts)
      -- Disabled by default; toggle with <leader>rm
      opts.enabled = false
      require('render-markdown').setup(opts)
      -- Use Lua API directly so the keymap works even when enabled = false
      vim.keymap.set('n', '<leader>rm', function()
        require('render-markdown').toggle()
      end, { desc = '[R]ender [M]arkdown toggle' })
    end,
  },
}
