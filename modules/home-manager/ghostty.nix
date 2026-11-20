{lib, osConfig, ...}:
{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "12-bit Rainbow";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
    } // lib.optionalAttrs osConfig.useNiri {
        window-decoration = "none";
      };
  };
}
