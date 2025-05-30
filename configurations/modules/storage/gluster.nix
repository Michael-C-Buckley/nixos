{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  local = config.system.gluster;

  mgmtPorts = {from = 24004; to = 24008;};
  brickPorts = {from = 49152; to = 49162;};
  ranges = [mgmtPorts brickPorts];

in {
  options.system.gluster = {
    enable = mkEnableOption "Enable GlusterFS";
  };

  config = mkIf local.enable {
    services.glusterfs = {
      enable = true;
    };

    networking.firewall = {
      allowedUDPPortRanges = ranges;
      allowedTCPPortRanges = ranges;
    };
  };
}
