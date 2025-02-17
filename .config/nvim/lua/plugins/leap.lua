return {
  'ggandor/leap.nvim',
  config = function()
    local leap = require 'leap'
    leap.create_default_mappings()

    leap.case_sensitive = false
    leap.equivalence_classes = { ' \t\r\n' }
    leap.max_phase_one_targets = nil
    leap.highlight_unlabeled_phase_one_targets = false
    leap.max_highlighted_traversal_targets = 10
    leap.substitute_chars = {}
    leap.safe_labels = 'sfnut/SFNLHMUGTZ?'
    leap.labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?'
    leap.special_keys = {
      next_target = '<enter>',
      prev_target = '<tab>',
      next_group = '<space>',
      prev_group = '<tab>',
    }
  end,
}
