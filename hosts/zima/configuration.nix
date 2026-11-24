{ pkgs, ... }:

{
  imports = [
    ../../modules/immich.nix
    ./hardware-configuration.nix
  ];
  # Makes immich refuse to start if the ssd is missing
  systemd.services.immich-server.unitConfig.RequiresMountsFor = "/srv/immich";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.forceImportRoot = false;

  networking = {
    hostName = "zimaboard";
    networkmanager.enable = true;
    firewall.enable = true;

    hostId = "1984a349"; # ZFS needs this!
  };

  services = {
    openssh.enable = true;
    tailscale = {
      enable = true;
      openFirewall = true;
    };

    zfs.autoScrub.enable = true;
  };

  users.users.logan = {
    isNormalUser = true;
    description = "Logan Foster";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAZRR96QchXZ2DlaUgwHfcmQ7+sXTZwA5SF6mUhkGlH logan@zimaboard"
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
