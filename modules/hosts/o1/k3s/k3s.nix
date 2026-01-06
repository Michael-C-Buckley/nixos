{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.o1 = {
    imports = with flake.modules.nixos; [
      k3s
      kube-cert-manager
      kube-traefik
    ];
  };
}
