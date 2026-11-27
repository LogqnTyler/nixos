{ lib, osConfig, ... }:

{
  config = lib.mkIf osConfig.useNiri {
    xdg.configFile."niri/config.kdl".source = ./niri.kdl;
  };
}
