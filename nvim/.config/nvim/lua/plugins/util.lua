return {
    { 'nvim-lua/plenary.nvim',       lazy = true },
    { 'kyazdani42/nvim-web-devicons' },
    { "folke/which-key.nvim",        event = "VeryLazy" },
    { 'windwp/nvim-autopairs',       event = 'InsertEnter',        config = true },
    { 'L3MON4D3/LuaSnip',            event = 'InsertEnter' },
    { 'saecki/crates.nvim',          event = 'BufRead Cargo.toml', config = true },
}
