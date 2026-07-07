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
    config = function()
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = 'Hg/Fig: ' .. desc })
      end

      local function toggle_signify_diff()
        local tab = vim.api.nvim_get_current_tabpage()
        if vim.wo.diff then
          vim.cmd('diffoff!')
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            pcall(vim.keymap.del, 'n', 'q', { buffer = buf })
            if vim.bo[buf].buftype == 'nofile' or vim.bo[buf].bufhidden == 'wipe' then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        else
          vim.cmd('SignifyDiff')
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
              local buf = vim.api.nvim_win_get_buf(win)
              vim.keymap.set('n', 'q', toggle_signify_diff, { buffer = buf, silent = true })
            end
          end)
        end
      end

      -- Hunk & Diff actions for Fig / Mercurial
      map('<leader>hp', '<cmd>SignifyHunkDiff<CR>', '[H]unk [P]review (popup diff for line/block)')
      map('<leader>hu', '<cmd>SignifyHunkUndo<CR>', '[H]unk [U]ndo / Revert hunk under cursor')
      map('<leader>hd', toggle_signify_diff, '[H]unk [D]iff (toggle side-by-side diffmode)')
      map('<leader>hl', '<cmd>SignifyToggleHighlight<CR>', '[H]unk [L]ine highlight toggle')
    end,
  },
}
