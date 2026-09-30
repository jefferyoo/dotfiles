{ ... }:

{
  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = false;

  # Enable ly display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      waylandsessions = "/home/yoops/.local/share/wayland-sessions";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1"; # Configure Electron / CEF apps to use Wayland

    RADV_PERFTEST="gpl";
    RADV_DEBUG="nongg";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  systemd.services.display-manager = {
    environment = {
      XDG_DATA_DIRS = "/run/current-system/sw/share";
    };
  };
}
