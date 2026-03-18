return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = {
      'MarkdownPreview',
      'MarkdownPreviewStop',
      'MarkdownPreviewToggle',
    },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
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
--
-- -- install without yarn or npm
-- {
--     "iamcco/markdown-preview.nvim",
--     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--     ft = { "markdown" },
--     build = function() vim.fn["mkdp#util#install"]() end,
-- }
--
-- -- install with yarn or npm
-- {
--   "iamcco/markdown-preview.nvim",
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--   build = "cd app && yarn install",
--   init = function()
--     vim.g.mkdp_filetypes = { "markdown" }
--   end,
--   ft = { "markdown" },
-- },
--
