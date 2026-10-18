-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- check for plugin updates quietly (no popup on startup)
  checker = { enabled = true, notify = false },
  -- don't announce every config file change
  change_detection = { notify = false },
})

-- Update plugins silently in the background, at most once a day.
-- Something broke after an update? :Lazy restore rolls back to lazy-lock.json
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local stamp = vim.fn.stdpath("state") .. "/lazy-last-update"
    local last = vim.fn.filereadable(stamp) == 1 and tonumber(vim.fn.readfile(stamp)[1]) or 0
    if os.time() - last < 24 * 60 * 60 then
      return
    end
    vim.fn.writefile({ tostring(os.time()) }, stamp)
    require("lazy").update({ show = false, wait = false })
  end,
})
