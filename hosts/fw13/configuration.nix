# hosts/fw13/configuration.nix
{
  pkgs,
  lib,
  config,
  ...
}:
{

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/niri.nix

  ];

  # Theme Settings
  useNiri = true;
  useDux = false;

  niri.wallpaper = "${config.users.users.logan.home}/Pictures/WallPapers/waneella/GIFs/Zephyr_waneella.gif";
  # niri.wallpaper = "${config.users.users.logan.home}/Pictures/WallPapers/waneella/GIFs/Abyss_waneella.gif";
  # niri.wallpaper = "${config.users.users.logan.home}/Pictures/WallPapers/waneella/Wallpaper packs/waneella motionless wallpaper pack jun'19/Satellite_Six_Pt3_5200x2600.png";
  # /Pictures/WallPapers/waneella/GIFs/Abyss_waneella.gif, Pictures/WallPapers/waneella/GIFs/Zephyr_waneella.gif

  # Normal settings
  networking.hostName = "sandtrout";
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest; # guide: non-LTS kernel
  services.fwupd.enable = true;

  ## Fingerprinting
  services.fprintd.enable = true; # setup fingerprinting
  users.users.logan.extraGroups = [ "input" ];

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  # system.stateVersion = "26.05"; # the installer's release, not the old host's value
  #

  # setting up intel graphics according to https://wiki.nixos.org/wiki/Intel_Graphics
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver # VA-API (iHD) userspace
      vpl-gpu-rt # oneVPL (QSV) runtime

      # Optional (compute / tooling):
      intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe

    ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 24 * 1024; # MiB: 24 GiB
    }
  ];

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "5min";
    HibernateOnACPower = false;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };

  environment.systemPackages = [ pkgs.nautilus ];

}
