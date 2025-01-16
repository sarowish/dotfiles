return {
    'kyazdani42/nvim-tree.lua',
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = { { '<A-tab>', "<cmd>NvimTreeToggle<cr>", mode = 'n' } },
    opts = {
        disable_netrw = true,
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
        renderer = {
            highlight_opened_files = 'name',
            indent_markers = {
                enable = true,
            },
        }
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)

        local nvim_tree_events = require('nvim-tree.events')
        local bufferline_api = require('bufferline.api')

        local function get_tree_size()
            return require 'nvim-tree.view'.View.width
        end



        nvim_tree_events.subscribe("TreeOpen", function()
            bufferline_api.set_offset(get_tree_size())
        end)

        nvim_tree_events.subscribe("Resize", function()
            bufferline_api.set_offset(get_tree_size())
        end)

        nvim_tree_events.subscribe("TreeClose", function()
            bufferline_api.set_offset(0)
        end)

        vim.api.nvim_create_autocmd("BufEnter", {
            nested = true,
            callback = function()
                if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
                    vim.cmd "quit"
                end
            end
        })
    end
}
