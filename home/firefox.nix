{ ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      # extensions.force = true;
      settings = {
      	"layout.css.devPixelsPerPx" = "1.2";
      };
    };
    policies = {
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
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
}
