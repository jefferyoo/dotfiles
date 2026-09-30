{ pkgs, ... }:

{
  networking.hostName = "yoops"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22       # SSH
    8100     # BlueMap (Mineraft)
    25565    # Minecraft
    27036    # Steam (in-home streaming / Remote Play)
    27037    # Steam
    47984    # Sunshine (Moonlight HTTPS)
    47989    # Sunshine (Moonlight HTTP)
    48010    # Sunshine (Moonlight RTSP)
  ];

  networking.firewall.allowedUDPPorts = [
    27031    # Steam (Remote Play)
    27036    # Steam (Remote Play)
    47998    # Sunshine (Moonlight video)
    47999    # Sunshine (Moonlight control)
    48000    # Sunshine (Moonlight audio)
    48002    # Sunshine (Moonlight mic)
    48010    # Sunshine (Moonlight RTSP)
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable Tailscale and IP forwarding
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = [ "3efa5cb78a624343" ];
  };

  systemd.services = {
    # Enable UDP GRO forwarding on boot
    tailscale-udp-gro = {
      description = "Enable UDP GRO forwarding for Tailscale";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        # Get the default route interface
        NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | cut -f 5 -d " ")
        if [ -n "$NETDEV" ]; then
          ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off || true
        fi
      '';
    };

    tailscaled = {
      after = [ "network-online.target" "NetworkManager-wait-online.service" ];
      wants = [ "network-online.target" "NetworkManager-wait-online.service" ];
    };

    NetworkManager-wait-online.enable = true;
  };
}
