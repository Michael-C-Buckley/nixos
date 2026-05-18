{
  flake.modules.nixos.b550 = {
    networking = {
      hostName = "b550";
      hostId = "272a6fae";

      nameservers = [
        "192.168.61.0"
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };
}
