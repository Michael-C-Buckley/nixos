{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkForce mkIf;
  inherit (config.hardware) nvidia;
in {
  options.hardware.nvidia.useNvidia = mkEnableOption "Custom option to enable Nvidia features and settings.";

  # User will still need to set their own package version
  config = mkIf nvidia.useNvidia {
    # Reimplement nixpkgs with Cuda support
    _module.args.pkgs = mkForce (
      import inputs.nixpkgs {
        inherit (config.nixpkgs.hostPlatform) system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      }
    );

    boot.blacklistedKernelModules = ["nouveau"];
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics.enable = true;
      nvidia = {
        open = false;
        modesetting.enable = true;
        nvidiaSettings = true;
        nvidiaPersistenced = true;
        powerManagement.enable = true;
      };
    };
  };
}
