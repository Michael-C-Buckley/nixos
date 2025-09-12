{
  imports = [
    ./forgejo.nix
  ];
  virtualisation.quadlet.networks = {
    br200.networkConfig = {
      podmanArgs = ["--interface-name=br200"];
      driver = "bridge";
      disableDns = true;
      gateways = ["192.168.53.1"];
      subnets = ["192.168.53.0/26"];
    };
  };
}
