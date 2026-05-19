{flake, ...}: {
  imports = [
    flake.nixosModules.bgp
    ./wifi.nix
  ];

  networking = {
    hostId = "ad56e78a";
    hostName = "t14g5";
    networkmanager.enable = true;
  };
}
