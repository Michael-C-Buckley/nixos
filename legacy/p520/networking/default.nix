{
  flake.modules.nixos.p520 = {
    networking = {
      nameservers = [
        "192.168.61.0"
        "1.1.1.1"
        "8.8.8.8"
      ];

      hostName = "p520";
      hostId = "181a3ead";
    };
  };
}
