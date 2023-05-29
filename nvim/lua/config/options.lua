-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
	backup = false, -- creates a backup file
	clipboard = "xclip", -- allows neovim to access the system clipboard
	cmdheight = 1, -- more space in the neovim command line for displaying messages
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	conceallevel = 0, -- so that `` is visible in markdown files
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	swapfile = false, -- creates a swapfile
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	numberwidth = 2, -- set number column width to 2 {default 4}
	wrap = true, -- display lines as one long line
}
