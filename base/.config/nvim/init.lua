-- -----------------------------------------------------------------------------
-- source vimrc
-- -----------------------------------------------------------------------------
vim.cmd('source ' .. vim.fn.expand('<sfile>:p:h') .. '/vimrc')

-- -----------------------------------------------------------------------------
-- nvim-lspconfig
-- -----------------------------------------------------------------------------
local lsp_ok, lsp = pcall(require, 'lspconfig')
local function lsp_setup(server, config)
    local cmd = config.cmd or lsp[server].document_config.default_config.cmd
    if lsp.util.has_bins(cmd[1]) then
        lsp[server].setup(config)
    end
end

if lsp_ok then
    lsp_setup('gopls', {})
    lsp_setup('rust_analyzer', {})
    lsp_setup('bashls', {})
    lsp_setup('pyright', {})
    lsp_setup('sumneko_lua', {
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
    })
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
