return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 200,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = "     - <author>, <author_time:%Y-%m-%d> - <summary>",
  },
}
