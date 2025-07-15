{config, ...}: {
  # ...
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks pods;
  in {
    containers = {
      vaultwarden = {
        containerConfig = {
          image = "vaultwarden/server:latest";
          networks = ["podman" networks.internal.ref];
          pod = pods.foo.ref;
        };
        serviceConfig.TimeoutStartSec = "60";
      };
    };
    networks = {
      internal.networkConfig.subnets = ["10.0.123.1/24"];
    };
    pods = {
      foo = {};
    };
  };
}
