{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = pkgs.writeText "kanshi-config" ''
    profile laptop {
      output eDP-1 enable mode 1920x1200@60.001Hz position 0,0 scale 1
    }
  '';
  condition = pkgs.writeShellScript "kanshi-desktop" ''
    case ":''${XDG_CURRENT_DESKTOP:-}:" in
      *:Hyprland:*|*:umbriel:*|*:Umbriel:*) exit 0 ;;
      *) exit 1 ;;
    esac
  '';
in
{
  packages = [ pkgs.kanshi ];
  xdg.config.files."kanshi/config".source = cfg;
  programs.hyprland.execOnce = lib.mkIf (!config.environment.useSystemd) [
    "${pkgs.kanshi}/bin/kanshi -c ${lib.escapeShellArg "${config.xdg.config.directory}/kanshi/config"}"
  ];
  systemd.services.kanshi = lib.mkIf config.environment.useSystemd {
    description = "Apply the laptop display profile";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requires = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
    reloadTriggers = [ cfg ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanshi}/bin/kanshi -c ${config.xdg.config.directory}/kanshi/config";
      ExecReload = "${pkgs.kanshi}/bin/kanshictl reload";
      ExecCondition = "${condition}";
      Restart = "always";
    };
  };
}
