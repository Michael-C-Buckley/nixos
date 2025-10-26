{
  flake.modules.nixos.kube-common = {pkgs, ...}: {
    hjem.users.michael.rum.programs.fish.config = ''
      kubectl completion fish | source
    '';

    environment.systemPackages = with pkgs; [
      k9s
      kubectl
      kubernetes-helm
    ];

    custom.impermanence = {
      cache.user.directories = [
        ".config/helm"
      ];
      persist.directories = [
        "/var/lib/containerd" # ← image layers, runtime state
        "/var/lib/kubelet" # ← pod volumes, certs, plugins
      ];
    };
  };
}
