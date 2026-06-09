{
  flake,
  pkgs,
  ...
}: {
  imports = with flake.nixosModules; [
    server-preset
    containerlab
    no-static-default-routes
    lab-network
    libvirt
    attic
    tailscale
    tpm2
  ];

  system.stateVersion = "26.11";

  environment = {
    systemPackages = with pkgs; [
      attic-client
    ];
  };
}
