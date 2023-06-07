require("catppuccin").setup({
  color_overrides = {
    mocha = {
      base = "#000000", -- bg transparent: base = '#000000'
    },
  },
})

return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
