{ config, ... }:

{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_age" ];

  age.secrets.afs_password = {
    file = ../secrets/afs_password.age;
  };

  programs.rclone = {
    enable = true;
    remotes = {
      afs = {
        # Wrap the standard rclone keys in a 'config' block
        config = {
          type = "sftp";
          host = "ece026.ece.local.cmu.edu";
          user = "jefferyo";
          key_file = "none";
          auth_method = "password";
          shell_type = "unix";
        };
      };
    };
  };
}
