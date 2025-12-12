{ pkgs, lib, neovim-nightly-overlay, ...}:

{
  nixpkgs.config.allowUnfreePredicate = pkg : builtins.elem (lib.getName pkg) [
    "discord-canary"
    "steam"
    "steam-unwrapped"
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "org.vinegarhq.Sober"
    ];
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
  };

  home.packages = with pkgs; [
    networkmanagerapplet
    libnotify
    nerd-fonts.fira-code
    hyprshot
    gamemode
    wl-clipboard

    flatpak
    appimage-run
    jmtpfs
    p7zip

    discord-canary
    xournalpp
    tmux
    keepassxc
    typst
    
    steam
    prismlauncher
    limo
    dolphin-emu

    vulkan-tools
  ];

  fonts.fontconfig.enable = true;

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.force = true;
      settings = {
#       "widget.use-xdg-desktop-portal.file-picker" = 1;
      	"layout.css.devPixelsPerPx" = "1.2";
      };
    };
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
      	# uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      	# Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4638816/privacy_badger17-2025.12.9.xpi";
          installation_mode = "force_installed";
        };
      	# User-Agent Switcher and Manager:
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4593736/user_agent_string_switcher-0.6.6.xpi";
          installation_mode = "force_installed";
        };
      	# ClearURLs:
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4432106/clearurls-1.27.3.xpi";
          installation_mode = "force_installed";
        };
      	# SponsorBlock:
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4644570/sponsorblock-6.1.2.xpi";
          installation_mode = "force_installed";
        };
      	# Decentraleyes:
        "jid1-BoFifL9Vbdl2zQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4392113/decentraleyes-3.0.0.xpi";
          installation_mode = "force_installed";
        };
      	# Disconnect:
        "2.0@disconnect.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4240055/disconnect-20.3.1.2.xpi";
          installation_mode = "force_installed";
        };
      	# Don't Track Me Google:
        "dont-track-me-google@robwu.nl" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4132891/dont_track_me_google1-4.28.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/dotfiles#yoops";
      config = "nvim ~/dotfiles/configuration.nix";
      flake = "nvim ~/dotfiles/flake.nix";
      home = "nvim ~/dotfiles/home.nix";	  
      
      ls = "eza -la";
      cat = "bat --style=plain --paging=never";
    };

    initExtra = ''
      ds4color() {
        local RED=''${1:-4}
        local GREEN=''${2:-0}
        local BLUE=''${3:-0}
      
        # Find DualShock 4 controller (054C:09CC is Sony DualShock 4)
        local CONTROLLER=$(ls -l /sys/class/leds/ | grep "054C:09CC" | grep ":red" | sed 's/.*\(input[0-9]*\):red.*/\1/' | head -1)
      
        if [ -z "$CONTROLLER" ]; then
          echo "No DualShock 4 controller found"
          echo "Available LED devices:"
          ls /sys/class/leds/ | grep -E ":(red|blue|green)$"
          return 1
        fi
      
        echo $RED | sudo tee /sys/class/leds/''${CONTROLLER}:red/brightness > /dev/null
        echo $GREEN | sudo tee /sys/class/leds/''${CONTROLLER}:green/brightness > /dev/null
        echo $BLUE | sudo tee /sys/class/leds/''${CONTROLLER}:blue/brightness > /dev/null
      
        echo "Set controller $CONTROLLER to RGB($RED,$GREEN,$BLUE)"
      }
    '';

    oh-my-zsh = {
      enable = true;
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    plugins = {
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "a63550b2f91f0553cc545fd8081a03810bc41bc0";
        sha256 = "sha256-PYeR6fiWDbUMpJbTFSkM57FzmCbsB4W4IXXe25wLncg=";  
      };
    };

    initLua = ''
      require("starship"):setup()
    '';
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jeffery Oo";
        email = "oojefferywm@proton.me";
      };
      init = {
        defaultBranch = "main";
      };
    };
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };
  };

  programs.neovim = {
    enable = true;
    package = neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

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
      svls
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

    extraLuaConfig = ''
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
    '';
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";

    eza.enable = true;
    yazi.enable = true;
    nvim.enable = true;
    atuin.enable = true;
    starship.enable = true;
    hyprland.enable = true;
    bat.enable = true;
    foot.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    waybar.enable = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=11";
      };
    };
  };

  programs.bat.enable = true;
  programs.rofi.enable = true;
  services.dunst.enable = true;
  programs.waybar.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

#   services.xdg-desktop-portal-termfilepickers = {
#     enable = true;
#     package = xdg-termfilepickers.packages.${pkgs.stdenv.hostPlatform.system}.default;
#     config = {
#       terminal_command = [(lib.getExe pkgs.foot)];
#     };
#   };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

#   xdg.portal = {
#     enable = true;
#     extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
#     config = {
#       common = {
#         default = [ "hyprland" ];
#         "org.freedesktop.impl.portal.FileChooser" = [ "termfilepickers" ];
#       };
#     };
#   };

  home.sessionVariables = {
    GTK_USE_PORTAL = "1"; # legacy
    GDK_DEBUG = "portals"; # termfilechooser
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";

    VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    AMD_VULKAN_ICD="RADV";
    RADV_PERFTEST="gpl";
    RADV_DEBUG="nongg";
  };

  home.stateVersion = "25.05";
}

