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

    # https://github.com/longhorn/longhorn/issues/2166#issuecomment-3315367546
    systemd.services.iscsid.serviceConfig = {
      PrivateMounts = "yes";
      BindPaths = "/run/current-system/sw/bin:/bin";
    };
  };
}
