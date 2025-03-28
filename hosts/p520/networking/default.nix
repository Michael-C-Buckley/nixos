_: {
  imports = [
    ./routing.nix
  ];
  
  networking = {
    hostName = "p520";
    hostId = "181a3ead";

    # WIP: transition to resolved
    nameservers = [
      "1.1.1.1"
    ];

    bridges.br0.interfaces = ["eno1"];
    interfaces.br0.ipv4 = {
      addresses = [{
        address = "192.168.48.5";
        prefixLength = 24;
      }];
    };
  };
}