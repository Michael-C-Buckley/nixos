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
      kernelPackages = pkgs.linuxKernel.packagesFor flake.packages.${pkgs.stdenv.hostPlatform.system}.jet2;
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "uas" "sd_mod" "sdhci_pci"];
        kernelModules = ["dm-snapshot"];
      };
      kernelParams = [
        "amd_pstate=active" # AMD Power efficiency on Linux 6.3+
        "zfs.zfs_arc_max=8589934592" # 8GB max
        "zfs.zfs_arc_min=2147483648" # 2GB min
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
