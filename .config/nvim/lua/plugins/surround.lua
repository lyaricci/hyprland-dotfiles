return {
	-- "kylechui/nvim-surround",
	-- version = "*", -- Use for stability; omit to use `main` branch for the latest features
	-- event = "VeryLazy",
	-- config = function()
	--   require("nvim-surround").setup({
	--     -- Configuration here, or leave empty to use defaults
	--   })
	-- end,
	--
	-- Change mini.surround mappings
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
	},
}
