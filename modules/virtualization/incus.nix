{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf mkDefault;
  incus = config.custom.virtualization.incus;
in {
  options.custom.virtualization.incus = {
    enable = mkEnableOption "Incus";
    useLvmThin = mkEnableOption "LVM Thin Boot";
    package = mkOption {
      type = types.package;
      default = pkgs.incus;
      description = "Package to use (default does not use LTS edition)";
    };
  };

  config = mkIf incus.enable {
    # Incus requires nftables over iptables
    networking.nftables.enable = mkDefault true;
    services.lvm.boot.thin.enable = incus.useLvmThin;

    virtualisation = {
      incus = {
        package = incus.package;
        enable = true;
        ui.enable = true;
        agent.enable = true;
      };
    };
  };
}
