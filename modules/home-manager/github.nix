{ config, ... }:
{
  programs = {
    git = {
      enable = true;

      settings = {
        user.name = "Logan Foster";
        user.email = "zup7mn@virginia.edu";

        url."git@github-tpv:truepathvision/".insteadOf = "git@github.com:truepathvision/";
        url."git@github-tpv:lgntpv/".insteadOf = "git@github.com:lgntpv/";
      };

      includes = [
        {
          condition = "gitdir:~/Work/";
          contents = {
            user.name = "Logan Foster";
            user.email = "logan@truepathvision.com";
          };
        }
      ];

    };

    ssh.settings= {
      "github.com" = {
      user = "git";
      identityFile = config.sops.secrets.github_ssh_key.path;
      identitiesOnly = true;
    };

      "github-tpv" = {
        hostname = "github.com";
        user = "git";
        identityFile = config.sops.secrets.tpv_ssh_key.path;
        identitiesOnly = true;
      };
    };

    lazygit.enable = true;
  };
}
