{config, ...}: {
  flake.modules.nixos.k3s = {
    imports = with config.flake.modules.nixos; [
      kube-common
    ];

    custom = {
      shell.environmentVariables = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };
      impermanence.persist.directories = [
        "/var/lib/rancher" # etcd + server state
        "/etc/rancher" # kubeconfig, TLS assets
      ];
    };

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
  };
}
