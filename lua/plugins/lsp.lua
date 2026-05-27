return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Globally wrap the documentHighlight handler to silently ignore any errors
      -- (some servers like CiderLSP advertise capability but fail on specific filetypes like BUILD or markdown)
      local original_highlight_handler = vim.lsp.handlers["textDocument/documentHighlight"]
      vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
        if err then
          return
        end
        if original_highlight_handler then
          original_highlight_handler(err, result, ctx, config)
        end
      end

      local function python_supports_mason_pypi()
        if vim.fn.executable 'python3' ~= 1 then
          return false
        end

        vim.fn.system { 'python3', '-c', 'import ensurepip, venv' }
        return vim.v.shell_error == 0
      end

      local has_ruff = vim.fn.executable 'ruff' == 1
      local can_manage_ruff_with_mason = python_supports_mason_pypi()

      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name ~= 'ciderlsp' and vim.startswith(vim.api.nvim_buf_get_name(event.buf), '/google') then
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(event.buf) then
                vim.lsp.buf_detach_client(event.buf, client.id)
                -- Clear any diagnostics published by this public LSP before it was detached
                local ns = vim.lsp.diagnostic.get_namespace(client.id)
                if ns then
                  vim.diagnostic.reset(ns, event.buf)
                end
              end
            end)
            return
          end

          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          if client and client.name == 'clangd' then
            -- disable semantic highlighting
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = false,
        jump = { float = true },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--header-insertion=never',
            '--background-index',
            '--clang-tidy',
            '--log=error',
          },
        },
        -- gopls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'basic',
                diagnosticMode = 'workspace',
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },
        ruff = (has_ruff or can_manage_ruff_with_mason) and {
          -- Ruff acts as both a linter (LSP diagnostics) and formatter (via conform).
          -- These settings control the LSP/linting side.
          init_options = {
            settings = {
              lineLength = 120, -- Max line length (mirrors formatter setting below)
              lint = {
                extendSelect = { 'E501' }, -- E501: Line too long
                ignore = { 'W391' }, -- W391: Blank line at end of file
              },
            },
          },
        } or nil,
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })

      if not has_ruff and can_manage_ruff_with_mason then
        table.insert(ensure_installed, 'ruff')
      end

      require('mason').setup {
        install_root_dir = vim.fn.stdpath 'data' .. '/mason',
        PATH = 'prepend',
        pip = {
          -- Bypassing corporate mirror that might be missing some packages or versions
          -- while we are on a new machine setup.
          install_args = { '--index-url', 'https://pypi.org/simple' },
        },
        npm = {
          -- Bypassing corporate mirror that might have expired tokens in ~/.npmrc
          install_args = { '--registry', 'https://registry.npmjs.org' },
        },
      }

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        -- We configure handlers to be empty because we are manually setting up servers below
        handlers = {},
      }

      -- Setup servers manually to ensure robust configuration and bypass logic
      local lsp_configs = require('lspconfig.configs')
      for server_name, server in pairs(servers) do
        local config = lsp_configs[server_name]
        if not config then
          goto continue
        end

        local default_root_dir = server.root_dir or (config.document_config and config.document_config.default_config and config.document_config.default_config.root_dir)
        server.root_dir = function(fname, bufnr)
          if vim.startswith(fname, '/google') then
            return nil
          end
          if default_root_dir then
            return default_root_dir(fname, bufnr)
          end
          return require('lspconfig.util').path.dirname(fname)
        end

        server.single_file_support = false
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        config.setup(server)

        ::continue::
      end

      -- Configure CiderLSP if available
      local ciderlsp_bin = vim.env.CIDERLSP_BIN
      if ciderlsp_bin and vim.fn.executable(ciderlsp_bin) == 1 then
        local configs = require('lspconfig.configs')
        if not configs.ciderlsp then
          local ciderlsp_settings = {
            "enable_placeholders",
            "enable:inlay_hints_kotlin_show_local_variable_types",
          }
          configs.ciderlsp = {
            default_config = {
              cmd = {
                ciderlsp_bin,
                "--tooltag=nvim-lsp",
                "--noforward_sync_responses",
                "--request_options=" .. table.concat(ciderlsp_settings, ","),
              },
              filetypes = {
                "borg", "bzl", "c", "cpp", "cs", "dart", "gcl", "go", "googlesql",
                "graphql", "java", "kotlin", "markdown", "mlir", "ncl", "objc",
                "patchpanel", "proto", "python", "qflow", "soy", "swift", "textpb",
                "typescript"
              },
              root_dir = function(filename)
                if vim.startswith(filename, '/google') then
                  return '/google'
                end
                return nil
              end,
            },
          }
        end
        require('lspconfig.configs').ciderlsp.setup({
          capabilities = capabilities,
        })
      end
    end,
  },

  { -- Autoformat
    -- Note: fallbacks to lsp default when formatters are not installed. See `:ConformInfo` to see which formatter is used for this buffer
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
      },
      formatters = {
        ruff_format = {
          -- Must mirror lineLength in the ruff LSP settings above
          prepend_args = { '--line-length', '120' },
        },
      },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
