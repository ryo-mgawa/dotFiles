return {
  'lopi-py/luau-lsp.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('luau-lsp').setup {
      platform = {
        type = 'roblox',
      },
      types = {
        roblox_security_level = 'PluginSecurity',
      },
      sourcemap = {
        enabled = true,
        autogenerate = true,
        watch = true,
      },
    }
  end,
}
