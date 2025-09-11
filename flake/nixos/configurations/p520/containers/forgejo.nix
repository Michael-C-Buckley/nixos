{config, ...}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet.networks.br200) ref;

    # Latest as of September 11 2025
    version = "12.0.3";
  in {
    containers.forgejo = {
      autoStart = true;
      containerConfig = {
        image = "codeberg.org/forgejo/forgejo:${version}";
        networks = ["${ref}:ip=192.168.52.21"];
        environments = {
          "USER_UID" = "1000";
          "USER_GID" = "1000";
        };
        # WIP: Clocks need testing and verification
        volumes = [
          "/var/lib/quadlet/forgejo:/data/"
          # "/etc/timezone:/etc/timezone:ro"
          # "/etc/localtime:/etc/localtime:ro"
        ];
      };
      serviceConfig.TimeoutStartSec = "60";
    };
  };
}
