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
    # Incus requires nftables over iptables
    networking.nftables.enable = mkDefault incus.enable;
    services.lvm.boot.thin.enable = mkDefault incus.useLvmThin;

    virtualisation = {
      incus = {
        package = mkDefault pkgs.incus;
        ui.enable = mkDefault true;
        agent.enable = mkDefault true;
      };
    };
  };
}
