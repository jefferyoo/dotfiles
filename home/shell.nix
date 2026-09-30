{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      update = "nh os switch";

      config = "nvim ~/dotfiles/configuration.nix";
      flake = "nvim ~/dotfiles/flake.nix";
      home = "nvim ~/dotfiles/home.nix";	  
      hypr = "nvim ~/.config/hypr/hyprland.conf";	  

      trash-clear = "rm -rf ~/.local/share/Trash/files/* && rm -rf ~/.local/share/Trash/info/*";
      
      sudo = "run0";
      ls = "eza -la";
      cat = "bat --style=plain --paging=never";
      cd = "z";
      claer = "clear";
    };

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

  programs.bat.enable = true;
}
