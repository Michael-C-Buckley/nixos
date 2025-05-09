_: {
  imports = [
    ../../modules/presets/nvidia.nix
    ./networking
    ./systemd
    ./hardware.nix
  ];

  virtualisation.libvirtd.enable = true;
  system = {
    preset = "server";
    stateVersion = "24.05";
    zfs.enable = true;
  };
  programs.atop.atopgpu.enable = true;
}
