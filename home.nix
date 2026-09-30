{ pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.ragenix.homeManagerModules.default
    ./home/firefox.nix
    ./home/shell.nix
    ./home/afs.nix
    ./home/git.nix
    ./home/neovim.nix
    ./home/theme.nix
    ./home/desktop.nix
    ./home/ssh.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg : builtins.elem (lib.getName pkg) [
    "discord-canary"
    "discord-canary-unwrapped"
    "steam"
    "steam-unwrapped"
    "cloudflare-warp"
    "ltspice"
    "7zz"
    "uasm"
  ];

  home.packages = with pkgs; [
    # System utilities
    appimage-run
    android-tools

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
    _7zz-rar
    mpv
    imv

    # Languages
    python312
    rustup
    nushell
    gcc
    gnumake

    # EDA
    verilator
    kicad
    ltspice
    gtkwave
    octave

    # Apps
    discord-canary
    signal-desktop
    xournalpp
    tmux
    keepassxc
    typst
    deluge
    cloudflare-warp
    amberol
    omp
    abiword
    
    # Gaming
    protonup-rs
    prismlauncher
    limo
    dolphin-emu
    ryubing
    azahar
    openmw

    # Gaming components
    gamemode
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.05";
}
