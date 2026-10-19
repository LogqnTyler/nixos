{ pkgs, ... }:

{
  imports = [
    ../../modules/immich.nix

    # Generate this file on the ZimaBoard, copy it into this directory,
    # and then uncomment the import.
    # ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "zimaboard";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services = {
    openssh.enable = true;
    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };

  users.users.logan = {
    isNormalUser = true;
    description = "Logan Foster";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.fstrim.enable = true;

  environment.systemPackages = with pkgs; [
    git
    tmux
  ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "26.05";
}
