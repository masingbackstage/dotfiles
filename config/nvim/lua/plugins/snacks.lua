-- Fuzzy picker: snacks.nvim (replaces telescope.nvim)
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        picker = {
            enabled = true,
            sources = {
                explorer = {
                    hidden = true, -- show dotfiles (toggle with H)
                    layout = { layout = { width = 32 } },
                },
            },
        },
        -- File tree sidebar; also opens instead of netrw for `nvim .`
        explorer = { enabled = true, replace_netrw = true },
    },
    keys = {
        { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
        { "<leader>ff", function() Snacks.picker.files() end,       desc = "Find files" },
        { "<leader>fg", function() Snacks.picker.grep() end,        desc = "Live grep" },
        { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
        { "<leader>fh", function() Snacks.picker.help() end,        desc = "Help tags" },
        { "<leader>fr", function() Snacks.picker.recent() end,      desc = "Recent files" },
        { "<leader>fw", function() Snacks.picker.grep_word() end,   desc = "Grep word under cursor", mode = { "n", "x" } },
        { "<leader>fk", function() Snacks.picker.keymaps() end,     desc = "Keymaps" },
        { "<leader><space>", function() Snacks.picker.smart() end,  desc = "Smart find files" },
        { "<leader>/", function() Snacks.picker.lines() end,        desc = "Search in buffer" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (all files)" },
        { "<leader>f.", function() Snacks.picker.resume() end,      desc = "Resume last picker" },
    },
}
