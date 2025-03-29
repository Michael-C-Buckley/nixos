{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.nixos-modules.nixosModules) nvidia;
in {
  system.stateVersion = "24.05";

  imports = [
    nvidia
    ./networking
    ./systemd
    ./hardware.nix
  ];

  boot = {
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelPackages = pkgs.linuxKernel.packages.linux_hardened;
  };

  custom.virtualisation.libvirt = {
    users = ["michael" "root"];
  };

  programs.atop.atopgpu.enable = true;
}
