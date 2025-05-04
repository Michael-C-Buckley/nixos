_: {
  system.stateVersion = "24.05";

  imports = [
    ../../../modules/hardware/nvidia.nix
    ./networking
    ./systemd
    ./hardware.nix
  ];

  virtualisation.libvirtd.enable = true;
  system.zfs.enable = true;
  programs.atop.atopgpu.enable = true;
}
