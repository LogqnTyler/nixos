# hosts/fw13/configuration.nix
{ pkgs, ... }: {
  networking.hostName = "fw13";
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest; # guide: non-LTS kernel
  services.fwupd.enable = true;
  # system.stateVersion = "26.05"; # the installer's release, not the old host's value
}
