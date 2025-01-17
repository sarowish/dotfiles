return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            local is_pos_in_range = function(position, range)
                return position.line == range.start.line and position.character >= range.start.character and
                    position.character <= range['end'].character
            end


            local jump_to_ref = function(relative)
                local position = vim.lsp.util.make_position_params()
                local locations = vim.tbl_map(function(item) return item.user_data end, vim.fn.getloclist(0))

                for idx, location in pairs(locations) do
                    if is_pos_in_range(position.position, location.range) then
                        idx = (idx + relative - 1) % #locations + 1
                        vim.lsp.util.show_document(locations[idx], "utf-16")
                        vim.api.nvim_exec_autocmds("CursorHold", { group = "lsp-highlight" })
                        vim.notify(("Local References [%d/%d]"):format(idx, #locations))
                        break
                    end
                end
            end

            local get_document_highlights = function()
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, 'textDocument/documentHighlight', params, function(_, result, ctx)
                    if not result then
                        return
                    end

                    local as_locations = vim.tbl_map(function(document_highlight)
                        return {
                            range = document_highlight.range,
                            uri = vim.uri_from_bufnr(ctx.bufnr)
                        }
                    end, result)

                    local items = vim.lsp.util.locations_to_items(as_locations, "utf-16")
                    vim.fn.setloclist(0, items, ' ')
                    vim.lsp.util.buf_highlight_references(ctx.bufnr, result, "utf-16")
                end)
            end

            local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
            local diagnostic_signs = {}
            for type, icon in pairs(signs) do
                diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end
            vim.diagnostic.config { signs = { text = diagnostic_signs } }

            -- Fuck You Telescope
            vim.fn.sign_define("DiagnosticSignError",
                { text = "", texthl = "DiagnosticError" })
            vim.fn.sign_define("DiagnosticSignWarn",
                { text = "", texthl = "DiagnosticWarn" })
            vim.fn.sign_define("DiagnosticSignInfo",
                { text = "", texthl = "DiagnosticInfo" })
            vim.fn.sign_define("DiagnosticSignHint",
                { text = "", texthl = "DiagnosticHint" })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local lsp = require('lspconfig')

            lsp.pyright.setup {
                capabilities = capabilities,
            }

            lsp.clangd.setup {
                capabilities = capabilities,
            }

            lsp.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { 'vim' },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
                    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
                    map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
                    map('gr', require('telescope.builtin').lsp_references, 'Goto References')
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

                    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
                    map('ga', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

                    map('<leader><leader>s', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
                    map('<leader><leader>w', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                        'Workspace Symbols')

                    map('K', vim.lsp.buf.hover, "Hover Information")
                    map('<leader>K', vim.lsp.buf.signature_help, "Signature Information")

                    map('<leader><leader>d', require('telescope.builtin').diagnostics, "List Diagnostics")
                    map('<leader>d', vim.diagnostic.open_float, "Show Diagnostic")
                    map('g[', vim.diagnostic.goto_prev, "Previous Diagnostic")
                    map('g]', vim.diagnostic.goto_next, "Next Diagnostic")


                    map('#', function() jump_to_ref(-vim.v.count1) end, "Jump to previous reference")
                    map('*', function() jump_to_ref(vim.v.count1) end, "Jump to next reference")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = get_document_highlights,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = function()
                                vim.lsp.buf.clear_references()
                            end
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        vim.lsp.inlay_hint.enable()
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, 'Toggle Inlay Hints')
                    end
                end
            })
        end
    },

    {
        'Bekaboo/dropbar.nvim',
        config = function()
            local dropbar_api = require('dropbar.api')
            vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
            vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
            vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
        end
    }
}
