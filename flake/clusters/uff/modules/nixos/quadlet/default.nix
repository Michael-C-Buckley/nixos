_: {
  imports = [
    ./vaultwarden.nix
    ./forgejo.nix
  ];
  virtualisation.quadlet.networks = {
    # Systemd has created the interface and bound it to the fabric
    # Podman will configure the address so that containers may be in the subnet
    br100-fabric.networkConfig = {
      podmanArgs = ["--interface-name=br100"];
      driver = "bridge";
      disableDns = true;
      gateways = ["192.168.52.1"];
      subnets = ["192.168.52.0/26"];
    };
  };
}
