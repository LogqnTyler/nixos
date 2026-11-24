{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      settings = {
        user.name = "Logan Foster";
        user.email = "zup7mn@virginia.edu";
      };

      includes = [
        {
          condition = "gitdir:~/work/";
          contents = {
            user.name = "Logan Foster";
            user.email = "logan@truepathvision.com";
          };
        }
      ];

    };

    ssh.settings."github.com" = {
      user = "git";
      identityFile = config.sops.secrets.github_ssh_key.path;
      identitiesOnly = true;

    };

    lazygit.enable = true;
  };
}
