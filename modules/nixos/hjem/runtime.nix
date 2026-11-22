{
  config,
  lib,
  pkgs,
  ...
}:
{
  _file = __curPos.file;
  key = __curPos.file;
  options = {
    systemd.sessionVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Environment for the systemd user manager, written through environment.d.";
    };
    activation.commands = lib.mkOption {
      type = lib.types.attrsOf lib.types.lines;
      default = { };
      description = "Idempotent commands run after files are linked, ordered by attribute name.";
    };
    activation.script = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = "After-link activation entry point.";
    };
    environment = {
      profileDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/etc/profiles/per-user/${config.user}";
        description = "Package profile exposed to the home. Standalone configurations override this.";
      };
      genericLinux = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use an existing Linux distribution's binaries and desktop infrastructure.";
      };
      useSystemd = lib.mkOption {
        type = lib.types.bool;
        default = pkgs.stdenv.hostPlatform.isLinux;
        description = "Whether the home has a systemd user manager. Disabled on Finix.";
      };
    };
  };
  config = {
    environment.sessionVariables.PATH = lib.mkDefault "${config.environment.profileDirectory}/bin:\${PATH}";
    systemd.sessionVariables = lib.mkIf config.environment.useSystemd (
      (lib.mapAttrs (
        _: value:
        lib.mkOptionDefault (
          if builtins.isList value then lib.concatStringsSep ":" value else toString value
        )
      ) config.environment.sessionVariables)
      // {
        PATH = lib.mkDefault "${config.environment.profileDirectory}/bin:${config.directory}/.local/bin:\${PATH}";
        XDG_DATA_DIRS = lib.mkDefault (
          config.environment.sessionVariables.XDG_DATA_DIRS
            or "${config.xdg.data.directory}:${config.environment.profileDirectory}/share:\${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
        );
        TERMINFO_DIRS = lib.mkDefault "${config.environment.profileDirectory}/share/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo";
      }
    );
    activation.commands."10-systemd-environment" = lib.optionalString config.environment.useSystemd ''
      if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
        ${pkgs.systemd}/bin/systemctl --user daemon-reload
      fi
    '';
    xdg.config.files."environment.d/10-hjem.conf" = lib.mkIf (config.systemd.sessionVariables != { }) {
      text =
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: value: ''${name}="${lib.escape [ "\\" "\"" ] value}"''
          ) config.systemd.sessionVariables
        )
        + "\n";
    };
    activation.script = pkgs.writeShellScript "hjem-after-link-${config.user}" ''
      set -eu
      ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}"''}
      if [ -n "''${XDG_RUNTIME_DIR:-}" ] && [ -S "$XDG_RUNTIME_DIR/bus" ]; then
        export DBUS_SESSION_BUS_ADDRESS="''${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
      fi
      . ${config.environment.loadEnv}
      export PATH=${
        lib.makeBinPath [
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnugrep
          pkgs.gnused
        ]
      }:"$PATH"
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: command: ''
          echo ${lib.escapeShellArg "Hjem activation: ${name}"}
          ${command}
        '') config.activation.commands
      )}
    '';
  };
}
