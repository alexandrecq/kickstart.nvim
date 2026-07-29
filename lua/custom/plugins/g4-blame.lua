-- Google3 / Piper G4 Blame plugin for Neovim
-- Annotates the active google3 file with Piper CL numbers in a side-by-side split window

local M = {}

function M.toggle()
  local current_win = vim.api.nvim_get_current_win()
  local current_tab = vim.api.nvim_get_current_tabpage()

  -- Toggle off if already open in current tab
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'g4blame' then
      pcall(vim.api.nvim_win_set_option, current_win, 'scrollbind', false)
      pcall(vim.api.nvim_win_close, win, true)
      return
    end
  end

  local filepath = vim.api.nvim_buf_get_name(0)
  if not filepath:find('/google3/') then
    vim.notify('g4-blame: Current file is not in a google3 workspace directory', vim.log.levels.WARN)
    return
  end

  local depot_path = filepath:gsub('.*/google3/', '//depot/google3/')
  local cmd = string.format('g4 annotate -u -c %s 2>/dev/null', vim.fn.shellescape(depot_path))
  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 or #output == 0 then
    vim.notify('g4-blame: g4 annotate failed for ' .. depot_path, vim.log.levels.ERROR)
    return
  end

  -- Skip header line
  table.remove(output, 1)

  local cl_lines = {}
  for _, line in ipairs(output) do
    local cl, user = line:match('^(%d+) %(([^%)]+)%):')
    if cl and user then
      table.insert(cl_lines, string.format(' %-9s %-12s ', cl, user))
    elseif cl then
      table.insert(cl_lines, string.format(' %-9s              ', cl))
    else
      table.insert(cl_lines, '                        ')
    end
  end

  vim.cmd('leftabove vnew')
  local blame_buf = vim.api.nvim_get_current_buf()
  local blame_win = vim.api.nvim_get_current_win()

  vim.api.nvim_buf_set_lines(blame_buf, 0, -1, false, cl_lines)

  -- Buffer options
  vim.bo[blame_buf].buftype = 'nofile'
  vim.bo[blame_buf].bufhidden = 'wipe'
  vim.bo[blame_buf].swapfile = false
  vim.bo[blame_buf].filetype = 'g4blame'

  -- Window options
  vim.wo[blame_win].number = false
  vim.wo[blame_win].relativenumber = false
  vim.wo[blame_win].signcolumn = 'no'
  vim.wo[blame_win].foldcolumn = '0'
  vim.wo[blame_win].wrap = false
  vim.api.nvim_win_set_width(blame_win, 24)

  -- Synchronized scrolling
  vim.wo[blame_win].scrollbind = true
  vim.wo[current_win].scrollbind = true

  -- Keymaps inside blame window
  vim.keymap.set('n', 'q', function()
    pcall(vim.api.nvim_win_set_option, current_win, 'scrollbind', false)
    pcall(vim.api.nvim_win_close, blame_win, true)
  end, { buffer = blame_buf, silent = true })

  -- Return focus to main editor window
  vim.api.nvim_set_current_win(current_win)
end

return {
  {
    name = 'g4-blame',
    dir = '/dev/null',
    virtual = true,
    config = function()
      vim.api.nvim_create_user_command('G4Blame', M.toggle, { desc = 'Toggle Piper G4 Blame sidebar' })
      vim.keymap.set('n', '<leader>hb', M.toggle, { desc = '[H]g/Piper G4 [B]lame' })
    end,
  },
}
