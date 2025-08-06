# Kubernetes single node
# Configures a single node as master and worker
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (config.presets.kubernetes) singleNode useImpermanence;
  imperm = config.system.impermanence.enable;
  kube = config.services.kubernetes;
in {
  options.presets.kubernetes = {
    singleNode = mkEnableOption "Enable and define the preset for a single-node Kube instance.";
    useImpermanence = mkEnableOption "Enable persistence for Kubernetes directories";
  };

  config = mkIf singleNode {
    networking.firewall.allowedTCPPorts = [
      80
      443
      kube.apiserver.securePort
    ];

    virtualisation.containerd = {
      enable = true;
      settings = {
        plugins."io.containerd.grpc.v1.cri".containerd = {
          snapshotter = "overlayfs";
        };
      };
    };

    services.kubernetes = {
      masterAddress = mkDefault config.networking.loopback.ipv4;
      roles = ["master" "node"];
      easyCerts = true;
      apiserver = {
        allowPrivileged = true;
        securePort = 6443;
      };
      addons.dns = {
        enable = true;
        replicas = 1;
      };
      flannel.enable = true;
      kubelet.extraOpts = ''
        --fail-swap-on=false
      '';
    };

    environment = {
      persistence = mkIf (imperm && useImpermanence) {
        "/persist".directories = [
          "/var/lib/cfssl"
          "/var/lib/cni"
          "/var/lib/containerd"
          "/var/lib/etcd"
          "/var/lib/kubelet"
          "/var/lib/kubernetes"
        ];
      };
      systemPackages = with pkgs; [
        cfssl
        openssl
        kubernetes
        kubernetes-helm
        kubectl
        kompose
      ];
    };
  };
}
