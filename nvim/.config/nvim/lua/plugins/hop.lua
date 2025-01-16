return {
    'smoka7/hop.nvim',
    keys =
    {
        { '<leader>w', function() require('hop').hint_words() end,                 mode = '' },
        { '<leader>/', function() require('hop').hint_patterns() end },
        { '<leader>f', function() require('hop').hint_char1() end,                 mode = '' },
        { '<leader>s', function() require('hop').hint_char2() end },
        { '<leader>j', function() require('hop').hint_lines_skip_whitespace() end, mode = '' },
    },
    opts = {
        multi_windows = true },
}
