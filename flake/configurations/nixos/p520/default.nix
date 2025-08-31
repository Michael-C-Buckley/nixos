{inputs, ...}: let
  inherit (inputs) home-config;
in {
  imports = [
    home-config.hjemConfigurations.server
    ./hardware
    ./networking
    ./systemd
  ];

  virtualisation = {
    containerlab.enable = true;
    libvirtd.enable = true;
    podman.enable = true;
  };

  system = {
    impermanence.enable = true;
    preset = "server";
    stateVersion = "25.11";
    zfs.enable = true;
  };
}
