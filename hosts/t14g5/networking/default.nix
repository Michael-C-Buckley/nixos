{config, ...}: {
  flake.modules.nixos.t14g5 = {
    imports = with config.flake.modules.nixos; [
      bgp
    ];

    networking = {
      hostId = "ad56e78a";
      hostName = "t14g5";
      networkmanager.enable = true;
    };
  };
}
