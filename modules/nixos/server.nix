{ pkgs, ... }: {
  imports = [
    ./base.nix
    ./metal.nix
    ./network/tailscale.nix
    ./packages/network.nix
    ./virtualization/incus.nix
  ];

  environment.systemPackages = with pkgs; [
    cage
  ];
  networking.useNetworkd = true;
}
