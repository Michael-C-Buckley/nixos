# Nix-related elements for K3s
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.b550 = {pkgs, ...}: let
    buildManifest = flake.lib.buildManifest pkgs;
  in {
    imports = with flake.modules.nixos; [
      k3s
      kube-cert-manager
    ];

    custom.impermanence = {
      persist.directories = [
        "/var/lib/forgejo"
        "/var/lib/openwebui"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      30222 # Forgejo SSH
      80
      443
    ];

    services.k3s = {
      manifests = {
        traefik-config.source = ./manifests/traefik-config.yaml;
        open-webui.source = buildManifest ./open-webui;
        forgejo.source = buildManifest ./forgejo;
      };
    };
  };
}
