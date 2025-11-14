{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.t14 = {
    config,
    lib,
    modulesPath,
    pkgs,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      kernelPackages = pkgs.linuxKernel.packagesFor flake.packages.${pkgs.stdenv.hostPlatform.system}.jet2-kernel_6_17_8;
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "uas" "sd_mod" "sdhci_pci"];
        kernelModules = ["dm-snapshot"];
      };
      kernelParams = [
        "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
      ];
      kernelModules = ["kvm" "kvm-amd" "virtiofs" "9p" "9pnet_virtio"];
      extraModulePackages = [];
    };

    networking.useDHCP = lib.mkDefault true;

    # For sound
    security.rtkit.enable = true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
