{flake, ...}: {
  imports = [
    flake.nixosModules.bgp
  ];

  networking = {
    hostId = "ad56e78a";
    hostName = "t14g5";
    networkmanager.enable = true;
  };
}
