{
  flake.nixosModules = {
    default = ../flake/nixos/modules/_default.nix;
    network = ../flake/nixos/modules/network/_default.nix;
    security-gpg = ../flake/nixos/modules/security/gpg.nix;
    hardware-intelGraphics = ../flake/nixos/modules/hardware/intelGraphics.nix;
    packages-default = ../flake/nixos/modules/packages/default.nix;
    system-nix = ../flake/nixos/modules/system/nix.nix;
    virtualization-containerlab = ../flake/nixos/modules/virtualization/containerlab.nix;
    virtualization-docker = ../flake/nixos/modules/virtualization/docker.nix;
    virtualization-libvirt = ../flake/nixos/modules/virtualization/libvirt.nix;
    virtualization-k3s = ../flake/nixos/modules/virtualization/k3s.nix;
  };
}
