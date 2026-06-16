return {
  {
    name = 'google-internal',
    dir = '/usr/share/vim/google',
    lazy = false, -- Load at startup
    priority = 1000, -- Load early to set up filetypes before other plugins
    cond = function()
      return vim.fn.filereadable('/usr/share/vim/google/google.vim') == 1
    end,
    config = function()
      -- Source the main Google Vim configuration
      vim.cmd('source /usr/share/vim/google/google.vim')

      -- Force googlesql filetype for SQL files inside google3/depot
      vim.filetype.add({
        pattern = {
          ['.*/google3/.*%.sql'] = 'googlesql',
          ['.*/google3/.*%.sql[pmt]'] = 'googlesql',
          ['^/google/.*%.sql'] = 'googlesql',
          ['^/google/.*%.sql[pmt]'] = 'googlesql',
        },
      })
    end,
  },
}
