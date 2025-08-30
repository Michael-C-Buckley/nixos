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
    boot.uuid = "D8CD-79D6";
    preset = "server";
    stateVersion = "24.05";
    zfs.enable = true;
  };
}
