{
  flake.modules.nixos.k3s-longhorn = {config, ...}: let
    inherit (config.system) stateVersion;
    inherit (config.networking) hostName;
  in {
    boot.kernelModules = ["iscsi_tcp" "iscsi_ibft"];
    services.openiscsi = {
      enable = true;
      name = "iqn.nixos-${stateVersion}-${hostName}";
    };
  };
}
