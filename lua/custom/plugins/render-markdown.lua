local ns = vim.api.nvim_create_namespace('render_markdown_ascii_flowcharts')

local function clear_ascii_diagrams(buf)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  end
end

local function render_ascii_diagrams(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  clear_ascii_diagrams(buf)

  local ok, parser = pcall(vim.treesitter.get_parser, buf, 'markdown')
  if not ok or not parser then
    return
  end

  local tree = parser:parse()[1]
  if not tree then
    return
  end

  local query = vim.treesitter.query.parse(
    'markdown',
    [[
    (fenced_code_block) @block
    ]]
  )

  for id, node, _ in query:iter_captures(tree:root(), buf, 0, -1) do
    local capture_name = query.captures[id]
    if capture_name == 'block' then
      local lang = nil
      local code = nil
      for child in node:iter_children() do
        if child:type() == 'info_string' then
          lang = vim.treesitter.get_node_text(child, buf):match('^%s*(%S+)')
        elseif child:type() == 'code_fence_content' then
          code = vim.treesitter.get_node_text(child, buf)
        end
      end

      if (lang == 'mermaid' or lang == 'dot') and code then
        local _, _, end_row, _ = node:range()

        local ascii_lines = {}
        if lang == 'mermaid' then
          if vim.fn.executable('mermaid2ascii') == 1 then
            ascii_lines = vim.fn.systemlist({ 'mermaid2ascii' }, code)
            if vim.v.shell_error ~= 0 then
              ascii_lines = {}
            end
          else
            vim.notify_once('[render-markdown] mermaid2ascii CLI is not installed; mermaid blocks cannot be rendered as ASCII', vim.log.levels.WARN)
          end
        elseif lang == 'dot' then
          if vim.fn.executable('graph-easy') == 1 then
            ascii_lines = vim.fn.systemlist({ 'graph-easy', '--as=boxart' }, code)
            if vim.v.shell_error ~= 0 then
              ascii_lines = {}
            end
          else
            vim.notify_once('[render-markdown] graph-easy CLI is not installed; dot blocks cannot be rendered as ASCII', vim.log.levels.WARN)
          end
        end

        if #ascii_lines > 0 and ascii_lines[1] ~= '' then
          local virt_lines = {}
          table.insert(virt_lines, { { '─── Rendered ASCII Flowchart ───', 'Comment' } })
          for _, line in ipairs(ascii_lines) do
            table.insert(virt_lines, { { line, 'SpecialComment' } })
          end

          vim.api.nvim_buf_set_extmark(buf, ns, end_row, 0, {
            virt_lines = virt_lines,
            virt_lines_above = false,
          })
        end
      end
    end
  end
end

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      enabled = false,
      pipe_table = {
        enabled = true,
        preset = 'round',
        style = 'full',
        cell = 'padded',
      },
      custom_handlers = {
        markdown = {
          extends = true,
          parse = function(_, buf)
            render_ascii_diagrams(buf)
            return {}
          end,
        },
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)

      vim.keymap.set('n', '<leader>rm', function()
        require('render-markdown').toggle()
      end, { desc = '[R]ender [M]arkdown toggle' })
    end,
  },
}


