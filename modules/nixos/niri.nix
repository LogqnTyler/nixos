{
  pkgs,
  lib,
  config,
  utils,
  ...
}:
{

  options.niri.default_wallpaper = lib.mkOption {
    type = lib.types.str;
    default = "/home/logan/Pictures/WallPapers/3411059_prisonercoin_slow-end.gif";
    # attr: https://www.newgrounds.com/art/view/prisonercoin/slow-end
    description = "Path to the system's default wallpaper";
  };

  options.niri.wallpaper = lib.mkOption {
    type = lib.types.str;
    default = config.niri.default_wallpaper;
    description = "Path to the system's current wallpaper";
  };

  config = lib.mkIf config.useNiri (

    lib.mkMerge [

      # we'll enable niri either way
      { programs.niri.enable = config.useNiri; }

      # if We're using Dux, enable it here

      (lib.mkIf config.useDux {

        programs.dux-shell.enable = true;

        services.displayManager.dux-greeter = {
          enable = config.useDux;
          compositor.name = "niri";
        };
      })

      (lib.mkIf (!config.useDux) {

        environment.systemPackages = [
          pkgs.awww
          pkgs.brightnessctl # backlight control for XF86MonBrightness keys
        ];

        systemd.user.services.awww = {
          description = "Animated wallpaper daemon";
          wantedBy = [ "niri.service" ];
          after = [ "niri.service" ];
          partOf = [ "niri.service" ];
          serviceConfig = {
            ExecStart = "${pkgs.awww}/bin/awww-daemon";
            ExecStartPost = "${pkgs.awww}/bin/awww img ${
              utils.escapeSystemdExecArgs [ config.niri.wallpaper ]
            }";
            Restart = "on-failure";
          };
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              user = "greeter";
              command = "${lib.getExe pkgs.tuigreet} --cmd ${config.programs.niri.package}/bin/niri-session";
            };
          };
        };

      })
    ]
  );

}
