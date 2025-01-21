return {
    'romgrk/barbar.nvim',
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {
        auto_hide = true,
        icons = {
            button = '✖'
        },
        sidebar_filetypes = {
            NvimTree = true
        }
    }
}
