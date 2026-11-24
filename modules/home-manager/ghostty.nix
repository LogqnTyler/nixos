{lib, osConfig, ...}:
{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "light:Blueprint,dark:12-bit Rainbow";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
    } // lib.optionalAttrs osConfig.useNiri {
        window-decoration = "none";
      };
  };
}
