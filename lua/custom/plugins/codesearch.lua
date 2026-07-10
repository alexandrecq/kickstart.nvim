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
      -- Load telescope codesearch extension
      pcall(require('telescope').load_extension, 'codesearch')

      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local utils = require('telescope.utils')
      local strings = require('plenary.strings')
      local entry_display = require('telescope.pickers.entry_display')

      local default_opts = {
        corpus = 'piper',
        backend = 'cs',
        experimental = false,
        check_existence = false,
        add_workspace = true,
        enable_proximity = true,
        google_src = '/google/src',
        max_num_results = 200,
        disable_devicons = false,
        directory_hl_group = 'TelescopeResultsComment',
        filename_hl_group = 'TelescopeResultsClass',
      }

      local function getWorkspaceId(opts)
        local cwd = vim.fn.getcwd()
        local google3Path = string.match(cwd, '^(' .. opts.google_src .. '/cloud/[^/]+/[^/]+)/google3')
        if not google3Path then return 'head' end
        local workspaceFile = google3Path .. '/.citc/workspace_id'
        if vim.fn.filereadable(workspaceFile) ~= 1 then return 'head' end
        return vim.fn.readfile(workspaceFile)[1]
      end

      local function getLdapAndCitc(opts)
        local cwd = vim.fn.getcwd()
        return string.match(cwd, '^' .. opts.google_src .. '/cloud/([^/]+/[^/]+)/google3')
      end

      local function build_cs_file_cmd(prompt, opts)
        local cmd = {
          opts.backend or 'cs',
          '--max_num_results=' .. (opts.max_num_results or 200),
          '--corpus=' .. (opts.corpus or 'piper'),
          '--check_existence=' .. tostring(opts.check_existence or false),
          '-l',
          '-i',
          '--local',
          '--enable_local_proxy=true',
          '--default_match_content_only=false',
        }

        if opts.experimental then
          table.insert(cmd, '--experimental')
        end

        local retrieve_end_user_credentials = '--retrieve_end_user_credentials='
          .. tostring(opts.retrieve_end_user_credentials or false)
        table.insert(cmd, retrieve_end_user_credentials)

        table.insert(cmd, '--')

        if opts.hidden_query and opts.hidden_query ~= '' then
          table.insert(cmd, '(' .. opts.hidden_query .. ')')
        end

        if not prompt or prompt:match('^%s*$') then
          table.insert(cmd, 'f:.')
        else
          local terms = vim.split(prompt, '%s+', { trimempty = true })
          for _, t in ipairs(terms) do
            -- 1. Pass-through for explicit CodeSearch filter syntax (e.g., lang:py, f:foo, -f:bar)
            if t:match('^[%a_]+:') or t:match('^%-[%a_]+:') then
              table.insert(cmd, t)
            -- 2. Preserve raw regex or path slashes (e.g., waymo/planner, *.py) without modifying
            elseif t:match('[/%[%]%(%)%*%+%?%^%$%%\\]') then
              table.insert(cmd, 'f:' .. t)
            -- 3. Split delimiter-separated terms (e.g. metric_potential_co) into separate f: filters
            elseif t:match('[_%-]') then
              local parts = vim.split(t, '[_%-]', { trimempty = true })
              for _, p in ipairs(parts) do
                if #p > 0 then
                  table.insert(cmd, 'f:' .. p)
                end
              end
            -- 4. Convert single continuous words (e.g., metpotco, pipebuilfdl) into filename-restricted
            --    subsequence regexes (f:[^/]*c1[^/]*c2...). Uses [^/]* to avoid matching across directory
            --    slashes, leaving candidate ranking and scoring to Telescope's FZF sorter.
            else
              local chars = {}
              for i = 1, #t do
                local c = t:sub(i, i)
                if c:match('%w') then
                  table.insert(chars, c)
                end
              end
              if #chars > 0 then
                table.insert(cmd, 'f:[^/]*' .. table.concat(chars, '[^/]*'))
                if #chars >= 3 then
                  local hint = chars[1] .. chars[2] .. chars[3]
                  table.insert(cmd, 'f:' .. hint)
                end
              else
                table.insert(cmd, 'f:' .. t)
              end
            end
          end
        end

        local workspaceId = getWorkspaceId(opts)
        if opts.add_workspace and workspaceId ~= 'head' then
          table.insert(cmd, 'add_workspace:' .. workspaceId)
        end

        return cmd
      end

      local function create_codesearch_entry_maker(opts)
        local workspaceId = getWorkspaceId(opts)
        local ldapAndCitc = getLdapAndCitc(opts)

        return function(entry)
          if not entry or entry == '' then return nil end

          if ldapAndCitc then
            entry = entry:gsub(workspaceId .. '//depot', ldapAndCitc, 1)
            entry = entry:gsub(workspaceId, ldapAndCitc, 1)
          end

          local make_display = function(e)
            local display = e.value
            display = display:gsub('^' .. opts.google_src .. '/cloud/[^/]+/[^/]+/', '', 1)
            display = display:gsub('^' .. opts.google_src .. '/files/[^/]+/depot/', '', 1)
            display = utils.transform_path(opts, display)

            local directory, filename = display:match('^(.+/)(.+)$')
            if directory == nil then
              directory = ''
              filename = display
            end

            local icon, hl_group = utils.get_devicons(filename, opts.disable_devicons)
            local icon_width = 0
            if not opts.disable_devicons then
              local templateIcon = utils.get_devicons('fname', opts.disable_devicons)
              icon_width = strings.strdisplaywidth(templateIcon)
            end

            local function formatDirectory(dir)
              dir = dir or ''
              if opts.disable_devicons then return dir else return ' ' .. dir end
            end

            local displayer = entry_display.create({
              separator = '',
              items = {
                { width = icon_width },
                {},
                { remaining = true },
              },
            })

            return displayer({
              { icon, hl_group },
              { formatDirectory(directory), opts.directory_hl_group or 'TelescopeResultsComment' },
              { filename or '', opts.filename_hl_group or 'TelescopeResultsClass' },
            })
          end

          return {
            value = entry,
            display = make_display,
            ordinal = entry,
            filename = entry,
            row = nil,
            col = 0,
          }
        end
      end

      local function getDefaultText(opts)
        if opts['default_text_expand'] then
          return vim.fn.expandcmd(opts['default_text_expand'])
        end

        local mode = vim.api.nvim_get_mode().mode
        if mode == 'v' then
          local startSelectionRow = vim.fn.line('v')
          local endSelectionRow = vim.fn.line('.')
          if startSelectionRow == endSelectionRow then
            local start_col = vim.fn.col('.')
            local end_col = vim.fn.col('v')
            if start_col > end_col then start_col, end_col = end_col, start_col end
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes('<esc>', true, false, true),
              'm',
              true
            )
            local line = vim.api.nvim_buf_get_lines(0, startSelectionRow - 1, startSelectionRow, 0)
            return '"' .. string.sub(line[1], start_col, end_col) .. '"'
          end
        end
      end

      local function custom_find_files(opts)
        opts = opts or {}
        opts = vim.tbl_extend('force', default_opts, opts)

        if opts['default_text'] == nil then
          opts['default_text'] = getDefaultText(opts)
        end

        local finder = finders.new_job(function(prompt)
          return build_cs_file_cmd(prompt, opts)
        end, create_codesearch_entry_maker(opts))

        local picker = pickers.new(opts, {
          results_title = 'codesearch',
          prompt_title = 'fuzzy file search',
          finder = finder,
          sorter = conf.file_sorter(opts),
          previewer = conf.file_previewer(opts),
        })
        picker:find()
      end

      -- Override telescope.extensions.codesearch.find_files
      local cs_ext = require('telescope').extensions.codesearch
      if cs_ext then
        cs_ext.find_files = custom_find_files
      end

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = 'CodeSearch: ' .. desc })
      end

      -- Custom mappings for quick access
      map('<leader>csf', custom_find_files, '[F]ind files')
      map('<leader>cse', function()
        custom_find_files({
          experimental = true,
          hidden_query = get_experimental_query(),
        })
      end, 'Include [E]xperimental files')
      map('<leader>csq', require('telescope').extensions.codesearch.find_query, '[Q]uery')
      map('<leader>csw', function()
        require('telescope').extensions.codesearch.find_query { default_text_expand = '<cword>' }
      end, 'Search [W]ord under cursor')
      map('<leader>css', function()
        custom_find_files { default_text_expand = '<cword>' }
      end, 'Search file with [S]ame name as word')
    end,
  },
}
