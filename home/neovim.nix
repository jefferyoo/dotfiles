{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-zoxide
      telescope-undo-nvim

      luasnip
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip

      typst-preview-nvim

      (nvim-treesitter.withPlugins (p: [
      	p.systemverilog
      	p.vhdl
      	p.asm
        p.rust
      	p.c
      	p.arduino
      	p.matlab
      	p.nix
      	p.lua
      	p.luadoc
      	p.java
      	p.javadoc
      	p.python
      	p.yaml
      	p.json
        p.typst
      ]))
    ];

    extraPackages = with pkgs; [
      verible
      vhdl-ls
      asm-lsp
      rust-analyzer
      clang-tools
      arduino-language-server
      nil
      lua-language-server
      jdt-language-server
      pyright
      yaml-language-server
      vscode-langservers-extracted
      tinymist
    ];

    initLua = builtins.readFile ./neovim.lua;
  };
}
