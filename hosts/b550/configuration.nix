{
  flake,
  pkgs,
  ...
}: {
  imports = with flake.nixosModules;
    [
      server-preset
      containerlab
      no-static-default-routes
      lab-network
      libvirt
      attic
      tailscale
    ]
    ++ [
      ./hardware
      ./k3s
      ./networking
      ./secrets.nix
    ];

  system.stateVersion = "26.05";

  environment = {
    systemPackages = with pkgs; [
      attic-client
    ];
  };
}
