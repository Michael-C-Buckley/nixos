{
  flake.modules.nixos.k3s-longhorn = {
    boot.kernelModules = ["iscsi_tcp" "iscsi_ibft"];
    services.openiscsi.enable = true;
  };
}
