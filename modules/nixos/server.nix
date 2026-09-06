{ pkgs, ... }: {
  imports = [
    ./base.nix
    ./packages/network.nix
  ];

  environment.systemPackages = with pkgs; [
    cage
  ];
  networking.useNetworkd = true;
}
