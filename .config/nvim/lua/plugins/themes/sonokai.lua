return {
  'sainnhe/sonokai',
  lazy = false,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.sonokai_enable_italic = true

    -- styles: default, atlantis, andromeda, shusia, maia, espresso
    vim.g.sonokai_style = 'andromeda'
    vim.g.sonokai_transparent_background = 2

    vim.cmd.colorscheme 'sonokai'
  end,
}
