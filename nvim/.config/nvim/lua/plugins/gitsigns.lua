return {
    'lewis6991/gitsigns.nvim',
    priority = 100,
    opts = {
        signs                        = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '┃' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
        },
        signcolumn                   = true,
        numhl                        = false,
        linehl                       = false,
        word_diff                    = false,
        watch_gitdir                 = {
            interval = 1000,
            follow_files = true
        },
        diff_opts                    = {
            algorithm = "histogram",
        },
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil, -- Use default
        max_file_length              = 40000,
        preview_config               = {
            -- Options passed to nvim_open_win
            border = 'rounded',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
        on_attach                    = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            -- Actions
            map('n', '<leader>gs', gs.stage_hunk)
            map('n', '<leader>gr', gs.reset_hunk)
            map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            map('n', '<leader>gS', gs.stage_buffer)
            map('n', '<leader>gu', gs.undo_stage_hunk)
            map('n', '<leader>gR', gs.reset_buffer)
            map('n', '<leader>gp', gs.preview_hunk)
            map('n', '<leader>gb', function() gs.blame_line { full = true } end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>gd', gs.diffthis)
            map('n', '<leader>gD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
}
