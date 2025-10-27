{
  flake.modules.nixos.kube-longhorn = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.system) stateVersion;
    inherit (config.networking) hostName;
  in {
    boot.kernelModules = ["iscsi_tcp" "iscsi_ibft"];
    services.openiscsi = {
      enable = true;
      name = "iqn.nixos-${stateVersion}-${hostName}";
    };
    environment.systemPackages = with pkgs; [
      openiscsi
    ];

    # Compatibility since Longhorn uses hardcoded FHS paths
    systemd.tmpfiles.rules = [
      "L+ /usr/bin/iscsiadm - - - - ${pkgs.openiscsi}/bin/iscsiadm"
      "L+ /usr/sbin/iscsid  - - - - ${pkgs.openiscsi}/sbin/iscsid"
    ];
  };
}
