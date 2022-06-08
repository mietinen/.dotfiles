-- -----------------------------------------------------------------------------
-- source vimrc
-- -----------------------------------------------------------------------------
vim.cmd('source ' .. vim.fn.expand('<sfile>:p:h') .. '/vimrc')

-- -----------------------------------------------------------------------------
-- nvim-lspconfig
-- -----------------------------------------------------------------------------
local lsp_ok, lsp = pcall(require, 'lspconfig')
if lsp_ok then
    -- pacman -S gopls rust-analyzer bash-language-server pyright lua-language-server
    lsp.gopls.setup {}
    lsp.rust_analyzer.setup {}
    lsp.bashls.setup {}
    lsp.pyright.setup {}
    lsp.sumneko_lua.setup {
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT', path = vim.split(package.path, ';'), },
                diagnostics = {
                    globals = { 'vim', 'awesome', 'client', 'screen', 'root' },
                    disable = { 'lowercase-global' },
                },
                workspace = { library = vim.api.nvim_get_runtime_file("", true), },
            },
        },
    }
end

-- -----------------------------------------------------------------------------
-- nvim-cmp
-- -----------------------------------------------------------------------------
local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
    cmp.setup({
        snippet = {
            expand = function(args)
                require('snippy').expand_snippet(args.body)
            end,
        },
        mapping = {
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'snippy' },
            { name = 'buffer' },
        })
    })
end

-- -----------------------------------------------------------------------------
-- nvim-snippy
-- -----------------------------------------------------------------------------
local snippy_ok, snippy = pcall(require, 'snippy')
if snippy_ok then
    snippy.setup({
        mappings = {
            is = {
                ['<Tab>'] = 'expand_or_advance',
                ['<S-Tab>'] = 'previous',
            },
            nx = {
                ['<leader>x'] = 'cut_text',
            },
        },
    })
end

-- vim: set ts=4 sw=4 tw=0 et :
