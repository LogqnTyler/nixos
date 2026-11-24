{ pkgs, ... }:

{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;
    openFirewall = true;

    mediaLocation = "/srv/immich";

    accelerationDevices = [ "/dev/dri/renderD128" ];

  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  users.users.immich.extraGroups = [
    "render"
    "video"
  ];

  systemd.tmpfiles.rules = [
    "d /srv/immich 0700 immich immich -"
  ];
}
