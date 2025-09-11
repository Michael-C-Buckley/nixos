{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault mkIf optionals;
  inherit (config.system) impermanence;
  inherit (config.virtualisation) incus;
in {
  options.virtualisation.incus = {
    useLvmThin = mkEnableOption "LVM Thin Boot";
  };

  config = mkIf incus.enable {
    services.lvm.boot.thin.enable = mkDefault incus.useLvmThin;
    # Incus is bested used with these modules available
    boot.kernelModules = ["apparmor" "virtiofs" "9p" "9pnet_virtio"];
    # Incus will prefer Red Hat's Virtiofs over 9P
    environment = {
      persistence."/cache".directories = optionals impermanence.enable ["/var/lib/incus"];
      systemPackages = [pkgs.virtiofsd];
    };

    # Incus Profile is bugged
    # security.apparmor.enable = mkDefault incus.enable;

    virtualisation = {
      incus = {
        package = mkDefault pkgs.incus; # Stable version is old
        ui.enable = mkDefault incus.enable;
        agent.enable = mkDefault incus.enable;
      };
    };
  };
}
