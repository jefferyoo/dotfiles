{ pkgs, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 20";
    flake = "/home/yoops/dotfiles";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libxcrypt-legacy   # libcrypt.so.1 — tes3cmd needs this
    stdenv.cc.cc.lib   # libstdc++ / libgcc_s — common C++ runtime deps
    zlib               # libz.so.1
    glibc              # libm.so.6, libc.so.6, etc
  ];


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vulkan-validation-layers
    libva-utils
    desktop-file-utils
    steam-run

    rage
    ragenix
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
