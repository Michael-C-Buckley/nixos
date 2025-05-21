{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault optionals;
  incus = config.virtualisation.incus;
in {
  options.virtualisation.incus = {
    useLvmThin = mkEnableOption "LVM Thin Boot";
  };

  config = {
    services.lvm.boot.thin.enable = mkDefault incus.useLvmThin;
    # Incus is bested used with these modules available
    boot.kernelModules = optionals incus.enable ["apparmor" "virtiofs" "9p" "9pnet_virtio"];
    # Incus will prefer Red Hat's Virtiofs over 9P
    environment.systemPackages = optionals incus.enable [pkgs.virtiofsd];

    # For now, only enable if Incus is
    security.apparmor.enable = mkDefault incus.enable;

    virtualisation = {
      incus = {
        package = mkDefault pkgs.incus; # Stable version is old
        ui.enable = mkDefault incus.enable;
        agent.enable = mkDefault incus.enable;
      };
    };
  };
}
