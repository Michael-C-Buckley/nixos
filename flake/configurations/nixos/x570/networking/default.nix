_: let
  certSecret = file: {
    owner = "michael";
    path = "/home/michael/.certs/${file}";
  };
in {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  # Certs for my own services
  sops.secrets = {
    "x570-key" = certSecret "x570.key.pem";
    "x570-crt" = certSecret "x570.crt.pem";
    "x570-p12" = certSecret "x570.p12";
  };

  services.unbound.enable = true;

  networking = {
    hostId = "c07fa570";
    networkmanager.enable = true;
    usePredictableInterfaceNames = true;

    loopback.ipv4 = "192.168.63.10/32";

    firewall = {
      allowedUDPPorts = [33401];
    };

    bridges.br0.interfaces = [];
    interfaces = {
      # Onboard 1GbE
      enp7s0.useDHCP = true;
      # Onboard 2.5GbE
      enp8s0.useDHCP = true;
      # Intel X520-DA2
      enp16s0f0.useDHCP = true;
    };
  };
}
