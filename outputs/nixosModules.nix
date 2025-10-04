{
  flake.nixosModules = {
    network = ../flake/nixos/modules/network/_default.nix;
    security = {
      gpg = ../flake/nixos/modules/security/gpg.nix;
    };
    hardware = {
      intelGraphics = ../flake/nixos/modules/hardware/intelGraphics.nix;
    };
    packages = {
      default = ../flake/nixos/modules/packages/default.nix;
    };
    system = {
      nix = ../flake/nixos/modules/system/nix.nix;
    };
    virtualization = {
      containerlab = ../flake/nixos/modules/virtualization/containerlab.nix;
      docker = ../flake/nixos/modules/virtualization/docker.nix;
      libvirt = ../flake/nixos/modules/virtualization/libvirt.nix;
    };
  };
}
