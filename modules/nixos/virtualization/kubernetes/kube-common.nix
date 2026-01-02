{
  flake.modules.nixos.kube-common = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      k9s
      kubectl
      kubernetes-helm
    ];

    custom.impermanence = {
      cache.allUsers.directories = [
        ".config/helm"
      ];
      persist.directories = [
        "/var/lib/containerd" # ← image layers, runtime state
        "/var/lib/kubelet" # ← pod volumes, certs, plugins
      ];
    };
  };
}
