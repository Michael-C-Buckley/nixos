{ pkgs, ... }:
{
  imports = [
    ./metal.nix
    ../packages/network.nix
  ];

  environment.systemPackages = [ pkgs.cage ];
  networking.useNetworkd = true;
}
