{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (types) str int listOf;

  kube = config.cluster.ln.kubernetes;

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

  config = {
    cluster.ln.kubernetes.masterHostname = config.networking.hostName;
    networking.extraHosts = "${kube.masterIP} ${kube.masterHostname}";

    services.kubernetes = {
      masterAddress = kube.masterIP;
      apiserverAddress = "http://${kube.masterIP}:${toString kube.masterApiServerPort}";
      kubelet.hostname = kube.masterHostname;

      apiserver = {
        allowPrivileged = true;
        securePort = kube.masterApiServerPort;
        advertiseAddress = kube.masterIP;
      };
    };
  };
}
