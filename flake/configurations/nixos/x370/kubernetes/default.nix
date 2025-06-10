{config, ...}: let
  inherit (config.custom) kube;
in {
  imports = [
    ./containerd.nix
    ./coredns.nix
    ./options.nix
    ./packages.nix
  ];

  custom.kube = {
    masterHostname = config.networking.hostName;
    dns.forwardAddr = "192.168.65.1";
    masterIP = "192.168.65.100";
  };

  networking.extraHosts = "${kube.masterIP} ${kube.masterHostname}";

  services.kubernetes = {
    masterAddress = kube.masterIP;
    apiserverAddress = "http://${kube.masterIP}:${toString kube.masterApiServerPort}";
    easyCerts = true; # requires cfssl package
    flannel.enable = true;

    apiserver = {
      allowPrivileged = true;
      securePort = kube.masterApiServerPort;
      advertiseAddress = kube.masterIP;
    };

    kubelet = {
      hostname = kube.masterHostname;
      extraOpts = "--fail-swap-on=false";
    };
  };
}
