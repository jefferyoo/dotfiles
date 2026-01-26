{ pkgs, lib, config, neovim-nightly-overlay, ...}:

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
    # System utilities
    flatpak
    appimage-run
    jmtpfs

    # System components
    libnotify
    nerd-fonts.fira-code
    vulkan-tools
    mesa-demos

    # Hyprland components
    hyprshot
    wl-clipboard
    cliphist
    zoxide
    p7zip

    # Languages
    python312
    rustup
    gcc

    # Apps
    discord-canary
    xournalpp
    tmux
    keepassxc
    typst
    
    # Gaming
    steam
    protonup-rs
    prismlauncher
    limo
    dolphin-emu

    # Gaming components
    gamemode
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
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      update = "nh os switch && flatpak update";

      config = "nvim ~/dotfiles/configuration.nix";
      flake = "nvim ~/dotfiles/flake.nix";
      home = "nvim ~/dotfiles/home.nix";	  
      hypr = "nvim ~/.config/hypr/hyprland.conf";	  

      trash-clear = "rm -rf ~/.local/share/Trash/files/* && rm -rf ~/.local/share/Trash/info/*";
      
      sudo = "run0";
      ls = "eza -la";
      cat = "bat --style=plain --paging=never";
      cd = "z";
    };

    initContent = ''
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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
      pull.rebase = false;
      init.defaultBranch = "main";
      tag.gpgSign = true;
    };
    signing = {
      format = "openpgp";
      key = "19992BECE706CC59";
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

    extraLuaConfig = builtins.readFile ./neovim.lua;
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
    enableDefaultConfig = false;

    matchBlocks."*" = {
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      addKeysToAgent = "yes";
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
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";

    FLAKE="$HOME/dotfiles";
  };

  home.stateVersion = "25.05";
}

