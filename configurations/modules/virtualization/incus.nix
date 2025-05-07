{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault;
  incus = config.virtualisation.incus;
in {
  options.virtualisation.incus = {
    useLvmThin = mkEnableOption "LVM Thin Boot";
  };

  config = {
    services.lvm.boot.thin.enable = mkDefault incus.useLvmThin;
    # Incus will prefer Red Hat's Virtiofs over 9P
    environment.systemPackages = [pkgs.virtiofsd];
    # Incus requires nftables over iptables
    networking.nftables.enable = mkDefault incus.enable;

    virtualisation = {
      incus = {
        package = mkDefault pkgs.incus;
        ui.enable = mkDefault true;
        agent.enable = mkDefault true;
      };
    };
  };
}
