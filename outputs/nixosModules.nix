{
  flake.nixosModules = {
    default = ../modules/nixos/_default.nix;
    network = ../modules/nixos/network/_default.nix;
    security-gpg = ../modules/nixos/security/gpg.nix;
    hardware-intelGraphics = ../modules/nixos/hardware/intelGraphics.nix;
    packages-default = ../modules/nixos/packages/default.nix;
    system-nix = ../modules/nixos/system/nix.nix;
    virtualization-containerlab = ../modules/nixos/virtualization/containerlab.nix;
    virtualization-docker = ../modules/nixos/virtualization/docker.nix;
    virtualization-libvirt = ../modules/nixos/virtualization/libvirt.nix;
    virtualization-k3s = ../modules/nixos/virtualization/k3s.nix;
  };
}
