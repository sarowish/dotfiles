return {
    'nvim-treesitter/nvim-treesitter',
    opts = {
        highlight = {
            enable = true,
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        }
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)

        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

        parser_config.dgeval = {
            install_info = {
                url = "~/tree-sitter-dgeval",
                files = { "src/parser.c" },
            }
        }
    end
}
