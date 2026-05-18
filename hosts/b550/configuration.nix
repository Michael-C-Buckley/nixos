{
  flake,
  pkgs,
  ...
}: {
  imports = with flake.modules.nixos;
    [
      systemd-boot
      impermanence
      serverPreset
      homelabPreset
      network-no-static-default
      containerlab
      lab-network
      libvirt
      attic
      systemd-credentials
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
