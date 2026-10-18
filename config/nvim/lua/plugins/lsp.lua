-- LSP: servers are installed by Mason automatically the first time you open
-- a file of a given language, then enabled with the built-in vim.lsp.enable().
-- Server configs (cmd, root markers...) come from nvim-lspconfig's lsp/*.lua.

-- filetype -> Mason packages to install and enable for it
local servers_for_ft = {
    lua             = { "lua-language-server" },
    python          = { "pyright", "ruff" },
    rust            = { "rust-analyzer" },
    go              = { "gopls" },
    c               = { "clangd" },
    cpp             = { "clangd" },
    cs              = { "omnisharp" },
    javascript      = { "vtsls" },
    javascriptreact = { "vtsls" },
    typescript      = { "vtsls" },
    typescriptreact = { "vtsls" },
    html            = { "html-lsp" },
    css             = { "css-lsp" },
    scss            = { "css-lsp" },
    json            = { "json-lsp" },
    jsonc           = { "json-lsp" },
    yaml            = { "yaml-language-server" },
    toml            = { "taplo" },
    sh              = { "bash-language-server" },
    bash            = { "bash-language-server" },
    markdown        = { "marksman" },
    dockerfile      = { "dockerfile-language-server" },
    typst           = { "tinymist" },
    tex             = { "texlab" },
    plaintex        = { "texlab" },
}

-- Servers that come from system packages instead of Mason
local system_servers = {
    qml = { name = "qmlls", cmd = { "/usr/lib/qt6/bin/qmlls" } }, -- from qt6-declarative
}

local function ensure_server(pkg_name)
    local registry = require("mason-registry")
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if not ok then
        return
    end
    local lsp_name = pkg.spec.neovim and pkg.spec.neovim.lspconfig
    if not lsp_name then
        return
    end

    if pkg:is_installed() then
        vim.lsp.enable(lsp_name)
        return
    end
    if pkg:is_installing() then
        return
    end

    vim.notify("LSP: instaluję " .. pkg_name .. "…", vim.log.levels.INFO)
    pkg:install({}, vim.schedule_wrap(function(success)
        if success then
            vim.notify("LSP: zainstalowano " .. pkg_name, vim.log.levels.INFO)
            vim.lsp.enable(lsp_name) -- also attaches to buffers that are already open
        else
            vim.notify("LSP: nie udało się zainstalować " .. pkg_name .. " (:Mason)", vim.log.levels.WARN)
        end
    end))
end

return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        -- Better lua_ls support for editing the Neovim config itself
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            require("mason").setup()

            -- Completion capabilities for every server
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
            })

            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN]  = " ",
                        [vim.diagnostic.severity.HINT]  = "󰠠 ",
                        [vim.diagnostic.severity.INFO]  = " ",
                    },
                },
            })

            -- System servers
            for ft, server in pairs(system_servers) do
                if vim.fn.executable(server.cmd[1]) == 1 then
                    vim.lsp.config(server.name, { cmd = server.cmd, filetypes = { ft } })
                    vim.lsp.enable(server.name)
                end
            end

            -- Auto-install Mason servers per filetype
            local function on_filetype(ft)
                local pkgs = servers_for_ft[ft]
                if not pkgs then
                    return
                end
                require("mason-registry").refresh(vim.schedule_wrap(function()
                    for _, pkg_name in ipairs(pkgs) do
                        ensure_server(pkg_name)
                    end
                end))
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("UserLspAutoInstall", {}),
                callback = function(ev)
                    on_filetype(ev.match)
                end,
            })
            -- The buffer that triggered loading this plugin already has its filetype set
            on_filetype(vim.bo.filetype)

            -- Keymaps (Neovim also provides defaults: grn, gra, grr, gri, gO, K)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
                    end
                    map("n", "gR", function() Snacks.picker.lsp_references() end, "Show LSP references")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Show LSP definitions")
                    map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Show LSP implementations")
                    map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, "Show LSP type definitions")
                    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
                    map("n", "<leader>D", function() Snacks.picker.diagnostics_buffer() end, "Show buffer diagnostics")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
                    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
                    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
                    map("n", "K", vim.lsp.buf.hover, "Show documentation under cursor")
                    map("n", "<leader>rs", "<cmd>lsp restart<CR>", "Restart LSP")
                end,
            })
        end,
    },
}
