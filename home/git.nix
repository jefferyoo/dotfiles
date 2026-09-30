{ pkgs, ... }:

{
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

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = false;
    pinentry.package = pkgs.pinentry-curses;
  };
}
