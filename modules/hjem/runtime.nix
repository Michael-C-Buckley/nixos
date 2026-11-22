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
    _module.args.configPaths = lib.mkDefault (import ../../configs { inherit lib; });
    environment.sessionVariables.PATH = lib.mkDefault "${config.environment.profileDirectory}/bin:\${PATH}";
    # loadEnv only reaches shells; systemd user units read environment.d instead.
    xdg.config.files."environment.d/10-hjem.conf" = lib.mkIf config.environment.useSystemd {
      text = lib.concatLines (
        lib.mapAttrsToList (
          name: value:
          let
            str = if builtins.isList value then lib.concatStringsSep ":" value else toString value;
          in
          ''${name}="${lib.escape [ "\\" "\"" ] str}"''
        ) config.environment.sessionVariables
      );
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
