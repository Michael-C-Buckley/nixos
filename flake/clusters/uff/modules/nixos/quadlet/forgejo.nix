{
  config,
  lib,
  ...
}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet.networks.br100-fabric) ref;

    # Latest as of July 18 2025
    version = "1.21.5-0";
  in {
    containers.forgejo = {
      autoStart = lib.mkDefault false;
      containerConfig = {
        image = "codeberg.org/forgejo/forgejo:${version}";
        networks = ["${ref}:ip=192.168.52.21"];
        environments = {
          "USER_UID" = 1000;
          "USER_GID" = 1000;
        };
        volumes = [
          "/var/lib/quadlet/forgejo:/data/"
          "/etc/timezone:/etc/timezone:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
      };
      serviceConfig.TimeoutStartSec = "60";
    };
  };
}
