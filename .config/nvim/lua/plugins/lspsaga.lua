return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        enable = false, -- use 'Bekaboo/dropbar.nvim'
      },
    }

    -- Hover
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')

    -- Diagnostic
    vim.keymap.set('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<CR>', { noremap = true, silent = true })

    -- peek definition
    vim.keymap.set('n', '<leader>pd', '<cmd>Lspsaga peek_definition<CR>')
    vim.keymap.set('n', '<leader>pt', '<cmd>Lspsaga peek_type_definition<CR>')

    -- Callhierarchy
    vim.keymap.set('n', '<leader>pc', '<cmd>Lspsaga incoming_calls<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
