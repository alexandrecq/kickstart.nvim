return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
    keys = {
      { '<leader>rm', '<cmd>RenderMarkdown toggle<CR>', desc = '[R]ender [M]arkdown toggle' },
    },
  },
}
