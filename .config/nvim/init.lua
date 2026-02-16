------------------------------------------------------------
-- Plugins (vim-plug)
------------------------------------------------------------
vim.cmd([[
call plug#begin(stdpath('data') . '/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdcommenter'
    Plug 'tpope/vim-surround'
    Plug 'easymotion/vim-easymotion'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
    Plug 'windwp/nvim-autopairs'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
call plug#end()
]])

------------------------------------------------------------
-- Theme
------------------------------------------------------------
vim.opt.termguicolors = true
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_number_column = "bg0"
vim.cmd("colorscheme gruvbox")

------------------------------------------------------------
-- Settings
------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.clipboard:append("unnamedplus")
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.mouse = "a"
vim.opt.ruler = true
vim.opt.rulerformat = [[%80(%1*%.3n %f%=%l,%(%c%V%) %P%)%*]]
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.cursorline = true
vim.opt.showtabline = 0
vim.opt.laststatus = 0

-- Disable auto comment on new line
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

------------------------------------------------------------
-- Keymaps
------------------------------------------------------------
vim.g.mapleader = " "

local map = vim.keymap.set
local silent = { silent = true, noremap = true }

-- Buffers
map("n", "<leader>j", ":bnext<CR>", silent)
map("n", "<leader>k", ":bprevious<CR>", silent)
map("n", "<leader>n", ":bnext<CR>", silent)
map("n", "<leader>p", ":bprevious<CR>", silent)
map("n", "<leader><tab>", "<C-^>", silent)
map("n", "<Leader>d", ":bd<CR>", silent)

-- Remap J, K
map({ "n", "x" }, "J", "<C-d>zz", silent)
map({ "n", "x" }, "K", "<C-u>zz", silent)

-- Split navigation
map("n", "<C-J>", "<C-W><C-J>", silent)
map("n", "<C-K>", "<C-W><C-K>", silent)
map("n", "<C-L>", "<C-W><C-L>", silent)
map("n", "<C-H>", "<C-W><C-H>", silent)

-- :W -> sudo write
vim.api.nvim_create_user_command("W", function()
  vim.cmd("w !sudo tee %")
end, {})

-- Y like C/D behavior
map("n", "Y", "y$", silent)

-- Disable Ex mode
map("n", "Q", "<Nop>", silent)

------------------------------------------------------------
-- nvim-tree
------------------------------------------------------------
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- toggle
map("n", "<Leader>t", ":NvimTreeToggle<CR>", silent)

local function tree_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.map.on_attach.default(bufnr)

  -- custom mappings
  map("n", "C", api.tree.change_root_to_node, opts("CD"))
  map("n", "O", api.tree.collapse_all, opts("Collapse"))
  map("n", "?", api.tree.toggle_help, opts("Help"))

  -- autoclose: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
  vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
      local invalid_win = {}
      local wins = vim.api.nvim_list_wins()
      for _, w in ipairs(wins) do
        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
        if bufname:match("NvimTree_") ~= nil then
          table.insert(invalid_win, w)
        end
      end
      if #invalid_win == #wins - 1 then
        for _, w in ipairs(invalid_win) do
          vim.api.nvim_win_close(w, true)
        end
      end
    end,
  })
end

require("nvim-tree").setup({
  on_attach = tree_on_attach,
})

------------------------------------------------------------
-- easymotion
------------------------------------------------------------
--map({ "n", "x", "o" }, "<Leader>", "<Plug>(easymotion-prefix)", silent)
map({ "n", "x", "o" }, "<Leader>w", "<Plug>(easymotion-w)", silent)

------------------------------------------------------------
-- fzf
------------------------------------------------------------
map("n", "<Leader>b", ":Buffers<CR>", silent)
map("n", "<Leader>f", ":Files<CR>", silent)
map("n", "<Leader>l", ":Lines<CR>", silent)
map("n", "<Leader>s", ":Rg<CR>", silent)
map("n", "<C-f>", ":Rg<CR>", silent)

------------------------------------------------------------
-- treesitter
------------------------------------------------------------
vim.g.c_syntax_for_h = 1

require("nvim-treesitter").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- bufferline
require("bufferline").setup({
  options = {
    numbers = function(opts)
      return string.format("%s", opts.raise(opts.id))
    end,
    middle_mouse_command = "bdelete! %d",
    offsets = { { filetype = "NvimTree", text = "File Explorer" } },
  },
  highlights = {
    fill = { bg = "#282828" },
  },
})

------------------------------------------------------------
-- Mason
------------------------------------------------------------
-- Add the same capabilities to ALL server configurations.
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "pyright", "lua_ls", "bashls" }
}

-- Keymaps
map({ "n", "x" }, "gd", "<Cmd>lua vim.lsp.buf.definition()<cr>", silent)
map({ "n", "x" }, "gD", "<Cmd>lua vim.lsp.buf.declaration()<cr>", silent)
map({ "n", "x" }, "gi", "<Cmd>lua vim.lsp.buf.implementation()<cr>", silent)
map({ "n", "x" }, "gr", "<Cmd>lua vim.lsp.buf.references()<cr>", silent)
map({ "n", "x" }, "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<cr>", silent)
map({ "n", "x" }, "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<cr>", silent)
map({ "n", "x" }, "<leader>F", "<Cmd>lua vim.lsp.buf.format({ async = true })<cr>", silent)

-- Diagnostic
vim.o.updatetime = 250  -- faster hover trigger

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      border = "rounded",
      source = "always",
    })
  end,
})

------------------------------------------------------------
-- nvim-cmp (completion)
------------------------------------------------------------
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
  }),
})

------------------------------------------------------------
-- autopairs
------------------------------------------------------------
require("nvim-autopairs").setup({
  check_ts = true, -- use treesitter
  enable_check_bracket_line = false,
})

-- with cmp autocompletion
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done()
)
