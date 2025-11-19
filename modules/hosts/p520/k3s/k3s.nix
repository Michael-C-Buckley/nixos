# Nix-related elements for K3s
{config, ...}: {
  flake.modules.nixos.p520 = {
    imports = [
      config.flake.modules.nixos.k3s
    ];

    custom.impermanence = {
      persist.directories = [
        "/var/lib/forgejo"
        "/var/lib/openwebui"
      ];
    };

    # TODO: get ingress more robustly established
    networking.firewall.allowedTCPPorts = [
      30300 # Forgejo HTTP
      30222 # Forgejo SSH
      30800 # Open WebUI HTTP
    ];

    # Deploy external service for bare-metal PostgreSQL
    services.k3s.manifests = {
      postgres-external-service.source = ./postgres-external-service.yaml;
      open-webui.source = ./open-webui/kustomization.yaml;
      forgejo.source = ./forgejo/kustomization.yaml;
    };
  };
}
