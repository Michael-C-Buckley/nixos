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
      # Single-node, so host gateway is preferred
      extraFlags = [
        "--flannel-backend host-gw"
      ];

      # Load the Nix-built container images into K3s
      images = [
        flake.packages.${pkgs.stdenv.hostPlatform.system}.attic
      ];

      # This section merges and flattens the components into a single manifest per app
      # for example, to view it run:
      # nix build --no-link --print-out-paths '.#nixosConfigurations.p520.config.services.k3s.manifests.forgejo.source' 2>&1 | tail -1 | read -l output; and cat $output/manifest.yaml
      manifests = {
        cert-manager.source = ./manifests/cert-manager.yaml;
        cloudflare.source = config.sops.templates.k3s-cloudflare-secret.path;
        lets-encrypt.source = ./manifests/lets-encrypt.yaml;
        traefik-config.source = ./manifests/traefik-config.yaml;
        certificate.source = ./manifests/certificate.yaml;
        open-webui.source = buildManifest "open-webui";
        forgejo.source = buildManifest "forgejo";
      };
    };
  };
}
