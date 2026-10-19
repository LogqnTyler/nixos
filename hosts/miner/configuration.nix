{
  system.nixos.tags = [ "miner" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;

    nvidia = {
      modesetting.enable = true;
      open = true;
      dynamicBoost.enable = true;

      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  virtualisation.docker.enable = true;
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  home-manager.users.logan.dconf.settings."org/gnome/settings-daemon/plugins/power" = {
    sleep-inactive-ac-type = "nothing";
  };
}
