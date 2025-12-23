{
  flake.modules.nixos.b550 = {
    networking = {
      hostName = "b550";
      hostId = "272a6fae";

      # TODO: switch to using internal DNS server once set up
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };
}
