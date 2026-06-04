local path = vim.env.CODESEARCH_PLUGIN_PATH

if not path or vim.fn.isdirectory(path) == 0 then
  return {}
end

-- List of LDAP users to search in google3/experimental/waymo/users/ when using <leader>cse
local EXPERIMENTAL_USERS = {
  'alexandrecq',
  'lixiny',
  'liyenhsu',
}

local function get_experimental_query()
  local query
  if #EXPERIMENTAL_USERS == 0 then
    query = 'f:experimental/waymo/users/nonexistent_user_placeholder'
  elseif #EXPERIMENTAL_USERS == 1 then
    query = 'f:experimental/waymo/users/' .. EXPERIMENTAL_USERS[1]
  else
    query = 'f:experimental/waymo/users/(' .. table.concat(EXPERIMENTAL_USERS, '|') .. ')'
  end
  return ' ' .. query .. ' '
end

return {
  {
    dir = path,
    name = 'telescope-codesearch',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      -- This asks telescope to load the codesearch extension and makes
      -- the 'codesearch' picker available through the `Telescope` command.
      pcall(require('telescope').load_extension, 'codesearch')

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = 'CodeSearch: ' .. desc })
      end

      -- Custom mappings for quick access
      map('<leader>csf', require('telescope').extensions.codesearch.find_files, '[F]ind files')
      map('<leader>cse', function()
        require('telescope').extensions.codesearch.find_files({
          experimental = true,
          hidden_query = get_experimental_query(),
        })
      end, 'Include [E]xperimental files')
      map('<leader>csq', require('telescope').extensions.codesearch.find_query, '[Q]uery')
      map('<leader>csw', function()
        require('telescope').extensions.codesearch.find_query { default_text_expand = '<cword>' }
      end, 'Search [W]ord under cursor')
      map('<leader>css', function()
        require('telescope').extensions.codesearch.find_files { default_text_expand = '<cword>' }
      end, 'Search file with [S]ame name as word')
    end,
  },
}
