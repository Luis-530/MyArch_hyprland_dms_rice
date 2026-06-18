-- 基础设置
vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 300
opt.timeoutlen = 500

opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true

-- 常用快捷键
local keymap = vim.keymap.set

keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "保存文件" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "退出" })
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "清除搜索高亮" })

keymap("n", "<C-h>", "<C-w>h", { desc = "移动到左侧窗口" })
keymap("n", "<C-j>", "<C-w>j", { desc = "移动到下方窗口" })
keymap("n", "<C-k>", "<C-w>k", { desc = "移动到上方窗口" })
keymap("n", "<C-l>", "<C-w>l", { desc = "移动到右侧窗口" })

keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "垂直分屏" })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "水平分屏" })

-- lazy.nvim 插件管理器
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 配色
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  -- 文件搜索 / 全文搜索
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup()

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "查找文件" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "全文搜索" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "查找 buffer" })
    end,
  },

  -- 文件树
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "文件树" })
    end,
  },

  -- 括号、引号、标签包围操作
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- 快速注释
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
},

{
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    lspconfig.rust_analyzer.setup({})
    lspconfig.lua_ls.setup({})
    lspconfig.clangd.setup({})
    lspconfig.pylsp.setup({})

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "跳转到定义" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "悬浮文档" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "重命名" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "代码操作" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })
  end,
})
