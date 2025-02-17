return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    {
      mode = 'n',
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'load the session for the current directory',
    },
    {
      mode = 'n',
      '<leader>qS',
      function()
        require('persistence').select()
      end,
      desc = 'select a session to load',
    },
    {
      mode = 'n',
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'load the last session',
    },
    {
      mode = 'n',
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = 'stop Persistence',
    },
  },
}
