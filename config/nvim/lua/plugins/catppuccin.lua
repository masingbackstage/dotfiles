return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            -- Let the terminal background (Ghostty's opacity) show through
            transparent_background = true,
            float = { transparent = true, solid = false },
            -- Pick up highlight groups for installed plugins (blink.cmp, snacks, which-key...)
            auto_integrations = true,
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
