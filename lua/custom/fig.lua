local M = {}

--- Custom Telescope picker to browse and open files modified in the current Fig CL/changeset (.)
function M.telescope_current_cl()
  local t_utils = require("telescope.utils")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local previewers = require("telescope.previewers")
  local putils = require("telescope.previewers.utils")

  -- 1. Get repo root to ensure paths resolve correctly from any subdirectory
  local root_match = t_utils.get_os_command_output({"chg", "root"})
  if not root_match or #root_match == 0 then
    print("Not in a fig repository")
    return
  end
  local root = root_match[1] .. "/"

  -- 2. Run chg status --change . with template to force repo-relative paths
  local cmd = { "chg", "status", "--change", ".", "--template={status} {path}\n" }
  local output = t_utils.get_os_command_output(cmd)

  -- 3. Launch Telescope picker
  pickers.new({}, {
    prompt_title = "Files in current CL (.)",
    finder = finders.new_table({
      results = output,
      entry_maker = function(entry)
        -- entry format: "M google3/path/to/file.cc"
        local status, file = string.match(entry, "(.) (.*)")
        if not file then return nil end
        local absolute_path = root .. file
        return {
          value = file,
          display = entry,
          ordinal = file,
          filename = absolute_path,
          status = status,
        }
      end,
    }),
    sorter = conf.file_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = "chg diff -c .",
      define_preview = function(self, entry)
        -- Show the diff for this file specifically in the current changeset
        local diff_cmd = { "chg", "diff", "-c", ".", root .. entry.value }
        putils.job_maker(diff_cmd, self.state.bufnr, {
          value = entry.value,
          bufname = self.state.bufname,
        })
        putils.regex_highlighter(self.state.bufnr, "diff")
      end,
    }),
  }):find()
end

return M
