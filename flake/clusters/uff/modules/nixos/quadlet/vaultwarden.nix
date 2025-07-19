{
  config,
  lib,
  ...
}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet.networks.br100-fabric) ref;

    # Latest as of July 18 2025
    version = "1.34.1-alpine";
  in {
    containers.vaultwarden = {
      autoStart = lib.mkDefault false;
      containerConfig = {
        image = "vaultwarden/server:${version}";
        networks = ["${ref}:ip=192.168.52.20"];
        volumes = ["/var/lib/quadlet/vaultwarden:/data/"];
      };
      serviceConfig.TimeoutStartSec = "60";
    };
  };
}
