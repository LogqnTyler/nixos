# hosts/fw13/configuration.nix
{ pkgs, ... }: {


  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "fw13";
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest; # guide: non-LTS kernel
  services.fwupd.enable = true;
  # system.stateVersion = "26.05"; # the installer's release, not the old host's value
  #

  programs.niri.enable = true;
  programs.dux-shell.enable = true;

  # setting up intel graphics according to https://wiki.nixos.org/wiki/Intel_Graphics
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    # Required for modern Intel GPUs (Xe iGPU and ARC)
    intel-media-driver     # VA-API (iHD) userspace
    vpl-gpu-rt             # oneVPL (QSV) runtime

    # Optional (compute / tooling):
    intel-compute-runtime  # OpenCL (NEO) + Level Zero for Arc/Xe
    # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
    # libvdpau-va-gl       # Only if you must run VDPAU-only apps
  ];
};

environment.sessionVariables = {
  LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
  # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
};

}
