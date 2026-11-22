{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.noctalia;
  format = pkgs.formats.toml { };
in
{
  _file = __curPos.file;
  key = __curPos.file;
  options.programs.noctalia = {
    package = lib.mkPackageOption pkgs "noctalia" { nullable = true; };
    settings = lib.mkOption {
      inherit (format) type;
      default = { };
      description = "Noctalia settings, merged with the shared TOML.";
    };
    systemd.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run Noctalia as a graphical-session service.";
    };
  };
  config = {
    assertions = [
      {
        assertion = cfg.systemd.enable -> config.environment.useSystemd;
        message = "Noctalia's systemd service requires a systemd user manager; use Hyprland execOnce on Finix.";
      }
    ];
    packages = lib.optional (cfg.package != null) cfg.package;
    programs.noctalia.settings = lib.mapAttrsRecursive (_: lib.mkDefault) (
      builtins.fromTOML (
        builtins.replaceStrings [ "@HOME@" ] [ config.directory ] (
          builtins.readFile ../../../configs/noctalia/config.toml
        )
      )
    );
    xdg.config.files."noctalia/config.toml".source = format.generate "noctalia.toml" cfg.settings;
    systemd.services.noctalia = lib.mkIf cfg.systemd.enable {
      description = "Noctalia desktop shell";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      restartTriggers = [ config.xdg.config.files."noctalia/config.toml".source ];
      serviceConfig = {
        ExecStart = if cfg.package == null then "/usr/bin/noctalia" else lib.getExe cfg.package;
        Restart = "on-failure";
      };
    };
  };
}
