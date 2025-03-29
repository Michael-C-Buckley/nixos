_: {
  system.stateVersion = "24.05";

  imports = [
    ../../modules/hardware/nvidia.nix
    ./networking
    ./systemd
    ./hardware.nix
  ];

  custom.virtualisation.libvirt = {
    users = ["michael" "root"];
  };

  programs.atop.atopgpu.enable = true;
}
