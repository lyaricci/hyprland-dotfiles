-- require("notify").setup({
-- 	background_colour = "#000",
-- })

-- THEMES
require("plugins.themes.catppuccin")
require("plugins.themes.kanagawa")
require("plugins.themes.tokyonight")
require("plugins.themes.moonfly")

return {

	{ "RRethy/nvim-base16" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "base16-material-darker",
		},
	},
}
