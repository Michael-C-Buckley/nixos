{
  flake.modules.nixos.k3s = {pkgs, ...}: {
    # The local machine has my kube config set
    hjem.users.michael.rum.programs.fish.config = ''
      set -x KUBECONFIG /etc/rancher/k3s/k3s.yaml
      kubectl completion fish | source
    '';

    custom.impermanence.persist.directories = [
      "/var/lib/rancher" # ← etcd + server state
      "/var/lib/containerd" # ← image layers, runtime state
      "/etc/rancher" # ← kubeconfig, TLS assets
      "/var/lib/kubelet" # ← pod volumes, certs, plugins
    ];

    environment.systemPackages = with pkgs; [
      k9s
      kubectl
      kubernetes-helm
    ];
    # Following along at: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
    networking.firewall = {
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

    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = [
        "--write-kubeconfig-group wheel"
        "--write-kubeconfig-mode \"0640\""
      ];
    };
  };
}
