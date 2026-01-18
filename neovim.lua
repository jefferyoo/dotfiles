-- Tabs to spaces
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Set leader key to Space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Use system clipboard (Wayland)
vim.opt.clipboard = 'unnamedplus'

-- LSP setup using new vim.lsp.config API
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Completion setup
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- LSP capabilities with completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Common on_attach function
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Define LSP configurations
local servers = {
  svls = {},
  vhdl_ls = {},
  asm_lsp = {},
  rust_analyzer = {},
  clangd = {},
  arduino_language_server = {
    cmd = {
      "arduino-language-server",
      "-cli-config", "/path/to/arduino-cli.yaml",
      "-fqbn", "arduino:avr:uno",
      "-clangd", "${pkgs.clang-tools}/bin/clangd"
    }
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  },
  jdtls = {},
  pyright = {},
  bashls = {},
  yamlls = {},
  jsonls = {},
  tinymist = {},
}

-- Setup all servers
for server_name, config in pairs(servers) do
  vim.lsp.config(server_name, vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
  }, config))

  vim.lsp.enable(server_name)
end

-- Typst preview setup
require('typst-preview').setup({
  -- Auto-open preview when opening .typ files
  open_cmd = nil,  -- Uses default browser
})

-- Keybinding to toggle preview
vim.keymap.set('n', '<leader>tp', ':TypstPreview<CR>', 
  { desc = "Toggle Typst preview" })
