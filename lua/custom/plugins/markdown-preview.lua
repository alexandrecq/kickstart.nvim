return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = {
      'MarkdownPreview',
      'MarkdownPreviewStop',
      'MarkdownPreviewToggle',
    },
    build = 'cd app && npm install --registry https://registry.npmjs.org',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    keys = {
      { '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', desc = '[M]arkdown preview [T]oggle' },
      { '<leader>mo', '<cmd>MarkdownPreview<CR>', desc = '[M]arkdown preview [O]pen' },
      { '<leader>mc', '<cmd>MarkdownPreviewStop<CR>', desc = '[M]arkdown preview [C]lose' },
    },
  },
}
