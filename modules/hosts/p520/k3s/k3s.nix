# Nix-related elements for K3s
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.p520 = {
    config,
    pkgs,
    ...
  }: let
    buildManifest = flake.lib.buildManifest pkgs;
  in {
    imports = [
      flake.modules.nixos.k3s
    ];

    custom.impermanence = {
      persist.directories = [
        "/var/lib/forgejo"
        "/var/lib/openwebui"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      30222 # Forgejo SSH
    ];

    services.k3s = {
      extraFlags = [
        "--flannel-backend=none"
        "--cluster-cidr=192.168.56.32/27"
        "--node-ip=${flake.hosts.p520.interfaces.br1.ipv4}"
      ];

      # Load the Nix-built container images into K3s
      images = [
        flake.packages.${pkgs.stdenv.hostPlatform.system}.attic
      ];

      # This section merges and flattens the components into a single manifest per app
      manifests = {
        cert-manager.source = ./manifests/cert-manager.yaml;
        cloudflare.source = config.sops.templates.k3s-cloudflare-secret.path;
        lets-encrypt.source = ./manifests/lets-encrypt.yaml;
        traefik-config.source = ./manifests/traefik-config.yaml;
        certificate.source = ./manifests/certificate.yaml;
        open-webui.source = buildManifest ./open-webui;
        forgejo.source = buildManifest ./forgejo;
      };
    };
  };
}
