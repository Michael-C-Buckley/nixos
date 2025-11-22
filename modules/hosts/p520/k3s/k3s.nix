# Nix-related elements for K3s
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.p520 = {
    config,
    pkgs,
    ...
  }: let
    buildManifest = path:
      pkgs.runCommand "${path}-manifests" {} ''
        mkdir -p $out
        ${pkgs.kustomize}/bin/kustomize build ${./${path}} > $out/manifest.yaml
      '';
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

    # This section merges and flattens the components into a single manifest per app
    # for example, to view it run:
    # nix build --no-link --print-out-paths '.#nixosConfigurations.p520.config.services.k3s.manifests.forgejo.source' 2>&1 | tail -1 | read -l output; and cat $output/manifest.yaml
    services.k3s.manifests = {
      cert-manager.source = ./manifests/cert-manager.yaml;
      cloudflare.source = config.sops.templates.k3s-cloudflare-secret.path;
      lets-encrypt.source = ./manifests/lets-encrypt.yaml;
      traefik-config.source = ./manifests/traefik-config.yaml;
      open-webui.source = buildManifest "open-webui";
      forgejo.source = buildManifest "forgejo";
    };
  };
}
