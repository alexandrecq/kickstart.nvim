return {
  {
    url = "sso://googler@user/tylersaunders/telescope-fig.nvim",
    name = "telescope-fig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      pcall(require("telescope").load_extension, "fig")
    end,
  },
}
