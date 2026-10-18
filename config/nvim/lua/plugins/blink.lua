-- Completion: blink.cmp (replaces nvim-cmp + its source plugins + LuaSnip)
return {
    "saghen/blink.cmp",
    version = "*", -- release tags ship a prebuilt fuzzy matcher, no Rust build needed
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "enter", -- <CR> accepts, <C-Space> opens, <C-e> closes
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        },
        completion = {
            list = { selection = { preselect = false, auto_insert = false } },
            documentation = { auto_show = true, auto_show_delay_ms = 300 },
            accept = { auto_brackets = { enabled = true } },
        },
        signature = { enabled = true },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },
    },
    opts_extend = { "sources.default" },
}
