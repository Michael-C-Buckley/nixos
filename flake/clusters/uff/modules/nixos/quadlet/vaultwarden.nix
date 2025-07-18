{
  config,
  lib,
  ...
}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet.networks.br100-fabric) ref;

    # Latest as of July 18 2025
    version = "sha256-87996ca0371d043df90f04a0fa8efb72a880927eb71edc3fd55fd8ad354e42c8";
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
