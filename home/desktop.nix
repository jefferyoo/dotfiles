{ lib, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=11";
      };
    };
  };

  programs.rofi.enable = true;
  services.dunst.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.file.".local/share/wayland-sessions/hyprland-uwsm.desktop".text = lib.mkForce ''
[Desktop Entry]
Name=Hyprland (uwsm-managed)
Comment=An intelligent dynamic tiling Wayland compositor
Exec=uwsm start -e -D Hyprland hyprland.desktop
TryExec=uwsm
DesktopNames=Hyprland:X-NIXOS-SYSTEMD-AWARE
Type=Application
  '';

  home.sessionVariables = {
    GTK_USE_PORTAL = "1"; # legacy
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";

    FLAKE="$HOME/dotfiles";

    # XDG_DATA_DIRS = lib.concatStringsSep ":" [
    #   "$HOME/.local/share/flatpak/exports/share"
    #   "/var/lib/flatpak/exports/share"
    #   "$HOME/.nix-profile/share"
    #   "/run/current-system/sw/share"
    # ];
  };
}
