{flake, ...}: {
  imports = [
    flake.modules.nixos.bgp
    ./wifi.nix
  ];

  networking = {
    hostId = "ad56e78a";
    hostName = "t14g5";
    networkmanager.enable = true;
  };
}
