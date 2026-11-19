
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/home-manager
    inputs.dms.homeModules.dank-material-shell
  ];

}

