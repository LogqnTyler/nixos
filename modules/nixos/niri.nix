{
  pkgs,
  lib,
  config,
  ...
}:
{

  useNiri = true;
  useDux = false;

  config = lib.mkIf config.useNiri (

    lib.mkMerge [

      # we'll enable niri either way
      { programs.niri.enable = config.useNiri; }

      # if We're using Dux, enable it here

      (lib.mkIf config.useDux {
        services.displayManager.dux-greeter = {
          enable = config.useDux;
          compositor.name = "niri";
        };
      })

      (lib.mkIf (!config.useDux) {
        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              user = "greeter";
              command = getExe' pkgs.tuigreet "tuigreet"; # you may pass `--config` here
            };
          };
        };
      })
    ]
  );

}
