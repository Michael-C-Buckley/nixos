{lib, ...}: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  networking = {
    hostId = "c07fa570";
    useDHCP = lib.mkForce true;
    hostName = "x570";
    networkmanager.enable = true;
    usePredictableInterfaceNames = true;

    firewall = {
      extraInputRules = ''
        ip protocol 89 accept comment "Allow OSPF"
      '';
      allowedUDPPorts = [33401];
    };

    bridges.br0.interfaces = [];
    interfaces = {
      lo.ipv4.addresses = [{
        address = "192.168.63.10"; prefixLength = 32;
      }];
      enp8s0.useDHCP = true;
      enp9s0.ipv4.addresses = [{
        address = "192.168.48.9"; prefixLength = 24;
      }];
    };
  };
}
