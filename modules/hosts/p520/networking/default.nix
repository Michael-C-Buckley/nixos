{
  flake.modules.nixos.p520 = {
    networking = {
      # TODO: switch to using internal DNS server once set up
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      hostName = "p520";
      hostId = "181a3ead";
    };
  };
}
