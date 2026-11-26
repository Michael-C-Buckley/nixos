{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.hjem.finixModules.default ];

  hjem = {
    specialArgs = { inherit inputs; };
    clobberByDefault = true;
    extraModules = [
      ../../hjem/runtime.nix
      {
        config.environment.useSystemd = false;
        # Shared Linux modules may contain disabled systemd definitions. Finix
        # has no upstream unit module, so accept only empty, filtered results.
        options.systemd = lib.genAttrs [ "services" "targets" "paths" ] (
          name:
          lib.mkOption {
            internal = true;
            type = lib.types.attrsOf lib.types.unspecified;
            default = { };
            apply =
              units:
              if units == { } then
                units
              else
                throw "Finix cannot manage systemd ${name}; use Finit or Hyprland execOnce instead.";
            description = "Empty compatibility declarations for shared Linux modules on Finix.";
          }
        );
      }
    ];
  };

  # Include package data in Hjem's per-user profile.
  environment.pathsToLink = [ "/share" ];

  # Finix creates users' home directories in tmpfiles-setup. The linker must
  # not race that task or create the home itself with the wrong ownership.
  finit.tasks = lib.mkMerge (
    [ { hjem-prepare.conditions = [ "task/tmpfiles-setup/success" ]; } ]
    ++ lib.mapAttrsToList (
      _: user:
      lib.mkIf (user.enable && user.activation.commands != { }) {
        "hjem-after-${user.user}" = {
          description = "Apply after-link home configuration for ${user.user}";
          inherit (user) user;
          conditions = [ "task/hjem-activate-${user.user}/success" ];
          command = user.activation.script;
        };
        "hjem-copy-${user.user}".conditions = [ "task/hjem-after-${user.user}/success" ];
      }
    ) config.hjem.users
  );
}
