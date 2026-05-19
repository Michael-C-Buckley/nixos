{pkgs, ...}: let
  KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
in {
  environment.systemPackages = with pkgs; [
    k9s
    kubectl
    kubernetes-helm
  ];
  environment.variables = {
    inherit KUBECONFIG;
  };

  networking = {
    # Does not currently stably support nftables
    nftables.enable = false;

    firewall = {
      allowedTCPPorts = [
        2379
        2380
        6443 # Kubernetes API
        10250 # Kubelet API
      ];
      allowedUDPPorts = [
        8472 # Flannel VXLAN
      ];
    };
  };

  services = {
    # This exists chiefly to collide and stop eval if both are enabled
    kubernetes.kubelet.enable = false;

    k3s = {
      enable = true;
      role = "server";
      extraFlags = [
        "--write-kubeconfig-group wheel"
        "--write-kubeconfig-mode \"0640\""
      ];
    };
  };
}
