return {
  "nvim-treesitter/nvim-treesitter-context",
  opts = {
    enable = true,
    default = {
      "class",
      "function",
      "method",
      "for",
      "while",
      "if",
      "switch",
      "case",
      "interface",
      "struct",
      "enum",
    },
    json = {
      "pair",
    },
    typescript = {
      "export_statement",
    },
    yaml = {
      "block_mapping_pair",
    },
    ruby = {
      "call",
      "module",
    },
  },
}
