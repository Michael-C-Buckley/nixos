{lib, ...}: let
  inherit (lib) mkOption types;
  inherit (types) str int listOf;

  mkStrOption = input:
    mkOption {
      type = str;
      description = input;
    };
in {
  options.cluster.ln.kubernetes = {
    masterIP = mkStrOption "Kube Master IP of the node";
    masterHostname = mkStrOption "Kube Master hostname";
    masterApiServerPort = mkOption {
      type = int;
      default = 6443;
      description = "API port";
    };
    roles = mkOption {
      type = listOf str;
      default = ["master" "node"];
      description = "The roles of the node";
    };
    dns = {
      forwardAddr = mkStrOption "Forward Address for Core DNS Addon";
    };
  };
}
