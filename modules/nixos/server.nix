{ pkgs, ... }: {
  imports = [
    ./base.nix
    ./metal.nix
    ./packages/network.nix
  ];

  environment.systemPackages = with pkgs; [
    cage
  ];
  networking.useNetworkd = true;
}
