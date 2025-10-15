{
  flake.nixosModules.k3s = {pkgs, ...}: {
    # The local machine has my kube config set
    hjem.users.michael.rum.programs.fish.config = ''
      set -x KUBECONFIG /etc/rancher/k3s/k3s.yaml
      kubectl completion fish | source
    '';

    custom.impermanence.persist.directories = [
      "/var/lib/rancher/k3s"
      "/var/lib/containerd"
      "/etc/rancher/k3s"
      "/var/lib/kubelet"
      "/var/log/k3s"
    ];

    environment.systemPackages = with pkgs; [
      k9s
      kubectl
      kubernetes-helm
    ];
    # Following along at: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
    networking.firewall = {
      allowedTCPPorts = [6443 2379 2380];
      allowedUDPPorts = [8472];
    };

    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = [
        "--log /var/lib/rancher/k3s/k3s.log"
        "--write-kubeconfig-group wheel"
        "--write-kubeconfig-mode \"0640\""
      ];
    };
  };
}
