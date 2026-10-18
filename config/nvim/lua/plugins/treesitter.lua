-- Treesitter (main branch): highlighting and indent are started by Neovim itself;
-- this plugin only installs parsers. Missing parsers install automatically the
-- first time you open a file of that language (needs `tree-sitter` CLI + a C compiler).

local max_filesize = 100 * 1024 -- skip treesitter for files over 100 KB

-- Parsers Neovim ships itself; nvim-treesitter's newer queries need its own versions
local base_parsers = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }

local function is_large(buf)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats and stats.size > max_filesize
end

local function start(buf, lang)
    if not vim.api.nvim_buf_is_valid(buf) or not pcall(vim.treesitter.start, buf, lang) then
        return false
    end
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    return true
end

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.setup()

        if vim.fn.executable("tree-sitter") == 0 then
            vim.notify("Treesitter: brak `tree-sitter` CLI (sudo pacman -S tree-sitter-cli)", vim.log.levels.WARN)
            return
        end

        ts.install(base_parsers) -- no-op for parsers that are already installed

        local available = {}
        for _, lang in ipairs(ts.get_available()) do
            available[lang] = true
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("UserTreesitter", {}),
            callback = function(ev)
                local buf = ev.buf
                local lang = vim.treesitter.language.get_lang(ev.match)
                if not lang or not available[lang] or is_large(buf) then
                    return
                end
                if vim.tbl_contains(ts.get_installed("parsers"), lang) then
                    start(buf, lang)
                    return
                end
                ts.install(lang):await(vim.schedule_wrap(function(err)
                    if not err then
                        start(buf, lang)
                    end
                end))
            end,
        })
    end,
}
