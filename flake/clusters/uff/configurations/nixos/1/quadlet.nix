{config, ...}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks;
  in {
    containers = {
      vaultwarden = {
        containerConfig = {
          image = "vaultwarden/server:latest";
          networks = ["podman" networks.br100-fabric.ref];
          volumes = ["/var/lib/quadlet/vaultwarden:/data/"];
          ip = "192.168.52.10";
        };
        serviceConfig.TimeoutStartSec = "60";
      };
    };
    networks.br100-fabric.networkConfig = {
      subnets = ["192.168.52.0/26"];
      options."com.redhat.network.bridge.name" = "br100";
      driver = "bridge";
      gateways = ["192.168.52.1"];
    };
  };
}
