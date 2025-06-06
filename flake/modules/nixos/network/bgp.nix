{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption;
  inherit (lib.types) int;
  inherit (config.networking) bgp;

  fileLimitStr = builtins.toString bgp.fileLimit;
in {
  options.networking.bgp = {
    enable = mkEnableOption "Enable BGP and allow the default port";
    port = mkOption {
      type = int;
      default = 179;
      description = "BGP Listen Port";
    };
    fileLimit = mkOption {
      type = int;
      default = 2048;
      description = "File descriptor limit for use with bgpd.";
    };
  };
  config = mkIf bgp.enable {
    networking.firewall.allowedTCPPorts = [bgp.port];
    services.frr = {
      bgpd = {
        enable = mkDefault true;
        options = ["--limit-fds ${fileLimitStr}"];
      };
      openFilesLimit = bgp.fileLimit;
      zebra.options = ["--limit-fds ${fileLimitStr}"];
    };
  };
}
